# CI/CD — PR builds on Firebase App Distribution

Workflow: `.github/workflows/pr-firebase-distribution.yml`

Every pull request into `main` (opened, new push, reopened, marked ready):

1. **Quality gates**: `dart format` check, `flutter analyze`, `flutter test`.
2. **Android build**: `flutter build apk --release` with
   `config/staging.json` (real Open WebUI backend), build number = GitHub run
   number.
3. **Upload** to Firebase App Distribution for the tester group(s). Firebase
   emails the testers; release notes contain the PR number, title, branch,
   commit and CI link.
4. The APK is also kept as a workflow artifact for 7 days.

Draft PRs are skipped. A new push cancels the build still running for that PR.
PRs from forks run the quality gates only (no secrets). The workflow can also
be started by hand (*Actions › Run workflow*).

### Manual runs: `release` vs `debug`

*Actions › Run workflow* asks for **build mode**:

- `release` (default, and the only mode PRs use): signed staging release APK,
  uploaded to Firebase App Distribution, exactly like a PR build.
- `debug`: `flutter build apk --debug` with `config/staging.json`. No AOT
  compile and no R8, so it builds faster, but it is a JIT build signed with
  the runner's debug key (slow on device, cannot be installed over a release
  build). It is **not** sent to testers; download it from the run's artifacts
  (`goai-staging-debug-apk-<run>`). Quality gates still run first.

## Build speed & caching

Measured before caching (run 37759081683, 2026-10-08): `flutter build apk
--release` took **11m48s**, all of it inside Gradle `assembleRelease` with a
cold Gradle User Home (Gradle 9.3.1 `-all` distribution, AGP 9.1, Kotlin 2.4,
Java 17). The Flutter SDK and pub cache were already restored.

| Cache | Written by | Key | Contents |
| --- | --- | --- | --- |
| Flutter SDK + pub cache | `subosito/flutter-action` (`cache: true`) in **Quality gates** | Flutter channel/version/arch + `pubspec.lock` hash | Flutter SDK, `~/.pub-cache` |
| Gradle User Home | `gradle/actions/setup-gradle` (`cache-provider: basic`) in **Android** only | Hash of `android/**/*.gradle*` + `gradle-wrapper.properties` | `~/.gradle/caches`, `~/.gradle/wrapper` |

- **One writer per cache.** Quality gates runs first and saves the Flutter
  cache; the Android job then gets an exact hit, and `actions/cache` never
  re-saves an exact hit. Only the Android job touches the Gradle cache.
- **Not cached:** the keystore (`$RUNNER_TEMP`), the service-account
  credentials file, `config/*.json`, `build/` and `.dart_tool/`. Release output
  is always rebuilt from source, so caching cannot change what QA receives.
- **Scope (GitHub rule):** a run can restore caches from its own branch/PR or
  from `main`. A PR's first build is cold, unless `main` has a Gradle entry;
  later pushes to the same PR hit. To seed `main`, run the workflow by hand on
  `main` (`debug` mode is enough to fill most of the dependency cache and is not
  distributed).
- **Miss triggers:** changing a Gradle build file or the wrapper version
  (Gradle cache), a new Flutter `stable` release or a `pubspec.lock` change
  (Flutter cache). The basic Gradle provider has no restore keys, so a miss
  starts from empty, and an existing key is never updated (new plugins'
  dependencies are just downloaded again).
- **Where to look:** the Android job summary has a table with the build
  duration and `Gradle User Home cache: hit/miss`. `setup-gradle` adds its own
  summary of each Gradle build and cache entry.

Estimates only, not measured yet. A Gradle cache hit should save roughly the
distribution download and dependency resolution, about **1–3 min** of the
~12 min. Most of the remaining time is Dart AOT compilation (three ABIs) and R8,
which caching does not skip without risking stale release output. Optional
repo variable `ANDROID_TARGET_PLATFORMS` (e.g. `android-arm64`) builds fewer
ABIs, which should cut roughly two thirds of the AOT time. It is off by default because the
APK would no longer install on 32-bit ARM devices or x86_64 emulators.

## One-time setup

### 1. Firebase

1. Firebase console → project `goai-576b4` → Android app with package
   **`com.goaiapp.goai.staging`** (done). Builds with `config/staging.json`
   get the `.staging` suffix automatically (`android/app/build.gradle.kts`
   reads `APP_ENV`), so staging installs next to production and shows as
   "goai_mobile staging". `google-services.json` is **not** needed or
   committed: the app does not use Firebase SDKs.
2. *Release & Monitor › App Distribution* → *Get started*.
3. *Testers & Groups* → create group `qa` (alias) and add the QA emails.
4. Copy the **App ID** (*Project settings › Your apps*, `1:123…:android:abc…`).
5. Google Cloud console (same project) → *IAM › Service accounts* → create one
   with role **Firebase App Distribution Admin** → *Keys › Add key › JSON*.

### 2. GitHub secrets (*Settings › Secrets and variables › Actions*)

| Name | Kind | Value |
| --- | --- | --- |
| `FIREBASE_ANDROID_APP_ID` | secret | App ID from step 4 |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | secret | Full content of the JSON key |
| `FIREBASE_TESTER_GROUPS` | variable (optional) | Group aliases, comma-separated; default `qa` |
| `ANDROID_KEYSTORE_BASE64` | secret (recommended) | `base64 -i release.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | secret | Keystore password |
| `ANDROID_KEY_ALIAS` | secret | Key alias |
| `ANDROID_KEY_PASSWORD` | secret | Key password |

Without the keystore secrets the APK is signed with the runner's throwaway
debug key, so QA must uninstall the previous build before installing a new
one. Create a keystore once:

```bash
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias goai
base64 -i release.jks | pbcopy   # paste into ANDROID_KEYSTORE_BASE64
```

Keep `release.jks` and its passwords outside the repo (`*.jks` is gitignored).
`android/app/build.gradle.kts` reads them from `ANDROID_KEYSTORE_PATH`,
`ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`; a
local release build without them falls back to the debug key.

### 3. Branch protection (recommended)

*Settings › Branches › main*: require the status checks **Quality gates** and
**Android → App Distribution**, so a PR merges only after a build reached QA.

## QA flow

1. Tester accepts the Firebase invite once and installs **Firebase App Tester**
   (or opens the email link).
2. Each PR push → new build in the tester's list, notes show `PR #… : title`.
3. QA approves the PR (or comments) after verifying; then it is merged.

## Not covered yet

- **iOS**: needs an Apple Developer account, an Ad Hoc (or Enterprise)
  distribution certificate + provisioning profile with the testers' device
  UDIDs, and a macOS runner. Add a job that imports the `.p12`/profile from
  secrets and runs `flutter build ipa --export-method ad-hoc`, then the same
  `appdistribution:distribute` step with the iOS App ID.
- Flutter version: CI uses the latest `stable` (the project needs Dart
  `^3.13.4`). Pin `flutter-version` in the workflow once the team agrees on one.
  Pinning also stops each new `stable` release from causing a cold Flutter
  cache.

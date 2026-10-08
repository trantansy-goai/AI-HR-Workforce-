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

import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// APP_ENV from `--dart-define-from-file=config/<env>.json` (Flutter passes
// dart-defines to Gradle base64-encoded). Staging gets its own application id
// so it installs next to production and matches its Firebase app.
val appEnv: String =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.map { String(Base64.getDecoder().decode(it)) }
        ?.firstOrNull { it.startsWith("APP_ENV=") }
        ?.substringAfter("=")
        ?: "development"

android {
    namespace = "com.goaiapp.goai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.goaiapp.goai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        if (appEnv == "staging") {
            applicationIdSuffix = ".staging"
            manifestPlaceholders["appLabel"] = "goai_mobile staging"
        } else {
            manifestPlaceholders["appLabel"] = "goai_mobile"
        }
    }

    // Release signing comes from the environment (CI secrets). Without it the
    // release build falls back to the debug keys so `flutter run --release`
    // still works locally. Never commit a keystore or its passwords.
    val releaseKeystore = System.getenv("ANDROID_KEYSTORE_PATH")?.let { file(it) }
    val hasReleaseKeystore = releaseKeystore?.exists() == true

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = releaseKeystore
                storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("ANDROID_KEY_ALIAS")
                keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(
                if (hasReleaseKeystore) "release" else "debug",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

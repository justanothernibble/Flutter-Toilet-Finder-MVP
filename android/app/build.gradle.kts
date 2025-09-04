import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load env for Android GMS API KEY
val dotenvFile = rootProject.file("../.env")
val dotenv = Properties().apply {
    if (dotenvFile.exists()) {
        dotenvFile.inputStream().use { load(it) }
    }
}

android {
    namespace = "com.example.flutter_toilet_finder_mvp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_toilet_finder_mvp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode?.toInt() ?: 1
        versionName = flutter.versionName
        
        // Set manifest placeholders
        addManifestPlaceholders(
            mapOf(
                "GOOGLE_MAPS_API_KEY" to dotenv.getProperty("ANDROID_MAPS_API_KEY", "")
            )
        )
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22")
}

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // For flutter_local_notifications // Workaround for: https://github.com/MaikuB/flutter_local_notifications/issues/2286
    implementation("androidx.core:core-ktx:1.17.0") // For Android Auto
}


// Workaround for https://pub.dev/packages/unifiedpush#the-build-fails-because-of-duplicate-classes
configurations.all {
    // Use the latest version published: https://central.sonatype.com/artifact/com.google.crypto.tink/tink-android
    val tink = "com.google.crypto.tink:tink-android:1.17.0"
    // You can also use the library declaration catalog
    // val tink = libs.google.tink
    resolutionStrategy {
        force(tink)
        dependencySubstitution {
            substitute(module("com.google.crypto.tink:tink")).using(module(tink))
        }
    }
}


android {
    namespace = "chat.pantheon.hermes"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    val hasReleaseKeystore = if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
        signingConfigs.create("release").apply {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
        true
    } else {
        false
    }

    defaultConfig {
        applicationId = "chat.pantheon.hermes"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.infernal.smokingdetector"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.infernal.smokingdetector"
        minSdk = 30  // Wear OS 3.0+
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        ndk {
            abiFilters += listOf("armeabi-v7a")
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        compose = true
        viewBinding = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.8"
    }
}

dependencies {
    // Wear OS
    implementation("androidx.wear:wear:1.3.0")
    implementation("com.google.android.support:wearable:2.9.0")
    compileOnly("com.google.android.wearable:wearable:2.9.0")

    // Compose Wear OS (Material 3)
    implementation(platform("androidx.compose:compose-bom:2024.02.00"))
    implementation("androidx.wear.compose:compose-material3:1.0.0-alpha17")
    implementation("androidx.wear.compose:compose-foundation:1.3.0")
    implementation("androidx.wear.compose:compose-navigation:1.3.0")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.activity:activity-compose:1.8.2")
    debugImplementation("androidx.compose.ui:ui-tooling")

    // Horologist (Google's Wear OS Compose helpers)
    implementation("com.google.android.horologist:horologist-compose-layout:0.6.5")
    implementation("com.google.android.horologist:horologist-compose-material:0.6.5")

    // Core Android
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")

    // TensorFlow Lite (LiteRT 2024)
    implementation("org.tensorflow:tensorflow-lite:2.14.0")
    implementation("org.tensorflow:tensorflow-lite-support:0.4.4")

    // NNAPI delegate (hardware acceleration)
    implementation("org.tensorflow:tensorflow-lite-gpu:2.14.0")

    // Sensors & Health Services
    implementation("androidx.health:health-services-client:1.0.0-beta03")

    // Wear Remote Interactions (open URLs on phone via Bluetooth)
    implementation("androidx.wear:wear-remote-interactions:1.0.0")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")

    // Lifecycle
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-service:2.7.0")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.7.0")

    // Testing
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}

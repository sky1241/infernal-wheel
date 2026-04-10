pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        // Local libs/ folder for the Samsung Health Sensor SDK AAR
        // (samsung-health-sensor-api-*.aar). The AAR is not on Maven Central.
        flatDir {
            dirs("app/libs")
        }
    }
}

rootProject.name = "SmokingDetector"
include(":app")

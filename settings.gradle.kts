//
// © 2024-present https://github.com/cengiz-pz
//

pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "godot-android-deeplink-plugin"

include(":godot-lib")
include(":deeplink")

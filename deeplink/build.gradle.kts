//
// © 2024-present https://github.com/cengiz-pz
//

import com.android.build.gradle.internal.tasks.factory.dependsOn
import org.apache.tools.ant.filters.ReplaceTokens

plugins {
	id("com.android.library")
	id("org.jetbrains.kotlin.android") version "2.0.10"
}

val pluginNodeName = "Deeplink"
val pluginName = "DeeplinkPlugin"
val pluginPackageName = "org.godotengine.plugin.android.deeplink"
val godotVersion = "3.6.0"
val pluginVersion = "1.0-godot-3"
val demoAddOnsDirectory = "../demo/addons"
val demoAndroidPluginsDirectory = "../demo/android/plugins"
val templateDirectory = "addon_template"
val pluginDependencies = arrayOf(
	"androidx.annotation:annotation:1.8.2",
	"androidx.fragment:fragment:1.8.4"
)

android {
	namespace = pluginPackageName
	compileSdk = 34

	buildFeatures {
		buildConfig = true
	}

	defaultConfig {
		minSdk = 21

		manifestPlaceholders["godotPluginName"] = pluginName
		manifestPlaceholders["godotPluginPackageName"] = pluginPackageName
		buildConfigField("String", "GODOT_PLUGIN_NAME", "\"${pluginName}\"")
		setProperty("archivesBaseName", "$pluginName-$pluginVersion")
	}

	compileOptions {
		sourceCompatibility = JavaVersion.VERSION_17
		targetCompatibility = JavaVersion.VERSION_17
	}

	kotlinOptions {
		jvmTarget = "17"
	}
}

dependencies {
	//implementation("org.godotengine:godot:$godotVersion.stable")
	api(project(":godot-lib"))
	pluginDependencies.forEach { implementation(it) }
}

val copyAARsToDemoAndroidPlugins by tasks.registering(Copy::class) {
	description = "Copies the generated release AAR binary to the plugin's android plugins directory"
	from("build/outputs/aar")
	include("$pluginName-$pluginVersion-release.aar")
	include("$pluginName-$pluginVersion-debug.aar")
	into("$demoAndroidPluginsDirectory/")
	rename("$pluginName-$pluginVersion-release.aar", "$pluginName-$pluginVersion.release.aar")
	rename("$pluginName-$pluginVersion-debug.aar", "$pluginName-$pluginVersion.debug.aar")
}

val copyConfigToDemoAndroidPlugins by tasks.registering(Copy::class) {
	description = "Copies the generated release AAR binary to the plugin's android plugins directory"
	from("config")
	include("${pluginNodeName}*")
	into("$demoAndroidPluginsDirectory/")

	var dependencyString = ""
	for (i in pluginDependencies.indices) {
		dependencyString += "\"${pluginDependencies[i]}\""
		if (i < pluginDependencies.size-1) dependencyString += ", "
	}
	filter(ReplaceTokens::class,
		"tokens" to mapOf(
			"pluginName" to pluginName,
			"pluginNodeName" to pluginNodeName,
			"pluginVersion" to pluginVersion,
			"pluginDependencies" to dependencyString))
}

val cleanDemoAddonsAndAndroidPlugins by tasks.registering(Delete::class) {
	delete(
		"${demoAddOnsDirectory}/$pluginName",
		fileTree(demoAndroidPluginsDirectory) {
			include("${pluginName}*")
			include("${pluginNodeName}*")
		})
}

val copyPngsToDemo by tasks.registering(Copy::class) {
	description = "Copies the PNG images to the plugin's addons directory"
	from(templateDirectory)
	into("$demoAddOnsDirectory/$pluginName")
	include("**/*.png")
}

val copyAddonsToDemo by tasks.registering(Copy::class) {
	description = "Copies the export scripts templates to the plugin's addons directory"

	dependsOn(cleanDemoAddonsAndAndroidPlugins)
	finalizedBy(copyAARsToDemoAndroidPlugins)
	finalizedBy(copyConfigToDemoAndroidPlugins)
	finalizedBy(copyPngsToDemo)

	from(templateDirectory)
	into("$demoAddOnsDirectory/$pluginName")
	exclude("**/*.png")
	var dependencyString = ""
	for (i in pluginDependencies.indices) {
		dependencyString += "\"${pluginDependencies[i]}\""
		if (i < pluginDependencies.size-1) dependencyString += ", "
	}
	filter(ReplaceTokens::class,
		"tokens" to mapOf(
			"pluginNodeName" to pluginNodeName,
			"pluginName" to pluginName,
			"pluginVersion" to pluginVersion,
			"pluginPackage" to pluginPackageName,
			"pluginDependencies" to dependencyString))
}

tasks.register<Zip>("packageDistribution") {
	archiveFileName.set("${pluginName}-${pluginVersion}.zip")
	destinationDirectory.set(layout.buildDirectory.dir("dist"))

	from("../demo/addons/${pluginName}") {
		into("${pluginName}-root/addons/${pluginName}")
	}

	from(demoAndroidPluginsDirectory) {
		include("${pluginNodeName}*")
		into("${pluginName}-root/android/plugins")
	}
}

tasks.named<Delete>("clean").apply {
	dependsOn(cleanDemoAddonsAndAndroidPlugins)
}

afterEvaluate {
	tasks.named("assembleDebug").configure {
		finalizedBy(copyAddonsToDemo)
	}
	tasks.named("assembleRelease").configure {
		finalizedBy(copyAddonsToDemo)
	}
}

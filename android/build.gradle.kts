allprojects {
    repositories {
        google()
        mavenCentral()
    }
    subprojects {
        afterEvaluate {
            if (plugins.hasPlugin("com.android.library")) {
                extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                    if (namespace == null) {
                        namespace = group.toString()
                    }
                    // ensure Android library modules use Java 21
                    compileOptions {
                        sourceCompatibility = JavaVersion.VERSION_21
                        targetCompatibility = JavaVersion.VERSION_21
                    }
                }
            }
            if (plugins.hasPlugin("com.android.application")) {
                extensions.configure<com.android.build.gradle.AppExtension>("android") {
                    // ensure Android app modules use Java 21
                    compileOptions {
                        sourceCompatibility = JavaVersion.VERSION_21
                        targetCompatibility = JavaVersion.VERSION_21
                    }
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Force Kotlin compile jvm target to match Java (21) across all subprojects
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_21.toString()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
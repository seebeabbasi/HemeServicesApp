import org.gradle.api.tasks.Delete
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import java.io.File

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Move build directory out (safe to keep)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    // 🔥 Force Kotlin & Java to use Java 11 for all modules/dependencies
    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "11"
        }
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "11"
        targetCompatibility = "11"
        options.compilerArgs.addAll(listOf("-Xlint:-options"))
    }

    // Fix toolchain if needed
    plugins.withId("org.jetbrains.kotlin.jvm") {
        the<org.jetbrains.kotlin.gradle.dsl.KotlinJvmProjectExtension>().jvmToolchain(11)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

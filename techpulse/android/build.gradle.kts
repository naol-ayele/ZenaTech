allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val namespaceMethod = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = namespaceMethod.invoke(android) as? String
                    if (currentNamespace.isNullOrEmpty()) {
                        val manifestFile = file("${project.projectDir}/src/main/AndroidManifest.xml")
                        if (manifestFile.exists()) {
                            val content = manifestFile.readText()
                            val packageMatch = Regex("package=\"([^\"]+)\"").find(content)
                            packageMatch?.let {
                                val packageName = it.groupValues[1]
                                android.javaClass.getMethod("setNamespace", String::class.java)
                                    .invoke(android, packageName)
                            }
                        }
                    }
                } catch (e: Exception) {
                    // Ignore - method not available
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
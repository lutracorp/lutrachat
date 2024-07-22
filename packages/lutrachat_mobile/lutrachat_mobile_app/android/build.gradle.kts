allprojects {
  repositories {
    google()
    mavenCentral()
  }
}

rootProject.layout.buildDirectory = file("../build")

subprojects {
  project.layout.buildDirectory = rootProject.layout.buildDirectory.dir(project.name)
}

subprojects {
  project.evaluationDependsOn(":app")

  dependencyLocking {
    ignoredDependencies.add("io.flutter:*")
    lockFile = file("${rootProject.projectDir}/project-${project.name}.lockfile")
    if (!project.hasProperty("local-engine-repo")) {
      lockAllConfigurations()
    }
  }
}

tasks.register<Delete>("clean") {
  delete(rootProject.layout.buildDirectory)
}
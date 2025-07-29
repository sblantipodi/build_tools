# WiX Toolset (build tool)

Java 14 (and later) needs a third party build tool to create native binaries and installers, this is not my own work.
Wix is now installed using CI/CD pipeline.

# Flatpak

Flatak folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the flatpak
locally.

# Snapcraft

Snapcraft folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the snap
locally.


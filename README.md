# WiX Toolset (build tool)

Java 21 (and later) needs a third party build tool to create native binaries and installers, this is not my own work.  
Wix is now installed using CI/CD pipeline with the following commands:

```
dotnet tool install --global wix --version 6;
wix extension add -g WixToolset.Util.wixext/6.0.0;
wix extension add -g WixToolset.Ui.wixext/6.0.0;
```

wix folder contains the `main.wxs` custom file to create a custom checkbox to launch the app after the installation.  
to use that file you need to add this param to jpackage: `--resource-dir build_tools/wix`

# Flatpak

Flatak folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the flatpak
locally.

# Snapcraft

Snapcraft folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the snap
locally.


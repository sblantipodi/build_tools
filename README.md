# Luciferin custom build tools

### WiX Toolset (build tool)

Java 21 (and later) needs a third party build tool to create native binaries and installers, this is not my own work.  
Wix is now installed using CI/CD pipeline with the following commands:

```
dotnet tool install --global wix --version 7.0.1;
wix eula accept wix7;
wix extension add -g WixToolset.Util.wixext/7.0.1;
wix extension add -g WixToolset.UI.wixext/7.0.1;
```

WiX 7 requires explicit acceptance of the [OSMF EULA](https://docs.firegiant.com/wix/osmf/) before building. The tool
and extensions are pinned to the same version.
For an existing installation, replace the first command with `dotnet tool update --global wix --version 7.0.1`.

wix folder contains the `main.wxs` custom file to create a custom checkbox to launch the app after the installation.  
to use that file you need to add this param to jpackage: `--resource-dir build_tools/wix`  
[Originl source from jpackage](https://github.com/openjdk/jdk21u-dev/blob/master/src/jdk.jpackage/windows/classes/jdk/jpackage/internal/resources/main.wxs
) before Luciferin customization.

### Flatpak

Flatak folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the flatpak
locally.  
You can find [Luciferin on Flathub here](https://flathub.org/apps/org.dpsoftware.FireflyLuciferin).

### Snapcraft

Snapcraft folder contains a build.sh script that is able to mvn clean, package, and jpackage, and build the snap
locally.  
You can find [Luciferin on Snap Store here](https://snapcraft.io/fireflyluciferin).

### Windows Package Manager

You can find Firefly Luciferin file on
the [Microsoft repo here](https://github.com/microsoft/winget-pkgs/tree/master/manifests/d/DpSoftware/FireflyLuciferin).  
This allow you to install Firefly Luciferin with this command
> winget install luciferin

### How to trigger a Release

release.sh is the script used to trigger a full release on GitHub.
Simply run ./release.sh and follow the instructions.

The script creates a new tag, which in turn triggers the CI/CD pipeline on GitHub. The pipeline builds the software,
runs tests, and publishes the release to GitHub, Snap Store, Flathub, and Windows Package Manager.

#!/bin/sh

# Note: to use the build.sh with a local file you need to change json file to point to a type file with a path and not a url,
# example:
#"sources": [
#    {
#      "type" : "file",
#      "path" : "FireflyLuciferinLinux.deb"
#    }
#]
read -p "Insert release version: " app_version
cd ..;
cd ..;
mvn clean;
mvn -B package;
echo "";
echo "Running jpackage...";
jpackage -i target --main-class org.dpsoftware.JavaFXStarter \
--main-jar FireflyLuciferin-jar-with-dependencies.jar \
--icon data/img/luciferin_logo.png --linux-shortcut \
--copyright "Davide Perini" --name FireflyLuciferin \
--vendor DPsoftware --app-version "$app_version" \
--java-options "-XX:+UseZGC -XX:+UseStringDeduplication -Xms64m -Xmx1024m \
--add-modules=jdk.incubator.vector --enable-native-access=org.dpsoftware \
--enable-native-access=ALL-UNNAMED";
cd build_tools/flatpak;
cp ../../*.deb ./FireflyLuciferinLinux.deb;
rm -rf ../../firef*.deb;
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.FireflyLuciferin.json;
rm -rf FireflyLuciferinLinux.deb;
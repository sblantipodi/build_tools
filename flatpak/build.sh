#!/bin/sh

# Copyright © 2020 - 2024  Davide Perini  (https://github.com/sblantipodi)
# If you pass an argument version it uses it without prompting for it. (ex ./built.sh 2.17.10)
# This install a new build locally.
# flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak run org.dpsoftware.FireflyLuciferin
# flatpak remove org.dpsoftware.FireflyLuciferin
# flatpak enter org.dpsoftware.FireflyLuciferin /bin/sh
# flatpak run --command=flatpak-builder-lint org.flatpak.Builder appstream org.dpsoftware.FireflyLuciferin.appdata.xml
# other manifest: https://github.com/search?q=org%3Aflathub+gstreamer&type=code

if [ -z "$1" ]; then
  read -p "Please insert app version (ex: 2.17.10): " app_version
else
  app_version=$1
fi

cd ..;
cd ..;
mvn clean;
mvn -B package;
rm -rf target/fireflyluciferin*.jar
echo "";

echo "Running jpackage...";
jpackage -i target --main-class org.dpsoftware.JavaFXStarter \
--main-jar FireflyLuciferin-jar-with-dependencies.jar \
--icon data/img/luciferin_logo.png --linux-shortcut \
--copyright "Davide Perini" --name FireflyLuciferin \
--vendor DPsoftware --app-version "$app_version" \
--java-options "-XX:+UseZGC -XX:+UseStringDeduplication -Xms64m -Xmx1024m \
--add-modules=jdk.incubator.vector --enable-native-access=org.dpsoftware \
--enable-native-access=ALL-UNNAMED --enable-native-access=com.sun.jna \
--enable-native-access=javafx.graphics --enable-native-access=javafx.web \
--enable-native-access=com.fazecast.jSerialComm --enable-native-access=org.newsclub.net.unix";

cd build_tools/flatpak || exit;
cp ../../*.deb ./FireflyLuciferinLinux.deb;

dpkg-deb -R FireflyLuciferinLinux.deb firetoedit
sed -i 's/libasound2t64/libasound2/g' "firetoedit/DEBIAN/control"
sed -i 's/Unknown/perini.davide@dpsoftware.org/g' "firetoedit/DEBIAN/control"
dpkg-deb -b firetoedit FireflyLuciferinLinux.deb
cat firetoedit/DEBIAN/control
rm -rf firetoedit

rm -rf ../../firef*.deb;
mv org.dpsoftware.FireflyLuciferin.json org.dpsoftware.FireflyLuciferin.remote.json;
mv org.dpsoftware.FireflyLuciferin.local.json org.dpsoftware.FireflyLuciferin.json;
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.FireflyLuciferin.json;
mv org.dpsoftware.FireflyLuciferin.json org.dpsoftware.FireflyLuciferin.local.json;
mv org.dpsoftware.FireflyLuciferin.remote.json org.dpsoftware.FireflyLuciferin.json;
rm -rf FireflyLuciferinLinux.deb;
flatpak run org.dpsoftware.FireflyLuciferin
#!/bin/bash

# Copyright © 2020 - 2024  Davide Perini  (https://github.com/sblantipodi)
# If you pass an argument version it uses it without prompting for it. (ex ./built.sh 2.17.10)
# Firewall rules for snapcraft
# sudo ufw allow in on lxdbr0
# sudo ufw route allow in on lxdbr0
# sudo ufw route allow out on lxdbr0
# sudo usermod -a -G lxd $USER
# snap run --shell fireflyluciferin
# sudo journalctl --output=short --follow --all | sudo snappy-debug
# This install a new build locally.
# other manifest: https://github.com/search?q=path%3Asnapcraft.yaml+%22icon%22&type=code

if [ -z "$1" ]; then
  read -p "Please insert app version (ex: 2.17.10): " app_version
else
  app_version=$1
fi

read -p "Clean before the build? (y/N) " clean

file_to_edit="snap/snapcraft.yaml"
sed -i "s/version: '[0-9]\+\.[0-9]\+\.[0-9]\+'/version: '$app_version'/" "$file_to_edit"

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
--enable-native-access=com.fazecast.jSerialComm";

cd build_tools/snapcraft || exit;
cp ../../*.deb ./FireflyLuciferinLinux.deb;

dpkg-deb -R FireflyLuciferinLinux.deb firetoedit
sed -i 's/libasound2t64/libasound2/g' "firetoedit/DEBIAN/control"
sed -i 's/Unknown/perini.davide@dpsoftware.org/g' "firetoedit/DEBIAN/control"
dpkg-deb -b firetoedit FireflyLuciferinLinux.deb
cat firetoedit/DEBIAN/control
rm -rf firetoedit

rm -rf ../../firef*.deb;

if [[ "$clean" =~ ^[Yy]$ ]]; then
  snapcraft clean;
fi
sudo snap remove fireflyluciferin;
rm -rf *.snap;
#snapcraft --verbosity=debug;
snapcraft;
sudo snap install fireflyluciferin_${app_version}_amd64.snap --dangerous;
rm -rf /home/sblantipodi/.openjfx;
snap run fireflyluciferin;
rm -rf FireflyLuciferinLinux.deb;

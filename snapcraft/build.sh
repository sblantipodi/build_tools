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

sed -i "s/VERSION_PLACEHOLDER/$app_version/g" snap/snapcraft.yaml;

cd ..;
cd ..;
mvn clean;
mvn -B package;
rm -rf target/fireflyluciferin*.jar;
rm -rf target/fireflyluciferin*.jar;
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

cd build_tools/snapcraft || exit;
cp ../../*.deb ./FireflyLuciferinLinux.deb;
rm -rf ../../firef*.deb;

if [[ "$clean" =~ ^[Yy]$ ]]; then
  snapcraft clean;
fi
sudo snap remove fireflyluciferin;
rm -rf *.snap;
#snapcraft --verbosity=debug;
snapcraft;
sudo snap install fireflyluciferin_${app_version}_amd64.snap --dangerous --devmode;
rm -rf /home/sblantipodi/.openjfx;
snap run fireflyluciferin;
sed -i "s/$app_version/VERSION_PLACEHOLDER/g" snap/snapcraft.yaml;
rm -rf FireflyLuciferinLinux.deb;

#!/bin/sh

# Copyright © 2020 - 2026  Davide Perini  (https://github.com/sblantipodi)
# If you pass an argument version it uses it without prompting for it. (ex ./jpackage_windows_build.sh 2.17.10)
# This runs the build up to jpackage (stops after jpackage).

if [ -z "$1" ]; then
  read -p "Please insert app version (ex: 2.17.10): " app_version
else
  app_version=$1
fi

cd ..;
rm -rf *.deb;
mvn clean;
mvn -B package;
rm -rf target/fireflyluciferin*.jar
echo "";

echo "Running jpackage...";
jpackage -i target --type exe --resource-dir build_tools/wix --main-class org.dpsoftware.JavaFXStarter \
--main-jar FireflyLuciferin-jar-with-dependencies.jar --icon data/img/java_fast_screen_capture_logo.ico \
--win-menu --win-menu-group Luciferin --copyright "Davide Perini" --name "Firefly Luciferin" \
--vendor DPsoftware --win-dir-chooser --win-shortcut --win-per-user-install \
--win-upgrade-uuid 33c82dc4-e0e0-11ea-87d0-0242ac130003 --app-version "$app_version" \
--win-shortcut --win-shortcut-prompt --java-options "-XX:+UseZGC -XX:+UseStringDeduplication -Xms64m -Xmx1024m \
--add-modules=jdk.incubator.vector --enable-native-access=org.dpsoftware --enable-native-access=ALL-UNNAMED \
--enable-native-access=com.sun.jna --enable-native-access=javafx.graphics --enable-native-access=javafx.web \
--enable-native-access=com.fazecast.jSerialComm";
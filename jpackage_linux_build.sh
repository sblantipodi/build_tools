#!/bin/sh

# Copyright © 2020 - 2026  Davide Perini  (https://github.com/sblantipodi)
# If you pass an argument version it uses it without prompting for it. (ex ./jpackage_linux_build.sh 2.17.10)
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

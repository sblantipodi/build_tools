#!/bin/sh


if [ -z "$1" ]; then
  read -p "Please insert app version (ex: 2.17.10): " app_version
else
  app_version=$1
fi

snapcraft clean;
sudo snap remove fireflyluciferin;

sed -i "s/VERSION_PLACEHOLDER/$app_version/g" snap/snapcraft.yaml;

snapcraft --verbosity=debug;
sudo snap install fireflyluciferin_${app_version}_amd64.snap --dangerous --devmode;
snap run fireflyluciferin;
sed -i "s/$app_version/VERSION_PLACEHOLDER/g" snap/snapcraft.yaml;

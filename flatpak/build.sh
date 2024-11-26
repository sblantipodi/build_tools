#!/bin/sh

# Note: to use the build.sh with a local file you need to change json file to point to a type file with a path and not a url,
# example:
#"sources": [
#    {
#      "type" : "file",
#      "path" : "FireflyLuciferinLinux.deb"
#    }
#]
cp ../../*.deb org.dpsoftware.FireflyLuciferin/FireflyLuciferinLinux.deb;
cd org.dpsoftware.FireflyLuciferin;
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.FireflyLuciferin.json;

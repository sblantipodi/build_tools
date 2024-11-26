#!/bin/sh

cp ../../*.deb org.dpsoftware.FireflyLuciferin/FireflyLuciferinLinux.deb;
cd org.dpsoftware.FireflyLuciferin;
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.FireflyLuciferin.json;

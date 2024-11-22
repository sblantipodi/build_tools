#!/bin/sh

cp ../../*.deb FireflyLuciferinLinux.deb;
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.FireflyLuciferin.json

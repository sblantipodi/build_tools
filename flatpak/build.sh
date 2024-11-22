#!/bin/sh

flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.dpsoftware.fireflyluciferin.json

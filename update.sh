#!/usr/bin/env bash
set -euo pipefail

# Fetch latest version info from Devin Desktop API
echo "Fetching latest version info..."
API_INFO=$(curl -s https://windsurf-stable.codeium.com/api/update/linux-x64-deb/stable/latest)

# Extract URL and version using grep/sed
URL=$(echo "$API_INFO" | grep -o '"url":"[^"]*"' | sed 's/"url":"//;s/"$//')
SHA256=$(echo "$API_INFO" | grep -o '"sha256hash":"[^"]*"' | sed 's/"sha256hash":"//;s/"$//')

# Extract version from URL (format: Devin-linux-x64-VERSION.deb)
VERSION=$(echo "$URL" | sed 's/.*Devin-linux-x64-\([0-9.]*\)\.deb.*/\1/')

if [[ -z "$VERSION" || -z "$URL" || -z "$SHA256" ]]; then
    echo "Error: Failed to extract version info from API"
    exit 1
fi

echo "Latest version: $VERSION"
echo "URL: $URL"
echo "SHA256: $SHA256"

# Update pkgs/devin-desktop/default.nix
echo "Updating pkgs/devin-desktop/default.nix..."
sed -i "s/version = \".*\";/version = \"$VERSION\";/" pkgs/devin-desktop/default.nix
sed -i "s|url = \".*\";|url = \"$URL\";|" pkgs/devin-desktop/default.nix
sed -i "s|hash = \".*\";|hash = \"sha256-$SHA256\";|" pkgs/devin-desktop/default.nix

# Update aur-build
echo "Updating aur-build..."
sed -i "s/pkgver=.*/pkgver=$VERSION/" aur-build
sed -i "s|_url=.*|_url=\"$URL\"|" aur-build
sed -i "s/sha256sums=.*/sha256sums=('$SHA256')/" aur-build

echo "✓ Updated to version $VERSION"
echo "Run 'nix flake update' to update the flake lock if needed"

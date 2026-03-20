#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/Jamesbarford/holyc-lang.git"
INSTALL_DIR="$HOME/.local/bin"
BUILD_DIR="/tmp/holyc-build"

echo "HolyC Installer (macOS)"
echo "------------------------"

if ! xcode-select -p &> /dev/null; then
  echo "[+] Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "[!] Please re-run this script after installation completes."
  exit 1
fi

echo "[+] Checking dependencies..."
for cmd in git make gcc; do
  if ! command -v $cmd &> /dev/null; then
    echo "[!] Missing dependency: $cmd"
    exit 1
  fi
done

rm -rf "$BUILD_DIR"

echo "[+] Cloning repository..."
git clone "$REPO_URL" "$BUILD_DIR"

cd "$BUILD_DIR"

echo "[+] Building HolyC..."
make

mkdir -p "$INSTALL_DIR"
cp holyc "$INSTALL_DIR/holyc"
chmod +x "$INSTALL_DIR/holyc"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "[!] Add this to your ~/.zshrc:"
  echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo "[+] Verifying installation..."
if command -v holyc &> /dev/null; then
  echo "[✓] Installed successfully!"
  holyc --version || true
else
  echo "[!] Installed, but not found in PATH."
fi
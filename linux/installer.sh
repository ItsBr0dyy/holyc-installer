#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/Jamesbarford/holyc-lang.git"
INSTALL_DIR="$HOME/.local/bin"
BUILD_DIR="/tmp/holyc-build"

echo "[+] Starting HolyC installation..."

echo "[+] Checking dependencies..."
for cmd in git make gcc; do
  if ! command -v $cmd &> /dev/null; then
    echo "[!] Missing dependency: $cmd"
    echo "    Please install it and re-run this script."
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

echo "[+] Installing..."
cp holyc "$INSTALL_DIR/holyc"

chmod +x "$INSTALL_DIR/holyc"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo "[!] $INSTALL_DIR is not in your PATH."
  echo "    Add this line to your shell config (~/.bashrc or ~/.zshrc):"
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo "[+] Verifying installation..."
if command -v holyc &> /dev/null; then
  echo "[✓] HolyC installed successfully!"
  holyc --version || true
else
  echo "[!] Installation completed, but 'holyc' not found in PATH."
fi
$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/Jamesbarford/holyc-lang.git"
$BUILD_DIR = "$env:TEMP\holyc-build"
$INSTALL_DIR = "$env:USERPROFILE\.local\bin"

Write-Host "HolyC Installer (Windows)"
Write-Host "--------------------------"

Write-Host "[+] Checking dependencies..."

foreach ($cmd in @("git", "gcc", "make")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "[!] Missing dependency: $cmd"
        exit 1
    }
}

if (Test-Path $BUILD_DIR) {
    Remove-Item -Recurse -Force $BUILD_DIR
}

Write-Host "[+] Cloning repository..."
git clone $REPO_URL $BUILD_DIR

Set-Location $BUILD_DIR

Write-Host "[+] Building HolyC..."
make

New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null
Copy-Item ".\holyc.exe" "$INSTALL_DIR\holyc.exe"

Write-Host "[+] Adding to PATH..."
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$INSTALL_DIR*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$INSTALL_DIR",
        "User"
    )
    Write-Host "[!] Restart your terminal for PATH changes to apply."
}

Write-Host "[+] Verifying installation..."
if (Get-Command holyc -ErrorAction SilentlyContinue) {
    Write-Host "[✓] Installed successfully!"
    holyc --version
} else {
    Write-Host "[!] Installed, but not found in PATH."
}
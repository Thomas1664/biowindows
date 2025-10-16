# URL and expected SHA256
$URL = "https://github.com/rcedgar/muscle/releases/download/v5.3/muscle-win64.v5.3.exe"
$SHA256_EXPECTED = "a86637db99deb3efa1cb6762c4e3160ca33644608270eb167e4214f1f9409711"

# Download the binary
Write-Host "Downloading muscle binary from $URL..."
Invoke-WebRequest -Uri $URL -OutFile "$env:SRC_DIR\muscle.exe"

# Compute SHA256 hash
$SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 "$env:SRC_DIR\muscle.exe").Hash

# Verify hash
if ($SHA256_ACTUAL -ne $SHA256_EXPECTED) {
    Write-Host "SHA256 mismatch!"
    Write-Host "Expected: $SHA256_EXPECTED"
    Write-Host "Actual: $SHA256_ACTUAL"
    exit 1
}

Write-Host "SHA256 verified successfully"

# Copy to environment Scripts folder
$scriptsDir = "$env:PREFIX\Scripts"
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir | Out-Null
}
Copy-Item "$env:SRC_DIR\muscle.exe" "$scriptsDir\muscle.exe"

Write-Host "muscle.exe installed successfully to $scriptsDir"

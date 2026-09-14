$ErrorActionPreference = "Stop"

$binDir = Join-Path $HOME "bin"
$daselPath = Join-Path $binDir "dasel.exe"
$inputPath = Join-Path (Get-Location) "settings.json"
$outputPath = Join-Path (Get-Location) "settings.transpiled.toml"
$tempPath = "$outputPath.tmp"

# Make sure the installation directory exists.
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

# Download Dasel if it is not already installed.
if (-not (Test-Path $daselPath -PathType Leaf)) {
    Write-Host "Downloading Dasel..."

    $release = Invoke-RestMethod `
        -Uri "https://api.github.com/repos/TomWright/dasel/releases/latest"

    $asset = $release.assets |
        Where-Object { $_.name -eq "dasel_windows_amd64.exe" } |
        Select-Object -First 1

    if ($null -eq $asset) {
        throw "Could not find the Windows AMD64 Dasel release asset."
    }

    Invoke-WebRequest `
        -Uri $asset.browser_download_url `
        -OutFile $daselPath
}

# Verify the input exists.
if (-not (Test-Path $inputPath -PathType Leaf)) {
    throw "Input file not found: $inputPath"
}

# Convert JSON to TOML.
# The call operator (&) executes the path stored in $daselPath.
Get-Content $inputPath -Raw |
    & $daselPath -i json -o toml |
    Set-Content -Path $tempPath -Encoding utf8

if ($LASTEXITCODE -ne 0) {
    Remove-Item $tempPath -ErrorAction SilentlyContinue
    throw "Dasel failed to convert JSON to TOML."
}

# Replace the output only after successful conversion.
Move-Item -Force $tempPath $outputPath

Write-Host "Created $outputPath"

Invoke-WebRequest "https://raw.githubusercontent.com/microsoft/terminal/main/doc/cascadia/profiles.schema.json" -Outfile ./settings.schema.json

$source = "./settings.toml"
$schema = "./settings.schema.json"
$gen = "./settings.generated.json"

yq -p=toml -o=json -I=2 '.' $source > $temp

if ($LASTEXITCODE -NE 0){
    Remove-Item $temp -ErrorAction SilentlyContinue
    throw "TOML Conversion failed"
}

$json = Get-Content $temp -Raw

if ( -not ($json | Test-Json -SchemaFile $schema )){
    Remove-Item $temp -ErrorAction SilentlyContinue
    throw "Generated JSON failed Windows Terminal schema validation"
}


Write-Host "Configuration is valid"

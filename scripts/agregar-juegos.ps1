$root = Split-Path -Parent $PSScriptRoot
$games = Join-Path $root 'Juegos\PS2'
New-Item -ItemType Directory -Force -Path $games | Out-Null
Write-Host 'Copia tus ISO de PS2 aqui. No se mueven archivos automaticamente.'
Start-Process explorer.exe -ArgumentList ('"' + $games + '"')

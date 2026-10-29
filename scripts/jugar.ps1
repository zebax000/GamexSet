$ErrorActionPreference = 'Stop'
try {
    $root = Split-Path -Parent $PSScriptRoot
    $emu = Join-Path $root 'Emuladores\PCSX2'
    if (-not (Test-Path -LiteralPath $emu)) { throw 'Falta el emulador. Ejecuta PREPARAR.bat primero.' }
    $executables = @(Get-ChildItem -LiteralPath $emu -Filter 'pcsx2*.exe' -File | Sort-Object Name)
    if ($executables.Count -ne 1) { throw 'Debe existir una sola distribucion PCSX2 en Emuladores\PCSX2. Ejecuta PREPARAR.bat.' }
    $portable = Join-Path $emu 'portable.ini'
    if (-not (Test-Path -LiteralPath $portable)) { throw 'Falta preparar el modo portable. Ejecuta PREPARAR.bat.' }
    Start-Process -FilePath $executables[0].FullName -WorkingDirectory $emu
} catch {
    Write-Host ('Error: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}

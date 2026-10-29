$ErrorActionPreference = 'Stop'
try {
    $root = Split-Path -Parent $PSScriptRoot
    $emu = Join-Path $root 'Emuladores\PCSX2'
    $games = Join-Path $root 'Juegos\PS2'
    New-Item -ItemType Directory -Force -Path $emu, $games, (Join-Path $emu 'bios') | Out-Null
    $executables = @(Get-ChildItem -LiteralPath $emu -Filter 'pcsx2*.exe' -File | Sort-Object Name)
    if ($executables.Count -eq 0) {
        Write-Host 'Falta PCSX2. Descarga la distribucion portable oficial para Windows.'
        Write-Host "Extrae TODO su contenido directamente en: $emu"
        Write-Host 'Despues ejecuta PREPARAR.bat otra vez. No se descarga BIOS ni juegos.'
        Start-Process 'https://pcsx2.net/downloads/'
        exit 1
    }
    if ($executables.Count -ne 1) { throw 'Hay varios ejecutables PCSX2. Conserva una sola distribucion completa en Emuladores\PCSX2.' }
    $portable = Join-Path $emu 'portable.ini'
    if (-not (Test-Path -LiteralPath $portable)) { New-Item -ItemType File -Path $portable | Out-Null }
    Write-Host 'Modo portable preparado. No se han modificado tus ajustes existentes.'
    Write-Host "En PCSX2: configura tu BIOS y mando; agrega esta carpeta a la biblioteca: $games"
    Write-Host 'Activa la busqueda en subcarpetas. Despues solo copia ISO y abre JUGAR.bat.'
    Start-Process -FilePath $executables[0].FullName -WorkingDirectory $emu
} catch {
    Write-Host ('Error: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$rb = Join-Path $root 'RetroBat'
$roms = Join-Path $rb 'roms'
$inbox = Join-Path $root 'Pon-tus-juegos-aqui'
$pcIn = Join-Path $inbox 'PC'
$done = Join-Path $inbox '_procesados'
$winDir = Join-Path $roms 'windows'
$pcDir = Join-Path $rb 'juegos-pc'
$oldPcDir = Join-Path $winDir 'juegos-pc'
$script:count = 0
$avisos = New-Object System.Collections.ArrayList

$map = @{
  '.gba' = 'gba'; '.nes' = 'nes'; '.sfc' = 'snes'; '.smc' = 'snes'
  '.z64' = 'n64'; '.n64' = 'n64'; '.v64' = 'n64'
  '.gb' = 'gb'; '.gbc' = 'gbc'; '.nds' = 'nds'
  '.md' = 'megadrive'; '.gen' = 'megadrive'
}

function Find-7z {
  $c = Get-Command 7z -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  foreach ($p in @('C:\Program Files\7-Zip\7z.exe', 'C:\Program Files (x86)\7-Zip\7z.exe')) {
    if (Test-Path $p) { return $p }
  }
  return $null
}

function Get-GameExe([string]$dir) {
  $dir = $dir.TrimEnd('\')
  $ov = Join-Path $dir 'ejecutable.txt'
  if (Test-Path -LiteralPath $ov) {
    $rel = (Get-Content -LiteralPath $ov -TotalCount 1).Trim()
    $p = Join-Path $dir $rel
    if (Test-Path -LiteralPath $p) { return Get-Item -LiteralPath $p }
  }
  $bad = 'unins|setup|redist|dxsetup|dotnet|crash|install|updater'
  $all = @(Get-ChildItem -LiteralPath $dir -Filter '*.exe' -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.BaseName -notmatch $bad })
  if ($all.Count -eq 0) { return $null }
  $all | Sort-Object @{ Expression = { $_.FullName.Substring($dir.Length).Split('\').Count } }, @{ Expression = { $_.Length }; Descending = $true } |
    Select-Object -First 1
}

function Add-PcGame([string]$src, [string]$name) {
  $dest = Join-Path $pcDir $name
  if (Test-Path -LiteralPath $dest) {
    [void]$avisos.Add("Ya existe el juego '$name'. No se movio.")
    return
  }
  Move-Item -LiteralPath $src -Destination $dest
}

function Move-OldPcGames {
  if (-not (Test-Path -LiteralPath $oldPcDir)) { return }
  foreach ($g in @(Get-ChildItem -LiteralPath $oldPcDir -Directory)) {
    $target = Join-Path $pcDir $g.Name
    if (Test-Path -LiteralPath $target) {
      [void]$avisos.Add("'$($g.Name)' existe en la carpeta vieja y en la nueva. No se migro.")
      continue
    }
    Move-Item -LiteralPath $g.FullName -Destination $target
    $oldBat = Join-Path $winDir ($g.Name + '.bat')
    if (Test-Path -LiteralPath $oldBat) { Remove-Item -LiteralPath $oldBat -Force }
  }
  if (@(Get-ChildItem -LiteralPath $oldPcDir -Force).Count -eq 0) {
    Remove-Item -LiteralPath $oldPcDir -Force
  }
}

function Update-PcLaunchers {
  foreach ($g in @(Get-ChildItem -LiteralPath $pcDir -Directory)) {
    $bat = Join-Path $winDir ($g.Name + '.bat')
    if (Test-Path -LiteralPath $bat) { continue }
    $exe = Get-GameExe $g.FullName
    if (-not $exe) {
      [void]$avisos.Add("'$($g.Name)': no encontre ningun .exe. Crea un ejecutable.txt dentro de su carpeta con la ruta relativa del .exe y vuelve a ejecutar este script.")
      continue
    }
    $rel = $exe.DirectoryName.Substring($pcDir.Length).TrimStart('\')
    $lines = @('@echo off', ('cd /d "%~dp0..\..\juegos-pc\' + $rel + '"'), ('start "" /wait "' + $exe.Name + '"'))
    Set-Content -LiteralPath $bat -Value $lines -Encoding OEM
    $script:count++
  }
}

function Add-Rom($item, [string]$sys) {
  $dir = Join-Path $roms $sys
  if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    [void]$avisos.Add("Se creo roms\$sys. Verifica que '$sys' sea un nombre de sistema valido de RetroBat.")
  }
  $dest = Join-Path $dir $item.Name
  if (Test-Path -LiteralPath $dest) {
    [void]$avisos.Add("Ya existe '$($item.Name)' en roms\$sys. No se movio.")
    return
  }
  Move-Item -LiteralPath $item.FullName -Destination $dest
  $script:count++
}

Write-Host '=== GamexSet - Agregar juegos ===' -ForegroundColor Cyan
try {
  if (-not (Test-Path (Join-Path $rb 'retrobat.exe'))) {
    throw 'RetroBat no esta instalado. Ejecuta primero 1-INSTALAR.bat'
  }
  New-Item -ItemType Directory -Force -Path $winDir, $pcDir, $pcIn, $done | Out-Null
  Move-OldPcGames

  foreach ($f in @(Get-ChildItem -LiteralPath $pcIn -File | Where-Object { $_.Extension -in '.zip', '.7z' })) {
    $tmp = Join-Path $pcIn ('_x_' + $f.BaseName)
    if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
    New-Item -ItemType Directory -Path $tmp | Out-Null
    if ($f.Extension -eq '.zip') {
      Expand-Archive -LiteralPath $f.FullName -DestinationPath $tmp -Force
    } else {
      $z = Find-7z
      if (-not $z) {
        [void]$avisos.Add("'$($f.Name)': para .7z instala 7-Zip o descomprimelo a mano.")
        Remove-Item -LiteralPath $tmp -Recurse -Force
        continue
      }
      & $z x $f.FullName ('-o' + $tmp) -y | Out-Null
    }
    $items = @(Get-ChildItem -LiteralPath $tmp -Force)
    if ($items.Count -eq 1 -and $items[0].PSIsContainer) { $inner = $items[0].FullName } else { $inner = $tmp }
    Add-PcGame $inner $f.BaseName
    if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
    Move-Item -LiteralPath $f.FullName -Destination $done -Force
  }

  foreach ($d in @(Get-ChildItem -LiteralPath $pcIn -Directory | Where-Object { $_.Name -notlike '_x_*' })) {
    Add-PcGame $d.FullName $d.Name
  }
  Update-PcLaunchers

  foreach ($d in @(Get-ChildItem -LiteralPath $inbox -Directory | Where-Object { $_.Name -notin 'PC', '_procesados' })) {
    $sys = $d.Name.ToLower()
    foreach ($i in @(Get-ChildItem -LiteralPath $d.FullName -Force)) {
      if ($i.Name -like 'LEEME*') { continue }
      Add-Rom $i $sys
    }
  }

  foreach ($f in @(Get-ChildItem -LiteralPath $inbox -File)) {
    if ($f.Extension -eq '.txt') { continue }
    $sys = $map[$f.Extension.ToLower()]
    if ($sys) {
      Add-Rom $f $sys
    } else {
      [void]$avisos.Add("'$($f.Name)': no se de que consola es. Ponlo en una subcarpeta con el nombre del sistema (ej. ps2).")
    }
  }

  Write-Host ''
  Write-Host ("Juegos agregados: " + $script:count) -ForegroundColor Green
  foreach ($a in $avisos) { Write-Host ('AVISO: ' + $a) -ForegroundColor Yellow }
  Write-Host 'Abre 3-JUGAR.bat. RetroBat detecta los juegos nuevos al iniciar o al actualizar la lista de juegos.'
} catch {
  Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
}
Read-Host 'Presiona Enter para cerrar' | Out-Null

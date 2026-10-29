$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$rb = Join-Path $root 'RetroBat'
$exe = Join-Path $rb 'retrobat.exe'

function Find-7z {
  $c = Get-Command 7z -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  foreach ($p in @('C:\Program Files\7-Zip\7z.exe', 'C:\Program Files (x86)\7-Zip\7z.exe')) {
    if (Test-Path $p) { return $p }
  }
  return $null
}

Write-Host '=== GamexSet - Instalacion ===' -ForegroundColor Cyan
Write-Host "Carpeta del proyecto: $root"

try {
  try {
    $q = Split-Path -Qualifier $root
    if ($q) {
      $vol = Get-Volume -DriveLetter $q.TrimEnd(':') -ErrorAction Stop
      if ($vol.FileSystem -eq 'FAT32') {
        Write-Host 'AVISO: la USB esta en FAT32 (limite de 4 GB por archivo). Se recomienda exFAT o NTFS.' -ForegroundColor Yellow
      }
    }
  } catch { }

  if (Test-Path $exe) {
    Write-Host 'RetroBat ya esta instalado en la USB. Nada que hacer.' -ForegroundColor Green
  } else {
    New-Item -ItemType Directory -Force -Path $rb | Out-Null
    Write-Host ''
    Write-Host 'PASO 1: se abrira la pagina oficial de RetroBat. Descarga la ultima version.'
    Start-Process 'https://www.retrobat.org/en/download/'
    Read-Host 'Cuando termine la descarga, presiona Enter' | Out-Null

    $dl = Join-Path $env:USERPROFILE 'Downloads'
    $file = Get-ChildItem $dl -Filter 'retrobat*' -File -ErrorAction SilentlyContinue |
      Where-Object { $_.Extension -in '.exe', '.zip', '.7z' } |
      Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $file) {
      $p = Read-Host 'No encontre el archivo en Descargas. Escribe la ruta completa del archivo'
      $file = Get-Item -LiteralPath $p.Trim('"')
    }
    Write-Host "Archivo: $($file.FullName)"

    if ($file.Extension -eq '.exe') {
      Write-Host ''
      Write-Host 'PASO 2: se abrira el instalador. Cuando pregunte la carpeta de destino, elige EXACTAMENTE:' -ForegroundColor Yellow
      Write-Host $rb -ForegroundColor Yellow
      Start-Process -FilePath $file.FullName -Wait
    } else {
      $tmp = Join-Path $rb '_tmp'
      New-Item -ItemType Directory -Force -Path $tmp | Out-Null
      if ($file.Extension -eq '.zip') {
        Expand-Archive -LiteralPath $file.FullName -DestinationPath $tmp -Force
      } else {
        $z = Find-7z
        if (-not $z) { throw 'Para un .7z instala 7-Zip (7-zip.org) o descarga la version .exe.' }
        & $z x $file.FullName ('-o' + $tmp) -y | Out-Null
      }
      $found = Get-ChildItem $tmp -Filter 'retrobat.exe' -Recurse -File | Select-Object -First 1
      if (-not $found) { throw 'No encontre retrobat.exe dentro del archivo descargado.' }
      Copy-Item -Path (Join-Path $found.DirectoryName '*') -Destination $rb -Recurse -Force
      Remove-Item $tmp -Recurse -Force
    }

    if (Test-Path $exe) {
      Write-Host ''
      Write-Host 'RetroBat instalado en la USB.' -ForegroundColor Green
      Write-Host 'Siguiente: pon tus juegos en Pon-tus-juegos-aqui y ejecuta 2-AGREGAR-JUEGOS.bat'
      Write-Host 'Consejo: antes de usar la USB sin internet, abre un juego de cada consola para que se descargue su emulador.'
    } else {
      Write-Host "No encontre retrobat.exe en $rb. Revisa que elegiste esa carpeta al instalar." -ForegroundColor Red
    }
  }
} catch {
  Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
}
Read-Host 'Presiona Enter para cerrar' | Out-Null

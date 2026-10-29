# GamexSet

USB portable de juegos para Windows basada en [RetroBat](https://www.retrobat.org/).
Descargas este repositorio como ZIP, lo extraes en tu USB, ejecutas un instalador y solo agregas juegos.

> Estado: primera version. Los scripts estan escritos pero conviene probarlos en tu USB antes de confiar en ellos.

## Requisitos

- Windows 10 u 11.
- USB formateada en exFAT o NTFS (FAT32 no admite archivos de mas de 4 GB).
- Internet la primera vez (RetroBat descarga los emuladores cuando falta alguno).

## Uso rapido

1. En GitHub: Code > Download ZIP. Extrae el contenido en la raiz de tu USB.
2. Ejecuta `1-INSTALAR.bat` (una sola vez).
3. Pon tus juegos en `Pon-tus-juegos-aqui` (ver abajo).
4. Ejecuta `2-AGREGAR-JUEGOS.bat`.
5. Ejecuta `3-JUGAR.bat`.

## Como poner los juegos

### Juegos de PC (por ejemplo FIFA 15)

Pon la carpeta completa y ya descomprimida dentro de `Pon-tus-juegos-aqui/PC/`:

```text
Pon-tus-juegos-aqui/PC/FIFA 15/fifa15.exe
```

Tambien puedes poner un `.zip` (o `.7z` si tienes 7-Zip instalado). El script lo descomprime por ti.
Al ejecutar `2-AGREGAR-JUEGOS.bat` se mueve a `RetroBat/roms/windows/juegos-pc/` y se crea un acceso `.bat` que RetroBat muestra en su menu de Windows.
Si el script elige mal el `.exe`, crea un archivo `ejecutable.txt` dentro de la carpeta del juego con la ruta relativa del `.exe` correcto.

### Juegos de consola

- Archivos con extension inequivoca (`.gba`, `.nes`, `.sfc`, `.smc`, `.z64`, `.n64`, `.v64`, `.gb`, `.gbc`, `.nds`, `.md`, `.gen`): sueltos en `Pon-tus-juegos-aqui/`.
- Formatos ambiguos (`.iso`, `.chd`, `.bin`, `.cue`, `.zip`): dentro de una subcarpeta con el nombre del sistema de RetroBat, por ejemplo `Pon-tus-juegos-aqui/ps2/` o `Pon-tus-juegos-aqui/psx/`. Los nombres validos estan en la [lista de sistemas de RetroBat](https://wiki.retrobat.org/systems-and-emulators/supported-game-systems).

Algunas consolas necesitan BIOS (por ejemplo PS2). Debes obtenerla de tu propia consola y copiarla en `RetroBat/bios/` segun indique el wiki de cada sistema.

## Importante

- Este repositorio NO incluye RetroBat, emuladores, BIOS ni juegos.
- Usa solo juegos que tengas derecho a usar (por ejemplo copias de tus propios discos).
- La licencia de RetroBat prohibe venderlo preinstalado en dispositivos de almacenamiento. Este proyecto es gratuito y solo automatiza su instalacion.
- Un juego de PC copiado a la USB no siempre funciona en otro PC: ver `docs/solucionar-errores.md`.

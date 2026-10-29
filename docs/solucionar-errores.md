# Solucionar errores con juegos de PC

Sigue este orden y no pases al siguiente hasta descartar el anterior.

1. Abre el `.exe` del juego directamente, sin RetroBat. Si falla asi, el problema es el juego o el PC, no el proyecto.
2. Ejecutalo como administrador (clic derecho en el `.exe`).
3. Lee el mensaje de error:
   - Falta `d3dx9_*.dll` u otra libreria de DirectX: instala el DirectX End-User Runtime oficial de Microsoft.
   - Falta `vcruntime` o `msvcp`: instala el Visual C++ Redistributable oficial de Microsoft.
4. No descargues archivos DLL sueltos de paginas web. Instala el paquete oficial.
5. Verifica los requisitos del juego (por ejemplo FIFA 15: Windows 64 bits, 4 GB de RAM y GPU con DirectX 11).
6. Algunos repacks necesitan pasos previos (montar una imagen, copiar un archivo, instalar componentes). Lee el archivo de instrucciones del repack.
7. Si el menu abre otro `.exe` (por ejemplo un instalador), crea `ejecutable.txt` dentro de la carpeta del juego con la ruta relativa del `.exe` correcto y vuelve a ejecutar `2-AGREGAR-JUEGOS.bat`. Si ya existia el acceso `.bat` en `RetroBat/roms/windows`, borralo antes.

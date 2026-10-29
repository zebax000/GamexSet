# GamexSet — PS2

Una carpeta de juegos y un acceso para abrir PCSX2. Sin RetroBat. Solo PS2 por ahora.

## Primera preparación
1. Extrae el repositorio completo en una carpeta con permisos de escritura, por ejemplo en tu USB. No ejecutes los BAT dentro del ZIP.
2. Ejecuta PREPARAR.bat. Si falta PCSX2, se abrirá su página oficial: descarga la distribución portable para Windows y extrae TODO su contenido dentro de Emuladores/PCSX2 (el ejecutable debe quedar directamente ahí). Si viene comprimida en 7z, necesitas una herramienta compatible para extraerla.
3. Ejecuta PREPARAR.bat otra vez. Creará portable.ini sin sobrescribir tus ajustes.
4. En el asistente de PCSX2, selecciona tu BIOS, extraída de tu propia PS2, y configura el mando. No incluimos ni descargamos BIOS ni juegos.
5. Añade Juegos/PS2 como carpeta de biblioteca y activa la búsqueda en subcarpetas.

## Uso diario
Copia tus ISO de PS2 en Juegos/PS2 y abre JUGAR.bat. Elige un juego en PCSX2. Si no aparece, vuelve a examinar la biblioteca. No necesitas ejecutar un importador ni instalar cada juego. Los archivos comprimidos ZIP/RAR/7z deben extraerse primero. Una ISO de PC u otra consola no es un juego de PS2.

## Carpetas
- PREPARAR.bat: preparación inicial.
- JUGAR.bat: abre PCSX2 portable.
- Juegos/PS2: tus juegos; se permiten subcarpetas.
- Emuladores/PCSX2: distribución completa del emulador, BIOS y datos portables.
- scripts: lógica pequeña de preparación y arranque.

## USB y límites
El modo portable conserva los datos del emulador junto a él. Si cambias la letra de la USB y no aparecen los juegos, vuelve a seleccionar Juegos/PS2 en la biblioteca. El rendimiento depende del computador y no se garantiza compatibilidad con todos los juegos. Cierra PCSX2 antes de retirar la USB.

## Migración
Este cambio no borra carpetas, juegos o partidas de tu computador ni convierte partidas de RetroBat. Haz una copia de seguridad antes de retirar una instalación antigua. Los accesos y scripts antiguos quedan sustituidos por redirecciones a la nueva versión; sus nombres no se eliminan en este commit. No uses Pon-tus-juegos-aqui: la carpeta actual es Juegos/PS2.

Otras consolas se añadirán solo si se necesitan. No se incluyen emuladores adicionales.

Fuentes oficiales: https://pcsx2.net/downloads/ y https://pcsx2.net/docs/setup/

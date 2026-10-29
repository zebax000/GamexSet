@echo off
if not exist "%~dp0RetroBat\retrobat.exe" (
  echo Primero ejecuta 1-INSTALAR.bat
  pause
  exit /b
)
start "" "%~dp0RetroBat\retrobat.exe"

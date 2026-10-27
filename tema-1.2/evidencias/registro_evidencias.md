# Registro de Evidencias de Ejecución - Tema 1.2

**Estudiante:** Bryan Steven Quindil Ninasunta  
**Institución:** Instituto Superior Tecnológico Yavirac  
**Asignatura:** Aplicaciones Móviles  
**Fecha:** 26 de octubre de 2026  

---

## 1. Evidencia Actividad 2: Verificación de Versiones y Diagnóstico

### 1.1 Comando `flutter --version` y `dart --version`
```text
Flutter 3.35.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 9f455d2486 (1 year, 1 month ago) • 2025-10-08 14:55:31 -0500
Engine • hash a5f2c36e367c13f868cfe98db5806f562c52c35e (revision d2913632a4) (12 months ago) • 2025-10-07 17:26:21.000Z
Tools • Dart 3.9.2 • DevTools 2.48.0
Dart SDK version: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "windows_x64"
```

### 1.2 Ubicación de Ejecutables (`where.exe`)
```text
where.exe flutter:
C:\src\flutter\bin\flutter
C:\src\flutter\bin\flutter.bat

where.exe dart:
C:\src\flutter\bin\dart
C:\src\flutter\bin\dart.exe
```

### 1.3 Archivo de diagnóstico generado
El archivo de diagnóstico completo se encuentra en `../doctor.txt`.

---

## 2. Evidencia Actividad 3: Kit Portable e `iniciar.bat`

### 2.1 Código del script `iniciar.bat`
```batch
@echo off
set DEV=%~dp0
set PATH=%DEV%flutter\bin;%PATH%
set PUB_CACHE=%DEV%pub-cache
flutter --version
start "" "%DEV%vscode\Code.exe"
```

### 2.2 Validación de funcionamiento
- `%~dp0` resuelve dinámicamente la ruta de la unidad USB/carpeta del script con barra invertida final.
- Las variables de entorno modificadas dentro de `iniciar.bat` tienen ámbito local al proceso (sesión temporal). Al abrir una terminal independiente del sistema, el `PATH` no se encuentra alterado globalmente.
- VS Code se inicia como proceso hijo heredando el entorno enriquecido con `PATH` y `PUB_CACHE`.

---

## 3. Evidencia Actividad 4A: Ejecución de Consola (`hola_entorno`)

### 3.1 Ejecución en Terminal Integrada
Comando ejecutado:
```bash
cd hola_entorno
dart run bin/hola_entorno.dart
```

Salida interactiva con entrada estándar de usuario:
```text
¿Cómo te llamas? Steven
Hola, Steven. Tu entorno Dart funciona.
Sistema: windows
Dart: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "windows_x64"
```

### 3.2 Archivo de configuración de depuración
Ubicación: `hola_entorno/.vscode/launch.json`
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dart: archivo actual",
      "type": "dart",
      "request": "launch",
      "program": "${file}",
      "console": "terminal"
    }
  ]
}
```

---

## 4. Evidencia Actividad 4B: Destinos Ligeros y Flutter en Chrome (`hola_flutter`)

### 4.1 Dispositivos disponibles (`flutter devices`)
```text
3 connected devices:

Windows (desktop) • windows • windows-x64    • Microsoft Windows [Versión 10.0.26300.9711]
Chrome (web)      • chrome  • web-javascript • Google Chrome 156.0.8078.48
Edge (web)        • edge    • web-javascript • Microsoft Edge 153.0.4234.32
```

### 4.2 Configuración del proyecto `hola_flutter`
- Título personalizado en `lib/main.dart`: `"Steven Quindil - Entorno Portable"`
- Barra de estado / AppBar: `"Steven Quindil - Flutter en Chrome"`
- Color de tema (`seedColor`): `Colors.indigo`
- Verificación con `flutter analyze`: `No issues found! (ran in 10.4s)`

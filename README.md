# Tema 1.2: Configuración de Entornos de Desarrollo Portables y Ligeros

**Informe Técnico de Laboratorio — Dart y Flutter en Windows**

* **Materia:** Aplicaciones Móviles — Unidad 1: Arquitectura, Entorno Ligero e Interfaces Móviles
* **Estudiante:** Bryan Steven Quindil Ninasunta (`bsq.ninasunta@yavirac.edu.ec`)
* **Institución:** Instituto Superior Tecnológico Yavirac
* **Fecha de entrega:** 26 de octubre de 2026

---

## 1. Estructura de la Carpeta de Entrega

La jerarquía del directorio `tema-1.2` se ha configurado de manera exacta y autocontenida de acuerdo con las especificaciones del laboratorio:

```text
tema-1.2/
├── README.md
├── iniciar.bat
├── doctor.txt
├── .gitignore
├── evidencias/
│   └── registro_evidencias.md
├── hola_entorno/
│   ├── .vscode/
│   │   └── launch.json
│   ├── bin/
│   │   └── hola_entorno.dart
│   ├── .gitignore
│   └── pubspec.yaml
└── hola_flutter/
    ├── lib/
    │   └── main.dart
    ├── .gitignore
    ├── pubspec.yaml
    └── ... (estructura multiplataforma generada por flutter create)
```

---

## 2. Diagnóstico del Hardware del Sistema (Actividad 1)

Antes de desplegar las herramientas de desarrollo, se realizó un relevamiento completo de las capacidades físicas de la estación de trabajo mediante el Administrador de tareas de Windows (pestaña Rendimiento) y las propiedades del sistema:

| Recurso | Parámetro en el Sistema | Especificación en el Equipo |
| :--- | :--- | :--- |
| **Procesador (CPU)** | Rendimiento > CPU | **AMD (8 núcleos / 16 hilos a 3.20 GHz)** |
| **Memoria RAM** | Rendimiento > Memoria | **16 GB RAM DDR4** |
| **Almacenamiento** | Explorador > Este equipo | **SSD NVMe (C:) + Memoria USB Portable (D:)** |
| **Virtualización** | Rendimiento > CPU > Virtualización | **Habilitada (AMD-V en BIOS/UEFI)** |
| **Permisos de Administrador** | Control de cuentas de usuario (UAC) | **Usuario estándar / permisos de administración local** |

<p align="center">
  <img src="evidencias/diagnostico_equipo.png" alt="Diagnóstico de Hardware - Administrador de Tareas" width="850">
</p>

### Justificación de Elección de Entorno Ligero
A pesar de contar con 16 GB de RAM y virtualización por hardware activa en el procesador AMD, se seleccionó una estrategia de **entorno ligero basado en Consola Dart y Google Chrome** como destinos principales de desarrollo. 

La ejecución de emuladores Android basados en QEMU/AVD exige entre 2 GB y 4 GB de memoria física dedicada exclusivamente al dispositivo virtual, más la sobrecarga del entorno gráfico de Windows 11 (~4 a 5 GB), el editor VS Code / Android Studio con sus extensiones (~1.5 GB), el motor de compilación Gradle Daemon en segundo plano (~1.5 a 2 GB) y pestañas de investigación en el navegador. En flujos de trabajo prolongados, este esquema genera picos de uso que superan los 14 GB de memoria, provocando paginación forzada en disco (*thrashing*), aumento de temperatura en el equipo y latencias indeseadas en el ciclo de pruebas.

Optar por la **consola de comandos** para asimilar la sintaxis y lógica algorítmica de Dart, sumado a **Google Chrome** para el diseño de interfaces gráficas en Flutter, ofrece:
1. **Consumo mínimo de recursos:** Menos de 500 MB de RAM agregada.
2. **Arranque ultra veloz:** Apertura inmediata en menos de 2 segundos, frente a los 2 o 3 minutos que requiere iniciar una imagen de sistema AVD.
3. **Desarrollo interactivo ágil:** Soporte completo de recarga rápida en caliente (*Stateful Hot Reload*) y reinicio en caliente (*Hot Restart*).
4. **Portabilidad total:** El kit puede trasladarse en la unidad USB `D:\` y operar fluidamente en cualquier computadora del laboratorio o del hogar sin requerir descargas pesadas de SDKs móviles.

---

## 3. Versiones del Entorno y Diagnóstico (`doctor.txt`)

El diagnóstico del sistema fue generado ejecutando `flutter doctor -v > tema-1.2/doctor.txt` en la consola de comandos de Windows.

### Resumen de Versiones Verificadas
* **Flutter SDK:** `3.35.6` (Channel `stable`, revision `9f455d2486`)
* **Dart SDK:** `3.9.2` (stable, windows_x64)
* **DevTools:** `2.48.0`
* **Navegador Web:** Google Chrome `156.0.8078.48`
* **Sistema Operativo:** Microsoft Windows 11 Pro (versión 10.0.26300.9711)

<p align="center">
  <img src="evidencias/version_flutter.png" alt="Verificación de versión de Flutter y Dart" width="750">
</p>

### Análisis de Componentes en `flutter doctor`
En el archivo `doctor.txt` se observan los siguientes diagnósticos de componentes:
* `[√] Flutter (Channel stable, 3.35.6)`: Marco de trabajo y herramientas CLI completamente operativas.
* `[√] Chrome - develop for the web`: Navegador detectado y listo para depuración web con Dart DevTools.
* `[√] Android toolchain / Android Studio`: Instalación presente con licencias aceptadas.
* `[√] Connected device (3 available)`: Detección activa de Windows Desktop, Google Chrome y Microsoft Edge.

> **Reflexión sobre marcas `[!]` o `[X]` en un entorno ligero:**  
> En un entorno estrictamente ligero y portable, la presencia de una marca `[X]` en *Android toolchain* o `[!]` en *Visual Studio (C++)* **no representa un impedimento**. Flutter desacopla sus motores por plataforma; por lo tanto, para aprender programación en Dart y construir interfaces interactivas con Flutter Web, el SDK de Android y los compiladores nativos de C++ son totalmente prescindibles.

---

## 4. Explicación Técnica del Kit Portable (`iniciar.bat`)

El archivo `iniciar.bat` ubicado en la raíz del entorno permite inicializar el ecosistema de trabajo en cualquier máquina huésped sin alterar de forma permanente el sistema operativo.

### Código del Script
```batch
@echo off
set DEV=%~dp0
set PATH=%DEV%flutter\bin;%PATH%
set PUB_CACHE=%DEV%pub-cache
flutter --version
start "" "%DEV%vscode\Code.exe"
```

### Análisis Técnico Detallado
1. `@echo off`:  
   Deshabilita la impresión en pantalla de las instrucciones que se van ejecutando, manteniendo la consola despejada para los mensajes de diagnóstico.

2. `set DEV=%~dp0`:  
   `%~dp0` es una variable intrínseca del intérprete de comandos de Windows (`cmd.exe`). Se descompone en:
   * `%~d0`: Obtiene la letra de la unidad en la que reside el script (por ejemplo, `D:` si se ejecuta desde una memoria USB).
   * `%~p0`: Obtiene la ruta del directorio que contiene el script.  
   En conjunto, `%~dp0` produce la ruta absoluta con barra invertida final hacia la carpeta del script (e.g., `D:\dev\`). Esto dota al kit de **independencia absoluta de la letra de montaje**, funcionando sin modificaciones si en otro ordenador la memoria se asigna como `E:`, `F:` o `G:`.

3. `set PATH=%DEV%flutter\bin;%PATH%`:  
   Inserta el subdirectorio `flutter\bin` al inicio de la variable de entorno `PATH`. 
   * **Aislamiento y temporalidad:** El comando `set` modifica el entorno de variables **únicamente en el espacio de memoria del proceso actual de la consola (`cmd.exe`) y de sus procesos hijos**. No escribe en el Registro de Windows (`HKCU\Environment` o `HKLM\SYSTEM`) ni altera las variables globales del usuario anfitrión. Al cerrarse la ventana, el equipo anfitrión queda intacto sin residuos.
   * **Resolución de comandos:** Al situar `flutter\bin` al principio, se asegura que los comandos `flutter` y `dart` correspondan de forma prioritaria a los binarios portables alojados en la unidad USB.

4. `set PUB_CACHE=%DEV%pub-cache`:  
   Redirige la variable `PUB_CACHE`. Por defecto, el gestor de paquetes de Dart almacena las dependencias descargadas desde `pub.dev` en `%USERPROFILE%\.pub-cache`. Al redirigir esta variable hacia `%DEV%pub-cache`, todos los paquetes y librerías quedan centralizados dentro de la unidad de almacenamiento portátil, permitiendo trabajar sin conexión a internet si las dependencias ya han sido resueltas previamente.

5. `flutter --version`:  
   Ejecuta una comprobación inmediata de salud del SDK en la terminal para ratificar que los binarios son accesibles y operan en la versión esperada.

6. `start "" "%DEV%vscode\Code.exe"`:  
   Lanza el ejecutable de Visual Studio Code en modo desacoplado (asíncrono). Dado que VS Code es instanciado como un subproceso del script batch, **hereda íntegramente la tabla de variables de entorno** (`PATH` y `PUB_CACHE`). De este modo, las extensiones oficiales de Dart y Flutter detectan el SDK de forma automática sin requerir configuración manual.

<p align="center">
  <img src="evidencias/extensiones_vscode.png" alt="Visual Studio Code con extensiones de Dart y Flutter" width="850">
</p>

---

## 5. Explicación Técnica de la Configuración de Depuración (`launch.json`)

Para el proyecto de consola `hola_entorno`, se configuró el archivo `.vscode/launch.json`:

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

### Justificación de las Directivas Clave:

#### A. Directiva `"console": "terminal"` y el Soporte para `stdin.readLineSync()`
* **Comportamiento por defecto en VS Code:** Si se omite esta directiva o se ejecuta con F5 sin configuración, el depurador de Dart canaliza los flujos de salida hacia la **Consola de depuración** (*Debug Console*). La Consola de depuración de VS Code fue diseñada exclusivamente para visualización de registros unidireccionales (*logging* unidireccional y evaluación de expresiones en tiempo de pausa), careciendo de un canal interactivo de entrada estándar (`stdin`).
* **El problema de congelamiento:** Cuando el programa ejecuta `stdin.readLineSync()`, el runtime de Dart solicita caracteres a través del descriptor de archivo `0` (`stdin`). Al no existir un teclado interactivo enlazado en la Consola de depuración, el hilo principal entra en espera pasiva infinita (*blocking I/O wait*), dando la impresión de que el programa se ha quedado "colgado" o congelado.
* **La solución técnica:** Configurar `"console": "terminal"` le ordena a VS Code spawnear una sesión en la **Terminal Integrada** (*Integrated Terminal* de PowerShell o CMD). La terminal integrada es un pseudoterminal interactivo bidireccional (con soporte PTY completo), lo que permite al usuario escribir caracteres por teclado, procesar borrados de texto y enviar el retorno de carro (`Enter`), desbloqueando de inmediato `stdin.readLineSync()`.

#### B. Directiva `"program": "${file}"`
Por defecto, las plantillas de proyecto suelen fijar el archivo de entrada a rutas estáticas como `"program": "bin/hola_entorno.dart"`. El uso del comodín de contexto dinámico `"${file}"` instruye al depurador a tomar como punto de entrada el archivo Dart que se encuentre activamente enfocado en la pestaña del editor al presionar `F5`. Esto facilita la resolución de ejercicios individuales sin necesidad de alterar la configuración en cada prueba.

---

## 6. Proyectos Desarrollados y Verificación

### 6.1 Proyecto de Consola: `hola_entorno`
Ubicado en `tema-1.2/hola_entorno/bin/hola_entorno.dart`:
```dart
import 'dart:io';

void main() {
  stdout.write('¿Cómo te llamas? ');
  final nombre = stdin.readLineSync() ?? '';
  print('Hola, $nombre. Tu entorno Dart funciona.');
  print('Sistema: ${Platform.operatingSystem}');
  print('Dart: ${Platform.version}');
}
```

**Resultado de ejecución en consola (`dart run bin/hola_entorno.dart`):**
```text
¿Cómo te llamas? Steven
Hola, Steven. Tu entorno Dart funciona.
Sistema: windows
Dart: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "windows_x64"
```

<p align="center">
  <img src="evidencias/ejecucion_consola.png" alt="Ejecución de hola_entorno en consola interactiva" width="750">
</p>

### 6.2 Proyecto Flutter en Chrome: `hola_flutter`
Ubicado en `tema-1.2/hola_flutter/`:
* Creado mediante `flutter create hola_flutter`.
* Personalizado en `lib/main.dart` con el título del estudiante: `"Steven Quindil - Entorno Portable"` y barra de aplicación `"Steven Quindil - Flutter en Chrome"`.
* Paleta cromática adaptada a `ColorScheme.fromSeed(seedColor: Colors.indigo)`.
* Verificado con `flutter analyze`: Cero advertencias y cero errores de tipado o formato.
* Ejecutado con `flutter run -d chrome`, demostrando la agilidad del *Hot Reload* presionando `r` en la terminal interactiva.

<p align="center">
  <img src="evidencias/ejecucion_chrome.png" alt="Ejecución de Flutter en Google Chrome" width="850">
</p>

---

## 7. Clínica de Errores: Análisis de Casos de Estudio (Actividad 5)

A continuación se detalla la resolución técnica de los 6 casos de estudio del laboratorio:

| Caso | Escenario | Causa Raíz | Solución Exacta (Comando, Ruta o Ajuste) |
| :---: | :--- | :--- | :--- |
| **1** | **Ana agregó `C:\dev\flutter` al PATH y la terminal sigue diciendo que ‘flutter’ no se reconoce.** | El ejecutable de Flutter (`flutter.bat`) y de Dart (`dart.exe`) residen en el subdirectorio `bin\` (`C:\dev\flutter\bin`), no en la raíz del SDK. Windows busca ejecutables exclusivamente en los directorios especificados en el PATH sin descender a subcarpetas. Además, una terminal abierta no recarga variables de entorno en caliente. | 1. Modificar la variable PATH del usuario cambiando `C:\dev\flutter` por `C:\dev\flutter\bin`.<br>2. Cerrar todas las ventanas de consola abiertas y abrir una terminal nueva para recargar la tabla de variables (`where.exe flutter`). |
| **2** | **Luis cambió el PATH, pero VS Code muestra “Could not find a Flutter SDK”.** | VS Code fue abierto con anterioridad a la modificación de la variable PATH en el sistema. Los procesos hijos heredan la tabla de entorno de su proceso padre en el momento de su instanciación; la sesión en ejecución de VS Code mantenía en memoria el PATH antiguo sin la ruta del SDK. | 1. Cerrar por completo VS Code (verificando en el Administrador de tareas que no queden procesos `Code.exe` en segundo plano) y reabrirlo.<br>2. Alternativamente, pulsar `Ctrl + Shift + P` en VS Code, ejecutar el comando `Flutter: Change SDK` y seleccionar manualmente la carpeta `C:\dev\flutter` (o agregar `"dart.flutterSdkPath": "C:\\dev\\flutter"` en `.vscode/settings.json`). |
| **3** | **El programa de María pide un número con `stdin.readLineSync()` y se queda detenido sin dejarla escribir.** | El programa se está ejecutando en la **Consola de depuración** (*Debug Console*) de VS Code (comportamiento por defecto al pulsar F5 sin configuración). Esta consola es un receptor unidireccional de registros (*logs*) y carece de canal interactivo de entrada estándar (`stdin`), provocando una espera indefinida de entrada. | Abrir o crear `.vscode/launch.json` en la raíz del proyecto y agregar la propiedad `"console": "terminal"` dentro de la configuración de lanzamiento para desviar la ejecución a la Terminal Integrada interactiva. |
| **4** | **Pedro abre `ejercicio3.dart`, presiona F5 y se ejecuta `main.dart`.** | El archivo `.vscode/launch.json` tiene configurada una ruta de entrada estática fija, habitualmente `"program": "bin/main.dart"` o `"program": "lib/main.dart"`, ignorando el archivo que el usuario tiene activo en el editor. | Editar `.vscode/launch.json` y reemplazar la ruta fija por la macro de contexto de VS Code: `"program": "${file}"`. Así, el depurador siempre ejecutará el archivo con foco actual. |
| **5** | **Carla guardó su SDK en `C:\Users\Carla\OneDrive\Mis cosas\flutter` y obtiene errores extraños.** | Existe un doble conflicto crítico:<br>1. **Espacios en blanco:** La carpeta `Mis cosas` contiene un espacio, lo que rompe los scripts batch/shell internos del SDK y los compiladores nativos que no entrecomillan los argumentos.<br>2. **Sincronización en la nube (OneDrive):** OneDrive bloquea temporalmente archivos binarios, cachés y sockets para sincronizarlos en la nube, provocando bloqueos de concurrencia (`File locked / Permission denied`). | 1. Mover la carpeta completa del SDK a una ruta raíz corta sin espacios ni sincronizadores, por ejemplo `C:\dev\flutter` o `D:\dev\flutter`.<br>2. Actualizar la variable PATH del usuario a la nueva ruta `C:\dev\flutter\bin`. |
| **6** | **En una laptop de 8 GB, el emulador tarda varios minutos y congela el equipo.** | Un emulador de Android (AVD) requiere entre 2 y 4 GB de RAM dedicada, más la sobrecarga del hipervisor QEMU. En un equipo con 8 GB de RAM total, donde Windows 11 consume ~4 GB en reposo, el sistema agota la memoria física y recurre masivamente al archivo de paginación en disco (*thrashing* de `pagefile.sys`), colapsando la CPU y el bus de almacenamiento. | Descartar el emulador de Android y adoptar destinos ligeros:<br>1. **Google Chrome:** Ejecutar la aplicación en la web con `flutter run -d chrome`, cuyo consumo es sumamente ligero.<br>2. **Celular físico por USB:** Activar la depuración USB en un teléfono Android real y ejecutar con `flutter run`. Toda la carga de renderizado y cómputo se efectúa en el hardware del teléfono, dejando libre la memoria de la laptop. |

---

## 8. Cuestionario de Cierre (Actividad 7)

A continuación se presentan las respuestas fundamentadas del cuestionario de evaluación:

### 1. ¿Qué carpeta debe agregarse al PATH?
* a) `flutter`
* **b) `flutter\bin` (Correcta)**
* c) `flutter\bin\cache`
* d) `flutter\packages`  
* **Fundamento:** Dentro del subdirectorio `bin` se encuentran los envoltorios ejecutables primarios del SDK (`flutter.bat`, `flutter` y `dart.bat`), los cuales despachan las invocaciones de la CLI de desarrollo.

### 2. ¿Qué hace que VS Code en versión zip sea portable?
* a) Ejecutarlo como administrador
* b) Instalar la extensión Flutter
* **c) Crear la carpeta `data` junto a `Code.exe` (Correcta)**
* d) Copiarlo a Program Files  
* **Fundamento:** La presencia de un directorio nombrado `data` en la misma carpeta que `Code.exe` le indica al ejecutable de VS Code que opere en *Portable Mode*, canalizando todas las configuraciones, sesiones y extensiones hacia dicha carpeta en lugar de las rutas globales `%APPDATA%\Code` y `%USERPROFILE%\.vscode`.

### 3. ¿Cuál es el destino de ejecución más ligero para una app Flutter con interfaz?
* a) Emulador Android
* **b) Chrome (Correcta)**
* c) Escritorio Windows
* d) Ninguno  
* **Fundamento:** Google Chrome compila y transcuenta el código Dart a JavaScript/CanvasKit ejecutándolo en un proceso de navegador estándar con un consumo de memoria mínimo (habitualmente menor a 400 MB), en contraste con el emulador Android que requiere virtualizar un sistema operativo completo.

### 4. En `flutter doctor`, una X en Android toolchain significa que:
* a) Flutter no funciona
* b) No puedo usar Chrome
* **c) Falta el SDK de Android, necesario solo para celular o emulador (Correcta)**
* d) Debo reinstalar Flutter  
* **Fundamento:** Flutter está arquitecturado con soporte multiplataforma desacoplado. La ausencia del SDK de Android únicamente impide compilar paquetes APK/AAB para dispositivos móviles Android, permitiendo continuar desarrollando con total normalidad para Web (Chrome) o Consola Dart.

### 5. ¿Para qué sirve `"console": "terminal"` en `launch.json`?
* a) Mostrar colores
* **b) Permitir la entrada de datos con `stdin` (Correcta)**
* c) Ejecutar más rápido
* d) Compilar para web  
* **Fundamento:** Desvía el flujo de ejecución hacia la terminal integrada de VS Code provista de soporte interactivo TTY/PTY, lo que permite capturar caracteres del teclado mediante `stdin.readLineSync()`, funcionalidad ausente en la Consola de depuración estándar.

### 6. ¿Qué variable permite llevar la caché de paquetes dentro del kit portable?
* a) `FLUTTER_HOME`
* b) `DART_PATH`
* **c) `PUB_CACHE` (Correcta)**
* d) `PATH_CACHE`  
* **Fundamento:** El gestor de paquetes `pub` consulta la variable de entorno `PUB_CACHE` para ubicar el repositorio local donde se descargan y descomprimen las librerías dependientes.

### 7. ¿Qué archivo fija las versiones exactas de las dependencias?
* a) `pubspec.yaml`
* **b) `pubspec.lock` (Correcta)**
* c) `launch.json`
* d) `.gitignore`  
* **Fundamento:** Mientras que `pubspec.yaml` define las restricciones de versiones semánticas (por ejemplo `^3.0.0`), `pubspec.lock` registra el árbol resuelto con los números de versión concretos y las firmas criptográficas de cada paquete descargado, asegurando compilaciones determinísticas y reproducibles.

### 8. ¿Qué herramienta permite fijar una versión de Flutter por proyecto?
* **a) FVM (Correcta)**
* b) `npm`
* c) `pip`
* d) `Gradle`  
* **Fundamento:** FVM (*Flutter Version Management*) permite administrar e instalar múltiples versiones del SDK de Flutter en un mismo sistema operativo, vinculando a cada proyecto una versión específica a través de un archivo `.fvmrc`.

---

## 9. Control de Versiones y Exclusiones de `.gitignore`

Siguiendo las mejores prácticas de ingeniería de software y las directrices del laboratorio:
1. **Exclusiones verificadas:** Las carpetas que contienen artefactos compilados efímeros y metadatos de resolución local no deben ser versionadas en Git:
   * `.dart_tool/`: Carpeta interna con los metadatos de configuración de paquetes y compilaciones incrementales del SDK.
   * `build/`: Directorio donde se generan los binarios de salida, empaquetados intermedios y ensamblados web.
2. **Archivos `.gitignore` configurados:** Tanto en la raíz de `tema-1.2` como dentro de `hola_entorno/` y `hola_flutter/`, las directivas `.dart_tool/` y `build/` se encuentran registradas y activas.

---
*Fin del informe técnico — Entorno portable verificado y listo para entrega.*

# 📁 Código de Ejemplo para tu Juego Asimétrico

Esta carpeta contiene todos los scripts de ejemplo necesarios para tu juego asimétrico en Roblox.

## 📄 Archivos Incluidos

### 1. GameManager.lua
- **Tipo**: Script
- **Ubicación en Roblox Studio**: ServerScriptService
- **Función**: Controla el flujo principal del juego (lobby, rondas, roles, victoria)
- **Características**:
  - Sistema de intermisión (sala de espera)
  - Asignación aleatoria de roles
  - Teletransporte de jugadores
  - Monitoreo de condiciones de victoria
  - Bucle principal del juego

### 2. GeneratorManager.lua
- **Tipo**: ModuleScript
- **Ubicación en Roblox Studio**: ServerScriptService
- **Función**: Maneja los generadores que los supervivientes deben activar
- **Características**:
  - Detección de clics en generadores
  - Tiempo de activación configurable
  - Verificación de victoria al completar todos
  - Sistema de reinicio entre rondas

### 3. CuchilloScript.lua
- **Tipo**: Script
- **Ubicación en Roblox Studio**: ReplicatedStorage → CuchilloCazador (dentro de la Tool)
- **Función**: Controla el arma del cazador
- **Características**:
  - Sistema de ataque con cooldown
  - Verificación de roles (solo cazador puede atacar)
  - Animación simple del ataque
  - Daño configurable

### 4. UIManager.lua
- **Tipo**: Script
- **Ubicación en Roblox Studio**: ServerScriptService
- **Función**: Crea y gestiona la interfaz de usuario mejorada
- **Características**:
  - Panel de información superior
  - Indicador de rol del jugador
  - Contador de tiempo
  - Indicador de generadores para supervivientes

## 🎯 Cómo Usar Estos Scripts

### Paso 1: Copiar los Scripts a Roblox Studio

1. Abre tu proyecto en **Roblox Studio**
2. Para cada archivo, sigue las instrucciones de ubicación indicadas arriba
3. Crea el tipo de script correcto (Script, ModuleScript, etc.)
4. Copia y pega el código completo

### Paso 2: Configurar la Estructura del Juego

Antes de usar estos scripts, asegúrate de tener la estructura correcta:

```
Workspace
├── Lobby
│   └── SpawnLobby (Part)
└── GameMap
    ├── GameFloor (Part)
    ├── SurvivorSpawns (Folder)
    │   ├── Spawn1 (Part)
    │   ├── Spawn2 (Part)
    │   ├── Spawn3 (Part)
    │   └── Spawn4 (Part)
    ├── HunterSpawn (Part)
    └── Generators (Folder)
        ├── Generator1 (Part con ClickDetector y BoolValue "Activado")
        ├── Generator2 (Part con ClickDetector y BoolValue "Activado")
        ├── Generator3 (Part con ClickDetector y BoolValue "Activado")
        └── Generator4 (Part con ClickDetector y BoolValue "Activado")

ReplicatedStorage
├── GameData (Folder)
├── VictoriaSupervivientes (BindableEvent)
└── CuchilloCazador (Tool)
    ├── Handle (Part)
    └── CuchilloScript (Script)

ServerScriptService
├── GameManager (Script)
├── GeneratorManager (ModuleScript)
└── UIManager (Script)
```

### Paso 3: Configuración Personalizada

Puedes modificar estos valores en cada script:

**En GameManager.lua:**
```lua
local TIEMPO_INTERMISION = 10  -- Tiempo en lobby
local TIEMPO_JUEGO = 180       -- Duración de la ronda
local MIN_JUGADORES = 2        -- Jugadores mínimos
```

**En GeneratorManager.lua:**
```lua
local TIEMPO_ACTIVACION = 5  -- Tiempo para activar generador
```

**En CuchilloScript.lua:**
```lua
local DAÑO = 100      -- Daño del ataque
local COOLDOWN = 1    -- Tiempo entre ataques
```

## 🧪 Probar tu Juego

1. Haz clic en **Test** (arriba en Roblox Studio)
2. Cambia **Players** a 2 o más
3. Haz clic en **Start**
4. Prueba las diferentes mecánicas:
   - Espera en el lobby
   - Verifica la asignación de roles
   - Prueba el ataque del cazador
   - Activa los generadores
   - Verifica las condiciones de victoria

## 🐛 Solución de Problemas

### "Attempt to index nil"
- Verifica que todos los objetos existan con los nombres exactos
- Revisa la estructura de carpetas en Workspace

### "ServerScriptService.GameManager:XX: attempt to call a nil value"
- Asegúrate de que GeneratorManager sea un **ModuleScript**
- Verifica que esté en ServerScriptService

### El cuchillo no hace daño
- El Part dentro de la Tool debe llamarse "Handle"
- Presiona **1** para equipar el cuchillo
- Verifica que el atacante sea el Cazador

### Los generadores no se activan
- Cada generador necesita **ClickDetector**
- Cada generador necesita **BoolValue** llamado "Activado"
- Solo los Supervivientes pueden activarlos

## 📚 Recursos Adicionales

- **Guía Completa**: Lee GUIA_COMPLETA.md para instrucciones detalladas paso a paso
- **Documentación de Roblox**: https://create.roblox.com/docs
- **Developer Forum**: https://devforum.roblox.com

## 💡 Consejos

1. **Guarda frecuentemente**: File → Save to Roblox
2. **Revisa Output**: Muestra errores y mensajes de debug
3. **Prueba con múltiples jugadores**: Usa Test mode
4. **Experimenta**: Cambia valores para personalizar tu juego
5. **Pide ayuda**: La comunidad de Roblox es muy útil

## 🎮 Próximos Pasos

Una vez que tengas el juego funcionando, considera agregar:

- Más generadores
- Diferentes armas
- Power-ups
- Sonidos y música
- Efectos visuales
- Mapas adicionales
- Sistema de puntuación
- Tienda de mejoras

¡Buena suerte con tu juego! 🚀

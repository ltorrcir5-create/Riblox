# 🎯 Guía de Referencia Rápida

## Para el Usuario Impaciente

¿Quieres empezar rápidamente? Sigue estos pasos:

### 1️⃣ Preparación (5 minutos)

1. Descarga e instala **Roblox Studio** desde [roblox.com](https://www.roblox.com)
2. Crea cuenta si no tienes una (gratis)
3. Abre Roblox Studio
4. Selecciona **Baseplate** → **Create**

### 2️⃣ Estructura del Juego (10 minutos)

Crea esta estructura en **Workspace**:

```
Workspace
├── Lobby
│   └── SpawnLobby (Part: 50x1x50, Anchored)
└── GameMap
    ├── GameFloor (Part: 100x1x100, Anchored)
    ├── SurvivorSpawns (Folder)
    │   └── Spawn1-4 (Parts: 4x1x4, Anchored, Transparency=1)
    ├── HunterSpawn (Part: 4x1x4, Anchored, Transparency=1, Color=Rojo)
    └── Generators (Folder)
        └── Generator1-4 (Parts: 4x6x4, Anchored, Material=Metal)
            ├── ClickDetector
            └── Activado (BoolValue, desmarcado)
```

### 3️⃣ Configurar ReplicatedStorage (2 minutos)

```
ReplicatedStorage
├── GameData (Folder)
├── VictoriaSupervivientes (BindableEvent)
└── CuchilloCazador (Tool)
    ├── Handle (Part: 0.5x3x0.2, Color=Gris)
    └── CuchilloScript (Script) → Copiar de codigo-ejemplos/
```

### 4️⃣ Scripts (5 minutos)

En **ServerScriptService**, crea:

1. **GameManager** (Script) → Copiar de `codigo-ejemplos/GameManager.lua`
2. **GeneratorManager** (ModuleScript) → Copiar de `codigo-ejemplos/GeneratorManager.lua`
3. **UIManager** (Script) → Copiar de `codigo-ejemplos/UIManager.lua`

### 5️⃣ ¡Probar! (1 minuto)

1. Click en **Test**
2. Cambia **Players** a 2
3. Click en **Start**
4. ¡Juega!

---

## 📋 Checklist Rápido

Marca lo que has completado:

### Workspace
- [ ] Lobby/SpawnLobby creado
- [ ] GameMap/GameFloor creado
- [ ] SurvivorSpawns con 4 spawns
- [ ] HunterSpawn creado
- [ ] Generators carpeta creada
- [ ] 4 generadores con ClickDetector y BoolValue

### ReplicatedStorage
- [ ] GameData carpeta
- [ ] VictoriaSupervivientes (BindableEvent)
- [ ] CuchilloCazador (Tool) con Handle
- [ ] CuchilloScript dentro de la Tool

### ServerScriptService
- [ ] GameManager (Script)
- [ ] GeneratorManager (ModuleScript)
- [ ] UIManager (Script)

### Probar
- [ ] Juego inicia con 2 jugadores
- [ ] Roles se asignan (1 Cazador, resto Supervivientes)
- [ ] Cazador puede atacar con cuchillo (tecla 1)
- [ ] Supervivientes pueden activar generadores
- [ ] Juego termina cuando se cumple condición de victoria

---

## 🎮 Controles del Juego

### Como Jugador
- **W,A,S,D**: Moverse
- **Espacio**: Saltar
- **1**: Equipar herramienta (Cazador)
- **Click**: Atacar (Cazador) / Activar generador (Superviviente)

### En Roblox Studio
- **Play (▶)**: Probar solo
- **Test**: Probar con múltiples jugadores
- **Stop (⏹)**: Detener prueba
- **F9**: Abrir Output (ver errores)

---

## ⚙️ Configuración Rápida

### Modificar Tiempos

En **GameManager.lua** (líneas 6-8):
```lua
local TIEMPO_INTERMISION = 10  -- Cambiar tiempo en lobby
local TIEMPO_JUEGO = 180       -- Cambiar duración de ronda
local MIN_JUGADORES = 2        -- Cambiar mínimo de jugadores
```

### Modificar Ataque

En **CuchilloScript.lua** (líneas 8-9):
```lua
local DAÑO = 100      -- Cambiar daño (100 = mata al instante)
local COOLDOWN = 1    -- Cambiar tiempo entre ataques
```

### Modificar Generadores

En **GeneratorManager.lua** (línea 8):
```lua
local TIEMPO_ACTIVACION = 5  -- Cambiar tiempo para activar
```

---

## 🐛 Problemas Comunes

| Problema | Solución |
|----------|----------|
| "Attempt to index nil" | Verifica nombres exactos de objetos |
| Juego no inicia | Necesitas al menos MIN_JUGADORES |
| Roles no se asignan | Revisa que GameData exista en ReplicatedStorage |
| Cuchillo no daña | Verifica que Part se llame "Handle" |
| Generadores no funcionan | Deben tener ClickDetector y BoolValue "Activado" |

---

## 📞 Ayuda

- **¿Algo no funciona?** → Lee **GUIA_COMPLETA.md** sección "Solución de Problemas"
- **¿Quieres más detalles?** → Lee **GUIA_COMPLETA.md** desde el inicio
- **¿Código no funciona?** → Revisa **codigo-ejemplos/README.md**

---

## 🚀 Siguiente Nivel

Una vez que funcione:

1. **Personaliza**: Cambia colores, tiempos, tamaños
2. **Agrega sonidos**: Toolbox → Audio
3. **Mejora el mapa**: Agrega paredes, decoración
4. **Iluminación**: Insert → Light → SpotLight
5. **Efectos**: Insert → ParticleEmitter

---

## 📚 Recursos

- **Guía Completa**: [GUIA_COMPLETA.md](GUIA_COMPLETA.md)
- **Código Ejemplo**: [codigo-ejemplos/](codigo-ejemplos/)
- **Documentación Oficial**: https://create.roblox.com/docs
- **DevForum**: https://devforum.roblox.com
- **YouTube**: AlvinBlox, TheDevKing

---

*¿Listo para empezar? ¡Vamos! 🎮*

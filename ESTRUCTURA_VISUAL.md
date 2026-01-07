# 📊 Estructura Visual del Proyecto

## 🏗️ Arquitectura del Juego

```
┌─────────────────────────────────────────────────────────┐
│                    ROBLOX STUDIO                        │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
    WORKSPACE      REPLICATEDSTORAGE  SERVERSCRIPTSERVICE
        │                  │                  │
        │                  │                  │
```

## 📁 Jerarquía Completa del Proyecto

```
🎮 Mi Juego Asimétrico
│
├── 🌍 Workspace (El mundo del juego)
│   │
│   ├── 📦 Lobby (Sala de espera)
│   │   ├── 🟦 SpawnLobby (Part)
│   │   │   • Size: 50, 1, 50
│   │   │   • Anchored: ✓
│   │   │   • Material: Grass/Concrete
│   │   │   • Color: Verde/Gris
│   │   │
│   │   └── 🎯 SpawnLocation (Punto de aparición)
│   │       • Anchored: ✓
│   │       • CanCollide: ✗
│   │       • Transparency: 0.5
│   │
│   └── 📦 GameMap (Mapa de juego)
│       │
│       ├── 🟦 GameFloor (Part - Piso principal)
│       │   • Size: 100, 1, 100
│       │   • Anchored: ✓
│       │   • Position: Lejos del lobby
│       │
│       ├── 📁 SurvivorSpawns
│       │   ├── 🟦 Spawn1 (Part)
│       │   ├── 🟦 Spawn2 (Part)
│       │   ├── 🟦 Spawn3 (Part)
│       │   └── 🟦 Spawn4 (Part)
│       │       • Size: 4, 1, 4
│       │       • Anchored: ✓
│       │       • Transparency: 1 (invisible)
│       │
│       ├── 🟥 HunterSpawn (Part)
│       │   • Size: 4, 1, 4
│       │   • Anchored: ✓
│       │   • Transparency: 1
│       │   • Color: Rojo
│       │
│       └── 📁 Generators
│           ├── ⚡ Generator1 (Part)
│           ├── ⚡ Generator2 (Part)
│           ├── ⚡ Generator3 (Part)
│           └── ⚡ Generator4 (Part)
│               • Size: 4, 6, 4
│               • Anchored: ✓
│               • Material: Metal
│               • Color: Gris oscuro
│               │
│               ├── 👆 ClickDetector
│               └── ✔️ Activado (BoolValue)
│                   • Value: false (inicial)
│
├── 💾 ReplicatedStorage (Compartido servidor/cliente)
│   │
│   ├── 📁 GameData
│   │   └── (Almacena datos del juego)
│   │
│   ├── 📢 VictoriaSupervivientes (BindableEvent)
│   │   └── (Comunica victoria de supervivientes)
│   │
│   └── 🔪 CuchilloCazador (Tool)
│       │
│       ├── 🟦 Handle (Part)
│       │   • Size: 0.5, 3, 0.2
│       │   • Material: Metal
│       │   • Color: Gris
│       │
│       └── 📜 CuchilloScript (Script)
│           └── Controla el ataque del cazador
│
└── ⚙️ ServerScriptService (Scripts del servidor)
    │
    ├── 📜 GameManager (Script)
    │   └── Control principal del juego
    │
    ├── 📦 GeneratorManager (ModuleScript)
    │   └── Sistema de generadores
    │
    └── 📜 UIManager (Script)
        └── Interfaz de usuario
```

## 🔄 Flujo del Juego

```
┌─────────────┐
│   INICIO    │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────┐
│   INTERMISIÓN (Lobby)           │
│   • Espera MIN_JUGADORES        │
│   • Cuenta regresiva 10s        │
│   • Reinicia generadores        │
└──────┬──────────────────────────┘
       │
       ▼
┌─────────────────────────────────┐
│   ASIGNACIÓN DE ROLES           │
│   • 1 Cazador (aleatorio)       │
│   • Resto = Supervivientes      │
│   • Configurar personajes       │
│   • Dar herramientas            │
└──────┬──────────────────────────┘
       │
       ▼
┌─────────────────────────────────┐
│   TELETRANSPORTE                │
│   • Cazador → HunterSpawn       │
│   • Supervivientes → Spawns     │
└──────┬──────────────────────────┘
       │
       ▼
┌─────────────────────────────────┐
│   JUEGO ACTIVO (180s)           │
│                                 │
│   Cazador:                      │
│   • Eliminar supervivientes     │
│                                 │
│   Supervivientes:               │
│   • Activar generadores         │
│   • Evitar al cazador           │
└──────┬──────────────────────────┘
       │
       ├─────────────┬──────────────┬──────────────┐
       │             │              │              │
       ▼             ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ Cazador  │  │ Todos    │  │ Tiempo   │  │ Error/   │
│ Gana     │  │ Gens OK  │  │ Agotado  │  │ Abandono │
└────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │              │              │
     └─────────────┴──────────────┴──────────────┘
                    │
                    ▼
            ┌───────────────┐
            │   ENDING      │
            │ Mostrar       │
            │ mensaje 5s    │
            └───────┬───────┘
                    │
                    ▼
            ┌───────────────┐
            │ REINICIAR     │
            │ (vuelve a     │
            │ Intermisión)  │
            └───────────────┘
```

## 🎭 Sistema de Roles

```
┌─────────────────────────────────────────┐
│          ASIGNACIÓN DE ROLES            │
└─────────────────────────────────────────┘

Lista de Jugadores: [J1, J2, J3, J4]
                           │
                           ▼
                    math.random(1, 4)
                           │
                    ┌──────┴──────┐
                    │             │
                    ▼             ▼
              ┌──────────┐   ┌──────────┐
              │ CAZADOR  │   │SUPERVIV. │
              │  (J2)    │   │(J1,J3,J4)│
              └────┬─────┘   └────┬─────┘
                   │              │
    ┌──────────────┼──────────────┼──────────────┐
    │              │              │              │
    ▼              ▼              ▼              ▼
┌────────┐   ┌─────────┐   ┌─────────┐   ┌──────────┐
│ Speed  │   │ Color   │   │ Cuchillo│   │ UI Roja  │
│  +25%  │   │  Rojo   │   │ (Tool)  │   │ "CAZADOR"│
└────────┘   └─────────┘   └─────────┘   └──────────┘

              SUPERVIVIENTES
                   │
    ┌──────────────┼──────────────┐
    │              │              │
    ▼              ▼              ▼
┌────────┐   ┌─────────┐   ┌──────────┐
│ Speed  │   │ Color   │   │ UI Azul  │
│ Normal │   │ Normal  │   │"SUPERVIV"│
└────────┘   └─────────┘   └──────────┘
```

## ⚡ Sistema de Generadores

```
┌──────────────────────────────────────┐
│     ESTADO DE GENERADORES            │
└──────────────────────────────────────┘

Inicial: [⚪ Gen1] [⚪ Gen2] [⚪ Gen3] [⚪ Gen4]
           │         │         │         │
           │ Click   │ Click   │         │
           ▼         ▼         │         │
Progreso: [🟡 ...] [⚪ Gen2] [⚪ Gen3] [⚪ Gen4]
           │         │         │         │
    Wait 5s  │ Wait 5s│         │         │
           ▼         ▼         │         │
Estado:   [🟢 OK!] [⚪ Gen2] [⚪ Gen3] [⚪ Gen4]
                     │         │ Click   │ Click
                     ▼         ▼         ▼
Final:    [🟢 OK!] [🟢 OK!] [🟢 OK!] [🟢 OK!]
                              │
                              ▼
                      ┌───────────────┐
                      │  VICTORIA     │
                      │SUPERVIVIENTES!│
                      └───────────────┘

⚪ = Inactivo (Gris, Metal)
🟡 = Activando (5 segundos)
🟢 = Activado (Verde, Neon)
```

## 🎯 Condiciones de Victoria

```
┌────────────────────────────────────────────────┐
│          VERIFICACIÓN DE VICTORIA              │
└────────────────────────────────────────────────┘

Cada segundo durante el juego:
│
├─► ¿Todos los generadores activados?
│   │
│   ├─► SÍ → 🎉 SUPERVIVIENTES GANAN
│   │
│   └─► NO → Continuar
│
├─► ¿Todos los supervivientes muertos?
│   │
│   ├─► SÍ → 💀 CAZADOR GANA
│   │
│   └─► NO → Continuar
│
└─► ¿Tiempo agotado (180s)?
    │
    ├─► SÍ → ⏰ EMPATE / FIN DE TIEMPO
    │
    └─► NO → Continuar juego
```

## 📊 Comunicación entre Scripts

```
┌──────────────┐        ┌──────────────┐
│ GameManager  │◄──────►│ Generator    │
│              │  Module │ Manager      │
└──────┬───────┘  Require└──────┬───────┘
       │                         │
       │ VictoriaSupervivientes  │
       │   (BindableEvent)       │
       │◄────────────────────────┘
       │
       ├──────────────┐
       │              │
       ▼              ▼
┌──────────────┐  ┌──────────────┐
│  UIManager   │  │ Players      │
│              │  │ (Jugadores)  │
└──────────────┘  └──────────────┘
```

## 🎨 Interfaz de Usuario (UI)

```
┌─────────────────────────────────────────────────┐
│  ⏱️ 02:34          JUEGO ACTIVO      🔪 CAZADOR │  ← InfoPanel
├─────────────────────────────────────────────────┤
│                                                  │
│                                                  │
│          ⚡ Generadores: 2/4                    │  ← GeneradoresFrame
│                                                  │    (solo supervivientes)
│                                                  │
│                                                  │
│                                                  │
│       ┌──────────────────────────────┐          │
│       │  ¡Los roles han sido         │          │  ← MensajeLabel
│       │    asignados!                │          │    (mensajes centrales)
│       └──────────────────────────────┘          │
│                                                  │
│                                                  │
│                                                  │
└─────────────────────────────────────────────────┘
```

## 🔧 Scripts y Funciones

```
📜 GameManager.lua (Script Principal)
│
├─► obtenerJugadores()
│   └─► Devuelve lista de jugadores vivos
│
├─► teletransportarLobby(jugador)
│   └─► Mueve jugador al lobby
│
├─► enviarMensaje(mensaje)
│   └─► Muestra mensaje a todos
│
├─► configurarPersonaje(jugador)
│   └─► Ajusta velocidad y apariencia por rol
│
├─► darHerramientas(jugador)
│   └─► Da cuchillo al cazador
│
├─► asignarRoles()
│   └─► Elige cazador y asigna supervivientes
│
├─► teletransportarMapa()
│   └─► Mueve jugadores a sus spawns
│
├─► verificarSupervivientes()
│   └─► Cuenta supervivientes vivos
│
├─► victoriaSupervivientes()
│   └─► Termina juego con victoria supervivientes
│
├─► victoriaCazador()
│   └─► Termina juego con victoria cazador
│
├─► monitorearJuego()
│   └─► Verifica condiciones de victoria
│
├─► intermision()
│   └─► Espera en lobby
│
├─► iniciarRonda()
│   └─► Comienza el juego
│
├─► terminarRonda(razon)
│   └─► Finaliza el juego
│
└─► buclePrincipal()
    └─► Loop infinito: intermisión → ronda → intermisión...

📦 GeneratorManager.lua (ModuleScript)
│
├─► configurarGenerador(generador)
│   └─► Conecta ClickDetector con lógica
│
├─► verificarVictoria()
│   └─► Revisa si todos activados
│
└─► reiniciarGeneradores()
    └─► Resetea todos los generadores

📜 CuchilloScript.lua (Tool Script)
│
├─► atacar()
│   └─► Detecta contacto y hace daño
│
└─► tool.Activated:Connect(atacar)
    └─► Ejecuta al hacer clic

📜 UIManager.lua (UI Script)
│
└─► crearUI(jugador)
    └─► Crea interfaz personalizada
```

## 📦 Tipos de Objetos Importantes

```
Part (Bloque 3D)
│
├─► Properties principales:
│   ├─ Size (Vector3): Tamaño
│   ├─ Position (Vector3): Posición
│   ├─ Anchored (bool): Fijo o no
│   ├─ CanCollide (bool): Colisión
│   ├─ Transparency (0-1): Transparencia
│   ├─ Color (Color3): Color
│   └─ Material: Textura

Tool (Herramienta equipable)
│
├─► Debe contener:
│   ├─ Handle (Part): Parte visible
│   └─ Script: Lógica de la herramienta
│
└─► Se guarda en:
    ├─ Backpack del jugador
    └─ Character cuando equipada

ClickDetector (Detector de clics)
│
└─► Events:
    ├─ MouseClick: Al hacer clic
    └─ MouseHoverEnter/Leave: Al pasar mouse

BoolValue (Valor booleano)
│
└─► Properties:
    └─ Value: true o false

BindableEvent (Evento entre scripts)
│
└─► Methods:
    ├─ Fire(): Disparar evento
    └─ Event:Connect(func): Escuchar evento
```

## 🎓 Conceptos Clave

```
SERVER vs CLIENT
│
├─► SERVER (Script)
│   ├─ Se ejecuta en el servidor
│   ├─ Controla el juego
│   ├─ Autoridad sobre datos
│   └─ Ubicación: ServerScriptService
│
└─► CLIENT (LocalScript)
    ├─ Se ejecuta en cada jugador
    ├─ Controla UI y efectos locales
    ├─ No tiene autoridad sobre datos
    └─ Ubicación: StarterGui, StarterPlayer

REPLICATION (Replicación)
│
├─► ReplicatedStorage
│   └─ Accesible desde servidor y cliente
│
└─► Workspace
    └─ Visible para todos automáticamente
```

---

*Para más detalles, consulta **GUIA_COMPLETA.md***

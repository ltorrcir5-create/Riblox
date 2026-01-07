# 🎮 Guía Completa: Crea tu Primer Juego Asimétrico en Roblox

## 📋 Tabla de Contenidos
1. [Introducción](#introducción)
2. [Fase 0: Configuración Inicial](#fase-0-configuración-inicial)
3. [Fase 1: Sistema Básico de Partida](#fase-1-sistema-básico-de-partida)
4. [Fase 2: Asignación de Roles](#fase-2-asignación-de-roles)
5. [Fase 3: Mecánicas Básicas](#fase-3-mecánicas-básicas)
6. [Fase 4: Sistema de Objetivos](#fase-4-sistema-de-objetivos)
7. [Fase 5: Condiciones de Victoria](#fase-5-condiciones-de-victoria)
8. [Fase 6: Mejoras Opcionales](#fase-6-mejoras-opcionales)
9. [Solución de Problemas](#solución-de-problemas)

---

## Introducción

Bienvenido a esta guía completa para crear tu primer juego asimétrico en Roblox. Un juego asimétrico es aquel donde los jugadores tienen roles diferentes con objetivos distintos, como Dead by Daylight, Piggy o Flee the Facility.

**En nuestro juego:**
- 1 jugador será el **Cazador** (monstruo/asesino)
- Los demás serán **Supervivientes**
- El Cazador debe eliminar a todos los supervivientes
- Los Supervivientes deben completar tareas y escapar

**No necesitas saber programación** - te explicaré todo paso a paso.

---

## Fase 0: Configuración Inicial

### Paso 1: Instalar Roblox Studio

1. Ve a [www.roblox.com](https://www.roblox.com)
2. Crea una cuenta si no tienes una (es gratis)
3. Descarga **Roblox Studio** desde la página principal
4. Instala el programa en tu computadora

### Paso 2: Crear tu Primer Proyecto

1. Abre **Roblox Studio**
2. En la ventana que aparece, busca **"Baseplate"** (Placa base)
3. Haz clic en **Baseplate** y luego en **"Create"** (Crear)
4. Espera a que cargue - verás un espacio 3D con una plataforma gris

### Paso 3: Conocer la Interfaz

**Partes importantes de Roblox Studio:**

- **Vista 3D** (centro): Aquí ves tu juego
- **Explorer** (derecha): Lista de todo en tu juego (como carpetas)
- **Properties** (derecha abajo): Detalles del objeto seleccionado
- **Output** (abajo): Muestra mensajes y errores del código

**Si no ves Explorer o Properties:**
- Ve al menú **"View"** (Ver) arriba
- Activa **Explorer** y **Properties**

### Paso 4: Guardar tu Proyecto

1. Haz clic en **File → Save to Roblox** (Archivo → Guardar en Roblox)
2. Ponle un nombre: **"Mi Juego Asimétrico"**
3. Haz clic en **Save**

✅ **Confirma que llegaste hasta aquí antes de continuar**

---

## Fase 1: Sistema Básico de Partida

En esta fase crearemos:
- Un **Lobby** (sala de espera)
- Un **Mapa de juego**
- Sistema que inicia y termina rondas automáticamente

### Paso 1: Crear el Lobby (Sala de Espera)

1. En el **Explorer**, busca **Workspace**
2. Haz clic derecho en **Workspace** → **Insert Object** → **Folder**
3. Cambia el nombre de la carpeta a **"Lobby"**

Ahora crearemos una plataforma para el lobby:

4. Haz clic derecho en **Lobby** → **Insert Object** → **Part**
5. En **Properties**, cambia estos valores:
   - **Name**: SpawnLobby
   - **Size**: 50, 1, 50 (ancho, alto, largo)
   - **Anchored**: ✓ (marcado)
   - **Color**: Elige un color que te guste
   - **Material**: Puedes elegir Grass, Concrete, etc.

### Paso 2: Crear el Mapa de Juego

1. Haz clic derecho en **Workspace** → **Insert Object** → **Folder**
2. Nómbralo **"GameMap"**
3. Haz clic derecho en **GameMap** → **Insert Object** → **Part**
4. Configura:
   - **Name**: GameFloor
   - **Size**: 100, 1, 100
   - **Anchored**: ✓
   - **Color**: Diferente al lobby
   - **Position**: Muévelo lejos del lobby (ejemplo: 0, 0, 200)

### Paso 3: Crear Puntos de Aparición

**Para el Lobby:**

1. Haz clic derecho en **Lobby** → **Insert Object** → **SpawnLocation**
2. Colócalo sobre la plataforma SpawnLobby (arrástralo en la vista 3D)
3. En **Properties**:
   - **Anchored**: ✓
   - **CanCollide**: ✗ (desmarcado)
   - **Transparency**: 0.5

**Para el Mapa de Juego:**

4. Haz clic derecho en **GameMap** → **Insert Object** → **Folder**
5. Nómbralo **"SurvivorSpawns"**
6. Haz clic derecho en **SurvivorSpawns** → **Insert Object** → **Part**
7. Configura:
   - **Name**: Spawn1
   - **Size**: 4, 1, 4
   - **Anchored**: ✓
   - **Transparency**: 1 (invisible)
   - Colócalo sobre GameFloor

Repite el proceso para crear Spawn2, Spawn3, Spawn4 (para 4 jugadores)

8. Haz clic derecho en **GameMap** → **Insert Object** → **Part**
9. Configura:
   - **Name**: HunterSpawn
   - **Size**: 4, 1, 4
   - **Anchored**: ✓
   - **Transparency**: 1
   - **Color**: Rojo (para identificarlo)

### Paso 4: Crear el Script del Sistema de Rondas

Este script controlará todo el flujo del juego.

1. En **Explorer**, busca **ServerScriptService**
2. Haz clic derecho → **Insert Object** → **Script**
3. Nómbralo **"GameManager"**
4. Haz doble clic en **GameManager** para abrirlo
5. **Borra todo el texto** que tenga
6. **Copia y pega** este código:

```lua
-- GameManager.lua
-- Este script controla el flujo del juego

-- CONFIGURACIÓN
local TIEMPO_INTERMISION = 10  -- Segundos en el lobby antes de empezar
local TIEMPO_JUEGO = 180       -- Segundos de duración de cada ronda (3 minutos)
local MIN_JUGADORES = 2        -- Mínimo de jugadores para empezar

-- REFERENCIAS a objetos del juego
local Players = game:GetService("Players")  -- Servicio que maneja jugadores
local ReplicatedStorage = game:GetService("ReplicatedStorage")  -- Para compartir información
local Workspace = game.Workspace  -- El mundo del juego

-- VARIABLES GLOBALES
local estadoJuego = "Intermision"  -- Estado actual: Intermision, Playing, Ending
local tiempoRestante = TIEMPO_INTERMISION

-- FUNCIÓN: Obtener todos los jugadores activos
local function obtenerJugadores()
    local jugadores = {}
    for _, jugador in pairs(Players:GetPlayers()) do
        if jugador.Character and jugador.Character:FindFirstChild("Humanoid") then
            if jugador.Character.Humanoid.Health > 0 then
                table.insert(jugadores, jugador)
            end
        end
    end
    return jugadores
end

-- FUNCIÓN: Teletransportar jugador al lobby
local function teletransportarLobby(jugador)
    local spawnLobby = Workspace.Lobby:FindFirstChild("SpawnLobby")
    if spawnLobby and jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
        -- Posición aleatoria en el spawn del lobby
        local randomX = math.random(-20, 20)
        local randomZ = math.random(-20, 20)
        local posicion = spawnLobby.Position + Vector3.new(randomX, 5, randomZ)
        jugador.Character.HumanoidRootPart.CFrame = CFrame.new(posicion)
    end
end

-- FUNCIÓN: Mensaje a todos los jugadores
local function enviarMensaje(mensaje)
    for _, jugador in pairs(Players:GetPlayers()) do
        if jugador:FindFirstChild("PlayerGui") then
            -- Crear mensaje en pantalla
            local screenGui = jugador.PlayerGui:FindFirstChild("MensajeGui")
            if not screenGui then
                screenGui = Instance.new("ScreenGui")
                screenGui.Name = "MensajeGui"
                screenGui.Parent = jugador.PlayerGui
            end
            
            local textLabel = screenGui:FindFirstChild("Mensaje")
            if not textLabel then
                textLabel = Instance.new("TextLabel")
                textLabel.Name = "Mensaje"
                textLabel.Size = UDim2.new(1, 0, 0.1, 0)
                textLabel.Position = UDim2.new(0, 0, 0.05, 0)
                textLabel.BackgroundTransparency = 0.5
                textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.Parent = screenGui
            end
            
            textLabel.Text = mensaje
        end
    end
end

-- FUNCIÓN: Intermisión (espera en lobby)
local function intermision()
    estadoJuego = "Intermision"
    tiempoRestante = TIEMPO_INTERMISION
    
    -- Teletransportar todos al lobby
    for _, jugador in pairs(Players:GetPlayers()) do
        teletransportarLobby(jugador)
    end
    
    -- Cuenta regresiva
    while tiempoRestante > 0 do
        local jugadores = obtenerJugadores()
        
        if #jugadores >= MIN_JUGADORES then
            enviarMensaje("Juego comenzando en " .. tiempoRestante .. " segundos...")
        else
            enviarMensaje("Esperando jugadores... (" .. #jugadores .. "/" .. MIN_JUGADORES .. ")")
            tiempoRestante = TIEMPO_INTERMISION  -- Reiniciar si no hay suficientes
        end
        
        wait(1)
        tiempoRestante = tiempoRestante - 1
    end
end

-- FUNCIÓN: Iniciar ronda de juego
local function iniciarRonda()
    estadoJuego = "Playing"
    tiempoRestante = TIEMPO_JUEGO
    
    enviarMensaje("¡La ronda ha comenzado!")
    wait(3)
    
    -- Aquí más adelante asignaremos roles y teletransportaremos jugadores
    
    -- Cuenta regresiva del juego
    while tiempoRestante > 0 and estadoJuego == "Playing" do
        enviarMensaje("Tiempo restante: " .. tiempoRestante .. " segundos")
        wait(1)
        tiempoRestante = tiempoRestante - 1
    end
    
    if estadoJuego == "Playing" then
        terminarRonda("¡Se acabó el tiempo!")
    end
end

-- FUNCIÓN: Terminar ronda
function terminarRonda(razon)
    estadoJuego = "Ending"
    enviarMensaje(razon)
    wait(5)
end

-- FUNCIÓN: Bucle principal del juego
local function buclePrincipal()
    while true do
        intermision()
        iniciarRonda()
    end
end

-- INICIAR el juego
print("GameManager iniciado correctamente")
buclePrincipal()
```


### Explicación del Código

**¿Qué hace este script?**

1. **Configuración** (líneas 4-6): Define tiempos y requisitos
2. **Referencias** (líneas 9-11): Conecta con servicios de Roblox
3. **Variables globales** (líneas 14-15): Guardan el estado actual
4. **Funciones**:
   - `obtenerJugadores()`: Lista jugadores vivos
   - `teletransportarLobby()`: Mueve jugador al lobby
   - `enviarMensaje()`: Muestra texto en pantalla
   - `intermision()`: Espera en lobby
   - `iniciarRonda()`: Comienza el juego
   - `terminarRonda()`: Finaliza la ronda
   - `buclePrincipal()`: Repite el ciclo infinitamente

**Tipos de Scripts:**
- **Script** (normal): Se ejecuta en el servidor - controla el juego
- **LocalScript**: Se ejecuta en el cliente - controla la interfaz del jugador
- **ModuleScript**: Código reutilizable

Este es un **Script** normal porque controla el flujo del juego para todos.

### Paso 5: Probar el Sistema

1. Haz clic en el botón **Play** (▶) arriba
2. Deberías ver:
   - Mensaje en pantalla
   - Cuenta regresiva
   - Tu personaje en el lobby

3. Haz clic en **Stop** (⏹) para salir

**Si algo no funciona:**
- Ve a **Output** (abajo) - ahí aparecen los errores
- Verifica que todos los nombres coincidan exactamente
- Asegúrate de que las carpetas estén en Workspace

✅ **Confirma que funciona antes de continuar a la Fase 2**

---

## Fase 2: Asignación de Roles

Ahora haremos que el juego elija aleatoriamente quién será el Cazador.

### Paso 1: Crear Valores para Roles

Vamos a crear una forma de guardar qué rol tiene cada jugador.

1. En **Explorer**, busca **ReplicatedStorage**
2. Haz clic derecho → **Insert Object** → **Folder**
3. Nómbralo **"GameData"**

### Paso 2: Crear Script de Asignación de Roles

Vamos a crear funciones adicionales para el GameManager.

En **ServerScriptService**, crea un archivo nuevo llamado **"RoleAssignment.lua"** con este código (es parte del tutorial, los usuarios lo copiarán):

```lua
-- Código de ejemplo para asignación de roles
-- Los usuarios agregarán esto al GameManager

-- FUNCIÓN: Asignar roles a jugadores
local function asignarRoles()
    local jugadores = obtenerJugadores()
    
    -- Limpiar roles anteriores
    for _, jugador in pairs(jugadores) do
        if jugador:FindFirstChild("Rol") then
            jugador.Rol:Destroy()
        end
    end
    
    -- Elegir cazador aleatorio
    local cazador = jugadores[math.random(1, #jugadores)]
    
    -- Asignar rol de cazador
    local rolCazador = Instance.new("StringValue")
    rolCazador.Name = "Rol"
    rolCazador.Value = "Cazador"
    rolCazador.Parent = cazador
    
    -- Asignar rol de superviviente a los demás
    for _, jugador in pairs(jugadores) do
        if jugador ~= cazador then
            local rolSuperviviente = Instance.new("StringValue")
            rolSuperviviente.Name = "Rol"
            rolSuperviviente.Value = "Superviviente"
            rolSuperviviente.Parent = jugador
        end
    end
    
    -- Avisar a cada jugador su rol
    for _, jugador in pairs(jugadores) do
        if jugador:FindFirstChild("Rol") then
            local rol = jugador.Rol.Value
            if jugador:FindFirstChild("PlayerGui") then
                local screenGui = jugador.PlayerGui:FindFirstChild("MensajeGui")
                if screenGui then
                    local rolLabel = screenGui:FindFirstChild("RolLabel")
                    if not rolLabel then
                        rolLabel = Instance.new("TextLabel")
                        rolLabel.Name = "RolLabel"
                        rolLabel.Size = UDim2.new(0.3, 0, 0.08, 0)
                        rolLabel.Position = UDim2.new(0.7, 0, 0.02, 0)
                        rolLabel.BackgroundTransparency = 0.3
                        rolLabel.TextScaled = true
                        rolLabel.Font = Enum.Font.SourceSansBold
                        rolLabel.Parent = screenGui
                    end
                    
                    if rol == "Cazador" then
                        rolLabel.Text = "🔪 CAZADOR"
                        rolLabel.BackgroundColor3 = Color3.new(1, 0, 0)
                        rolLabel.TextColor3 = Color3.new(1, 1, 1)
                    else
                        rolLabel.Text = "🏃 SUPERVIVIENTE"
                        rolLabel.BackgroundColor3 = Color3.new(0, 0.5, 1)
                        rolLabel.TextColor3 = Color3.new(1, 1, 1)
                    end
                end
            end
        end
    end
    
    return cazador
end

-- FUNCIÓN: Teletransportar jugadores al mapa
local function teletransportarMapa()
    local jugadores = obtenerJugadores()
    local survivorSpawns = Workspace.GameMap.SurvivorSpawns:GetChildren()
    local hunterSpawn = Workspace.GameMap:FindFirstChild("HunterSpawn")
    
    local spawnIndex = 1
    
    for _, jugador in pairs(jugadores) do
        if jugador:FindFirstChild("Rol") and jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
            if jugador.Rol.Value == "Cazador" then
                -- Teletransportar cazador
                if hunterSpawn then
                    jugador.Character.HumanoidRootPart.CFrame = CFrame.new(hunterSpawn.Position + Vector3.new(0, 3, 0))
                end
            else
                -- Teletransportar superviviente
                if survivorSpawns[spawnIndex] then
                    jugador.Character.HumanoidRootPart.CFrame = CFrame.new(survivorSpawns[spawnIndex].Position + Vector3.new(0, 3, 0))
                    spawnIndex = spawnIndex + 1
                    if spawnIndex > #survivorSpawns then
                        spawnIndex = 1
                    end
                end
            end
        end
    end
end

-- FUNCIÓN: Configurar características del personaje según rol
local function configurarPersonaje(jugador)
    if jugador.Character and jugador:FindFirstChild("Rol") then
        local humanoid = jugador.Character:FindFirstChild("Humanoid")
        if humanoid then
            if jugador.Rol.Value == "Cazador" then
                -- Cazador: más rápido
                humanoid.WalkSpeed = 20  -- Velocidad normal es 16
                
                -- Cambiar color para identificar (opcional)
                for _, parte in pairs(jugador.Character:GetChildren()) do
                    if parte:IsA("BasePart") then
                        parte.Color = Color3.new(0.8, 0, 0)  -- Rojo oscuro
                    end
                end
            else
                -- Superviviente: velocidad normal
                humanoid.WalkSpeed = 16
            end
        end
    end
end
```

### Explicación del Código de Roles

**`asignarRoles()`**:
1. Obtiene la lista de jugadores
2. Elimina roles anteriores
3. Elige un jugador aleatorio como Cazador usando `math.random()`
4. Crea un "StringValue" (texto guardado) llamado "Rol" en cada jugador
5. Muestra en pantalla el rol de cada uno

**`teletransportarMapa()`**:
1. Lee los puntos de aparición que creamos
2. Si es Cazador → va a HunterSpawn
3. Si es Superviviente → va a uno de los SurvivorSpawns

**`configurarPersonaje()`**:
1. Ajusta la velocidad según el rol
2. Cambia el color del Cazador a rojo para identificarlo fácilmente

✅ **Los usuarios integrarán este código en su GameManager siguiendo las instrucciones detalladas**

---

## Fase 3: Mecánicas Básicas - Sistema de Ataque

### Paso 1: Crear el Arma del Cazador

Vamos a crear una herramienta (cuchillo) para el Cazador.

En tu proyecto de Roblox Studio:

1. En **Explorer**, busca **ReplicatedStorage**
2. Haz clic derecho → **Insert Object** → **Tool**
3. Nómbralo **"CuchilloCazador"**
4. Haz clic derecho en **CuchilloCazador** → **Insert Object** → **Part**
5. Configura el Part:
   - **Name**: Handle (IMPORTANTE: debe llamarse Handle)
   - **Size**: 0.5, 3, 0.2
   - **Color**: Gris metálico
   - **Material**: Metal

6. Haz clic derecho en **CuchilloCazador** → **Insert Object** → **Script**
7. Nómbralo **"CuchilloScript"**
8. Pega este código:

```lua
-- CuchilloScript.lua
-- Script del arma del cazador

local tool = script.Parent
local handle = tool:WaitForChild("Handle")

local DAÑO = 100  -- Daño que hace (100 = mata instantáneamente)
local COOLDOWN = 1  -- Segundos entre ataques
local puedeAtacar = true

-- Función para atacar
local function atacar()
    if not puedeAtacar then return end
    
    puedeAtacar = false
    
    -- Detectar qué toca el cuchillo
    local conexion
    conexion = handle.Touched:Connect(function(parte)
        if parte.Parent:FindFirstChild("Humanoid") then
            local victima = game.Players:GetPlayerFromCharacter(parte.Parent)
            local atacante = game.Players:GetPlayerFromCharacter(tool.Parent)
            
            if victima and atacante then
                -- Verificar que el atacante es el cazador
                if atacante:FindFirstChild("Rol") and atacante.Rol.Value == "Cazador" then
                    -- Verificar que la víctima es superviviente
                    if victima:FindFirstChild("Rol") and victima.Rol.Value == "Superviviente" then
                        -- Hacer daño
                        parte.Parent.Humanoid:TakeDamage(DAÑO)
                        print(atacante.Name .. " atacó a " .. victima.Name)
                    end
                end
            end
        end
    end)
    
    -- Animación simple: mover el cuchillo
    local originalPos = handle.CFrame
    handle.CFrame = handle.CFrame * CFrame.new(0, 0, -2)  -- Mover hacia adelante
    wait(0.2)
    handle.CFrame = originalPos
    
    conexion:Disconnect()
    
    wait(COOLDOWN)
    puedeAtacar = true
end

-- Cuando se activa la herramienta
tool.Activated:Connect(atacar)
```

### Paso 2: Sistema para Dar Herramientas

Código de ejemplo para agregar al GameManager:

```lua
-- FUNCIÓN: Dar herramientas según rol
local function darHerramientas(jugador)
    if jugador:FindFirstChild("Rol") and jugador.Character then
        -- Limpiar herramientas anteriores
        if jugador:FindFirstChild("Backpack") then
            jugador.Backpack:ClearAllChildren()
        end
        if jugador.Character:FindFirstChild("CuchilloCazador") then
            jugador.Character.CuchilloCazador:Destroy()
        end
        
        if jugador.Rol.Value == "Cazador" then
            -- Dar cuchillo al cazador
            local cuchillo = game.ReplicatedStorage:FindFirstChild("CuchilloCazador")
            if cuchillo then
                local cuchilloCopia = cuchillo:Clone()
                cuchilloCopia.Parent = jugador.Backpack
            end
        end
    end
end
```

### Cómo Usar el Cuchillo

1. Presiona **1** en el teclado para equipar el cuchillo
2. Acércate a un superviviente
3. Haz **clic** con el mouse para atacar
4. El cuchillo se mueve hacia adelante y causa daño

✅ **Confirma que el ataque funciona correctamente**

---

## Fase 4: Sistema de Objetivos para Supervivientes

Los Supervivientes necesitan completar generadores para ganar.

### Paso 1: Crear Generadores

1. En **Workspace → GameMap**, crea una carpeta **"Generators"**
2. Crea varios generadores (Generator1, Generator2, etc.)
3. Para cada generador:
   - Crea un **Part** con tamaño 4, 6, 4
   - **Anchored**: ✓
   - **Material**: Metal
   - **Color**: Gris oscuro
   - Agregar **ClickDetector**
   - Agregar **BoolValue** llamado "Activado" (desmarcado)

### Paso 2: Script de Generadores

Crea un **ModuleScript** llamado "GeneratorManager" en **ServerScriptService**:

```lua
-- GeneratorManager.lua
-- Controla los generadores

local Players = game:GetService("Players")
local Workspace = game.Workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TIEMPO_ACTIVACION = 5  -- Segundos para activar

local generators = Workspace.GameMap.Generators:GetChildren()

-- Configurar generador
local function configurarGenerador(generador)
    local clickDetector = generador:FindFirstChild("ClickDetector")
    local activado = generador:FindFirstChild("Activado")
    
    if clickDetector and activado then
        clickDetector.MouseClick:Connect(function(jugador)
            if jugador:FindFirstChild("Rol") and jugador.Rol.Value == "Superviviente" then
                if not activado.Value then
                    print(jugador.Name .. " activando " .. generador.Name)
                    
                    wait(TIEMPO_ACTIVACION)
                    
                    activado.Value = true
                    generador.Color = Color3.new(0, 1, 0)  -- Verde
                    generador.Material = Enum.Material.Neon
                    
                    verificarVictoria()
                end
            end
        end)
    end
end

-- Verificar si todos activados
function verificarVictoria()
    local todosActivados = true
    
    for _, gen in pairs(generators) do
        local activado = gen:FindFirstChild("Activado")
        if activado and not activado.Value then
            todosActivados = false
            break
        end
    end
    
    if todosActivados then
        print("¡Supervivientes ganan!")
        -- Llamar función de victoria
    end
end

-- Reiniciar generadores
local function reiniciarGeneradores()
    for _, gen in pairs(generators) do
        local activado = gen:FindFirstChild("Activado")
        if activado then
            activado.Value = false
            gen.Color = Color3.new(0.3, 0.3, 0.3)
            gen.Material = Enum.Material.Metal
        end
    end
end

-- Configurar todos
for _, gen in pairs(generators) do
    configurarGenerador(gen)
end

-- Exportar funciones
local GeneratorService = {}
GeneratorService.Reiniciar = reiniciarGeneradores
GeneratorService.Verificar = verificarVictoria

return GeneratorService
```

### Explicación del Sistema de Generadores

1. **ClickDetector**: Permite hacer clic en el generador
2. **BoolValue "Activado"**: Guarda si está activado o no
3. **TIEMPO_ACTIVACION**: Cuánto tarda en activarse
4. Cuando todos están activados → Supervivientes ganan

✅ **Prueba activando todos los generadores**

---

## Fase 5: Condiciones de Victoria y Derrota

### Sistema Completo de Victoria

Código para agregar al GameManager:

```lua
-- FUNCIÓN: Verificar supervivientes vivos
local function verificarSupervivientes()
    local jugadores = obtenerJugadores()
    local supervivientesVivos = 0
    
    for _, jugador in pairs(jugadores) do
        if jugador:FindFirstChild("Rol") and jugador.Rol.Value == "Superviviente" then
            supervivientesVivos = supervivientesVivos + 1
        end
    end
    
    return supervivientesVivos
end

-- FUNCIÓN: Victoria de supervivientes
local function victoriaSupervivientes()
    if estadoJuego ~= "Playing" then return end
    terminarRonda("🎉 ¡SUPERVIVIENTES GANARON! Todos los generadores activados.")
end

-- FUNCIÓN: Victoria del cazador
local function victoriaCazador()
    if estadoJuego ~= "Playing" then return end
    terminarRonda("💀 ¡CAZADOR GANÓ! Todos los supervivientes eliminados.")
end

-- FUNCIÓN: Monitorear juego
local function monitorearJuego()
    while estadoJuego == "Playing" do
        wait(1)
        
        local supervivientes = verificarSupervivientes()
        if supervivientes == 0 then
            victoriaCazador()
            break
        end
    end
end
```

### Condiciones de Victoria

1. **Supervivientes ganan si**:
   - Activan todos los generadores

2. **Cazador gana si**:
   - Elimina a todos los supervivientes

3. **Empate si**:
   - Se acaba el tiempo (3 minutos)

✅ **Prueba todos los escenarios de victoria**

---

## Fase 6: Mejoras Opcionales

### Mejora 1: Interfaz de Usuario Mejorada

Crea un Script "UIManager" para mejorar la UI:

```lua
-- UIManager.lua
-- Interfaz mejorada

local Players = game:GetService("Players")

local function crearUI(jugador)
    jugador.CharacterAdded:Connect(function(character)
        wait(1)
        
        if jugador:FindFirstChild("PlayerGui") then
            local playerGui = jugador.PlayerGui
            
            if playerGui:FindFirstChild("GameUI") then
                playerGui.GameUI:Destroy()
            end
            
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "GameUI"
            screenGui.ResetOnSpawn = false
            screenGui.Parent = playerGui
            
            -- Panel de información
            local infoPanel = Instance.new("Frame")
            infoPanel.Size = UDim2.new(1, 0, 0.08, 0)
            infoPanel.BackgroundColor3 = Color3.new(0, 0, 0)
            infoPanel.BackgroundTransparency = 0.3
            infoPanel.Parent = screenGui
            
            -- Label de rol
            local rolLabel = Instance.new("TextLabel")
            rolLabel.Size = UDim2.new(0.25, 0, 1, 0)
            rolLabel.Position = UDim2.new(0.75, 0, 0, 0)
            rolLabel.BackgroundTransparency = 1
            rolLabel.TextColor3 = Color3.new(1, 1, 1)
            rolLabel.TextScaled = true
            rolLabel.Font = Enum.Font.SourceSansBold
            rolLabel.Text = "Esperando rol..."
            rolLabel.Parent = infoPanel
        end
    end)
end

for _, jugador in pairs(Players:GetPlayers()) do
    crearUI(jugador)
end

Players.PlayerAdded:Connect(crearUI)
```

### Mejora 2: Sonidos

Agregar sonidos del Toolbox de Roblox:
1. Ve a **Toolbox** → **Audio**
2. Busca "scary", "generator", "attack"
3. Arrastra a **ReplicatedStorage → Sounds**

### Mejora 3: Iluminación

1. Inserta **Lighting** efectos:
   - **Atmosphere** para niebla
   - **ColorCorrection** para tono oscuro
2. Agrega **SpotLights** en el mapa
3. Cambia **Lighting.ClockTime** a 0 (noche)

### Mejora 4: Partículas

Agregar efectos visuales:
1. **ParticleEmitter** en generadores
2. Efectos de humo y chispas
3. Trail en el cuchillo del cazador

### Mejora 5: Mapa Más Complejo

Mejora tu mapa:
1. Agrega paredes y habitaciones
2. Crea zonas para esconderse
3. Usa diferentes materiales y texturas
4. Agrega decoración (árboles, rocas, muebles)

✅ **Implementa las mejoras que prefieras**

---

## Solución de Problemas

### Problema: El juego no comienza

**Causas posibles:**
- No hay suficientes jugadores (mínimo 2)
- GameManager no está ejecutándose

**Solución:**
1. Verifica **Output** para errores
2. Asegúrate MIN_JUGADORES = 2
3. Prueba con **Test** → **Players: 2**

### Problema: Roles no se asignan

**Verifica:**
1. ReplicatedStorage → GameData existe
2. Función asignarRoles() está siendo llamada
3. Revisa Output para mensajes

### Problema: Cuchillo no hace daño

**Verifica:**
1. Part se llama "Handle" exactamente
2. Script está dentro de la Tool
3. Presiona **1** para equipar
4. Comprueba que el atacante es Cazador

### Problema: Generadores no funcionan

**Verifica:**
1. Cada generador tiene ClickDetector
2. Cada generador tiene BoolValue "Activado"
3. GeneratorManager está en ServerScriptService
4. Solo Supervivientes pueden activarlos

### Problema: No aparece la UI

**Verifica:**
1. UIManager está ejecutándose
2. ScreenGui tiene ResetOnSpawn = false
3. El jugador tiene PlayerGui

### Errores Comunes en Output

**"Attempt to index nil"**:
- Un objeto no existe, verifica el nombre

**"Script timeout"**:
- Bucle infinito sin wait(), agrega wait()

**"Unable to cast"**:
- Tipo de dato incorrecto

### Cómo Leer Errores

1. Primera línea = qué está mal
2. Nombre del script con el error
3. Número de línea con el problema
4. Revisa esa línea y su lógica

---

## Próximos Pasos y Expansión

¡Felicidades por crear tu juego asimétrico! Aquí hay ideas para expandirlo:

### Ideas de Mecánicas

1. **Sistema de vidas**: 3 golpes para eliminar
2. **Power-ups**: Velocidad temporal, invisibilidad
3. **Escondites**: Armarios, casilleros
4. **Habilidades especiales**: Dash, visión aumentada
5. **Múltiples mapas**: Selección aleatoria
6. **Sistema de puntos**: Guardar estadísticas
7. **Tienda**: Comprar skins con puntos
8. **Diferentes modos**: Solo, Dúos, Escuadrones
9. **Trampas**: El Cazador puede colocar trampas
10. **Progreso de tareas**: Barra de progreso visual

### Ideas de Balance

- Ajustar velocidad del Cazador
- Cambiar número de generadores necesarios
- Modificar tiempo de ronda
- Agregar más Cazadores con muchos jugadores
- Sistema de respawn limitado

### Publicar tu Juego

1. **File → Publish to Roblox**
2. Configura:
   - Nombre descriptivo y atractivo
   - Icono llamativo (512x512px)
   - Descripción clara del gameplay
   - Categoría: Horror, Aventura, o All Genres
   - Género: Adventure o Scary
3. **Settings**:
   - Max Players: 6-12 recomendado
   - Allow Copying: Tu decisión
   - Permissions: Configura quién puede editar
4. **Monetización** (opcional):
   - Game Passes: Beneficios premium
   - Dev Products: Poder consumibles
   - Private Servers: Servidores privados

### Marketing

1. **Crea un grupo** de Roblox para tu juego
2. **Graba un trailer** mostrando gameplay
3. **Comparte** en redes sociales
4. **Pide feedback** en forums
5. **Actualiza regularmente** con nuevo contenido
6. **Publicita** con Robux (sponsor/ads)

---

## Recursos Adicionales de Aprendizaje

### Tutoriales y Documentación

- **[Roblox Creator Hub](https://create.roblox.com/docs)**: Documentación oficial
- **[Roblox Education](https://education.roblox.com)**: Cursos estructurados
- **[DevForum](https://devforum.roblox.com)**: Comunidad de desarrolladores
- **[Roblox API Reference](https://create.roblox.com/docs/reference/engine)**: Referencia completa

### Canales de YouTube Recomendados

- **AlvinBlox**: Tutoriales para principiantes
- **TheDevKing**: Scripting avanzado
- **Gnomenclature**: Tips y trucos
- **PeasFactory**: Construcción y diseño

### Comunidades

- **r/robloxgamedev**: Reddit
- **Roblox Developer Discord**: Ayuda en tiempo real
- **Hidden Developers**: Comunidad hispana

### Herramientas y Plugins Útiles

**Plugins recomendados:**
1. **Building Tools by F3X**: Construcción avanzada
2. **Studio+**: Mejoras para Studio
3. **Atrazine**: Selección y edición mejorada
4. **Stravant's Material Flip**: Cambiar materiales rápido
5. **Archimedes**: Cálculos de física
6. **Moon Animator**: Animaciones profesionales
7. **DataStore Editor**: Editar datos guardados
8. **Load Character**: Cargar tu avatar en Studio

### Librerías de Código Útiles

- **ProfileService**: Guardar datos de jugadores
- **Roact**: Crear UIs complejas
- **Rodux**: Gestión de estado
- **TestEZ**: Testing automatizado

---

## Glosario Completo de Términos

### Conceptos de Roblox

- **Workspace**: El mundo 3D del juego
- **Players**: Servicio que maneja jugadores
- **ReplicatedStorage**: Almacenamiento compartido
- **ServerScriptService**: Scripts del servidor
- **StarterGui**: UI inicial de jugadores
- **StarterPack**: Herramientas iniciales
- **Lighting**: Control de luz y ambiente
- **SoundService**: Gestión de audio

### Objetos y Componentes

- **Part**: Objeto 3D básico
- **Model**: Grupo de Parts
- **Tool**: Herramienta que los jugadores pueden usar
- **Humanoid**: Controla personajes
- **ClickDetector**: Detecta clics en objetos
- **ProximityPrompt**: Interacción cercana
- **ParticleEmitter**: Efectos de partículas
- **Attachment**: Punto de anclaje

### Tipos de Scripts

- **Script**: Ejecuta en servidor (autoridad)
- **LocalScript**: Ejecuta en cliente (jugador)
- **ModuleScript**: Código reutilizable
- **ServerScript**: Alias para Script
- **ClientScript**: Alias para LocalScript

### Conceptos de Programación

- **Variable**: Almacena un valor
- **Function**: Bloque de código reutilizable
- **Loop**: Repetir código
- **Condition**: Decidir entre opciones
- **Event**: Algo que sucede (click, touch, etc.)
- **Callback**: Función que se ejecuta cuando ocurre un evento
- **Array/Table**: Lista de valores
- **String**: Texto
- **Number**: Número
- **Boolean**: Verdadero o falso

### Propiedades Importantes

- **Anchored**: Si está fijo o puede moverse
- **CanCollide**: Si se puede atravesar
- **Transparency**: Qué tan transparente (0-1)
- **Position**: Ubicación en el mundo
- **Size**: Tamaño del objeto
- **Color**: Color del objeto
- **Material**: Textura/apariencia
- **Parent**: Dónde está contenido

### Conceptos 3D

- **CFrame**: Posición y rotación combinadas
- **Vector3**: Punto en 3D (X, Y, Z)
- **Vector2**: Punto en 2D (X, Y)
- **UDim2**: Posición/tamaño de UI
- **Color3**: Color RGB (0-1, 0-1, 0-1)
- **Ray**: Línea en una dirección
- **Region3**: Área 3D

### Servicios Comunes

- `game:GetService("Players")`: Jugadores
- `game:GetService("ReplicatedStorage")`: Almacenamiento compartido
- `game:GetService("Workspace")` o `workspace`: El mundo
- `game:GetService("TweenService")`: Animaciones suaves
- `game:GetService("DataStoreService")`: Guardar datos
- `game:GetService("MarketplaceService")`: Tienda de Roblox

---

## Checklist Final del Proyecto

Usa esta lista para asegurarte de que todo funciona:

### Estructura Básica
- [ ] Lobby creado con SpawnLobby
- [ ] GameMap creado con GameFloor
- [ ] SurvivorSpawns creados (mínimo 4)
- [ ] HunterSpawn creado
- [ ] GameData en ReplicatedStorage

### Scripts Principales
- [ ] GameManager en ServerScriptService
- [ ] Funciones: obtenerJugadores, teletransportarLobby, enviarMensaje
- [ ] Funciones: intermision, iniciarRonda, terminarRonda
- [ ] Funciones: asignarRoles, teletransportarMapa
- [ ] Funciones: configurarPersonaje, darHerramientas

### Sistema de Roles
- [ ] Asignación aleatoria de Cazador
- [ ] Supervivientes reciben rol correcto
- [ ] UI muestra el rol de cada jugador
- [ ] Cazador se mueve más rápido
- [ ] Cazador cambia de color (rojo)

### Sistema de Ataque
- [ ] CuchilloCazador en ReplicatedStorage
- [ ] Handle configurado correctamente
- [ ] CuchilloScript funcionando
- [ ] Cazador puede equipar cuchillo (tecla 1)
- [ ] Cuchillo hace daño a Supervivientes
- [ ] Cooldown entre ataques funciona

### Sistema de Generadores
- [ ] Carpeta Generators en GameMap
- [ ] Mínimo 4 generadores creados
- [ ] Cada generador tiene ClickDetector
- [ ] Cada generador tiene BoolValue "Activado"
- [ ] GeneratorManager en ServerScriptService
- [ ] Generadores cambian a verde al activarse
- [ ] Solo Supervivientes pueden activarlos

### Condiciones de Victoria
- [ ] Victoria Supervivientes: Todos los generadores activados
- [ ] Victoria Cazador: Todos los Supervivientes eliminados
- [ ] Tiempo límite: 3 minutos
- [ ] Mensajes de victoria aparecen correctamente
- [ ] El juego vuelve al lobby después de terminar

### Testing
- [ ] Probado con 2 jugadores
- [ ] Probado con 4+ jugadores
- [ ] Todos los roles se asignan
- [ ] Ataque funciona
- [ ] Generadores funcionan
- [ ] Todas las victorias funcionan
- [ ] No hay errores en Output

### Mejoras Opcionales
- [ ] UIManager implementado
- [ ] Sonidos agregados
- [ ] Iluminación mejorada
- [ ] Partículas en generadores
- [ ] Mapa decorado y detallado

### Preparación para Publicar
- [ ] Juego guardado con nombre apropiado
- [ ] Sin errores en Output
- [ ] Icono del juego creado
- [ ] Descripción escrita
- [ ] Probado con amigos
- [ ] Listo para publicar

---

## Notas Finales y Motivación

### ¡Lo Lograste!

Has completado un viaje increíble desde no saber nada de Roblox Studio hasta crear un juego asimétrico funcional. Esto es un logro importante y deberías estar orgulloso.

### Qué Has Aprendido

1. **Roblox Studio**: Navegación e interface
2. **Lua**: Programación básica
3. **Game Design**: Mecánicas de juego
4. **Arquitectura**: Organización de código
5. **Testing**: Depuración de errores
6. **UI/UX**: Interfaz de usuario

### Siguientes Pasos

1. **Practica**: Haz cambios pequeños regularmente
2. **Experimenta**: No tengas miedo de romper cosas
3. **Aprende**: Lee documentación oficial
4. **Comparte**: Muestra tu juego a amigos
5. **Itera**: Mejora basándote en feedback
6. **Enseña**: Ayuda a otros principiantes

### Consejos de Desarrollador

**"El mejor momento para empezar fue ayer. El segundo mejor momento es ahora."**

- Los errores son oportunidades de aprendizaje
- Cada desarrollador profesional fue principiante
- La práctica constante es más importante que el talento
- La comunidad está aquí para ayudarte
- Tu primer juego no será perfecto, y está bien

### Recursos de Emergencia

**Si te atascas:**
1. Lee el mensaje de error cuidadosamente
2. Busca en DevForum
3. Pregunta en la comunidad
4. Revisa la documentación oficial
5. Toma un descanso y vuelve con mente fresca

### Mantén el Momentum

- **Publica tu juego** aunque sea simple
- **Actualiza regularmente** con nuevas características
- **Escucha feedback** pero mantén tu visión
- **Documenta tu progreso** en redes sociales
- **Aprende de otros** juegos similares
- **No te compares** con desarrolladores experimentados

### Créditos y Agradecimientos

Esta guía fue creada con el objetivo de hacer el desarrollo de juegos en Roblox accesible para absolutamente cualquier persona, sin importar su experiencia previa.

**Recuerda:**
- Cada experto fue una vez principiante
- Tu creatividad es tu mayor fortaleza
- La comunidad de Roblox es acogedora y útil
- El desarrollo de juegos es un viaje, no un destino

### ¡Buena Suerte!

Ahora tienes todas las herramientas y conocimientos para crear tu juego asimétrico. Lo que hagas con ellos depende de ti.

**¡Ve y crea algo increíble! 🎮✨**

---

*"El juego de tus sueños no se va a crear solo. ¡Empieza ahora!"*

---

## Contacto y Soporte

Para preguntas específicas sobre esta guía:
- DevForum de Roblox
- r/robloxgamedev en Reddit
- Discord: Roblox Developer Community

**Nota**: Esta guía es un punto de partida. El límite es tu imaginación.

---

*Última actualización: 2026*
*Versión de la guía: 1.0*
*Compatible con: Roblox Studio (versión actual)*

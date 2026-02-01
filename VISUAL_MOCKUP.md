# Visual UI Mockup

This is a text-based representation of how the Riblox UI appears in-game.

## Loading Screen (Initial View)
```
┌────────────────────────────────────────────────────────────┐
│                    FULL SCREEN                             │
│                  (Dark Background)                         │
│                                                            │
│                                                            │
│                      RIBLOX                                │
│                                                            │
│              ╔══════════════════════╗                      │
│              ║████████████░░░░░░░░░░║  80%                │
│              ╚══════════════════════╝                      │
│                                                            │
│              Applying Configurations...                    │
│                                                            │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## Main UI (After Loading)
```
┌────────────────────────────────────────────────────┐
│  [R]  ← Open Button (Top-Left)                     │
│                                                     │
│                                                     │
│       ┌──────────────────────────────────┐         │
│       │  RIBLOX UI            ─   ×     │         │
│       ├──────────┬───────────────────────┤         │
│       │          │                       │         │
│       │ 👤 Player│  Walk Speed: 16       │         │
│       │          │  ╠════════╗           │         │
│       │          │                       │         │
│       │ 🎮 Game  │  Jump Power: 50       │         │
│       │          │  ╠═══╗                │         │
│       │          │                       │         │
│       │ 👁️ Visuals│ ○ Infinite Jump      │         │
│       │          │                       │         │
│       │ ⚙️ Settings│ ○ Flight             │         │
│       │          │                       │         │
│       │          │  Fly Speed: 50        │         │
│       │          │  ╠═══════╗            │         │
│       │          │                       │         │
│       │          │ ○ Noclip             │         │
│       │          │                       │         │
│       │          │ [Reset Character]    │         │
│       └──────────┴───────────────────────┘         │
│                                                     │
│                              ┌─────────────────┐   │
│                              │ Welcome!        │   │
│                              │ Press Right     │   │
│                              │ Shift to toggle │   │
│                              └─────────────────┘   │
└────────────────────────────────────────────────────┘
```

## UI with Different Tabs

### Game Tab Active
```
┌──────────────────────────────────┐
│  RIBLOX UI            ─   ×     │
├──────────┬───────────────────────┤
│          │                       │
│  Player  │  [Teleport to Spawn] │
│          │                       │
│ ▶️ Game   │  ● Auto Farm (Demo)  │
│          │                       │
│  Visuals │  [Collect Items]     │
│          │                       │
│  Settings│  [Show Players]      │
│          │                       │
└──────────┴───────────────────────┘
```

### Visuals Tab Active
```
┌──────────────────────────────────┐
│  RIBLOX UI            ─   ×     │
├──────────┬───────────────────────┤
│          │                       │
│  Player  │  ● Full Bright        │
│          │                       │
│  Game    │  ● Player ESP         │
│          │                       │
│▶️ Visuals │  ● FPS Counter        │
│          │                       │
│  Settings│                       │
│          │                       │
└──────────┴───────────────────────┘
```

### Settings Tab Active
```
┌──────────────────────────────────┐
│  RIBLOX UI            ─   ×     │
├──────────┬───────────────────────┤
│          │  RIBLOX UI v1.0       │
│  Player  │                       │
│          │  Created for Roblox   │
│  Game    │  Modern & Professional│
│          │                       │
│  Visuals │  [Rejoin Server]     │
│          │                       │
│▶️ Settings│  [Server Hop]        │
│          │                       │
│          │  [Copy Game ID]      │
│          │                       │
│          │  [Destroy GUI]       │
└──────────┴───────────────────────┘
```

## Toggle States

### OFF (Gray)
```
┌──────────────────────┐
│ Feature Name      ⚫│
└──────────────────────┘
```

### ON (Blue)
```
┌──────────────────────┐
│ Feature Name      🔵│
└──────────────────────┘
```

## Slider Representation

### Walk Speed Slider
```
┌────────────────────────────┐
│ Walk Speed           100   │
│ ╠══════════════╗           │
└────────────────────────────┘
```

## Notification System

### Notification Appearance (Bottom-Right)
```
                        ┌─────────────────┐
                        │ Feature Active  │
                        │ Flight enabled  │
                        └─────────────────┘
                                ↑
                        (Slides in from right)
```

## Player ESP Visual

### When ESP is Active
```
    Player Username
    [Distance: 245 studs]
         ┌───────┐
         │ ▒▒▒▒▒ │  ← Highlighted player
         │ ▒▒▒▒▒ │     (visible through walls)
         │ ▒▒▒▒▒ │
         └───────┘
```

## FPS Counter (Top-Left)
```
┌────────────┐
│  FPS: 60   │
└────────────┘
```

## Complete Screen Layout

### Full Game View with All Elements
```
┌──────────────────────────────────────────────────────────────┐
│ [R]                         ┌─────────┐                      │
│                             │ FPS: 60 │                      │
│                             └─────────┘                      │
│                                                              │
│                                                              │
│          ┌──────────────────────────────────┐               │
│          │  RIBLOX UI            ─   ×     │               │
│          ├──────────┬───────────────────────┤               │
│          │          │                       │               │
│          │ ▶️ Player │  Walk Speed: 16      │               │
│          │          │  ╠════════╗           │               │
│          │  Game    │                       │               │
│          │          │  Jump Power: 50       │               │
│          │  Visuals │  ╠═══╗                │               │
│          │          │                       │               │
│          │  Settings│ ○ Infinite Jump      │               │
│          │          │                       │               │
│          │          │ ● Flight             │               │
│          └──────────┴───────────────────────┘               │
│                                                              │
│                                                              │
│                                                              │
│                                        ┌─────────────────┐   │
│                                        │ Welcome!        │   │
│   Player Username                      │ Press Right     │   │
│   [Distance: 120 studs]                │ Shift to toggle │   │
│      ┌───────┐                         └─────────────────┘   │
│      │ ▒▒▒▒▒ │ ← ESP Active                                 │
│      │ ▒▒▒▒▒ │                                               │
│      └───────┘                                               │
└──────────────────────────────────────────────────────────────┘
```

## Color Scheme Reference

```
┌─────────────────────────────────────┐
│ Background Colors:                  │
│ ███ Main BG (25, 25, 35)           │
│ ███ Secondary (30, 30, 45)         │
│ ███ Elements (40, 40, 60)          │
│                                     │
│ Accent Colors:                      │
│ ███ Primary Blue (100, 200, 255)   │
│ ███ White Text (255, 255, 255)     │
│ ███ Gray Text (200, 200, 200)      │
└─────────────────────────────────────┘
```

## Animation Flow

### Opening Animation
```
Step 1: Loading Bar Fills
[░░░░░░░░░░] → [████░░░░░░] → [██████████]

Step 2: Fade Out
[Visible] → [Fading...] → [Hidden]

Step 3: Main UI Appears
[Hidden] → [Appearing...] → [Visible]
```

### Toggle Animation
```
OFF → TRANSITION → ON
⚫  →    ↔️     →  🔵
```

### Notification Animation
```
Hidden (Right)  →  Slide In  →  Display  →  Slide Out  →  Hidden
     [ ]        →    [→]     →    [■]    →    [←]      →    [ ]
```

## Button States

### Normal State
```
┌──────────────────┐
│  Button Text     │
└──────────────────┘
```

### Hover State (Lighter Blue)
```
┌──────────────────┐
│  Button Text     │  ← Brighter
└──────────────────┘
```

### Click State
```
┌──────────────────┐
│  Button Text  ⚡  │
└──────────────────┘
```

## Draggable Window Demo
```
Initial Position:
           ┌──────────┐
           │ UI Here  │
           └──────────┘

After Dragging:
                              ┌──────────┐
                              │ UI Here  │
                              └──────────┘
```

---

## Notes on Visual Design

### Professional Elements
1. **Rounded Corners**: All elements have 8-12px radius
2. **Shadows**: Subtle drop shadows for depth
3. **Spacing**: Consistent 10-15px padding
4. **Typography**: Gotham font family throughout
5. **Icons**: Emoji icons for visual appeal

### Color Psychology
- **Blue Accent**: Trust, professionalism, technology
- **Dark Theme**: Reduces eye strain, modern look
- **White Text**: High contrast, easy to read
- **Gray Text**: Secondary information, less emphasis

### Animation Principles
- **Duration**: 0.2-0.5 seconds (not too fast/slow)
- **Easing**: Quad and Back for natural feel
- **Consistency**: Same timing throughout
- **Purpose**: Every animation serves UX purpose

### Layout Strategy
- **Left Sidebar**: Navigation (tabs)
- **Main Area**: Content (features)
- **Top Bar**: Title and controls
- **Bottom-Right**: Notifications
- **Top-Left**: Quick access (R button, FPS)

This visual mockup represents the actual rendered UI in Roblox! 🎨

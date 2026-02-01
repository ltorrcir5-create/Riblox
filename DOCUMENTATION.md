# Riblox UI - Documentation

## 🎮 Professional Roblox UI Script

A modern, professional, and feature-rich GUI for Roblox with smooth animations, professional loaders, and extensive player interaction capabilities.

## ✨ Features

### 🎨 User Interface
- **Professional Loading Screen**: Animated loading screen with progress bar and status updates
- **Modern Design**: Clean, dark-themed interface with smooth animations
- **Draggable Window**: Click and drag the title bar to reposition the GUI
- **Minimizable**: Minimize/close buttons for easy management
- **Tab System**: Organized features across multiple tabs
- **Notification System**: Real-time notifications for actions and status updates
- **Shadow Effects**: Professional shadow effects for depth

### 👤 Player Features (Player Tab)
- **Walk Speed Slider**: Adjust walk speed from 16 to 200
- **Jump Power Slider**: Adjust jump power from 50 to 200
- **Infinite Jump**: Jump infinitely without touching the ground
- **Flight System**: Full 6-direction flight with adjustable speed (WASD + Space/Shift)
- **Fly Speed Slider**: Adjust flight speed from 10 to 150
- **Noclip**: Walk through walls and objects
- **Character Reset**: Quick reset button

### 🎮 Game Features (Game Tab)
- **Teleport to Spawn**: Instant teleportation to spawn location
- **Auto Farm**: Demo toggle for auto-farming functionality (framework included)
- **Collect Items**: Collect all nearby items within 50 studs
- **Players List**: Display all players in the server

### 👁️ Visual Features (Visuals Tab)
- **Full Bright**: Remove darkness and shadows
- **Player ESP**: See other players through walls with:
  - Highlight effect
  - Name display
  - Distance indicator
  - Real-time updates
- **FPS Counter**: Display real-time FPS in the corner

### ⚙️ Settings (Settings Tab)
- **Version Information**: Display current version
- **Rejoin Server**: Quickly rejoin the current server
- **Server Hop**: Find and join a new server
- **Copy Game ID**: Copy the current game's place ID
- **Destroy GUI**: Safely remove the GUI

### 🛡️ Additional Features
- **Anti-AFK**: Prevents being kicked for inactivity
- **Persistent Settings**: Settings are maintained across character respawns
- **Smooth Animations**: TweenService-based animations for all UI elements
- **Error Handling**: Safe execution with pcall protection
- **Keyboard Shortcuts**: Right Shift to toggle GUI visibility

## 📖 Usage Instructions

### Installation
1. Copy the entire `RibloxUI.lua` script
2. In Roblox, create a LocalScript in one of these locations:
   - `StarterPlayer > StarterPlayerScripts`
   - `StarterPlayer > StarterCharacterScripts`
   - `StarterGui`
3. Paste the script and run the game

### Controls
- **Right Shift**: Toggle GUI visibility
- **Click R Button**: Open/close GUI (floating button in top-left)
- **Click and Drag**: Move the GUI window by dragging the title bar
- **ESC or X Button**: Close the GUI

### Flight Controls
When flight is enabled:
- **W**: Move forward
- **S**: Move backward
- **A**: Move left
- **D**: Move right
- **Space**: Move up
- **Left Shift**: Move down

## 🎯 Feature Details

### Loading Screen
The loading screen displays when the script first loads with:
- Animated title "RIBLOX"
- Progress bar with smooth animations
- Stage-based loading messages
- Fade-out effect when complete

### Tab Navigation
The GUI is organized into 4 main tabs:
1. **👤 Player**: Character movement and abilities
2. **🎮 Game**: Game-specific utilities
3. **👁️ Visuals**: Visual enhancements and overlays
4. **⚙️ Settings**: Configuration and information

### Sliders
Sliders provide precise control over numeric values:
- Click and drag to adjust values
- Real-time value display
- Smooth visual feedback
- Instant application

### Toggles
Toggle switches provide on/off control:
- Smooth animation when toggled
- Visual indicator of current state
- Instant feedback via notifications
- Blue = On, Gray = Off

### Notifications
Notifications appear in the bottom-right corner:
- Animated slide-in/slide-out
- 3-second default duration
- Title and message display
- Auto-dismiss

## 🔧 Customization

### Colors
The script uses a consistent color scheme:
- **Background**: RGB(25, 25, 35)
- **Secondary**: RGB(30, 30, 45)
- **Accent**: RGB(100, 200, 255)
- **Text**: RGB(255, 255, 255)

### Toggle Key
To change the toggle key from Right Shift, modify line in the UserInputService.InputBegan section:
```lua
if not gameProcessed and input.KeyCode == Enum.KeyCode.YourKeyHere then
```

### Default Values
Adjust default settings in the Settings table at the top of the script:
```lua
local Settings = {
    Speed = 16,        -- Default walk speed
    JumpPower = 50,    -- Default jump power
    Flying = false,    -- Start with flight disabled
    -- etc...
}
```

## 🛠️ Technical Details

### Services Used
- Players: Player management
- TweenService: Smooth animations
- UserInputService: Input handling
- RunService: Frame-by-frame updates
- CoreGui: GUI placement (with fallback)

### Performance
- Optimized animations using TweenService
- Efficient event connections
- Proper cleanup on disable
- Anti-lag measures for ESP and other features

### Compatibility
- Works in any Roblox game
- Compatible with both Studio and live games
- Supports filtering enabled
- No external dependencies

## ⚠️ Important Notes

1. **Script Location**: Must be a LocalScript in StarterPlayer or StarterGui
2. **Permissions**: Some features may not work in certain games due to game restrictions
3. **Anti-Cheat**: Use responsibly - may be detected by game anti-cheat systems
4. **Character Respawn**: Settings are automatically reapplied after respawn
5. **ESP Feature**: May impact performance with many players

## 🐛 Troubleshooting

### GUI Not Appearing
- Ensure it's a LocalScript, not a regular Script
- Check if the script is in the correct location
- Look for error messages in the output console

### Features Not Working
- Some games restrict certain features
- Check if the game has an anti-cheat system
- Verify the feature is enabled in the GUI

### Performance Issues
- Disable ESP if experiencing lag
- Reduce the number of active features
- Close other running scripts

## 📝 Version History

### v1.0 (Initial Release)
- Complete UI system with 4 tabs
- Professional loading screen
- Player movement features
- Visual enhancements
- Game utilities
- Settings and configuration
- Notification system
- Anti-AFK system

## 🎨 Design Philosophy

The Riblox UI was designed with these principles:
1. **Professional**: Clean, modern interface that looks polished
2. **Functional**: Every feature serves a purpose
3. **Intuitive**: Easy to understand and use
4. **Performant**: Optimized for smooth operation
5. **Extensible**: Easy to add new features

## 🔮 Future Enhancements

Potential features for future versions:
- Custom theme colors
- More game-specific features
- Advanced auto-farm implementations
- Custom hotkeys configuration
- Settings save/load system
- Multiple UI themes
- More visual effects

## 📄 License

This script is provided as-is for educational and entertainment purposes.

## 🤝 Credits

Created for the Riblox project
- Professional UI design
- Modern animations
- Comprehensive feature set
- Extensive documentation

---

**Enjoy using Riblox UI! 🚀**

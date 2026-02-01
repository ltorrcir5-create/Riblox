# Quick Installation Guide

## 🚀 3-Minute Setup

### Step 1: Get the Script
1. Open the file `RibloxUI.lua` in this repository
2. Click the "Copy" button or select all (Ctrl+A) and copy (Ctrl+C)

### Step 2: Open Roblox Studio
1. Launch Roblox Studio
2. Open any game or create a new one for testing

### Step 3: Create the LocalScript
1. In the Explorer panel, navigate to:
   - **Option A**: `StarterPlayer` → `StarterPlayerScripts`
   - **Option B**: `StarterGui`
2. Right-click and select **Insert Object**
3. Choose **LocalScript**
4. Rename it to "RibloxUI" (optional but recommended)

### Step 4: Paste the Code
1. Double-click the LocalScript to open it
2. Delete any existing code (usually just one line)
3. Paste the copied code (Ctrl+V)
4. Press Ctrl+S to save

### Step 5: Test It!
1. Click the **Play** button (F5) in Studio
2. Wait for the loading screen to complete
3. Press **Right Shift** to toggle the UI
4. Enjoy! 🎉

## 📱 Using in a Live Game

### Method 1: Executor (Most Common)
If you're using a script executor:
1. Copy the entire `RibloxUI.lua` script
2. Open your executor
3. Paste the script
4. Press "Execute" or "Inject"
5. Press Right Shift to open the UI

### Method 2: ServerScripts (Developers)
If you own the game:
1. Follow the Studio steps above
2. Publish your game
3. The script will run for all players automatically

## ⚙️ First Time Setup

### After the Script Loads:
1. **Loading Screen** will appear (5-6 seconds)
2. **Main UI** will appear in the center
3. **Welcome Notification** will show controls
4. **R Button** will appear in top-left corner

### Initial Configuration:
1. Click the **Player** tab (👤)
2. Adjust Walk Speed if desired
3. Try toggling Flight to test
4. Explore other tabs!

## 🎮 Basic Usage

### Opening/Closing:
- Press **Right Shift** anytime
- Click the **R button** (top-left)
- Click the **X** in the title bar

### Moving the Window:
- Click and hold the **title bar** (top)
- Drag to your preferred position
- Release to place

### Using Features:
- **Sliders**: Click and drag left/right
- **Toggles**: Click to turn on/off (blue = on)
- **Buttons**: Click to activate

## 🛠️ Troubleshooting

### "Script doesn't appear"
- ✅ Make sure it's a **LocalScript**, not a regular Script
- ✅ Place it in StarterPlayerScripts or StarterGui
- ✅ Check the Output window for errors (View → Output)

### "UI doesn't show"
- ✅ Wait 5-6 seconds for loading
- ✅ Press **Right Shift** to toggle
- ✅ Look for the **R button** in top-left
- ✅ Check if another UI is blocking it

### "Features don't work"
- ✅ Some games block certain features (anti-cheat)
- ✅ Make sure the toggle is ON (blue color)
- ✅ Try in a different game
- ✅ Check Output for errors

### "Performance issues"
- ✅ Disable **ESP** if active
- ✅ Turn off **Full Bright**
- ✅ Close other scripts/executors
- ✅ Restart Roblox

## 📋 Quick Reference

### Keyboard Shortcuts
| Key | Action |
|-----|--------|
| Right Shift | Toggle UI |
| W | Move forward (in flight) |
| A | Move left (in flight) |
| S | Move backward (in flight) |
| D | Move right (in flight) |
| Space | Jump / Move up (in flight) |
| Left Shift | Move down (in flight) |

### Default Values
| Setting | Default |
|---------|---------|
| Walk Speed | 16 |
| Jump Power | 50 |
| Fly Speed | 50 |
| Flight | OFF |
| Noclip | OFF |
| ESP | OFF |
| Full Bright | OFF |

## 🎯 Recommended First Steps

1. **Test Walk Speed**:
   - Open Player tab
   - Drag Walk Speed slider to 50
   - Walk around to feel the difference

2. **Try Flight**:
   - Toggle Flight ON
   - Use WASD + Space/Shift to fly
   - Adjust Fly Speed if too fast/slow

3. **Enable Full Bright**:
   - Go to Visuals tab
   - Toggle Full Bright ON
   - Notice the lighting change

4. **Check FPS**:
   - In Visuals tab
   - Toggle FPS Counter ON
   - See your FPS in top-left

## ⚡ Pro Tips for Beginners

1. **Start Small**: Don't enable everything at once
2. **Learn Controls**: Practice flight in a safe area first
3. **Save Position**: Drag UI to your preferred spot (it stays there)
4. **Use Notifications**: They tell you what's happening
5. **Explore Tabs**: Each tab has different features

## 🎓 Advanced Tips

1. **Combine Features**: Try Flight + Noclip for ultimate mobility
2. **Speed Settings**: Higher isn't always better (hard to control)
3. **ESP Usage**: Great for finding players in large maps
4. **Server Hop**: Use when game gets laggy or crowded
5. **Anti-AFK**: Auto-enabled, you won't get kicked

## 🔄 Updating the Script

If a new version is released:
1. Delete the old LocalScript
2. Follow the installation steps again
3. Paste the new version
4. Your settings will reset

## 📞 Getting Help

### Check These First:
1. Read the full [DOCUMENTATION.md](DOCUMENTATION.md)
2. Review [FEATURES.md](FEATURES.md)
3. Check Output window for error messages

### Common Issues:
- **"attempt to index nil"**: Game doesn't have required objects
- **"Cannot access property"**: Game restrictions active
- **"Script timeout"**: Script took too long to load (restart)

## ✨ You're Ready!

That's it! You now have a fully functional, professional Roblox UI.

**Remember**:
- Press **Right Shift** to toggle
- UI is **draggable** (grab the title bar)
- **Blue** = Feature is ON
- **Notifications** appear bottom-right

Have fun and use responsibly! 🎮

---

**Questions?** Read the full documentation in [DOCUMENTATION.md](DOCUMENTATION.md)

**Want more features?** Check out [FEATURES.md](FEATURES.md) for the complete list

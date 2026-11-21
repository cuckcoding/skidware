# linoria-sidebar

A **modified fork of [LinoriaLib](https://github.com/violin-suzutsuki/LinoriaLib)** with the tab bar
moved from the top to a **left icon rail**. Everything else is Linoria's proven rendering —
groupboxes, toggles, sliders, dropdowns, key pickers, color pickers, SaveManager & ThemeManager.

### What's different from stock LinoriaLib
- **Tabs on the left, not the top** — a vertical rail down the side instead of a horizontal bar.
- **Icon tabs** — `Window:AddTab(name, iconName)` renders a [Lucide](https://lucide.dev) icon beside
  the label; the active tab gets an accent bar and an accent-tinted icon.
- **Larger default window** (720×600) to fit the rail + two groupbox columns.

## Load it

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cuckcoding/linoria-sidebar/main/example.lua"))()
```

or use it as a library:

```lua
local repo = "https://raw.githubusercontent.com/cuckcoding/linoria-sidebar/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({ Title = "my hub", Center = true, AutoShow = true })

-- 2nd arg is a Lucide icon name (or "rbxassetid://123", or nil for no icon)
local Tab = Window:AddTab("Rage", "crosshair")
local Box = Tab:AddLeftGroupbox("Aimbot")

Box:AddToggle("AimEnabled", { Text = "Enabled", Default = true })
   :AddKeyPicker("AimKey", { Default = "MB2", Mode = "Hold", Text = "Aimbot" })
Box:AddSlider("AimFOV", { Text = "Maximum FOV", Default = 10, Min = 0, Max = 180, Rounding = 1, Suffix = "°" })
```

### Bundled icon names
`crosshair`, `eye`, `settings`, `wrench`, `save`, `folder`, `user`, `zap`
(plus aliases such as `aim`, `visuals`, `misc`, `config`). Pass any `"rbxassetid://..."` for a custom
image, or `nil` to show just the label.

## API

The element API is **100% stock Linoria** — see the
[LinoriaLib docs](https://github.com/violin-suzutsuki/LinoriaLib). Only `Window:AddTab` changed
(it now accepts an icon) and the window layout. `Toggles`, `Options`, SaveManager and ThemeManager
all behave exactly as upstream.

## Credits / license

- Base library: **LinoriaLib** by [violin-suzutsuki](https://github.com/violin-suzutsuki/LinoriaLib)
  (and the original Linoria authors). This repo only restructures the tab layout and adds icons.
- Tab icons: the [Lucide](https://lucide.dev) icon set via
  [latte-soft/lucide-roblox](https://github.com/latte-soft/lucide-roblox) (ISC).

All upstream notices are retained in `Library.lua`. Use under the same terms as the upstream project.

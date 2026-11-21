--[[
    Linoria-Sidebar — example
    A modified LinoriaLib with the tab bar moved to a LEFT ICON RAIL.

    Run:
      loadstring(game:HttpGet("https://raw.githubusercontent.com/cuckcoding/linoria-sidebar/main/example.lua"))()

    Toggle the menu with  End  (or RightShift via the Menu group).
]]

local repo = "https://raw.githubusercontent.com/cuckcoding/linoria-sidebar/main/"

local Library       = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager  = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager   = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = getgenv().Options
local Toggles = getgenv().Toggles

local Window = Library:CreateWindow({
    Title = "linoria • sidebar",
    Center = true,
    AutoShow = true,
    TabPadding = 4,
    MenuFadeTime = 0.2,
})

-- tabs now take an icon name (Lucide) as the 2nd argument
local Tabs = {
    Rage     = Window:AddTab("Rage", "crosshair"),
    Visuals  = Window:AddTab("Visuals", "eye"),
    Misc     = Window:AddTab("Misc", "wrench"),
    Settings = Window:AddTab("Settings", "settings"),
}

----------------------------------------------------------------- RAGE
local AimBox = Tabs.Rage:AddLeftGroupbox("Aimbot")
AimBox:AddToggle("AimbotEnabled", { Text = "Enabled", Default = true })
      :AddKeyPicker("AimbotKey", { Default = "MB2", Mode = "Hold", Text = "Aimbot", NoUI = false })
AimBox:AddDropdown("AimbotHitbox", { Text = "Target hitbox", Values = { "Head", "Neck", "Chest", "Pelvis" }, Default = 1 })
AimBox:AddSlider("AimbotFOV", { Text = "Maximum FOV", Default = 10, Min = 0, Max = 180, Rounding = 1, Suffix = "°" })
AimBox:AddSlider("AimbotSmooth", { Text = "Smoothing", Default = 0.65, Min = 0, Max = 1, Rounding = 2 })
AimBox:AddSlider("AimbotHitchance", { Text = "Hitchance", Default = 72, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
AimBox:AddToggle("AimbotQuickStop", { Text = "Quick stop", Default = true })
AimBox:AddToggle("AimbotSmoke", { Text = "Aim through smoke" })

local TrigBox = Tabs.Rage:AddRightGroupbox("Triggerbot")
TrigBox:AddToggle("TriggerEnabled", { Text = "Enabled", Default = true })
       :AddKeyPicker("TriggerKey", { Default = "LeftAlt", Mode = "Hold", Text = "Triggerbot" })
TrigBox:AddSlider("TriggerHitchance", { Text = "Hit chance", Default = 75, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
TrigBox:AddSlider("TriggerDelay", { Text = "Delay", Default = 0, Min = 0, Max = 250, Rounding = 0, Suffix = "ms" })
TrigBox:AddToggle("TriggerBurst", { Text = "Burst fire" })
TrigBox:AddToggle("TriggerWalls", { Text = "Shoot through walls" })

local OtherBox = Tabs.Rage:AddRightGroupbox("Other")
OtherBox:AddDropdown("AccuracyBoost", { Text = "Accuracy boost", Values = { "Off", "Low", "High" }, Default = 1 })
OtherBox:AddToggle("StandaloneRCS", { Text = "Standalone RCS" })

----------------------------------------------------------------- VISUALS
local EspBox = Tabs.Visuals:AddLeftGroupbox("Player ESP")
EspBox:AddToggle("EspEnabled", { Text = "Enabled", Default = true })
EspBox:AddToggle("EspBox", { Text = "Box", Default = true })
      :AddColorPicker("EspBoxColor", { Default = Color3.fromRGB(0, 85, 255), Title = "Box color" })
EspBox:AddToggle("EspName", { Text = "Name", Default = true })
      :AddColorPicker("EspNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "Name color" })
EspBox:AddToggle("EspHealth", { Text = "Health bar" })
EspBox:AddDropdown("EspBoxStyle", { Text = "Box style", Values = { "2D", "Corner", "3D" }, Default = 2 })
EspBox:AddSlider("EspDistance", { Text = "Render distance", Default = 500, Min = 50, Max = 2000, Rounding = 0, Suffix = "m" })

local WorldBox = Tabs.Visuals:AddRightGroupbox("World")
WorldBox:AddToggle("Fullbright", { Text = "Fullbright" })
WorldBox:AddSlider("FieldOfView", { Text = "FOV", Default = 90, Min = 70, Max = 120, Rounding = 0 })
WorldBox:AddLabel("Skybox tint"):AddColorPicker("SkyTint", { Default = Color3.fromRGB(40, 40, 60) })

----------------------------------------------------------------- MISC
local MoveBox = Tabs.Misc:AddLeftGroupbox("Movement")
MoveBox:AddToggle("BunnyHop", { Text = "Bunny hop" })
MoveBox:AddSlider("WalkSpeed", { Text = "Walk speed", Default = 16, Min = 16, Max = 100, Rounding = 0 })
MoveBox:AddInput("Nickname", { Text = "Nickname", Default = "", Placeholder = "player", Numeric = false, Finished = false })
MoveBox:AddButton("Reset character", function()
    Library:Notify("Reset pressed")
end)

----------------------------------------------------------------- SETTINGS (addons)
local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu")
MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("LinoriaSidebar")
SaveManager:SetFolder("LinoriaSidebar/configs")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Library:Notify("Loaded. Press End to toggle the menu.", 5)

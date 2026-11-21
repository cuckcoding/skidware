--[[
    skidware.cc 🎄 — example
    A modified LinoriaLib with the tab bar moved to a LEFT ICON RAIL, a darker-green
    accent, black outline, Arial font — plus winter extras: falling snow, a subtle
    background blur while the menu is open, a top-right watermark, and load notifications.

    Run:
      loadstring(game:HttpGet("https://raw.githubusercontent.com/cuckcoding/skidware/main/example.lua"))()

    Toggle the menu with  End.
]]

local repo = "https://raw.githubusercontent.com/cuckcoding/skidware/main/"

--// basic Roblox toast, used only if the library itself fails to load \\--
local function fallbackNotify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "skidware.cc", Text = text, Duration = 8,
        })
    end)
end

--// load the library (report to developer on failure) \\--
local okLib, Library = pcall(function()
    return loadstring(game:HttpGet(repo .. "Library.lua"))()
end)
if not okLib or type(Library) ~= "table" then
    fallbackNotify("Failed to load — report to developer")
    return warn("[skidware] library load failed: " .. tostring(Library))
end

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = getgenv().Options
local Toggles = getgenv().Toggles

--============================================================================
--  WINTER EXTRAS (snow, blur, watermark)
--============================================================================
local function festive(Library, Window)
    local RunService    = game:GetService("RunService")
    local TweenService  = game:GetService("TweenService")
    local Lighting      = game:GetService("Lighting")
    local Players       = game:GetService("Players")
    local Camera        = workspace.CurrentCamera
    local LocalPlayer   = Players.LocalPlayer

    ------------------------------------------------ subtle background blur
    local Blur = Instance.new("BlurEffect")
    Blur.Name = "Blur"
    Blur.Size = 0
    Blur.Parent = Lighting                     -- client-side only; never sent to the server
    local function setBlur(on)
        TweenService:Create(Blur, TweenInfo.new(0.25), { Size = on and 6 or 0 }):Play()
    end
    if Window.Holder then
        setBlur(Window.Holder.Visible)
        Library:GiveSignal(Window.Holder:GetPropertyChangedSignal("Visible"):Connect(function()
            setBlur(Window.Holder.Visible)
        end))
    end
    Library:OnUnload(function() pcall(function() Blur:Destroy() end) end)

    ------------------------------------------------ falling snow (+ the odd tree)
    local Snow = Instance.new("Frame")
    Snow.Name = "Snow"
    Snow.BackgroundTransparency = 1
    Snow.Size = UDim2.fromScale(1, 1)
    Snow.ZIndex = 0                            -- behind the menu, above the world
    Snow.Active = false
    Snow.Parent = Library.ScreenGui

    local flakes = {}
    local vp = Camera.ViewportSize
    for i = 1, 48 do
        local isTree = math.random() < 0.07
        local f = Instance.new("TextLabel")
        f.BackgroundTransparency = 1
        f.Font = Enum.Font.GothamBold
        f.Text = isTree and "🎄" or (math.random() < 0.5 and "❄" or "•")
        f.TextColor3 = Color3.fromRGB(236, 246, 255)
        f.TextTransparency = isTree and 0.1 or (0.3 + math.random() * 0.45)
        f.TextSize = isTree and math.random(14, 22) or math.random(9, 17)
        f.Size = UDim2.fromOffset(26, 26)
        f.ZIndex = 0
        f.Parent = Snow
        flakes[i] = {
            obj = f,
            x = math.random() * vp.X,
            y = math.random() * vp.Y,
            speed = 18 + math.random() * 44,
            drift = (math.random() - 0.5) * 26,
        }
    end
    Library:GiveSignal(RunService.RenderStepped:Connect(function(dt)
        vp = Camera.ViewportSize
        for _, fl in ipairs(flakes) do
            fl.y = fl.y + fl.speed * dt
            fl.x = fl.x + math.sin(fl.y / 55) * fl.drift * dt
            if fl.y > vp.Y + 24 then
                fl.y = -24
                fl.x = math.random() * vp.X
            end
            fl.obj.Position = UDim2.fromOffset(fl.x, fl.y)
        end
    end))

    ------------------------------------------------ watermark, pinned top-right
    Library:SetWatermarkVisibility(true)
    if Library.Watermark then
        Library.Watermark.AnchorPoint = Vector2.new(1, 0)
        Library.Watermark.Position = UDim2.new(1, -16, 0, 16)
    end
    local acc, frames, fps = 0, 0, 60
    Library:GiveSignal(RunService.RenderStepped:Connect(function(dt)
        acc = acc + dt; frames = frames + 1
        if acc >= 1 then
            fps = math.floor(frames / acc + 0.5); acc = 0; frames = 0
            pcall(function()
                Library:SetWatermark(("skidware.cc 🎄  |  %s  |  %d fps  |  %s"):format(
                    LocalPlayer and LocalPlayer.Name or "player", fps, os.date("%H:%M")))
            end)
            if Library.Watermark then
                Library.Watermark.AnchorPoint = Vector2.new(1, 0)
                Library.Watermark.Position = UDim2.new(1, -16, 0, 16)
            end
        end
    end))
end

--============================================================================
--  BUILD MENU
--============================================================================
local built, err = pcall(function()

local Window = Library:CreateWindow({
    Title = "skidware.cc 🎄",
    Center = true,
    AutoShow = true,
    TabPadding = 4,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Rage     = Window:AddTab("Rage", "crosshair"),
    Visuals  = Window:AddTab("Visuals", "eye"),
    Misc     = Window:AddTab("Misc", "wrench"),
    Settings = Window:AddTab("Settings", "settings"),
}

----------------------------------------------------------------- RAGE
local AimBox = Tabs.Rage:AddLeftGroupbox("Aimbot")
AimBox:AddToggle("AimbotEnabled", { Text = "Enabled", Default = true })
      :AddKeyPicker("AimbotKey", { Default = "MB2", Mode = "Hold", Text = "Aimbot" })
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
      :AddColorPicker("EspBoxColor", { Default = Color3.fromRGB(46, 137, 63), Title = "Box color" })
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

local XmasBox = Tabs.Misc:AddRightGroupbox("Winter 🎄")
XmasBox:AddToggle("SnowEnabled", { Text = "Snowfall", Default = true, Callback = function(v)
    local snow = Library.ScreenGui:FindFirstChild("Snow")
    if snow then snow.Visible = v end
end })
XmasBox:AddLabel("Happy holidays from skidware.cc")

----------------------------------------------------------------- SETTINGS (addons)
local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu")
MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("skidware")
SaveManager:SetFolder("skidware/configs")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

festive(Library, Window)

end) -- end pcall(build)

--============================================================================
--  LOAD NOTIFICATION
--============================================================================
if built then
    Library:Notify("skidware.cc loaded successfully 🎄", 6)
else
    warn("[skidware] build error: " .. tostring(err))
    local ok = pcall(function() Library:Notify("Failed to load — report to developer", 10) end)
    if not ok then fallbackNotify("Failed to load — report to developer") end
end

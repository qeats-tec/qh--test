-- [[ QEATHUB v2.1 - MASTER EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Eski arayüzü temizle
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_Premium") then
    LocalPlayer.PlayerGui.QeatHUB_Premium:Destroy()
end

-- Dinamik Ayarlar Bloğu
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    HitboxSize = 15,
    Toggles = {
        Hitbox = false, AutoClicker = false, Speed = false, JumpPowerToggle = false,
        Xray = false, ESP = false, Noclip = false, AutoAim = false, Fly = false, DoubleJump = false
    }
}

-- [[ CORE SCRIPT MENÜ TASARIMI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 390, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Başlık Çubuğu
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.03, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ QEATHUB PREMIUM v2.1"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "[-]"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -115, 1, -34)
ContentFrame.Position = UDim2.new(0, 110, 0, 32)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 100, 1, -34)
TabBar.Position = UDim2.new(0, 5, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.Padding = UDim.new(0, 3)

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 420)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.Padding = UDim.new(0, 5)
    
    Pages[name] = Page
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local WorldPage = CreatePage("World")
Pages["Combat"].Visible = true

local function AddTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BorderSizePixel = 0
    Btn.Text = " " .. name
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = TabBar
    
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end
AddTab("Combat")
AddTab("Player")
AddTab("World")

-- Menü Küçültme Mekanizması
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        TabBar.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 390, 0, 28), "Out", "Quad", 0.15, true)
        MinimizeBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 390, 0, 280), "Out", "Quad", 0.15, true, function()
            ContentFrame.Visible = true
            TabBar.Visible = true
        end)
        MinimizeBtn.Text = "[-]"
    end
end)

-- UI Toggle Element Yapıcı
local function CreateToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 32, 0, 14)
    Indicator.Position = UDim2.new(0.95, -32, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Frame
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, 2, 0.5, -5)
    Dot.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Dot.BorderSizePixel = 0
    Dot.Parent = Indicator
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        Config.Toggles[configKey] = not Config.Toggles[configKey]
        local active = Config.Toggles[configKey]
        if active then
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 50, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(25, 215, 0)}):Play()
            Frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
        else
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 10, 10)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(150, 50, 50)}):Play()
            Frame.BorderColor3 = Color3.fromRGB(30, 30, 30)
        end
        callback(active)
    end)
end

-- UI Slider (Ayar Çubuğu) Yapıcı
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 18)
    Label.Position = UDim2.new(0.04, 0, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 18)
    ValueLabel.Position = UDim2.new(0.65, 0, 0, 2)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(0.92, 0, 0, 6)
    SliderBar.Position = UDim2.new(0.04, 0, 0.7, -3)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.Parent = Frame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local function UpdateSlider(input)
        local totalWidth = SliderBar.AbsoluteSize.X
        local relativeX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, totalWidth)
        local ratio = relativeX / totalWidth
        local finalVal = math.floor(min + (max - min) * ratio)
        
        ValueLabel.Text = tostring(finalVal)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        callback(finalVal)
    end

    local connection
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateSlider(input)
            connection = UserInputService.InputChanged:Connect(function(change)
                if change.UserInputType == Enum.UserInputType.MouseMovement or change.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(change)
                end
            end)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if connection then connection:Disconnect() connection = nil end
        end
    end)
end

local function CreateSysButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BorderColor3 = color
    Btn.Text = text
    Btn.TextColor3 = color
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = parent
    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================================
-- 🎯 COMBAT SEKMESİ (SAVAŞ)
-- ==========================================================

-- Gelişmiş Duvar Arkası Kontrollü AutoAim (Head Lock)
CreateToggle(CombatPage, "Auto Aim Lock (Wall-Check Head)", "AutoAim", function() end)

local function IsVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, Camera, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    return raycastResult == nil -- Eğer engel yoksa true döner
end

local function GetClosestVisiblePlayerHead()
    local closest, maxDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            if IsVisible(head) then
                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < maxDist then closest = head; maxDist = dist end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Toggles.AutoAim then
        local targetHead = GetClosestVisiblePlayerHead()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- Hitbox Genişletici
CreateToggle(CombatPage, "Hitbox Extender (15 STU)", "Hitbox", function() end)
task.spawn(function()
    while true do task.wait(0.5)
        if Config.Toggles.Hitbox then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.7; hrp.Color = Color3.fromRGB(255, 215, 0)
                    hrp.Material = Enum.Material.Neon; hrp.CanCollide = false
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

-- Auto Clicker Widget
local ClickWidget = Instance.new("TextButton")
ClickWidget.Size = UDim2.new(0, 45, 0, 45)
ClickWidget.Position = UDim2.new(0.85, 0, 0.5, 0)
ClickWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ClickWidget.BorderColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.Text = "TAP"
ClickWidget.TextColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.Font = Enum.Font.Code
ClickWidget.Visible = false
ClickWidget.Active = true; ClickWidget.Draggable = true
local UICorner = Instance.new("UICorner") ; UICorner.CornerRadius = UDim.new(1,0) ; UICorner.Parent = ClickWidget
ClickWidget.Parent = ScreenGui

CreateToggle(CombatPage, "Auto Clicker Widget", "AutoClicker", function(state) ClickWidget.Visible = state end)
local clicking = false
ClickWidget.MouseButton1Click:Connect(function()
    clicking = not clicking
    ClickWidget.BackgroundColor3 = clicking and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(20, 20, 20)
    ClickWidget.TextColor3 = clicking and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(255, 215, 0)
end)
task.spawn(function()
    while true do task.wait(0.01)
        if Config.Toggles.AutoClicker and clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- ==========================================================
-- ⚡ PLAYER SEKMESİ (KARAKTER AYARLARI)
-- ==========================================================

-- Speed Changer & Slider
CreateToggle(PlayerPage, "Enable Speed Changer", "Speed", function() end)
CreateSlider(PlayerPage, "Set Speed Value", 16, 150, 50, function(value)
    Config.WalkSpeed = value
end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

-- Jump Power Changer & Slider
CreateToggle(PlayerPage, "Enable Jump Changer", "JumpPowerToggle", function() end)
CreateSlider(PlayerPage, "Set Jump Power", 50, 300, 100, function(value)
    Config.JumpPower = value
end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.JumpPowerToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpPower
    end
end)

-- Double Jump Motoru (Yenilenmiş Altyapı)
CreateToggle(PlayerPage, "Double Jump Engine", "DoubleJump", function() end)
local hasDoubleJumped = false
local oldState = false

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.DoubleJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hum and hum:GetState() == Enum.HumanoidStateType.FreeFall and not hasDoubleJumped then
            hasDoubleJumped = true
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Config.JumpPower, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
            hasDoubleJumped = false
        end
    end
end)

-- Yenilenmiş Fly Engine (Stabilize)
CreateToggle(PlayerPage, "Fly Engine", "Fly", function() end)
local flyGyro, flyVelocity
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if not hrp:FindFirstChild("QeatFlyGyro") then
            flyGyro = Instance.new("BodyGyro")
            flyGyro.Name = "QeatFlyGyro"
            flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyGyro.Parent = hrp
            
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Name = "QeatFlyVel"
            flyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
            flyVelocity.Parent = hrp
        end
        
        if hum then hum.PlatformStand = true end
        flyGyro.cframe = Camera.CFrame
        
        local moveDir = hum and hum.MoveDirection or Vector3.new(0,0,0)
        flyVelocity.velocity = moveDir * Config.FlySpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hrp:FindFirstChild("QeatFlyGyro") then hrp.QeatFlyGyro:Destroy() end
            if hrp:FindFirstChild("QeatFlyVel") then hrp.QeatFlyVel:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end
end)

-- Yenilenmiş Mobil Uyumlu Shiftlock Modülü
local ShiftlockButton = Instance.new("TextButton")
ShiftlockButton.Size = UDim2.new(0, 50, 0, 50)
ShiftlockButton.Position = UDim2.new(0.85, 0, 0.3, 0)
ShiftlockButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ShiftlockButton.BorderColor3 = Color3.fromRGB(255, 215, 0)
ShiftlockButton.BorderSizePixel = 2
ShiftlockButton.Text = "🔒"
ShiftlockButton.TextSize = 18
ShiftlockButton.Visible = false
local CornerLock = Instance.new("UICorner"); CornerLock.CornerRadius = UDim.new(1,0); CornerLock.Parent = ShiftlockButton
ShiftlockButton.Parent = ScreenGui

CreateToggle(PlayerPage, "Mobile Shiftlock Fix", "Shiftlock", function(state)
    ShiftlockButton.Visible = state
end)

local shiftlockActive = false
ShiftlockButton.MouseButton1Click:Connect(function()
    shiftlockActive = not shiftlockActive
    ShiftlockButton.BackgroundColor3 = shiftlockActive and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(20, 20, 20)
end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.Shiftlock and shiftlockActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camLook = Camera.CFrame.LookVector
        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(hrp.Position.X + camLook.X, hrp.Position.Y, hrp.Position.Z + camLook.Z))
        Camera.CameraOffset = Vector3.new(1.75, 0, 0) -- Ommuz hizası kamerası
    else
        Camera.CameraOffset = Vector3.new(0, 0, 0)
    end
end)

-- Noclip Engine
CreateToggle(PlayerPage, "Noclip Engine", "Noclip", function() end)
RunService.Stepped:Connect(function()
    if Config.Toggles.Noclip and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
    end
end)

-- ==========================================================
-- 🗺️ WORLD SEKMESİ (DÜNYA AYARLARI)
-- ==========================================================

-- Visual ESP Box
CreateToggle(WorldPage, "Visual ESP Box", "ESP", function() end)
local function CreateESP(player)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = "QeatESP"
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Color3 = Color3.fromRGB(255, 215, 0)
    Box.Transparency = 0.4
    Box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    Box.Size = Vector3.new(4, 5.5, 1)
    Box.Parent = ScreenGui
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        Box.Adornee = char:WaitForChild("HumanoidRootPart")
    end)
end
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
RunService.RenderStepped:Connect(function()
    for _, adorn in ipairs(ScreenGui:GetChildren()) do
        if adorn.Name == "QeatESP" then adorn.Visible = Config.Toggles.ESP end
    end
end)

-- X-Ray Vision
local originalTransparencies = {}
CreateToggle(WorldPage, "X-Ray Vision", "Xray", function(state)
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) and not Players:GetPlayerFromCharacter(obj.Parent) then
                if obj.Name ~= "Terrain" then originalTransparencies[obj] = obj.Transparency; obj.Transparency = 0.65 end
            end
        end
    else
        for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end
        table.clear(originalTransparencies)
    end
end)

CreateSysButton(WorldPage, " [>] Inject Infinite Yield", Color3.fromRGB(255, 165, 0), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
end)

CreateSysButton(WorldPage, " [!] TERMINATE QEATHUB", Color3.fromRGB(255, 50, 50), function()
    for k, _ in pairs(Config.Toggles) do Config.Toggles[k] = false end
    for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end
    ScreenGui:Destroy()
end)

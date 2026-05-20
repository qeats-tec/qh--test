-- [[ QEATHUB v2.0 - PREMIUM MULTI-HACK ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Eski arayüzü temizle (Üst üste binmesin diye)
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_Premium") then
    LocalPlayer.PlayerGui.QeatHUB_Premium:Destroy()
end

-- Ana Ayarlar Bloğu
local Config = {
    HitboxSize = 15,
    WalkSpeed = 50,
    FlySpeed = 50,
    Toggles = {
        Hitbox = false, AutoClicker = false, Speed = false, InfJump = false,
        Xray = false, ESP = false, Noclip = false, AutoAim = false, Fly = false, DoubleJump = false
    }
}

-- [[ CORE SCRIPT MENÜ TASARIMI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 260)
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
TitleText.Text = "⚡ QEATHUB PREMIUM v2.0"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Küçültme (-) Butonu
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "[-]"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TitleBar

-- İçerik Kutusu (Sekme içerikleri için)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -110, 1, -34)
ContentFrame.Position = UDim2.new(0, 105, 0, 32)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Yan Sekme Menüsü Çerçevesi
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 95, 1, -34)
TabBar.Position = UDim2.new(0, 5, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.Padding = UDim.new(0, 3)

-- Sayfa Yapıları (Scrolling)
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 350)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.Padding = UDim.new(0, 4)
    
    Pages[name] = Page
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local WorldPage = CreatePage("World")

Pages["Combat"].Visible = true -- İlk sayfa açık başlasın

-- Sekme Değiştirici Buton Fonksiyonu
local function AddTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BorderSizePixel = 0
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    Btn.Parent = TabBar
    
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end

AddTab("Combat")
AddTab("Player")
AddTab("World")

-- Küçültme Fonksiyonu
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        TabBar.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 380, 0, 28), "Out", "Quad", 0.2, true)
        MinimizeBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 380, 0, 260), "Out", "Quad", 0.2, true, function()
            ContentFrame.Visible = true
            TabBar.Visible = true
        end)
        MinimizeBtn.Text = "[-]"
    end
end)

-- Gelişmiş Toggle Oluşturucu (UI Güzelleştirmesi)
local function CreateToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(35, 35, 35)
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Code
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 35, 0, 16)
    Indicator.Position = UDim2.new(0.95, -35, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    Indicator.BorderSizePixel = 1
    Indicator.BorderColor3 = Color3.fromRGB(80, 20, 20)
    Indicator.Parent = Frame
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = UDim2.new(0, 2, 0.5, -6)
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
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 40, 10), BorderColor3 = Color3.fromRGB(25, 215, 0)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Color3.fromRGB(25, 215, 0)}):Play()
            Frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
        else
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 10, 10), BorderColor3 = Color3.fromRGB(80, 20, 20)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(150, 50, 50)}):Play()
            Frame.BorderColor3 = Color3.fromRGB(35, 35, 35)
        end
        callback(active)
    end)
end

-- Standart Sistem Buton Yapıcı (Inject/Kill için)
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
-- 🎯 COMBAT TAB (SAVAŞ SEKMESİ)
-- ==========================================================

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

-- 3. Gelişmiş AutoAim (En Yakın Oyuncuya Otomatik Kitlenme)
CreateToggle(CombatPage, "Auto Aim Lock", "AutoAim", function() end)
local function GetClosestPlayer()
    local closest, maxDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local screenPos, onScreen = Camera:WorldToScreenPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < maxDist then closest = p; maxDist = dist end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    if Config.Toggles.AutoAim then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Auto Clicker Widget Kontrolü
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
-- ⚡ PLAYER TAB (KARAKTER SEKMESİ)
-- ==========================================================

-- WalkSpeed Changer
CreateToggle(PlayerPage, "Speed Hack (x50)", "Speed", function() end)
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

-- Infinite Jump
CreateToggle(PlayerPage, "Infinite Jump", "InfJump", function() end)
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 7. Double Jump (Çift Zıplama)
CreateToggle(PlayerPage, "Double Jump Engine", "DoubleJump", function() end)
local jumpCount = 0
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.DoubleJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum:GetState() == Enum.HumanoidStateType.FreeFall and jumpCount < 1 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            jumpCount = jumpCount + 1
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
            jumpCount = 0
        end
    end
end)

-- 4. Fly Engine (Uçma Modu)
CreateToggle(PlayerPage, "Fly Engine (Uçma)", "Fly", function() end)
local BodyGyro, BodyVelocity
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not hrp:FindFirstChild("QeatFlyGyro") then
            BodyGyro = Instance.new("BodyGyro", hrp)
            BodyGyro.Name = "QeatFlyGyro"
            BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity = Instance.new("BodyVelocity", hrp)
            BodyVelocity.Name = "QeatFlyVel"
            BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        end
        BodyGyro.cframe = Camera.CFrame
        local dir = Vector3.new(0,0,0)
        -- Mobil Joystick/Kamera hareket yönü entegrasyonu
        if UserInputService.TouchEnabled then
            dir = Camera.CFrame.LookVector
        end
        BodyVelocity.velocity = dir * Config.FlySpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp:FindFirstChild("QeatFlyGyro") then hrp.QeatFlyGyro:Destroy() end
            if hrp:FindFirstChild("QeatFlyVel") then hrp.QeatFlyVel:Destroy() end
        end
    end
end)

-- Evrensel Shiftlock
CreateToggle(PlayerPage, "Force Shiftlock", "Shiftlock", function(state)
    LocalPlayer.DevEnableMouseLock = state
end)

-- 2. Noclip (Duvarlardan Geçme)
CreateToggle(PlayerPage, "Noclip Engine (Duvar Geçme)", "Noclip", function() end)
RunService.Stepped:Connect(function()
    if Config.Toggles.Noclip and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
    end
end)

-- ==========================================================
-- 🗺️ WORLD & SYSTEM TAB (DÜNYA SEKMESİ)
-- ==========================================================

-- 1. 2D Box ESP Mesh (Oyuncu Gösterme)
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

-- Sistem Araçları (Infinite Yield Backdoor & Terminate)
CreateSysButton(WorldPage, " [>] Inject Infinite Yield", Color3.fromRGB(255, 165, 0), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
end)

CreateSysButton(WorldPage, " [!] TERMINATE QEATHUB", Color3.fromRGB(255, 50, 50), function()
    for k, _ in pairs(Config.Toggles) do Config.Toggles[k] = false end
    for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end
    ScreenGui:Destroy()
end)

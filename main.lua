-- [[ QEATHUB EVRENSEL SARI/SİYAH UTILITY SCRIPTI ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- GUI Tasarımı (Sarı & Siyah QeatHUB Teması)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Ana Panel
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 220, 0, 320)
MainPanel.Position = UDim2.new(0.05, 0, 0.2, 0)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainPanel.BorderSizePixel = 2
MainPanel.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Canlı Sarı
MainPanel.Active = true
MainPanel.Draggable = true -- Mobil için sürükleme desteği
MainPanel.Parent = ScreenGui

-- UI Köşeleri ve Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = " [ QEATHUB v1.0 ] "
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 14
Title.Font = Enum.Font.Code
Title.Parent = MainPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainPanel
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Başlık için yer açma dolgusu
local Padding = Instance.new("Frame")
Padding.Size = UDim2.new(1, 0, 0, 32)
Padding.BackgroundTransparency = 1
Padding.LayoutOrder = 0
Padding.Parent = MainPanel

-- [[ SEÇENEK DEĞİŞKENLERİ ]] --
local Config = {
    HitboxSize = 15,
    WalkSpeed = 50,
    Toggles = {
        Hitbox = false,
        AutoClicker = false,
        Speed = false,
        InfJump = false,
        Xray = false
    }
}

-- Buton Oluşturucu Fonksiyon
local function CreateButton(text, layoutOrder, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 210, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Btn.BorderSizePixel = 1
    Btn.Text = " [ ] " .. text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = layoutOrder
    Btn.Parent = MainPanel
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
            Btn.BorderColor3 = Color3.fromRGB(255, 215, 0)
            Btn.Text = " [*] " .. text
        else
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.BorderColor3 = Color3.fromRGB(40, 40, 40)
            Btn.Text = " [ ] " .. text
        end
        callback(active)
    end)
    return Btn
end

-- ==========================================================
-- 🎯 COMBAT (SAVAŞ) AKTİVASYONLARI
-- ==========================================================

-- Hitbox Genişletici
CreateButton("Hitbox Extender (15 STU)", 1, function(state)
    Config.Toggles.Hitbox = state
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.Toggles.Hitbox then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.65
                    hrp.Color = Color3.fromRGB(255, 215, 0) -- Sarı kutu
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        else
            -- Kapatıldığında eski haline getirir
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
    end
end)

-- Mobil Auto Clicker Widget
local ClickWidget = Instance.new("TextButton")
ClickWidget.Name = "QeatClickWidget"
ClickWidget.Size = UDim2.new(0, 50, 0, 50)
ClickWidget.Position = UDim2.new(0.8, 0, 0.5, 0)
ClickWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ClickWidget.BorderColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.BorderSizePixel = 2
ClickWidget.Text = "TAP"
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ClickWidget
ClickWidget.TextColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.Font = Enum.Font.Code
ClickWidget.Visible = false
ClickWidget.Active = true
ClickWidget.Draggable = true
ClickWidget.Parent = ScreenGui

CreateButton("Auto Clicker Widget", 2, function(state)
    Config.Toggles.AutoClicker = state
    ClickWidget.Visible = state
end)

local clicking = false
ClickWidget.MouseButton1Click:Connect(function()
    clicking = not clicking
    if clicking then
        ClickWidget.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        ClickWidget.TextColor3 = Color3.fromRGB(15, 15, 15)
    else
        ClickWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ClickWidget.TextColor3 = Color3.fromRGB(255, 215, 0)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if Config.Toggles.AutoClicker and clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- ==========================================================
-- ⚡ PLAYER (KARAKTER) AKTİVASYONLARI
-- ==========================================================

-- WalkSpeed Changer Loop
CreateButton("Speed Hack (x50)", 3, function(state)
    Config.Toggles.Speed = state
end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

-- Infinite Jump
CreateButton("Infinite Jump", 4, function(state)
    Config.Toggles.InfJump = state
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Evrensel Shiftlock
CreateButton("Force Shiftlock", 5, function(state)
    if state then
        LocalPlayer.DevEnableMouseLock = true
    else
        LocalPlayer.DevEnableMouseLock = false
    end
end)

-- ==========================================================
-- 🗺️ WORLD (DÜNYA) AKTİVASYONLARI
-- ==========================================================

-- X-Ray Map Engine
local originalTransparencies = {}
CreateButton("X-Ray Vision", 6, function(state)
    Config.Toggles.Xray = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) and not Players:GetPlayerFromCharacter(obj.Parent) then
                if obj.Name ~= "Terrain" then
                    originalTransparencies[obj] = obj.Transparency
                    obj.Transparency = 0.65
                end
            end
        end
    else
        for obj, trans in pairs(originalTransparencies) do
            if obj and obj.Parent then
                obj.Transparency = trans
            end
        end
        table.clear(originalTransparencies)
    end
end)

-- ==========================================================
-- 🛠️ SYSTEM (SİSTEM) AKTİVASYONLARI
-- ==========================================================

-- Infinite Yield Injector
local IYBtn = Instance.new("TextButton")
IYBtn.Size = UDim2.new(0, 210, 0, 32)
IYBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 10)
IYBtn.BorderColor3 = Color3.fromRGB(255, 165, 0)
IYBtn.Text = " [>] Inject Infinite Yield"
IYBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
IYBtn.Font = Enum.Font.Code
IYBtn.TextSize = 11
IYBtn.LayoutOrder = 7
IYBtn.Parent = MainPanel

IYBtn.MouseButton1Click:Connect(function()
    IYBtn.Text = " [QEATHUB] Injected! "
    IYBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
end)

-- Güvenli Kapatma (Self Destruct)
local DestructBtn = Instance.new("TextButton")
DestructBtn.Size = UDim2.new(0, 210, 0, 32)
DestructBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
DestructBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
DestructBtn.Text = " [!] TERMINATE QEATHUB"
DestructBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
DestructBtn.Font = Enum.Font.Code
DestructBtn.TextSize = 11
DestructBtn.LayoutOrder = 8
DestructBtn.Parent = MainPanel

DestructBtn.MouseButton1Click:Connect(function()
    Config.Toggles.Hitbox = false
    Config.Toggles.Speed = false
    Config.Toggles.InfJump = false
    Config.Toggles.AutoClicker = false
    
    for obj, trans in pairs(originalTransparencies) do
        if obj and obj.Parent then obj.Transparency = trans end
    end
    
    ScreenGui:Destroy()
end)

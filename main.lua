-- [[ QeatHUB v1.0 - Roblox Executor Script ]] --
-- Tema: Black & Yellow (Hacker Style)
-- Geliştirici: Qeat Developer

local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:Service("RunService")
local UserInputService = game:Service("UserInputService")
local TweenService = game:Service("TweenService")
local HttpService = game:Service("HttpService")

-- [[ ANA GUI OLUŞTURMA ]] --
local QeatHUB = Instance.new("ScreenGui")
local MainPanel = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local Sidebar = Instance.new("Frame")
local Container = Instance.new("Frame")

-- GUI Ayarları
QeatHUB.Name = "QeatHUB"
QeatHUB.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
QeatHUB.ResetOnSpawn = false

-- Sürükleme Sistemi (Mobil & PC Uyumlu)
local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Ana Panel Tasarımı
MainPanel.Name = "MainPanel"
MainPanel.Parent = QeatHUB
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainPanel.BorderSizePixel = 2
MainPanel.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Sarı Sınır
MainPanel.Position = UDim2.new(0.3, 0, 0.25, 0)
MainPanel.Size = UDim2.new(0, 500, 0, 320)
makeDraggable(MainPanel, TopBar)

-- Üst Bar
TopBar.Name = "TopBar"
TopBar.Parent = MainPanel
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.Size = UDim2.new(1, 0, 0, 35)

Title.Parent = TopBar
Title.Text = "  QeatHUB v1.0"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 18
Title.Font = Enum.Font.Code
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Kapatma Butonu
CloseBtn.Parent = TopBar
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.Position = UDim2.new(0.93, 0, 0.1, 0)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Font = Enum.Font.Code

-- Küçültme Butonu (💛)
MinimizeBtn.Parent = TopBar
MinimizeBtn.Text = "💛"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Font = Enum.Font.Code

-- Sol Menü (Kategoriler)
Sidebar.Parent = MainPanel
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 120, 1, -35)

-- İçerik Alanı
Container.Parent = MainPanel
Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Container.Position = UDim2.new(0, 120, 0, 35)
Container.Size = UDim2.new(1, -120, 1, -35)

-- [[ KATEGORİ YÖNETİMİ ]] --
local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Parent = Container
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    page.ScrollBarThickness = 4
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 8)
    
    pages[name] = page
    return page
end

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, (order - 1) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    
    btn.MouseButton1Click:Connect(function()
        for k, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(200, 200, 200) end
        end
        btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    end)
end

-- Sayfaları Oluştur
local combatPage = createPage("Combat")
local playerPage = createPage("Player")
local worldPage = createPage("World")
local systemPage = createPage("System")

createTabButton("Combat", 1)
createTabButton("Player", 2)
createTabButton("World", 3)
createTabButton("System", 4)
pages["Combat"].Visible = true -- İlk açılış sayfası

-- [[ UI ELEMENT FABRİKASI ]] --
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(0.75, 0, 0.15, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "KAPALI"
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = frame
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "AÇIK"
            btn.TextColor3 = Color3.fromRGB(0, 255, 0)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 0)
        else
            btn.Text = "KAPALI"
            btn.TextColor3 = Color3.fromRGB(255, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        callback(active)
    end)
end

local function createTextBox(parent, text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 70, 0, 25)
    box.Position = UDim2.new(0.72, 0, 0.15, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.TextColor3 = Color3.fromRGB(255, 215, 0)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.Font = Enum.Font.Code
    box.TextSize = 14
    box.Parent = frame
    
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
end


-- [[ HİLE FONKSİYONLARI VE MANTIĞI ]] --

--- 🎯 COMBAT KATEGORİSİ ---
local hitboxSize = 10
local hitboxEnabled = false

createToggle(combatPage, "Hitbox Genişletici", function(val)
    hitboxEnabled = val
end)

createTextBox(combatPage, "Hitbox Boyutu:", "10", function(text)
    local num = tonumber(text)
    if num then hitboxSize = num end
end)

-- Hitbox Döngüsü
RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Bright yellow")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    else
        -- Kapatılınca eski haline getir
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = true
            end
        end
    end
end)

-- Mobil Auto Clicker Widget
local clickerWidget = Instance.new("TextButton")
clickerWidget.Name = "AutoClickerWidget"
clickerWidget.Parent = QeatHUB
clickerWidget.Size = UDim2.new(0, 65, 0, 65)
clickerWidget.Position = UDim2.new(0.85, 0, 0.5, 0)
clickerWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
clickerWidget.BorderColor3 = Color3.fromRGB(255, 215, 0)
clickerWidget.BorderSizePixel = 2
clickerWidget.Text = "CLICK"
clickerWidget.TextColor3 = Color3.fromRGB(255, 255, 255)
clickerWidget.Font = Enum.Font.SourceSansBold
clickerWidget.TextSize = 16
clickerWidget.Visible = false
makeDraggable(clickerWidget, clickerWidget)

-- Yuvarlaklaştırma
local widgetCorner = Instance.new("UICorner")
widgetCorner.CornerRadius = UDim.new(1, 0)
widgetCorner.Parent = clickerWidget

local autoClickSpeed = 0.05
local autoClickActive = false

createToggle(combatPage, "Mobil Auto Clicker Göster", function(val)
    clickerWidget.Visible = val
end)

createTextBox(combatPage, "Tıklama Saniyesi:", "0.05", function(text)
    local num = tonumber(text)
    if num then autoClickSpeed = num end
end)

clickerWidget.MouseButton1Click:Connect(function()
    autoClickActive = not autoClickActive
    if autoClickActive then
        clickerWidget.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        clickerWidget.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        clickerWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        clickerWidget.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Tıklama Döngüsü (VirtualUser ile hem Mobil hem PC uyumlu)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    while task.wait() do
        if autoClickActive then
            vu:Button1Down(Vector2.new(clickerWidget.AbsolutePosition.X, clickerWidget.AbsolutePosition.Y))
            task.wait(autoClickSpeed)
            vu:Button1Up(Vector2.new(clickerWidget.AbsolutePosition.X, clickerWidget.AbsolutePosition.Y))
        end
    end
end)


--- ⚡ PLAYER KATEGORİSİ ---
local customSpeed = 16
local speedLoopActive = false

createToggle(playerPage, "Hız Değiştirici Aktif", function(val)
    speedLoopActive = val
end)

createTextBox(playerPage, "Hız Değiğtir (WalkSpeed):", "16", function(text)
    local num = tonumber(text)
    if num then customSpeed = num end
end)

-- Öldükten sonra da koruyan Hız Döngüsü
RunService.Heartbeat:Connect(function()
    if speedLoopActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = customSpeed
    end
end)

-- Sonsuz Zıplama (Infinite Jump)
local infJumpEnabled = false
createToggle(playerPage, "Sonsuz Zıplama", function(val)
    infJumpEnabled = val
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Evrensel Shiftlock
local shiftLockEnabled = false
createToggle(playerPage, "Evrensel Shiftlock", function(val)
    shiftLockEnabled = val
    LocalPlayer.DevEnableMouseLock = shiftLockEnabled
end)


--- 🗺️ WORLD KATEGORİSİ ---
local xrayActive = false
createToggle(worldPage, "Harita X-Ray (%65 Şeffaf)", function(val)
    xrayActive = val
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Players) and obj.Name ~= "Terrain" then
            if xrayActive then
                if not obj:GetAttribute("OldTrans") then
                    obj:SetAttribute("OldTrans", obj.Transparency)
                end
                obj.Transparency = 0.65
            else
                local old = obj:GetAttribute("OldTrans")
                if old then
                    obj.Transparency = old
                    obj:SetAttribute("OldTrans", nil)
                else
                    obj.Transparency = 0
                end
            end
        end
    end
end)


--- 🛠️ SYSTEM KATEGORİSİ ---
createButton(systemPage, "Infinite Yield Panel Yükle", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeYoshi/InfiniteYield/master/source'))()
end)

createButton(systemPage, "Menüyü Tamamen Kapat", function()
    QeatHUB:Destroy()
end)


-- [[ KÜÇÜLTME (💛) FONKSİYONU ]] --
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Sidebar.Visible = false
        Container.Visible = false
        MainPanel:TweenSize(UDim2.new(0, 500, 0, 35), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "🖤"
    else
        MainPanel:TweenSize(UDim2.new(0, 500, 0, 320), "Out", "Quad", 0.3, true, function()
            Sidebar.Visible = true
            Container.Visible = true
        end)
        MinimizeBtn.Text = "💛"
    end
end)

-- Kapatma Butonu İşlevi
CloseBtn.MouseButton1Click:Connect(function()
    QeatHUB:Destroy()
end)

-- [[ QeatHUB v1.0 - Ultra Light Edition ]] --
-- Özellikler: WalkSpeed, JumpPower, Infinite Jump

local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:Service("RunService")
local UserInputService = game:Service("UserInputService")

-- [[ ⚙️ AYARLAR (Buradaki rakamları isteğine göre değiştirebilirsin) ]] --
local CustomSpeed = 60       -- Normal yürüme hızı 16'dır.
local CustomJumpPower = 80   -- Normal zıplama gücü 50'dir.
local InfJumpEnabled = true  -- Havada sınırsız zıplama (true: Açık, false: Kapalı)


-- [[ ⚡ HIZ VE ZIPLAMA GÜCÜ DÖNGÜSÜ ]] --
-- Heartbeat döngüsü sayesinde karakterin ölse bile değerler sıfırlanmaz.
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Oyunun zıplama gücü ayarını aktif et ve gücü tanımla
            humanoid.UseJumpPower = true 
            humanoid.WalkSpeed = CustomSpeed
            humanoid.JumpPower = CustomJumpPower
        end
    end
end)


-- [[ 🚀 SINIRSIZ ZIPLAMA (INFINITE JUMP) ]] --
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Karakterin havada zıplama durumunu sürekli tetikler
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

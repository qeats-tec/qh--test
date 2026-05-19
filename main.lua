-- Delta için en saf ve en hızlı bypass modu
game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 60
game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = 90

-- Sınırsız Zıplama (Ekrana dokundukça havada zıplar)
game:GetService("UserInputService").JumpRequest:Connect(function()
    game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(3)
end)

-- 🟥 Kill All Button para KRNL Android - Roblox Prison Life
-- Crea un botón flotante funcional que intenta matar a todos los jugadores menos a ti

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Crear pantalla flotante
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KillAllMenu"

local KillAllButton = Instance.new("TextButton")
KillAllButton.Size = UDim2.new(0, 200, 0, 50)
KillAllButton.Position = UDim2.new(0, 100, 0, 300)
KillAllButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
KillAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAllButton.TextScaled = true
KillAllButton.Text = "🔪 KILL ALL"
KillAllButton.Parent = ScreenGui

-- Función: Kill All (intenta romper las uniones de todos los jugadores)
KillAllButton.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character:BreakJoints() -- Este comando mata al jugador
        end
    end
end)
-- Kill All con botón flotante - ChatGPT para KRNL Android

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 120, 0, 40)
Button.Position = UDim2.new(0, 20, 0.5, 0)
Button.Text = "🔥 KILL ALL 🔥"
Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.Active = true
Button.Draggable = true

-- Kill All funcional
Button.MouseButton1Click:Connect(function()
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character:BreakJoints() -- Mata al jugador (Kill real)
        end
    end
end)
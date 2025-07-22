-- Espera a que el juego cargue completamente
repeat wait() until game:IsLoaded()

-- Variables base
local player = game.Players.LocalPlayer
local meleeEvent = game.ReplicatedStorage:FindFirstChild("meleeEvent")

-- Crear GUI flotante
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillOptionsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--========================
--== MÉTODO 1: Tu Script ==
--========================
local function killByHealth()
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") then
            target.Character.Humanoid.Health = 0
        end
    end
end

--===============================
--== MÉTODO 2: meleeEvent mío ==
--===============================
local function killByMeleeEvent()
    if not meleeEvent then
        warn("meleeEvent no encontrado. No se puede ejecutar el ataque.")
        return
    end

    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 5 do
                meleeEvent:FireServer(target.Character)
                wait(0.1)
            end
        end
    end
end

--===========================
--== BOTÓN: Tu Método ==
--===========================
local Button1 = Instance.new("TextButton")
Button1.Parent = ScreenGui
Button1.Size = UDim2.new(0, 150, 0, 40)
Button1.Position = UDim2.new(0, 20, 0, 60)
Button1.Text = "💀 Kill All (Salud)"
Button1.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Button1.TextColor3 = Color3.new(1, 1, 1)
Button1.Font = Enum.Font.SourceSansBold
Button1.TextSize = 18
Button1.MouseButton1Click:Connect(killByHealth)

--===========================
--== BOTÓN: Mi Método ==
--===========================
local Button2 = Instance.new("TextButton")
Button2.Parent = ScreenGui
Button2.Size = UDim2.new(0, 150, 0, 40)
Button2.Position = UDim2.new(0, 20, 0, 110)
Button2.Text = "🔪 Kill All (meleeEvent)"
Button2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button2.TextColor3 = Color3.new(1, 1, 1)
Button2.Font = Enum.Font.SourceSansBold
Button2.TextSize = 18
Button2.MouseButton1Click:Connect(killByMeleeEvent)
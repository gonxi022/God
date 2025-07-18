local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")

local killAllActive = false
local godModeActive = false

-- Función para matar a todos (excepto local)
local function killAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            meleeEvent:FireServer(player)
        end
    end
end

-- Función para mantener God Mode (regenerar salud)
local function enableGodMode()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    hum.HealthChanged:Connect(function(health)
        if godModeActive and health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)

    -- Loop extra para asegurar salud máxima
    spawn(function()
        while godModeActive do
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
            wait(0.1)
        end
    end)
end

-- Toggle kill all (por ejemplo con tecla K)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        killAllActive = not killAllActive
        if killAllActive then
            print("Kill All ACTIVADO")
            -- Ejecutar killAll continuamente mientras esté activo
            spawn(function()
                while killAllActive do
                    killAll()
                    wait(0.5)
                end
            end)
        else
            print("Kill All DESACTIVADO")
        end
    elseif input.KeyCode == Enum.KeyCode.G then
        godModeActive = not godModeActive
        if godModeActive then
            print("God Mode ACTIVADO")
            enableGodMode()
        else
            print("God Mode DESACTIVADO")
        end
    end
end)

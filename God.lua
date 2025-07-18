-- Prison Life - Kill All + God Mode con GUI
-- Uso exclusivo para testeo con admin y en servidores vulnerables

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")

-- Variables estado
local killAllActive = false
local godModeActive = false

-- Función Kill All
local function killAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Intentar matar player vía meleeEvent
            pcall(function()
                meleeEvent:FireServer(player)
            end)
        end
    end
end

-- Función God Mode
local function enableGodMode()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    hum.HealthChanged:Connect(function(health)
        if godModeActive and health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end)

    -- Loop constante para mantener salud máxima
    spawn(function()
        while godModeActive do
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
            task.wait(0.1)
        end
    end)
end

-- Crear GUI básica en CoreGui
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminTools"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Kill All Button
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 180, 0, 50)
KillBtn.Position = UDim2.new(0, 10, 0, 10)
KillBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Text = "Kill All: OFF"
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 20
KillBtn.Parent = Frame

-- God Mode Button
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(0, 180, 0, 50)
GodBtn.Position = UDim2.new(0, 10, 0, 70)
GodBtn.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
GodBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodBtn.Text = "God Mode: OFF"
GodBtn.Font = Enum.Font.GothamBold
GodBtn.TextSize = 20
GodBtn.Parent = Frame

-- Kill All toggle
KillBtn.MouseButton1Click:Connect(function()
    killAllActive = not killAllActive
    if killAllActive then
        KillBtn.Text = "Kill All: ON"
        spawn(function()
            while killAllActive do
                killAll()
                task.wait(0.5)
            end
        end)
    else
        KillBtn.Text = "Kill All: OFF"
    end
end)

-- God Mode toggle
GodBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        GodBtn.Text = "God Mode: ON"
        enableGodMode()
    else
        GodBtn.Text = "God Mode: OFF"
    end
end)

-- Mensaje inicial
print("[AdminTools] Script cargado. Usa la GUI para activar Kill All y God Mode.")

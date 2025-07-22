repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local ShootEvent = ReplicatedStorage:FindFirstChild("ShootEvent")
local ItemHandler = Workspace:FindFirstChild("Remote") and Workspace.Remote:FindFirstChild("ItemHandler")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PL_KillAmmoGUI"
gui.ResetOnSpawn = false

-- Create Kill All Button
local killButton = Instance.new("TextButton", gui)
killButton.Size = UDim2.new(0, 200, 0, 50)
killButton.Position = UDim2.new(0, 20, 0, 60)
killButton.Text = "🔫 Kill All (M9)"
killButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
killButton.TextColor3 = Color3.new(1, 1, 1)
killButton.Font = Enum.Font.SourceSansBold
killButton.TextSize = 18

-- Create Infinite Ammo Button
local ammoButton = Instance.new("TextButton", gui)
ammoButton.Size = UDim2.new(0, 200, 0, 50)
ammoButton.Position = UDim2.new(0, 20, 0, 120)
ammoButton.Text = "♾️ Balas Infinitas"
ammoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
ammoButton.TextColor3 = Color3.new(1, 1, 1)
ammoButton.Font = Enum.Font.SourceSansBold
ammoButton.TextSize = 18

-- Equipar M9 si está en la mochila
local function equipM9()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    local m9 = backpack:FindFirstChild("M9")
    if m9 then
        m9.Parent = LocalPlayer.Character
        wait(0.2)
    end
end

-- Disparar a jugador con ShootEvent
local function shoot(target)
    if target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local args = {
            ["Hit"] = head,
            ["Position"] = head.Position,
            ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
            ["Distance"] = 100,
            ["CFrame"] = CFrame.new(),
            ["Name"] = "M9",
            ["Target"] = head
        }
        for i = 1, 5 do
            ShootEvent:FireServer(args)
            wait(0.1)
        end
    end
end

-- Kill All Function
killButton.MouseButton1Click:Connect(function()
    if not ShootEvent then
        killButton.Text = "❌ ShootEvent no encontrado"
        return
    end

    equipM9()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            shoot(plr)
        end
    end
end)

-- Balas Infinitas Function
ammoButton.MouseButton1Click:Connect(function()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("M9")
    if not tool then
        ammoButton.Text = "❌ Equipa la M9"
        return
    end

    local config = tool:FindFirstChild("GunStates")
    if config then
        config:FindFirstChild("Ammo").Value = 999
        config:FindFirstChild("StoredAmmo").Value = 999
        ammoButton.Text = "✅ Munición Infinita Activada"
    else
        ammoButton.Text = "❌ No se encontró GunStates"
    end
end)
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ShootEvent = ReplicatedStorage:WaitForChild("ShootEvent")

-- Crear GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "KillAllV2"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 0, 60)
button.Text = "🔫 Kill All REAL"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18

-- Disparar a la cabeza del jugador objetivo
local function shootPlayer(plr)
    local targetChar = plr.Character
    local myChar = LocalPlayer.Character
    if not (targetChar and myChar and myChar:FindFirstChild("Head")) then return end

    local head = targetChar:FindFirstChild("Head")
    if not head then return end

    local args = {
        ["Hit"] = head,
        ["Position"] = head.Position,
        ["RayObject"] = Ray.new(myChar.Head.Position, (head.Position - myChar.Head.Position).Unit * 500),
        ["Distance"] = (myChar.Head.Position - head.Position).Magnitude,
        ["CFrame"] = CFrame.new(myChar.Head.Position, head.Position),
        ["Name"] = "M9",
        ["Target"] = head
    }

    for i = 1, 5 do
        ShootEvent:FireServer(args)
        wait(0.1)
    end
end

-- Kill All al presionar el botón
button.MouseButton1Click:Connect(function()
    if not Character:FindFirstChild("M9") then
        button.Text = "❌ Equipa la M9 primero"
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            shootPlayer(plr)
        end
    end
end)
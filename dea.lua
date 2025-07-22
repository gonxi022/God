repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local noclip = false
local blockFriendMain = false

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "SafeBypass"
gui.ResetOnSpawn = false

-- Botón: Noclip
local btn1 = Instance.new("TextButton", gui)
btn1.Size = UDim2.new(0, 200, 0, 50)
btn1.Position = UDim2.new(0, 20, 0, 60)
btn1.Text = "🚶‍♂️ Noclip: OFF"
btn1.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.Font = Enum.Font.SourceSansBold
btn1.TextSize = 18

btn1.MouseButton1Click:Connect(function()
    noclip = not noclip
    btn1.Text = noclip and "🚶‍♂️ Noclip: ON" or "🚶‍♂️ Noclip: OFF"
end)

-- Botón: Bloqueo FriendMain
local btn2 = Instance.new("TextButton", gui)
btn2.Size = UDim2.new(0, 200, 0, 50)
btn2.Position = UDim2.new(0, 20, 0, 120)
btn2.Text = "🔒 Block FriendMain: OFF"
btn2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.Font = Enum.Font.SourceSansBold
btn2.TextSize = 18

btn2.MouseButton1Click:Connect(function()
    blockFriendMain = not blockFriendMain
    btn2.Text = blockFriendMain and "🔒 Block FriendMain: ON" or "🔒 Block FriendMain: OFF"
end)

-- Noclip loop
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Hook seguro con protección
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    -- Protegido y limitado
    if blockFriendMain and tostring(self) == "FriendMain" and method == "FireServer" then
        warn("🔒 Bloqueado: FriendMain")
        return nil
    end

    -- Bloquear GameAnalytics para evitar loop
    if tostring(self):lower():find("gameanalytics") then
        warn("🛑 Bloqueado GameAnalytics")
        return nil
    end

    return old(self, unpack(args))
end)
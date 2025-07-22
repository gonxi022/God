repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Estado
local noclipEnabled = false
local blockRemote = false

-- Hook del remote
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if blockRemote and tostring(self) == "FriendMain" and method == "FireServer" then
        warn("🔒 Remote 'FriendMain' bloqueado")
        return nil
    end

    return oldNamecall(self, unpack(args))
end)

-- Noclip activo
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "BrainrotBypass"
gui.ResetOnSpawn = false

-- Botón: Noclip
local btnNoclip = Instance.new("TextButton", gui)
btnNoclip.Size = UDim2.new(0, 200, 0, 50)
btnNoclip.Position = UDim2.new(0, 20, 0, 60)
btnNoclip.Text = "🚶‍♂️ Noclip: OFF"
btnNoclip.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
btnNoclip.TextColor3 = Color3.new(1, 1, 1)
btnNoclip.Font = Enum.Font.SourceSansBold
btnNoclip.TextSize = 18

btnNoclip.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    btnNoclip.Text = noclipEnabled and "🚶‍♂️ Noclip: ON" or "🚶‍♂️ Noclip: OFF"
end)

-- Botón: Block Remote
local btnBlock = Instance.new("TextButton", gui)
btnBlock.Size = UDim2.new(0, 200, 0, 50)
btnBlock.Position = UDim2.new(0, 20, 0, 120)
btnBlock.Text = "🔒 Block FriendMain: OFF"
btnBlock.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btnBlock.TextColor3 = Color3.new(1, 1, 1)
btnBlock.Font = Enum.Font.SourceSansBold
btnBlock.TextSize = 18

btnBlock.MouseButton1Click:Connect(function()
    blockRemote = not blockRemote
    btnBlock.Text = blockRemote and "🔒 Block FriendMain: ON" or "🔒 Block FriendMain: OFF"
end)
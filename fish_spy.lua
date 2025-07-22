repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Noclip estado
local noclip = false

-- 📦 GUI setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "NoclipSpyGUI"
gui.ResetOnSpawn = false

-- 🔘 Botón Noclip
local noclipBtn = Instance.new("TextButton", gui)
noclipBtn.Size = UDim2.new(0, 200, 0, 50)
noclipBtn.Position = UDim2.new(0, 20, 0, 60)
noclipBtn.Text = "🚶‍♂️ Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 18

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "🚶‍♂️ Noclip: ON" or "🚶‍♂️ Noclip: OFF"
end)

-- 🧱 Noclip loop
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 🛰️ REMOTE SPY INTEGRADO (Auto-Activado)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" then
        print("====== 🔍 REMOTE SPY ======")
        print("📦 Remote:", self:GetFullName())
        print("⚙️ Method:", method)
        for i, v in ipairs(args) do
            print("Arg["..i.."]: ", v)
        end
        print("===========================")
    end

    return old(self, unpack(args))
end)
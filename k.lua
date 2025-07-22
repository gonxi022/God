-- 📌 Botones flotantes + Kill All reales + Remington
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- 🧱 Crear GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local function createButton(name, posY, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 180, 0, 40)
	button.Position = UDim2.new(0, 10, 0, posY)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderSizePixel = 0
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Text = name
	button.Parent = ScreenGui
	button.MouseButton1Click:Connect(callback)
end

-- 🔫 Botón para obtener Remington 870
createButton("🔫 Obtener Remington", 20, function()
	local toolName = "Remington 870"
	local prisonGuns = Workspace:FindFirstChild("Prison_ITEMS") and Workspace.Prison_ITEMS:FindFirstChild("giver")
	if prisonGuns then
		for _, item in pairs(prisonGuns:GetChildren()) do
			if item.Name == toolName then
				LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame + Vector3.new(0, 3, 0)
				wait(0.5)
			end
		end
	end
end)

-- 💀 Kill All Método 1: BreakJoints directo
createButton("💀 Kill All 1", 70, function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			plr.Character:BreakJoints()
		end
	end
end)

-- 💀 Kill All Método 2: Setear Health a 0
createButton("💀 Kill All 2", 120, function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
			plr.Character.Humanoid.Health = 0
		end
	end
end)

-- 💀 Kill All Método 3: Loop rápido de daños
createButton("💀 Kill All 3", 170, function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
			spawn(function()
				for i = 1, 10 do
					plr.Character.Humanoid.Health = 0
					wait(0.1)
				end
			end)
		end
	end
end)
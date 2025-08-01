-- Blade Ball Auto Parry - Android KRNL
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")

-- Buscar Remote de parry
local remote = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("ParryButtonPress")

-- Crear GUI flotante
local gui = Instance.new("ScreenGui")
gui.Name = "AutoParryGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 200)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextScaled = true
btn.Text = "Auto Parry: OFF"
btn.Parent = gui
btn.Active = true
btn.Draggable = true
btn.BorderSizePixel = 2
btn.BorderColor3 = Color3.new(1,1,1)

local parryOn = false
local connection = nil

-- Detectar pelota
local function getBall()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
			return obj
		end
	end
end

-- Activar auto parry
local function startParry()
	if connection then connection:Disconnect() end
	connection = RunService.Heartbeat:Connect(function()
		local ball = getBall()
		if ball and (ball.Position - hrp.Position).Magnitude < 25 then
			remote:FireServer()
		end
	end)
end

-- Detener
local function stopParry()
	if connection then connection:Disconnect() end
end

-- Botón
local function toggle()
	parryOn = not parryOn
	if parryOn then
		btn.Text = "Auto Parry: ON"
		startParry()
	else
		btn.Text = "Auto Parry: OFF"
		stopParry()
	end
end

btn.MouseButton1Click:Connect(toggle)
if UserInputService.TouchEnabled then
	btn.TouchTap:Connect(toggle)
end
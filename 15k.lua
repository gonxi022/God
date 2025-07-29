-- Prison Life Exploit - FULL MENU (Android)
-- Gonxi + GPT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
local damageEvent = ReplicatedStorage:FindFirstChild("DamageEvent")

-- GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 180, 0, 230)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local toggle = Instance.new("TextButton", mainFrame)
toggle.Size = UDim2.new(1, 0, 0, 30)
toggle.Position = UDim2.new(0, 0, 0, 0)
toggle.Text = "⏬ Minimizar"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextScaled = true

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1

toggle.MouseButton1Click:Connect(function()
	content.Visible = not content.Visible
	toggle.Text = content.Visible and "⏬ Minimizar" or "⏫ Maximizar"
end)

-- Botón constructor
local function crearBoton(texto, orden, callback)
	local boton = Instance.new("TextButton", content)
	boton.Size = UDim2.new(1, -10, 0, 35)
	boton.Position = UDim2.new(0, 5, 0, orden * 40)
	boton.Text = texto
	boton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	boton.TextColor3 = Color3.new(1, 1, 1)
	boton.TextScaled = true
	boton.MouseButton1Click:Connect(callback)
	return boton
end

-- KILL ALL FUNCIONAL
local killOn = true

local function killLoop()
	while true do
		if killOn then
			local myPos = Root.Position
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local target = p.Character.HumanoidRootPart
					if (target.Position - myPos).Magnitude <= 70 then -- distancia máxima realista sin teleporte
						for i = 1, 49 do
							meleeEvent:FireServer(p)
							damageEvent:FireServer(p)
						end
					end
				end
			end
		end
		wait(0.5)
	end
end

spawn(killLoop)

-- GOD MODE
local godOn = false

local function godLoop()
	while true do
		if godOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
			hum.Health = math.huge
			hum.MaxHealth = math.huge
		end
		wait(0.1)
	end
end

spawn(godLoop)

-- SPEED
local speedVal = 70

local function activarSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
	end
end

-- NOCLIP SOLO PAREDES
local function noclipLoop()
	RunService.Stepped:Connect(function()
		if LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					if part.Name ~= "HumanoidRootPart" and part.Position.Y > Root.Position.Y - 3 then
						part.CanCollide = false
					end
				end
			end
		end
	end)
end

noclipLoop()

-- Reconexión automática tras muerte
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	Root = char:WaitForChild("HumanoidRootPart")
	wait(1)
	activarSpeed()
end)

-- BOTONES
crearBoton("⚔️ Kill All (ON/OFF)", 0, function()
	killOn = not killOn
end)

crearBoton("🛡️ God Mode (ON/OFF)", 1, function()
	godOn = not godOn
end)

crearBoton("💨 Speed x70", 2, function()
	activarSpeed()
end)
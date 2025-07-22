repeat wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Buscar el evento de disparo
local shootEvent = replicated:FindFirstChild("ShootEvent")

-- Crear GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "AutoKillGUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 0, 120)
button.Text = "🔫 Auto Shoot All"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20

-- Comprobación
if not shootEvent then
	button.Text = "❌ 'ShootEvent' no encontrado"
	button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	return
end

-- Función para disparar a todos
local function shootAll()
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
            for i = 1, 5 do
                shootEvent:FireServer({
                    ["Hit"] = target.Character.Head,
                    ["Position"] = target.Character.Head.Position,
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 100,
                    ["CFrame"] = CFrame.new(),
                    ["Name"] = "M9",  -- Simula pistola
                    ["Target"] = target.Character.Head
                })
                wait(0.1)
            end
        end
    end
end

button.MouseButton1Click:Connect(shootAll)
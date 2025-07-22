repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Esperar a que el Remote esté disponible
local remoteFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE")
local brainrotRemote = remoteFolder:FindFirstChild("39c0ed9f-4f2c-89c8-b7a9b2d44d2e")

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.Name = "BrainrotStealer"

local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(0, 200, 0, 50)
stealButton.Position = UDim2.new(0, 20, 0, 60)
stealButton.Text = "🧠 Robar Brainrot"
stealButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stealButton.TextColor3 = Color3.new(1, 1, 1)
stealButton.Font = Enum.Font.SourceSansBold
stealButton.TextSize = 20
stealButton.Parent = gui

-- Valores capturados previamente desde la consola
local arg1 = 175315816.47994 -- puede ser timestamp
local arg2 = "e8ecef56-8247-419b-8909-383adc32f434" -- UID jugador
local arg3 = "455822cf-9800-4bac-bd58-e7b922f15243" -- ID del Brainrot
local arg4 = 1 -- estado

-- Acción al hacer clic
stealButton.MouseButton1Click:Connect(function()
    if brainrotRemote then
        brainrotRemote:FireServer(arg1, arg2, arg3, arg4)
        warn("✅ Intento de robo de Brainrot enviado.")
    else
        warn("❌ Remote no encontrado.")
    end
end)
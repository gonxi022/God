--[[
  Murder Mystery 2 Pro Mod Menu
  - ESP con colores por rol
  - Fly funcional
  - Noclip funcional
  - Menú táctil minimalista para activar/desactivar
  Compatible KRNL Android
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local mouse = LocalPlayer:GetMouse()

-- Variables de control
local noclipEnabled = false
local flyEnabled = false
local espEnabled = false

-- Velocidad del fly
local flySpeed = 50

-- Tabla para guardar las cajas ESP
local espBoxes = {}

-- Función para crear caja ESP para un jugador
local function createESP(player)
    if espBoxes[player] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Color3 = Color3.new(0,1,0) -- Default verde
    box.Parent = Camera
    espBoxes[player] = box
end

-- Función para actualizar color según rol
local function updateESP(player)
    local box = espBoxes[player]
    if not box then return end
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        box.Adornee = character:FindFirstChild("HumanoidRootPart")
        box.Size = Vector3.new(4, 6, 1)
        box.Transparency = 0.5
        local role = nil

        -- Intentar detectar rol:
        -- MM2 usa un StringValue en player:FindFirstChild("Role") o en PlayerGui
        -- Vamos a buscar en PlayerGui
        local gui = player:FindFirstChildOfClass("PlayerGui")
        if gui then
            local roleGui = gui:FindFirstChild("Role")
            if roleGui and roleGui:IsA("TextLabel") then
                role = roleGui.Text
            end
        end

        -- Como respaldo, algunos servidores usan un BoolValue o StringValue en player
        if not role then
            local roleVal = player:FindFirstChild("Role") or player:FindFirstChild("role")
            if roleVal and roleVal:IsA("StringValue") then
                role = roleVal.Value
            end
        end

        -- Definir color segun rol
        if role then
            local r = role:lower()
            if r == "murderer" or r == "assassin" or r == "asesino" then
                box.Color3 = Color3.new(1,0,0) -- rojo
            elseif r == "sheriff" then
                box.Color3 = Color3.new(0,0,1) -- azul para sheriff
            else
                box.Color3 = Color3.new(0,1,0) -- verde inocentes
            end
        else
            box.Color3 = Color3.new(0,1,0) -- verde si no detecta rol
        end
    else
        box.Adornee = nil
    end
end

-- Actualizar ESP para todos los jugadores
local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
            updateESP(player)
        end
    end
end

-- Limpiar ESP cuando se desactiva
local function clearESP()
    for player, box in pairs(espBoxes) do
        box:Destroy()
        espBoxes[player] = nil
    end
end

-- Noclip implementacion
local function noclipOn()
    RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Fly implementacion
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function startFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = LocalPlayer.Character.HumanoidRootPart

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Parent = root

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root

    -- Control fly
    RunService:BindToRenderStep("FlyControl", 301, function()
        if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local camCF = workspace.CurrentCamera.CFrame
            local moveDirection = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0,1,0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end

            flyBodyVelocity.Velocity = moveDirection
            flyBodyGyro.CFrame = camCF
        else
            flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    RunService:UnbindFromRenderStep("FlyControl")
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
end

-- Crear menú táctil simple
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0, 130, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.Parent = ScreenGui

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Botones del menú
local espButton = createButton("ESP: OFF", UDim2.new(0, 20, 0, 20), function()
    espEnabled = not espEnabled
    if espEnabled then
        espButton.Text = "ESP: ON"
        updateAllESP()
        RunService.Heartbeat:Connect(function()
            if espEnabled then
                updateAllESP()
            end
        end)
    else
        espButton.Text = "ESP: OFF"
        clearESP()
    end
end)

local noclipButton = createButton("Noclip: OFF", UDim2.new(0, 20, 0, 70), function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipButton.Text = "Noclip: ON"
        noclipOn()
    else
        noclipButton.Text = "Noclip: OFF"
    end
end)

local flyButton = createButton("Fly: OFF", UDim2.new(0, 20, 0, 120), function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly: ON"
        startFly()
    else
        flyButton.Text = "Fly: OFF"
        stopFly()
    end
end)

-- Auto limpiado al morir para que no quede bug
LocalPlayer.CharacterRemoving:Connect(function()
    clearESP()
    stopFly()
    noclipEnabled = false
    espEnabled = false
    flyEnabled = false
    espButton.Text = "ESP: OFF"
    noclipButton.Text = "Noclip: OFF"
    flyButton.Text = "Fly: OFF"
end)

print("MM2 Mod Menu cargado - usa el menú táctil para activar funciones.")
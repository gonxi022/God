local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Borrar menú previo si existe
pcall(function() CoreGui:WaitForChild("PLModMenu"):Destroy() end)

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PLModMenu"
ScreenGui.ResetOnSpawn = false

local function createButton(text, position, callback)
    local frame = Instance.new("Frame", ScreenGui)
    frame.Size = UDim2.new(0, 180, 0, 45)
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    local uic = Instance.new("UICorner", frame)
    uic.CornerRadius = UDim.new(0, 8)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    local btnuic = Instance.new("UICorner", btn)
    btnuic.CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(callback)
end

-- FUNCION: Dar Remington
local function giveRemington()
    local giveGunEvent = ReplicatedStorage:FindFirstChild("GiveGun") or ReplicatedStorage:FindFirstChild("GiveGunEvent")
    if giveGunEvent and giveGunEvent:IsA("RemoteEvent") then
        -- Enviar el nombre exacto del arma, comúnmente "Remington"
        giveGunEvent:FireServer("Remington")
        print("[Info] Remington solicitada.")
    else
        warn("No se encontró evento GiveGun.")
    end
end

-- FUNCION: Kill All - Disparos simulados
local function killAllShoot()
    local shootEvent = ReplicatedStorage:FindFirstChild("ShootEvent")
    if not shootEvent then
        warn("No se encontró ShootEvent")
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            -- FireServer con argumentos típicos de disparo (puede variar)
            shootEvent:FireServer(head.Position, Vector3.new(0,0,0), true, false)
        end
    end
    print("[Info] Kill All con disparos simulados ejecutado.")
end

-- FUNCION: Kill All - Teleport y golpe (ataque melee)
local function killAllTPHit()
    local originalPos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not (LocalPlayer.Character and humanoid) then
        warn("Personaje no cargado")
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Teletransportar cerca
            LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            -- Ejecutar animación o ataque simple
            humanoid:LoadAnimation(LocalPlayer.Character:FindFirstChildOfClass("Animation") or Instance.new("Animation")):Play()
            wait(0.3)
        end
    end

    -- Volver a posición original
    if originalPos then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPos)
    end

    print("[Info] Kill All con Teleport + Golpe ejecutado.")
end

-- FUNCION: Kill All - BreakJoints simple
local function killAllBreakJoints()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            plr.Character:BreakJoints()
        end
    end
    print("[Info] Kill All con BreakJoints ejecutado.")
end

-- Crear botones
createButton("🎯 Dar Remington", UDim2.new(0, 10, 0, 50), giveRemington)
createButton("🔫 Kill All Disparos", UDim2.new(0, 10, 0, 110), killAllShoot)
createButton("🚶‍♂️ Kill All Teleport + Hit", UDim2.new(0, 10, 0, 170), killAllTPHit)
createButton("💥 Kill All BreakJoints", UDim2.new(0, 10, 0, 230), killAllBreakJoints)

-- STEAL A FISH - CLONADOR/SPAWNEADOR VISUAL DE PECES
-- KRNL Android | Sin errores visuales | Auto-listado de peces

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Detectar carpeta de peces
local fishFolder = nil
for _, obj in pairs(Workspace:GetChildren()) do
    if obj:IsA("Folder") and obj.Name:lower():find("fish") then
        fishFolder = obj
        break
    end
end

if not fishFolder then
    warn("❌ No se encontró la carpeta de peces.")
    return
end

-- Crear UI flotante
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "FishSpawner"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0, 15, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "🐠 Fish Spawner"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

-- Dropdown con nombres de peces encontrados
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.TextScaled = true
dropdown.Text = "Seleccionar pez"

local selectedFish = nil

local listFrame = Instance.new("Frame", frame)
listFrame.Size = UDim2.new(1, -20, 0, 140)
listFrame.Position = UDim2.new(0, 10, 0, 80)
listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
listFrame.Visible = false
listFrame.ClipsDescendants = true

-- Scroll
local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.SortOrder = Enum.SortOrder.Name

-- Agregar peces reales detectados a la lista
local fishNames = {}
for _, fish in pairs(fishFolder:GetChildren()) do
    if fish:IsA("Model") or fish:IsA("Part") then
        if not table.find(fishNames, fish.Name) then
            table.insert(fishNames, fish.Name)
        end
    end
end

for i, fishName in ipairs(fishNames) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -6, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = fishName
    btn.TextScaled = true

    btn.MouseButton1Click:Connect(function()
        selectedFish = fishName
        dropdown.Text = "✅ " .. fishName
        listFrame.Visible = false
    end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, #fishNames * 25)

dropdown.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
end)

-- Botón para clonar 1 pez visualmente
local clone1 = Instance.new("TextButton", frame)
clone1.Size = UDim2.new(1, -20, 0, 30)
clone1.Position = UDim2.new(0, 10, 0, 230)
clone1.BackgroundColor3 = Color3.fromRGB(30, 90, 30)
clone1.TextColor3 = Color3.new(1, 1, 1)
clone1.Text = "🧬 Clonar 1 pez"
clone1.TextScaled = true

-- Botón para spawnear 10 clones
local clone10 = Instance.new("TextButton", frame)
clone10.Size = UDim2.new(1, -20, 0, 30)
clone10.Position = UDim2.new(0, 10, 0, 270)
clone10.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
clone10.TextColor3 = Color3.new(1, 1, 1)
clone10.Text = "🌊 Spawnear 10"
clone10.TextScaled = true

-- Función de clonación
local function spawnFish(amount)
    if not selectedFish then return end

    local base = nil
    for _, obj in pairs(fishFolder:GetChildren()) do
        if obj.Name == selectedFish then
            base = obj
            break
        end
    end

    if base then
        for i = 1, amount do
            local fake = base:Clone()
            fake.Parent = workspace
            local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
            if fake:IsA("Model") and fake:FindFirstChild("PrimaryPart") then
                fake:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame + offset)
            elseif fake:IsA("BasePart") then
                fake.Position = LocalPlayer.Character.PrimaryPart.Position + offset
            end
        end
    end
end

clone1.MouseButton1Click:Connect(function()
    spawnFish(1)
end)

clone10.MouseButton1Click:Connect(function()
    spawnFish(10)
end)
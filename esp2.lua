--Mod Menu
local Players = game:GetService("Players")
local modMenu = Instance.new("ScreenGui")
local botonEsp = Instance.new("TextButton")
local botonNoclip = Instance.new("TextButton")
local botonSpeed = Instance.new("TextButton")
local localPlayer = Players.LocalPlayer


--Propiedades
modMenu.Name = "ModMenu"
modMenu.ResetOnSpawn = false
modMenu.Parent = localPlayer:WaitForChild("PlayerGui")

--Boton ESP
botonEsp.Name = "ESP"
botonEsp.Size = UDim2.new(0, 100, 0, 30)
botonEsp.Position = UDim2.new(0, 20, 0, 120)
botonEsp.Text = "ESP Off"
botonEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
botonEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
botonEsp.Font = Enum.Font.SourceSans
botonEsp.TextSize = 16
botonEsp.Parent = modMenu

--Boton NoClip

botonNoclip.Name = "NoClip"
botonNoclip.Size = UDim2.new(0, 100, 0, 30) 
botonNoclip.Position = UDim2.new(0, 20, 0, 160)
botonNoclip.Text = "NoClip OFF"
botonNoclip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
botonNoclip.TextColor3 = Color3.fromRGB(255, 255, 255)
botonNoclip.Font = Enum.Font.SourceSans
botonNoclip.TextSize = 16
botonNoclip.Parent = modMenu

--Boton Speed 

botonSpeed.Name = "Speed"
botonSpeed.Size = UDim2.new(0, 100, 0, 30)
botonSpeed.Position = UDim2.new(0, 20, 0, 200)
botonSpeed.Text = "Speed OFF"
botonSpeed.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
botonSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
botonSpeed.Font = Enum.Font.SourceSans
botonSpeed.TextSize = 16
botonSpeed.Parent = modMenu

--  Funciones


local espEnabled = false
local espGuiFolder = Instance.new("Folder")
espGuiFolder.Parent = modMenu

local function createESPForPlayer(targetPlayer)
  if targetPlayer ~= localPlayer
  and targetPlayer.Character:FindFirstChild("Head") then
    if not
    espGuiFolder:FindFirstChild(targetPlayer.Name) then
      local billboard = Instance.new("BillboardGui")
      billboard.Name = targetPlayer.Name
      billboard.Size = UDim2.new(0, 100, 0, 40)
      billboard.Adornee = targetPlayer.Character.Head
      billboard.AlwaysOnTop = true
      billboard.StudsOffset = Vector3.new(0, 2, 0)
      billboard.Parent = espGuiFolder
      
      local nameLabel = Instance.new("TextLabel")
      nameLabel.Size = UDim2.new(1, 0, 1, 0)
      nameLabel.BackgroundTransparency = 1
      nameLabel.TextColor3 = Color3.new(1, 0, 0)
      nameLabel.Text = targetPlayer.Name
      nameLabel.TextScaled = true
      nameLabel.Font = Enum.Font.SourceSansBold
      nameLabel.Parent = billboard
    end
  end
end

local function toggleESP()
  espEnabled = not espEnabled
  botonEsp.Text = espEnabled and 
  "ESP On" or "ESP Off"
  
  if espEnabled then
    for _, plr in 
    pairs(Players:GetPlayers()) do
      createESPForPlayer(plr)
    end
  else
      for _, gui in
      pairs(espGuiFolder:GetChildren()) do
        gui:Destroy()
      end
  end
end
  
  botonEsp.MouseButton1Click:Connect(toggleESP)
  
  Players.PlayerAdded:Connect(function(plr)
    
    plr.CharacterAdded:Connect(function()
      if espEnabled then
        wait(1)
        createESPForPlayer(plr)
      end
    end)
  end)
local gui = Instance.new("ScreenGui")
gui.Name = "NoclipGui"
gui.ResetOnSpawn = false 
gui.Parent = game.Players.LocalPlayer.WaitForChild("PlayerGui")

local boton = Instance.new("TextButton")
boton.Parent = gui 
boton.Size = UDim2.new(0, 150, 0, 50)
boton.Position = UDim2.new(0, 20, 0, 100)
boton.Text = "Activar Noclip"
boton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
boton.TextColor3 = Color3.new(1, 1, 1)
boton.Font = Enum.Font.SourceSans
boton.TextSize = 18

local noclipActivo = false
local RunService = game:GetService("RunService")
local conexionNoclip

boton.MouseButton1Click:Connect(function()
  local player = game.Players.LocalPlayer
  local character = player.Character or player.CharacterAdded:Wait()
  if not character then return end 
  
  noclipActivo = not noclipActivo
  if noclipActivo then 
    boton.Text = "Desactivar Noclip"
    conexionNoclip = RunService.Stepped:Connect(function()
      for _, part in
      pairs(character:GetDescendants()) do if part:IsA("BasePart") then  part.CanCollide = false 
      end 
      end 
    end)
    else
      boton.Text = "Activar Noclip"
      if conexionNoclip then 
        conexionNoclip:Disconnect()
        conexionNoclip = nil
      end
      
      for _, part in pairs(character:GetDescendants()) do 
          if part:IsA("BasePart") then part.CanCollide = true 
          end
      end
        
  end
end)
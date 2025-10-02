--[[ 
Script: Hover con botón GUI
Activa = sube y flota, con movimiento
Desactiva = vuelve al suelo
]]

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local enabled = false
local connection

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoverGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 50)
toggleButton.Position = UDim2.new(0.5, -80, 0.9, -25)
toggleButton.Text = "Activar Hover"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

-- Activar / Desactivar Hover
local function toggleHover()
	enabled = not enabled
	
	if enabled then
		toggleButton.Text = "Desactivar Hover"
		-- Hacemos que el player flote
		connection = RunService.RenderStepped:Connect(function()
			if enabled and humanoidRootPart then
				-- fuerza de flotación
				humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 4, humanoidRootPart.Velocity.Z)
			end
		end)
	else
		toggleButton.Text = "Activar Hover"
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

toggleButton.MouseButton1Click:Connect(toggleHover)

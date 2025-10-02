--[[ 
Script: Hover / Super Jump con Panel
Autor: Fundador JonhScripts
Incluye GUI con círculo y opción de activar/desactivar elevador
]]

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

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

-- Panel principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.7, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Fundador JonhScripts"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Botón círculo
local circleButton = Instance.new("TextButton")
circleButton.Size = UDim2.new(0, 60, 0, 60)
circleButton.Position = UDim2.new(0.5, -30, 0.5, -30)
circleButton.Text = "⚪"
circleButton.TextSize = 30
circleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
circleButton.TextColor3 = Color3.new(0,0,0)
circleButton.Font = Enum.Font.SourceSansBold
circleButton.Parent = frame

-- Opción escondida
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0.5, -80, 1, -45)
toggleButton.Text = "Activar Elevador"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Visible = false
toggleButton.Parent = frame

-- Mostrar / ocultar opción al presionar círculo
circleButton.MouseButton1Click:Connect(function()
	toggleButton.Visible = not toggleButton.Visible
end)

-- Función Hover con Super Jump
local function toggleHover()
	enabled = not enabled
	if enabled then
		toggleButton.Text = "Desactivar Elevador"
		
		-- Conexión que da flotación y mejor salto
		connection = RunService.RenderStepped:Connect(function()
			if enabled and humanoidRootPart then
				-- Ligera fuerza hacia arriba para flotar
				humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 5, humanoidRootPart.Velocity.Z)
			end
		end)

		-- Potenciar salto sin exagerar
		humanoid.Jumping:Connect(function()
			if enabled then
				humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, 35, 0)
			end
		end)

	else
		toggleButton.Text = "Activar Elevador"
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

toggleButton.MouseButton1Click:Connect(toggleHover)

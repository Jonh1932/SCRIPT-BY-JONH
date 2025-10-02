--[[ 
Fundador JonhScripts
Panel + Círculo Mágico Movible + Elevador Mejorado
]]

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local enabled = false
local connection

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ElevadorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Círculo inicial
local circleButton = Instance.new("TextButton")
circleButton.Size = UDim2.new(0, 70, 0, 70)
circleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
circleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100) -- verde
circleButton.Text = ""
circleButton.AutoButtonColor = true
circleButton.Parent = screenGui
circleButton.Active = true
circleButton.Draggable = true

-- Redondear círculo
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0) -- círculo perfecto
circleCorner.Parent = circleButton

-- Panel oculto
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 250, 0, 150)
panel.Position = UDim2.new(0.4, 0, 0.4, 0)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.Parent = screenGui

-- Bordes redondeados
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 20)
panelCorner.Parent = panel

-- Gradiente rainbow animado
local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 0, 255))
}
gradient.Parent = panel

-- Animación del gradiente (loop)
task.spawn(function()
	while true do
		for i = 0, 1, 0.01 do
			gradient.Offset = Vector2.new(i, i)
			task.wait(0.05)
		end
	end
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Fundador JonhScripts"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = panel

-- Botón de activación
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 50)
toggleButton.Position = UDim2.new(0.5, -90, 0.6, -25)
toggleButton.Text = "Activar Elevador"
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = panel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- Mostrar/Ocultar panel al hacer clic en el círculo
circleButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

-- Función Hover/Jump
local function toggleHover()
	enabled = not enabled
	if enabled then
		toggleButton.Text = "Desactivar Elevador"
		-- Mantener flotando
		connection = RunService.RenderStepped:Connect(function()
			if enabled and humanoidRootPart then
				humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 6, humanoidRootPart.Velocity.Z)
			end
		end)
		-- Super salto
		humanoid.Jumping:Connect(function()
			if enabled then
				humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, 40, 0)
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

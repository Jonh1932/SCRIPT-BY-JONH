--[[ 
Fundador JonhScripts
Círculo Movible + Panel Rainbow + Elevador Potente + ESP Players
]]

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local elevadorEnabled = false
local espEnabled = false
local elevadorConnection
local jumpConnection

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ElevadorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Círculo movible
local circleButton = Instance.new("TextButton")
circleButton.Size = UDim2.new(0, 70, 0, 70)
circleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
circleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100) -- verde
circleButton.Text = ""
circleButton.AutoButtonColor = true
circleButton.Parent = screenGui
circleButton.Active = true
circleButton.Draggable = true

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circleButton

-- Panel oculto
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 260, 0, 200)
panel.Position = UDim2.new(0.4, 0, 0.4, 0)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.Parent = screenGui

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

-- Botón elevador
local elevadorButton = Instance.new("TextButton")
elevadorButton.Size = UDim2.new(0, 180, 0, 40)
elevadorButton.Position = UDim2.new(0.5, -90, 0.4, -20)
elevadorButton.Text = "Activar Elevador"
elevadorButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
elevadorButton.TextColor3 = Color3.new(1,1,1)
elevadorButton.Font = Enum.Font.GothamBold
elevadorButton.TextSize = 20
elevadorButton.Parent = panel

local elevadorCorner = Instance.new("UICorner")
elevadorCorner.CornerRadius = UDim.new(0, 15)
elevadorCorner.Parent = elevadorButton

-- Botón ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 180, 0, 40)
espButton.Position = UDim2.new(0.5, -90, 0.75, -20)
espButton.Text = "Activar ESP"
espButton.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 20
espButton.Parent = panel

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 15)
espCorner.Parent = espButton

-- Mostrar/Ocultar panel al hacer clic en el círculo
circleButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

-- Función Elevador
local function toggleElevador()
	elevadorEnabled = not elevadorEnabled
	if elevadorEnabled then
		elevadorButton.Text = "Desactivar Elevador"
		elevadorConnection = RunService.RenderStepped:Connect(function()
			if elevadorEnabled and humanoidRootPart then
				humanoidRootPart.Velocity = Vector3.new(
					humanoidRootPart.Velocity.X,
					18,
					humanoidRootPart.Velocity.Z
				)
			end
		end)
		jumpConnection = humanoid.Jumping:Connect(function()
			if elevadorEnabled then
				humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, 60, 0)
			end
		end)
	else
		elevadorButton.Text = "Activar Elevador"
		if elevadorConnection then elevadorConnection:Disconnect() end
		if jumpConnection then jumpConnection:Disconnect() end
	end
end
elevadorButton.MouseButton1Click:Connect(toggleElevador)

-- ESP simple (Highlight)
local function applyESP(char)
	if not char:FindFirstChild("HumanoidRootPart") then return end
	if not char:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillTransparency = 1
		highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
		highlight.OutlineTransparency = 0
		highlight.Parent = char
	end
end

local function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		espButton.Text = "Desactivar ESP"
		-- aplicar a todos los jugadores
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				applyESP(plr.Character)
			end
		end
		-- aplicar a futuros jugadores
		Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function(char)
				if espEnabled then
					applyESP(char)
				end
			end)
		end)
	else
		espButton.Text = "Activar ESP"
		-- quitar highlight
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChild("Highlight") then
				plr.Character.Highlight:Destroy()
			end
		end
	end
end
espButton.MouseButton1Click:Connect(toggleESP)

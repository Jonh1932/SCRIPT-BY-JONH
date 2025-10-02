--[[ 
Script completo: Crea GUI + Part en las piernas
Activa/desactiva con un botón
]]

-- Servicios
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local liftingPart = nil
local enabled = false

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LiftGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.9, -25)
toggleButton.Text = "Activar Elevación"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

-- Función para crear el Part
local function createLiftPart()
	if liftingPart then liftingPart:Destroy() end
	liftingPart = Instance.new("Part")
	liftingPart.Size = Vector3.new(5, 2, 5)
	liftingPart.Anchored = true
	liftingPart.CanCollide = false
	liftingPart.Transparency = 1 -- invisible
	liftingPart.Parent = workspace
end

-- Función para activar/desactivar
local function toggleLift()
	enabled = not enabled
	if enabled then
		toggleButton.Text = "Desactivar Elevación"
		createLiftPart()
		-- Elevar suavemente
		game:GetService("RunService").RenderStepped:Connect(function()
			if enabled and liftingPart and humanoidRootPart then
				-- Mantener el part debajo del jugador
				liftingPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0)
				-- Mover jugador arriba suavemente
				humanoidRootPart.Velocity = Vector3.new(0, 5, 0) -- leve empuje
			end
		end)
	else
		toggleButton.Text = "Activar Elevación"
		if liftingPart then
			liftingPart:Destroy()
			liftingPart = nil
		end
	end
end

toggleButton.MouseButton1Click:Connect(toggleLift)

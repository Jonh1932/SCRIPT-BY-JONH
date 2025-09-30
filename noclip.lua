-- Script: Noclip, Velocidad e Invisibilidad (OP)
-- UBICACIÓN CORRECTA: LocalScript DENTRO de StarterGui

-- Servicios (ESTO SIEMPRE VA DE PRIMERAS)
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===================================================
-- 1. INSTANCIAS Y PROPIEDADES DE LA GUI (AHORA DE PRIMERAS)
-- ===================================================

-- 1A. Creación de las instancias
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

-- 1B. Configuración de la GUI (Propiedades y Parentesco)
-- Le da el padre al ScreenGui
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0)
TextButton.BackgroundTransparency = 0.500
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
-- POSICIÓN: Ajustada a 0.85 para situarse por encima del chat.
TextButton.Position = UDim2.new(0.024, 0, 0.85, 0) 
TextButton.Size = UDim2.new(0, 151, 0, 44)
TextButton.Font = Enum.Font.Bangers
TextButton.Text = "NOCLIP/SPEED"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 18.000 

UICorner.Parent = TextButton

TextLabel.Parent = TextButton
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-0.132450327, 0, -0.681818187, 0)
TextLabel.Size = UDim2.new(0, 190, 0, 30)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "OFFLINE" 
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 18.000

-- ===================================================
-- 2. VARIABLES Y FUNCIONALIDAD (AHORA DESPUÉS DE LA GUI)
-- ===================================================

-- Variables de Estado y Configuración
local isEnabled = false
local defaultWalkSpeed = 16 
local boostedWalkSpeed = 70 
local maxTransparency = 1.0 

local persistentLoop = nil 

-- Función para obtener el personaje y sus partes
local function getCharacterParts()
	local char = Player.Character
	-- Usamos Player.CharacterAdded:Wait() para esperar que el personaje exista.
	while not char or not char.Parent do
		char = Player.CharacterAdded:Wait()
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	return char, humanoid
end

-- Función para aplicar las modificaciones (Noclip, Invisibilidad)
local function setCharacterProperties(char, humanoid, transparency, canCollide, walkSpeed)
	if not char or not humanoid then return end

	-- Velocidad (Humanoid)
	humanoid.WalkSpeed = walkSpeed

	-- Noclip e Invisibilidad (Partes y Accesorios)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.CanCollide = canCollide
			part.LocalTransparencyModifier = transparency
		elseif part:IsA("Accessory") then
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("BasePart") then
					child.LocalTransparencyModifier = transparency
				end
			end
		end
	end
end

local function startModifications()
	isEnabled = true
	local Character, Humanoid = getCharacterParts()

	-- Iniciar Bucle Persistente (Contrarresta la corrección del servidor)
	persistentLoop = RunService.Heartbeat:Connect(function()
		-- Re-aplicar Noclip, Velocidad e Invisibilidad
		setCharacterProperties(Character, Humanoid, maxTransparency, false, boostedWalkSpeed)
	end)

	-- Actualizar la GUI
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Verde
	TextButton.Text = "ACTIVADO (OP)"
	TextLabel.Text = "INVISIBLE & RAPIDO"
end

local function stopModifications()
	isEnabled = false
	local Character, Humanoid = getCharacterParts()

	-- Detener el Bucle Persistente
	if persistentLoop then
		persistentLoop:Disconnect()
		persistentLoop = nil
	end

	-- Restablecer las propiedades del personaje
	setCharacterProperties(Character, Humanoid, 0, true, defaultWalkSpeed)

	-- Actualizar la GUI
	TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0) -- Rojo original
	TextButton.Text = "NOCLIP/SPEED"
	TextLabel.Text = "OFFLINE"
end

-- Conecta la función de alternancia (Toggle) al clic del botón
TextButton.MouseButton1Click:Connect(function()
	if isEnabled then
		stopModifications()
	else
		startModifications()
	end
end)

-- Manejar la reaparición del personaje (CharacterAdded)
Player.CharacterAdded:Connect(function(newCharacter)
	-- Si estaba activado, detenemos y reiniciamos para que el bucle se conecte al nuevo personaje.
	if isEnabled then
		stopModifications() 
		startModifications() 
	end
end)

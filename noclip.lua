-- Script: Noclip, Velocidad Aumentada e Invisibilidad (Toggle)
-- DEBE ser un SOLO LocalScript ubicado en StarterGui o StarterPlayerScripts.

-- Servicios
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Variables de Estado y Configuración
local isEnabled = false
local defaultWalkSpeed = 16 
local boostedWalkSpeed = 50 -- Velocidad aumentada
local maxTransparency = 0.85 -- Nivel de invisibilidad (1.0 es totalmente invisible)

-- 1. INSTANCIAS: Creación de la GUI
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

-- 2. PROPIEDADES: Configuración de la GUI
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0)
TextButton.BackgroundTransparency = 0.500
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0243478268, 0, 0.443152457, 0)
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

-- 3. FUNCIONALIDAD: Lógica de Noclip, Velocidad e Invisibilidad

-- Función para obtener el personaje y sus partes
local function getCharacterParts()
	-- Espera por el personaje actual o el nuevo si ya se ha añadido
	local char = Player.Character
	while not char or not char.Parent do
		char = Player.CharacterAdded:Wait()
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	return char, humanoid
end

local function applyModifications(char, humanoid, enable)
	if not char or not humanoid then return end 

	local targetTransparency = enable and maxTransparency or 0
	local targetCanCollide = not enable -- false para noclip, true para normal

	-- 1. Noclip e Invisibilidad (CanCollide y Transparency)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			-- Noclip
			part.CanCollide = targetCanCollide

			-- Invisibilidad (Solo en LocalScript)
			part.LocalTransparencyModifier = targetTransparency
		elseif part:IsA("Accessory") then
			-- También aplica a los accesorios (sombreros, etc.)
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("BasePart") then
					child.LocalTransparencyModifier = targetTransparency
				end
			end
		end
	end

	-- 2. Velocidad (WalkSpeed)
	humanoid.WalkSpeed = enable and boostedWalkSpeed or defaultWalkSpeed

	-- 3. Actualizar la GUI
	TextButton.BackgroundColor3 = enable and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(255, 21, 0)
	TextButton.Text = enable and "ACTIVADO" or "NOCLIP/SPEED"
	TextLabel.Text = enable and "INVISIBLE" or "OFFLINE"
end

local function toggle()
	isEnabled = not isEnabled 
	local Character, Humanoid = getCharacterParts()

	applyModifications(Character, Humanoid, isEnabled)
end

-- Conecta la función de alternancia (Toggle) al clic del botón
TextButton.MouseButton1Click:Connect(toggle)

-- Manejar la reaparición del personaje (CharacterAdded)
Player.CharacterAdded:Connect(function(newCharacter)
	-- Si el modo estaba activado antes de morir, reaplicamos los cambios
	if isEnabled then
		local _, Humanoid = getCharacterParts()
		applyModifications(newCharacter, Humanoid, true) 
	end
end)

-- Script: Noclip y Velocidad Aumentada (Toggle)
-- DEBE ser un SOLO LocalScript ubicado en StarterGui o StarterPlayerScripts.

-- Servicios
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")

-- Variables de Estado y Configuración
local isEnabled = false
local defaultWalkSpeed = 16 -- Velocidad normal del personaje
local boostedWalkSpeed = 50 -- Nueva velocidad al activar el Noclip (puedes cambiar este valor)

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
TextButton.TextSize = 18.000 -- Reducido un poco para que quepa el texto

UICorner.Parent = TextButton

TextLabel.Parent = TextButton
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-0.132450327, 0, -0.681818187, 0)
TextLabel.Size = UDim2.new(0, 190, 0, 30)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "OFFLINE" -- Estado inicial
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 18.000

-- 3. FUNCIONALIDAD: Lógica de Noclip y Velocidad

-- Función para obtener el personaje y sus partes (clave para el noclip/velocidad)
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
	if not char or not humanoid then return end -- Seguridad

	-- 1. Noclip (CanCollide)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			-- Si 'enable' es true, CanCollide es false (Noclip ON). Si es false, CanCollide es true (Noclip OFF).
			part.CanCollide = not enable 
		end
	end

	-- 2. Velocidad (WalkSpeed)
	humanoid.WalkSpeed = enable and boostedWalkSpeed or defaultWalkSpeed

	-- 3. Actualizar la GUI
	TextButton.BackgroundColor3 = enable and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(255, 21, 0)
	TextButton.Text = enable and "ACTIVADO" or "NOCLIP/SPEED"
	TextLabel.Text = enable and "ONLINE" or "OFFLINE"
end

local function toggle()
	isEnabled = not isEnabled -- Cambia el estado (ON a OFF, o OFF a ON)
	local Character, Humanoid = getCharacterParts()

	applyModifications(Character, Humanoid, isEnabled)
end

-- Conecta la función de alternancia (Toggle) al clic del botón
TextButton.MouseButton1Click:Connect(toggle)

-- Manejar la reaparición del personaje (CharacterAdded)
Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter

	-- Debemos aplicar los cambios al nuevo personaje si el modo está activado.
	if isEnabled then
		local _, Humanoid = getCharacterParts()
		-- Reaplicar las modificaciones al nuevo personaje
		applyModifications(Character, Humanoid, true) 
	end
end)

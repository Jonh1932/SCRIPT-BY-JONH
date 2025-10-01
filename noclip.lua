-- Script: Noclip, Velocidad, Invisibilidad y Salto Infinito (OP)
-- UBICACIÓN CORRECTA: LocalScript DENTRO de StarterGui

-- Servicios
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===================================================
-- 1. GUI
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0)
TextButton.BackgroundTransparency = 0.500
TextButton.Position = UDim2.new(0.024, 0, 0.85, 0) 
TextButton.Size = UDim2.new(0, 151, 0, 44)
TextButton.Font = Enum.Font.Bangers
TextButton.Text = "TOGGLE OP MODE" 
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 18.000 

UICorner.Parent = TextButton

TextLabel.Parent = TextButton
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(-0.132, 0, -0.68, 0)
TextLabel.Size = UDim2.new(0, 190, 0, 30)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "OFFLINE" 
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 18.000

-- ===================================================
-- 2. VARIABLES
-- ===================================================
local isEnabled = false
local defaultWalkSpeed = 16 
local boostedWalkSpeed = 70 
local maxTransparency = 1.0 

local persistentLoop = nil 
local jumpConnection = nil

-- ===================================================
-- 3. FUNCIONES
-- ===================================================
local function getCharacterParts()
	local char = Player.Character or Player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	return char, humanoid
end

local function setCharacterProperties(char, humanoid, transparency, canCollide, walkSpeed)
	if not char or not humanoid then return end

	-- Velocidad
	humanoid.WalkSpeed = walkSpeed

	-- Noclip e Invisibilidad
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

-- Activar modo OP
local function startModifications()
	isEnabled = true
	local Character, Humanoid = getCharacterParts()

	-- Bucle Persistente
	persistentLoop = RunService.Heartbeat:Connect(function()
		setCharacterProperties(Character, Humanoid, maxTransparency, false, boostedWalkSpeed)
	end)

	-- Salto infinito
	jumpConnection = UIS.JumpRequest:Connect(function()
		if Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	-- GUI
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) 
	TextButton.Text = "ACTIVADO (OP)"
	TextLabel.Text = "JUMP, INV, RAPIDO"
end

-- Desactivar modo OP
local function stopModifications()
	isEnabled = false
	local Character, Humanoid = getCharacterParts()

	-- Detener el bucle
	if persistentLoop then
		persistentLoop:Disconnect()
		persistentLoop = nil
	end
	if jumpConnection then
		jumpConnection:Disconnect()
		jumpConnection = nil
	end

	-- Restaurar valores
	setCharacterProperties(Character, Humanoid, 0, true, defaultWalkSpeed)

	-- GUI
	TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0) 
	TextButton.Text = "TOGGLE OP MODE"
	TextLabel.Text = "OFFLINE"
end

-- Toggle
local function toggle()
	if isEnabled then
		stopModifications()
	else
		startModifications()
	end
end

-- Manejar respawn
Player.CharacterAdded:Connect(function()
	if isEnabled then
		stopModifications()
		task.wait(1)
		startModifications()
	end
end)

-- Botón
TextButton.MouseButton1Click:Connect(toggle)

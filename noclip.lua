-- SCRIPT OP COMPLETO ARREGLADO
-- LocalScript en StarterGui

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===================================================
-- 1. GUI ORIGINAL
-- ===================================================
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local FlyButton = Instance.new("TextButton")

ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Botón OP
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

-- Label estado
TextLabel.Parent = TextButton
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(-0.132, 0, -0.68, 0)
TextLabel.Size = UDim2.new(0, 190, 0, 30)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "OFFLINE" 
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextSize = 18.000

-- Botón Fly
FlyButton.Parent = ScreenGui
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
FlyButton.BackgroundTransparency = 0.3
FlyButton.Position = UDim2.new(0.8, 0, 0.85, 0)
FlyButton.Size = UDim2.new(0, 120, 0, 44)
FlyButton.Font = Enum.Font.Bangers
FlyButton.Text = "TOGGLE FLY" 
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 18.000

-- ===================================================
-- 2. VARIABLES
-- ===================================================
local isEnabled = false
local flying = false
local noclip = false

local flyConnection
local noclipConnection
local persistentLoop
local jumpConnection
local healLoop
local antiVoidLoop

local boostedWalkSpeed = 70 -- Speed bypass CFrame

-- ===================================================
-- 3. FUNCIONES
-- ===================================================
local function getCharacterParts()
	local char = Player.Character or Player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	return char, humanoid, hrp
end

-- Invisibilidad (solo pelo visible)
local function setInvisible(char)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
			if string.find(part.Name:lower(), "hair") then
				part.Handle.Transparency = 0
			else
				part.Handle.Transparency = 1
			end
		end
	end
end

local function setVisible(char)
	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 0
		elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
			part.Handle.Transparency = 0
		end
	end
end

-- Fly
local function startFlying(hrp)
	flying = true
	local speed = 60
	flyConnection = RunService.RenderStepped:Connect(function()
		local moveDir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - (workspace.CurrentCamera.CFrame.RightVector)
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + (workspace.CurrentCamera.CFrame.RightVector)
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDir = moveDir - Vector3.new(0,1,0)
		end
		if moveDir.Magnitude > 0 then
			hrp.Velocity = moveDir.Unit * speed
		else
			hrp.Velocity = Vector3.zero
		end
	end)
	FlyButton.Text = "FLY ON"
	FlyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
end

local function stopFlying(hrp)
	flying = false
	if flyConnection then flyConnection:Disconnect() flyConnection=nil end
	hrp.Velocity = Vector3.zero
	FlyButton.Text = "TOGGLE FLY"
	FlyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
end

-- Noclip real (sin caer al suelo)
local function startNoclip(char, hrp)
	noclip = true
	noclipConnection = RunService.Stepped:Connect(function()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
		-- Mantener flotando un poquito
		hrp.Velocity = Vector3.new(0,0,0)
	end)
end

local function stopNoclip(char)
	noclip = false
	if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
end

-- AntiKill + Heal
local function startAntiKill(hum)
	healLoop = RunService.Heartbeat:Connect(function()
		if hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end)
end

local function stopAntiKill()
	if healLoop then healLoop:Disconnect() healLoop=nil end
end

-- AntiVoid
local function startAntiVoid(hrp)
	antiVoidLoop = RunService.Heartbeat:Connect(function()
		if hrp.Position.Y < -10 then
			hrp.CFrame = CFrame.new(0, 50, 0)
		end
	end)
end

local function stopAntiVoid()
	if antiVoidLoop then antiVoidLoop:Disconnect() antiVoidLoop=nil end
end

-- ===================================================
-- 4. MODO OP
-- ===================================================
local function startModifications()
	isEnabled = true
	local char, hum, hrp = getCharacterParts()

	-- Speed bypass con CFrame
	persistentLoop = RunService.Heartbeat:Connect(function()
		if hum and hum.Health > 0 then
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				hrp.CFrame = hrp.CFrame + (moveDir * (boostedWalkSpeed/100))
			end
		end
	end)

	-- Salto infinito
	jumpConnection = UIS.JumpRequest:Connect(function()
		if hum:GetState() ~= Enum.HumanoidStateType.Dead then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	-- Invisibilidad
	setInvisible(char)

	-- Noclip sin caer
	startNoclip(char, hrp)

	-- AntiKill
	startAntiKill(hum)

	-- AntiVoid
	startAntiVoid(hrp)

	-- GUI
	TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) 
	TextButton.Text = "ACTIVADO (OP)"
	TextLabel.Text = "GOD, JUMP, INV, SPEED, FLY, NOCLIP"
end

local function stopModifications()
	isEnabled = false
	local char, hum, hrp = getCharacterParts()

	if persistentLoop then persistentLoop:Disconnect() persistentLoop=nil end
	if jumpConnection then jumpConnection:Disconnect() jumpConnection=nil end
	if flyConnection then flyConnection:Disconnect() flyConnection=nil end
	if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end

	stopAntiKill()
	stopAntiVoid()

	setVisible(char)
	stopNoclip(char)
	stopFlying(hrp)

	TextButton.BackgroundColor3 = Color3.fromRGB(255, 21, 0) 
	TextButton.Text = "TOGGLE OP MODE"
	TextLabel.Text = "OFFLINE"
end

local function toggle()
	if isEnabled then
		stopModifications()
	else
		startModifications()
	end
end

-- ===================================================
-- 5. EVENTOS
-- ===================================================
TextButton.MouseButton1Click:Connect(toggle)

FlyButton.MouseButton1Click:Connect(function()
	local _, _, hrp = getCharacterParts()
	if flying then
		stopFlying(hrp)
	else
		startFlying(hrp)
	end
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F and isEnabled then
		local _, _, hrp = getCharacterParts()
		if flying then
			stopFlying(hrp)
		else
			startFlying(hrp)
		end
	end
end)

Player.CharacterAdded:Connect(function()
	if isEnabled then
		stopModifications()
		task.wait(1)
		startModifications()
	end
end)

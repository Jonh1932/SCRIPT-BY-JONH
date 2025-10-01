-- Script generado por TurtleSpy, hecho por Intrer#0421

-- Función para activar los hacks
local function activateHacks()
    -- Hex Preview
    game:GetService("ReplicatedStorage").Signal.Hex:FireServer("addPreviewHexs",{-96,-1})

    -- Daily Reward
    game:GetService("ReplicatedStorage").Signal.DailyReward:InvokeServer()

    -- Died Event
    game:GetService("ReplicatedStorage").Signal.Died:FireServer()

    -- Level Up
    game:GetService("ReplicatedStorage").Signal.LevelUp:FireServer()

    -- Sprint
    game:GetService("ReplicatedStorage").Signal.Sprint:FireServer()

    -- Speed Upgrade
    game:GetService("ReplicatedStorage").Signal.SpeedUpgrade:FireServer()

    -- Stamina infinita
    local player = game.Players.LocalPlayer
    local stamina = player:WaitForChild("Stamina")
    local function setStamina()
        stamina.Value = 100
    end
    game:GetService("RunService").RenderStepped:Connect(setStamina)

    -- Velocidad máxima
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 100
end

-- Función para desactivar los hacks
local function deactivateHacks()
    -- Aquí puedes agregar código para desactivar los hacks si es necesario
    local player = game.Players.LocalPlayer
    local stamina = player:WaitForChild("Stamina")
    stamina.Value = 0
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16 -- Velocidad predeterminada
end

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local button = Instance.new("TextButton")
local title = Instance.new("TextLabel")

-- Configurar la GUI
screenGui.Parent = game:GetService("CoreGui")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
frame.Parent = screenGui

title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "Hacks Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

button.Size = UDim2.new(1, 0, 0, 50)
button.Position = UDim2.new(0, 0, 0.5, -25)
button.Text = "Activar Hacks"
button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 20
button.Font = Enum.Font.SourceSansBold
button.Parent = frame

-- Función para manejar el clic del botón
local function onButtonClick()
    if button.Text == "Activar Hacks" then
        activateHacks()
        button.Text = "Desactivar Hacks"
    else
        deactivateHacks()
        button.Text = "Activar Hacks"
    end
end

-- Conectar la función al evento de clic del botón
button.MouseButton1Click:Connect(onButtonClick)

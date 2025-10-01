-- Script generado por TurtleSpy, hecho por Intrer#0421

-- Función para activar los hacks
local function activateHacks()
    -- Activar Ping No Re
    game:GetService("ReplicatedStorage").Remotes.PINGNORE:FireServer()

    -- Enviar Ping
    game:GetService("ReplicatedStorage").PingSend:InvokeServer(46, 97)

    -- Stamina infinita
    game:GetService("Players").LocalPlayer.PlayerGui.Stamina.Frame.Speed:FireServer(10525299, 32)

    -- Accion de Header
    game:GetService("ReplicatedStorage").Remotes.Action:FireServer("Header")

    -- Remotes con ID específico
    game:GetService("ReplicatedStorage").Remotes["0.3430534413616612"]:FireServer(6.3160881996154785)
    game:GetService("ReplicatedStorage").Remotes["0.3430534413616612"]:FireServer(6.3160881996154785)

    -- SoftDisPlayer
    game:GetService("ReplicatedStorage").Remotes.SoftDisPlayer:FireServer(game:GetService("Players").LocalPlayer, 6.042978763580322, false)

    -- ShootTheBaII
    game:GetService("ReplicatedStorage").Remotes.ShootTheBaII:FireServer(
        nil,
        CFrame.new(50.805397, 1.46151423, 52.0827522, 0.496118546, -1.09897551e-11, -0.8682549, 5.45194185e-12, 1, -9.54206679e-12, 0.8682549, 3.23092247e-16, 0.496118546),
        0.6050488948822021,
        nil,
        false,
        true,
        "None",
        true,
        false,
        "Center"
    )
end

-- Función para desactivar los hacks
local function deactivateHacks()
    -- Aquí puedes agregar código para desactivar los hacks si es necesario
end

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local button = Instance.new("TextButton")

-- Configurar la GUI
screenGui.Parent = game:GetService("CoreGui")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Parent = screenGui

button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.Text = "Activar Hacks"
button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
button.TextColor3 = Color3.new(1, 1, 1)
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

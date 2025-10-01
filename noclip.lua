-- 🎣 AutoFishing GUI (Candy Cane Rod)
-- Orden real de pesca: reset -> cast -> boost -> reel
-- con GUI para Start / Stop

-- ⚡ Servicios
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rod = player.Backpack:FindFirstChild("Candy Cane Rod") 
    or workspace.NoReaperPls:FindFirstChild("Candy Cane Rod")

-- ⚡ GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishingGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "🎣 AutoFishing Candy Cane"
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.BorderSizePixel = 0
local UICorner2 = Instance.new("UICorner", Title)
UICorner2.CornerRadius = UDim.new(0, 10)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0, 220, 0, 40)
Button.Position = UDim2.new(0.5, -110, 0.55, 0)
Button.Text = "▶ Start AutoFishing"
Button.TextScaled = true
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Button.TextColor3 = Color3.new(1,1,1)
Button.BorderSizePixel = 0
local UICorner3 = Instance.new("UICorner", Button)
UICorner3.CornerRadius = UDim.new(0, 6)

-- ⚡ Variables de control
local running = false
local DelayTime = 2 -- tiempo entre pescas (ajústalo si va muy rápido)

-- ⚡ Función AutoFishing
local function AutoFish()
    while running and task.wait(DelayTime) do
        if not rod or not rod.Parent then
            rod = player.Backpack:FindFirstChild("Candy Cane Rod") 
                or workspace.NoReaperPls:FindFirstChild("Candy Cane Rod")
        end
        if rod then
            -- 1. Resetear caña
            rod.events.reset:FireServer()
            task.wait(0.3)

            -- 2. Lanzar caña
            rod.events.cast:FireServer(76,1)
            task.wait(0.5)

            -- 3. Pedir boost (opcional)
            ReplicatedStorage.packages.Net["RF/RequestCache"]:InvokeServer("Boost.Resilience")
            task.wait(0.5)

            -- 4. Finalizar reeling (captura)
            ReplicatedStorage.events.reelfinished:FireServer(math.random(), false)
        end
    end
end

-- ⚡ Botón Start/Stop
Button.MouseButton1Click:Connect(function()
    if running then
        running = false
        Button.Text = "▶ Start AutoFishing"
        Button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        running = true
        Button.Text = "■ Stop AutoFishing"
        Button.BackgroundColor3 = Color3.fromRGB(170,0,0)
        task.spawn(AutoFish)
    end
end)

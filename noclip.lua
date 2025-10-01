-- 🎣 AutoFishing GUI para Candy Cane Rod
-- by GPT
-- Con este script puedes elegir el pez que quieras y pescar infinito con 1 click

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
Frame.BackgroundTransparency = 0.1

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

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(0, 220, 0, 30)
TextBox.Position = UDim2.new(0.5, -110, 0.3, 0)
TextBox.PlaceholderText = "Escribe pez (ej: Mahi Mahi)"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.BorderSizePixel = 0
local UICorner3 = Instance.new("UICorner", TextBox)
UICorner3.CornerRadius = UDim.new(0, 6)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0, 220, 0, 40)
Button.Position = UDim2.new(0.5, -110, 0.65, 0)
Button.Text = "▶ Start AutoFishing"
Button.TextScaled = true
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Button.TextColor3 = Color3.new(1,1,1)
Button.BorderSizePixel = 0
local UICorner4 = Instance.new("UICorner", Button)
UICorner4.CornerRadius = UDim.new(0, 6)

-- ⚡ Variables de control
local running = false
local DelayTime = 1.5 -- tiempo entre pescas

-- ⚡ Función de auto fishing
local function AutoFish(FishName)
    while running and task.wait(DelayTime) do
        if not rod or not rod.Parent then
            rod = player.Backpack:FindFirstChild("Candy Cane Rod") 
                or workspace.NoReaperPls:FindFirstChild("Candy Cane Rod")
        end
        if rod then
            rod.events.cast:FireServer(30.4,1)
            ReplicatedStorage.packages.Net["RF/ResourceStream/Request"]:InvokeServer("fish", FishName)
            ReplicatedStorage.events.reelfinished:FireServer(100,false)
            rod.events.reset:FireServer()
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
        local FishName = TextBox.Text ~= "" and TextBox.Text or "Mahi Mahi"
        task.spawn(function() AutoFish(FishName) end)
    end
end)

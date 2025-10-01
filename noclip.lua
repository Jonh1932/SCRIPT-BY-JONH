-- 🎣 AutoFishing Candy Cane Rod (orden real)
-- Basado en los events que pasaste

-- ⚡ Configuración:
local DelayTime = 1.5 -- Tiempo entre pescas (ajústalo según lag)

-- ⚡ Servicios
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rod = player.Backpack:FindFirstChild("Candy Cane Rod") 
    or workspace.NoReaperPls:FindFirstChild("Candy Cane Rod")

-- ⚡ Función de AutoFishing
local function AutoFish()
    while task.wait(DelayTime) do
        if not rod or not rod.Parent then
            rod = player.Backpack:FindFirstChild("Candy Cane Rod") 
                or workspace.NoReaperPls:FindFirstChild("Candy Cane Rod")
        end
        if rod then
            -- 1. Resetear la caña
            rod.events.reset:FireServer()
            
            task.wait(0.3)
            
            -- 2. Tirar caña
            rod.events.cast:FireServer(76,1)
            
            task.wait(0.5)
            
            -- 3. Pedir boost (opcional)
            ReplicatedStorage.packages.Net["RF/RequestCache"]:InvokeServer("Boost.Resilience")
            
            task.wait(0.5)
            
            -- 4. Finalizar reeling (simular captura)
            ReplicatedStorage.events.reelfinished:FireServer(math.random(), false)
        end
    end
end

-- ⚡ Iniciar
task.spawn(AutoFish)

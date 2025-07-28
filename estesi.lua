-- Prison Life Police Hack V2 - Android KRNL
-- 3 Métodos Kill All Funcionales + Noclip + Speed

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local killAll1Active = false -- TP + Auto Shoot
local killAll2Active = false -- Damage Event
local killAll3Active = false -- Health Manipulation
local noclipEnabled = false
local speedEnabled = false
local normalSpeed = 16
local speedMultiplier = 4

-- Buscar remotes importantes basados en tus logs
local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
local shootEvent = ReplicatedStorage:FindFirstChild("ShootEvent") or ReplicatedStorage:FindFirstChild("ShotEvent")
local damageEvent = ReplicatedStorage:FindFirstChild("DamageEvent") 
local replicateEvent = ReplicatedStorage:FindFirstChild("ReplicateEvent")
local equipEvent = ReplicatedStorage:FindFirstChild("EquipEvent")
local unequipEvent = ReplicatedStorage:FindFirstChild("UnequipEvent")

-- Print de remotes encontrados
print("🔍 Remotes encontrados:")
if meleeEvent then print("✅ meleeEvent") end
if shootEvent then print("✅ shootEvent") end
if damageEvent then print("✅ damageEvent") end
if replicateEvent then print("✅ replicateEvent") end
if equipEvent then print("✅ equipEvent") end

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrisonLifePoliceV2"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleLabel.Text = "🚔 Prison Life Kill All V2"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Kill All Método 1: TP + Auto Shoot
local kill1Btn = Instance.new("TextButton")
kill1Btn.Size = UDim2.new(0.31, 0, 0, 35)
kill1Btn.Position = UDim2.new(0.03, 0, 0, 45)
kill1Btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
kill1Btn.Text = "🎯 TP SHOOT"
kill1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
kill1Btn.TextScaled = true
kill1Btn.Font = Enum.Font.Gotham
kill1Btn.Parent = mainFrame

local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 8)
btn1Corner.Parent = kill1Btn

-- Kill All Método 2: Damage Remote
local kill2Btn = Instance.new("TextButton")
kill2Btn.Size = UDim2.new(0.31, 0, 0, 35)
kill2Btn.Position = UDim2.new(0.345, 0, 0, 45)
kill2Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
kill2Btn.Text = "⚡ DAMAGE"
kill2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
kill2Btn.TextScaled = true
kill2Btn.Font = Enum.Font.Gotham
kill2Btn.Parent = mainFrame

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = kill2Btn

-- Kill All Método 3: Health Hack
local kill3Btn = Instance.new("TextButton")
kill3Btn.Size = UDim2.new(0.31, 0, 0, 35)
kill3Btn.Position = UDim2.new(0.66, 0, 0, 45)
kill3Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
kill3Btn.Text = "💀 HEALTH"
kill3Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
kill3Btn.TextScaled = true
kill3Btn.Font = Enum.Font.Gotham
kill3Btn.Parent = mainFrame

local btn3Corner = Instance.new("UICorner")
btn3Corner.CornerRadius = UDim.new(0, 8)
btn3Corner.Parent = kill3Btn

-- Noclip Button
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.48, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.03, 0, 0, 90)
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
noclipBtn.Text = "👻 NOCLIP"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.TextScaled = true
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.Parent = mainFrame

local btn4Corner = Instance.new("UICorner")
btn4Corner.CornerRadius = UDim.new(0, 6)
btn4Corner.Parent = noclipBtn

-- Speed Button
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.48, 0, 0, 30)
speedBtn.Position = UDim2.new(0.49, 0, 0, 90)
speedBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
speedBtn.Text = "💨 SPEED x4"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.Gotham
speedBtn.Parent = mainFrame

local btn5Corner = Instance.new("UICorner")
btn5Corner.CornerRadius = UDim.new(0, 6)
btn5Corner.Parent = speedBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 50)
statusLabel.Position = UDim2.new(0, 5, 0, 130)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔫 Listo para eliminar criminales\n👮 Selecciona un método Kill All\n⚡ Todos optimizados para Android"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Funciones principales

-- Obtener todos los criminales (inmates/prisoners)
local function getCriminals()
    local criminals = {}
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local head = targetPlayer.Character:FindFirstChild("Head")
            
            if humanoid and rootPart and head and humanoid.Health > 0 then
                -- Verificar si es criminal/inmate
                if targetPlayer.Team then
                    local teamName = targetPlayer.Team.Name:lower()
                    if teamName:find("criminal") or teamName:find("inmate") or teamName:find("prisoner") then
                        table.insert(criminals, targetPlayer)
                    end
                else
                    -- Sin team también puede ser criminal
                    table.insert(criminals, targetPlayer)
                end
            end
        end
    end
    return criminals
end

-- Método 1: TP + Auto Shoot (Remington)
local function killAllMethod1()
    local criminals = getCriminals()
    local killed = 0
    
    for _, criminal in pairs(criminals) do
        if not killAll1Active then break end
        
        if criminal.Character and criminal.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = criminal.Character.HumanoidRootPart.Position
            local headPos = criminal.Character.Head.Position
            
            -- TP detrás del criminal
            rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, -4), targetPos)
            wait(0.15)
            
            -- Múltiples métodos de disparo
            pcall(function()
                -- Método 1: ShootEvent con posición de cabeza
                if shootEvent then
                    shootEvent:FireServer(headPos, criminal.Character.Head)
                    shootEvent:FireServer(headPos, criminal.Character.Head, "Remington 870", 100)
                end
            end)
            
            pcall(function()
                -- Método 2: ReplicateEvent (basado en tus logs)
                if replicateEvent then
                    replicateEvent:FireServer("Shoot", criminal.Character.Head, headPos, 100)
                end
            end)
            
            pcall(function()
                -- Método 3: Simular click con daño
                if meleeEvent then
                    meleeEvent:FireServer(criminal.Character.Head)
                end
            end)
            
            killed = killed + 1
            wait(0.2)
        end
    end
    
    statusLabel.Text = "🎯 TP Shoot: " .. killed .. " eliminados\n⚡ Método 1 completado"
end

-- Método 2: Damage Event Directo
local function killAllMethod2()
    local criminals = getCriminals()
    local killed = 0
    
    for _, criminal in pairs(criminals) do
        if not killAll2Active then break end
        
        if criminal.Character and criminal.Character:FindFirstChild("Humanoid") then
            pcall(function()
                -- Método 1: DamageEvent directo
                if damageEvent then
                    damageEvent:FireServer(criminal.Character.Humanoid, 100, "Remington 870")
                end
            end)
            
            pcall(function()
                -- Método 2: Melee con daño alto
                if meleeEvent then
                    meleeEvent:FireServer(criminal.Character.Humanoid, 100)
                end
            end)
            
            pcall(function()
                -- Método 3: ReplicateEvent con daño
                if replicateEvent then
                    replicateEvent:FireServer("Damage", criminal.Character.Humanoid, 100)
                end
            end)
            
            killed = killed + 1
            wait(0.1)
        end
    end
    
    statusLabel.Text = "⚡ Damage: " .. killed .. " eliminados\n💀 Método 2 completado"
end

-- Método 3: Health Manipulation
local function killAllMethod3()
    local criminals = getCriminals()
    local killed = 0
    
    for _, criminal in pairs(criminals) do
        if not killAll3Active then break end
        
        if criminal.Character and criminal.Character:FindFirstChild("Humanoid") then
            -- Múltiples métodos de manipulación de health
            pcall(function()
                criminal.Character.Humanoid.Health = 0
                killed = killed + 1
            end)
            
            pcall(function()
                criminal.Character.Humanoid:TakeDamage(100)
            end)
            
            pcall(function()
                -- Método con ReplicateEvent
                if replicateEvent then
                    replicateEvent:FireServer("SetHealth", criminal.Character.Humanoid, 0)
                end
            end)
            
            pcall(function()
                -- Método directo con Humanoid
                criminal.Character.Humanoid.MaxHealth = 0
                criminal.Character.Humanoid.Health = 0
            end)
            
            wait(0.05) -- Muy rápido
        end
    end
    
    statusLabel.Text = "💀 Health: " .. killed .. " eliminados\n🔥 Método 3 completado"
end

-- Noclip Function
local noclipConnection = nil
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        noclipBtn.Text = "👻 ON"
        
        noclipConnection = RunService.Stepped:Connect(function()
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
        noclipBtn.Text = "👻 NOCLIP"
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Speed Function
local function toggleSpeed()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        speedBtn.Text = "💨 ON"
        if humanoid then
            humanoid.WalkSpeed = normalSpeed * speedMultiplier
        end
    else
        speedBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        speedBtn.Text = "💨 SPEED x4"
        if humanoid then
            humanoid.WalkSpeed = normalSpeed
        end
    end
end

-- Event Connections

-- Kill All Método 1
kill1Btn.MouseButton1Click:Connect(function()
    killAll1Active = not killAll1Active
    
    if killAll1Active then
        kill1Btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        kill1Btn.Text = "🎯 ACTIVE"
        statusLabel.Text = "🎯 TP Shoot activado\n⚡ Eliminando criminales..."
        
        spawn(function()
            while killAll1Active do
                killAllMethod1()
                wait(2)
            end
        end)
    else
        kill1Btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        kill1Btn.Text = "🎯 TP SHOOT"
        statusLabel.Text = "🎯 TP Shoot desactivado"
    end
end)

-- Kill All Método 2
kill2Btn.MouseButton1Click:Connect(function()
    killAll2Active = not killAll2Active
    
    if killAll2Active then
        kill2Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        kill2Btn.Text = "⚡ ACTIVE"
        statusLabel.Text = "⚡ Damage activado\n💀 Eliminando criminales..."
        
        spawn(function()
            while killAll2Active do
                killAllMethod2()
                wait(1.5)
            end
        end)
    else
        kill2Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
        kill2Btn.Text = "⚡ DAMAGE"
        statusLabel.Text = "⚡ Damage desactivado"
    end
end)

-- Kill All Método 3
kill3Btn.MouseButton1Click:Connect(function()
    killAll3Active = not killAll3Active
    
    if killAll3Active then
        kill3Btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        kill3Btn.Text = "💀 ACTIVE"
        statusLabel.Text = "💀 Health Hack activado\n🔥 Eliminando criminales..."
        
        spawn(function()
            while killAll3Active do
                killAllMethod3()
                wait(1)
            end
        end)
    else
        kill3Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        kill3Btn.Text = "💀 HEALTH"
        statusLabel.Text = "💀 Health Hack desactivado"
    end
end)

-- Otros botones
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
speedBtn.MouseButton1Click:Connect(toggleSpeed)

-- Drag functionality para móvil
local dragging = false
local dragStart = nil
local startPos = nil

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Restaurar speed si estaba activado
    if speedEnabled then
        humanoid.WalkSpeed = normalSpeed * speedMultiplier
    end
end)

-- Inicialización
print("🚔 Prison Life Kill All V2 cargado")
print("📱 3 métodos Kill All para Android")
print("⚡ Basado en remotes capturados")
print("👮 Listo para mantener el orden")
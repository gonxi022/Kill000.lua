-- Auto-Clicker Android KRNL con Botones Flotantes y Remote Spy
-- Funcional para dispositivos móviles

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local clicking = false
local spying = false
local clickSpeed = 0.01
local clickMultiplier = 1
local clickRemote = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal (draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner para el frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "Auto-Clicker v1.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Botón Auto-Click
local autoClickBtn = Instance.new("TextButton")
autoClickBtn.Size = UDim2.new(0.45, 0, 0, 35)
autoClickBtn.Position = UDim2.new(0.05, 0, 0, 35)
autoClickBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
autoClickBtn.Text = "START"
autoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoClickBtn.TextScaled = true
autoClickBtn.Font = Enum.Font.Gotham
autoClickBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = autoClickBtn

-- Botón Remote Spy
local spyBtn = Instance.new("TextButton")
spyBtn.Size = UDim2.new(0.45, 0, 0, 35)
spyBtn.Position = UDim2.new(0.5, 0, 0, 35)
spyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 220)
spyBtn.Text = "SPY OFF"
spyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spyBtn.TextScaled = true
spyBtn.Font = Enum.Font.Gotham
spyBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = spyBtn

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 80)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Listo para usar"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 15)
speedLabel.Position = UDim2.new(0, 5, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. (1/clickSpeed) .. " CPS"
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Funciones principales
local function findClickRemote()
    -- Buscar remotes comunes para clicks
    local possibleNames = {"SYSTEM", "Click", "AddClick", "Tap", "Farm", "Collect", "RemoteEvent"}
    
    for _, name in pairs(possibleNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            clickRemote = remote
            print("🎯 Remote encontrado:", name)
            statusLabel.Text = "Remote: " .. name
            return remote
        end
    end
    
    -- Si no encuentra, usar el primero disponible
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") then
            clickRemote = child
            print("🎯 Usando remote:", child.Name)
            statusLabel.Text = "Remote: " .. child.Name
            return child
        end
    end
    
    print("❌ No se encontraron remotes")
    statusLabel.Text = "No hay remotes"
    return nil
end

local function performClick()
    if not clickRemote then
        findClickRemote()
        if not clickRemote then return end
    end
    
    -- Intentar diferentes métodos de envío
    local success = false
    
    -- Método 1: Con multiplicador
    pcall(function()
        clickRemote:FireServer(clickMultiplier)
        success = true
    end)
    
    if not success then
        -- Método 2: Múltiples clicks individuales
        for i = 1, clickMultiplier do
            pcall(function()
                clickRemote:FireServer()
            end)
        end
        success = true
    end
    
    if not success then
        -- Método 3: Con parámetros comunes
        pcall(function()
            clickRemote:FireServer("click", clickMultiplier)
        end)
    end
end

-- Remote Spy básico
local originalFireServer = nil
local function setupRemoteSpy()
    if not originalFireServer then
        -- Interceptar FireServer
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local oldFireServer = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    if spying then
                        local argStr = ""
                        for i, arg in pairs(args) do
                            argStr = argStr .. tostring(arg) .. (i < #args and ", " or "")
                        end
                        print("🔍 SPY -", remote.Name .. ":FireServer(" .. argStr .. ")")
                    end
                    return oldFireServer(self, ...)
                end
            end
        end
    end
end

-- Eventos de botones
autoClickBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    
    if clicking then
        autoClickBtn.Text = "STOP"
        autoClickBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        statusLabel.Text = "Auto-clicking activo"
        
        -- Encontrar remote si no existe
        if not clickRemote then
            findClickRemote()
        end
        
        -- Loop de auto-click
        spawn(function()
            while clicking do
                performClick()
                wait(clickSpeed)
            end
        end)
    else
        autoClickBtn.Text = "START"
        autoClickBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        statusLabel.Text = "Detenido"
    end
end)

spyBtn.MouseButton1Click:Connect(function()
    spying = not spying
    
    if spying then
        spyBtn.Text = "SPY ON"
        spyBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        setupRemoteSpy()
        print("🔍 Remote Spy activado - Los logs aparecerán aquí")
    else
        spyBtn.Text = "SPY OFF" 
        spyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 220)
        print("🔍 Remote Spy desactivado")
    end
end)

-- Hacer el GUI draggable (para móvil)
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = newPosition
end

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- Inicialización
print("🚀 Auto-Clicker cargado correctamente")
print("📱 Optimizado para Android KRNL")
print("🎮 Listo para usar en Clicker League")

-- Buscar remote automáticamente al iniciar
findClickRemote()

-- Cambiar multiplicador con toque largo en móvil
local touchHoldTime = 0
local isTouching = false

autoClickBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isTouching = true
        touchHoldTime = 0
        
        -- Contar tiempo de toque
        spawn(function()
            while isTouching do
                wait(0.1)
                touchHoldTime = touchHoldTime + 0.1
                
                -- Si mantiene presionado por 1 segundo
                if touchHoldTime >= 1.0 and isTouching then
                    clickMultiplier = clickMultiplier + 1
                    if clickMultiplier > 10 then clickMultiplier = 1 end
                    statusLabel.Text = "Multiplicador: x" .. clickMultiplier
                    print("🔢 Multiplicador: x" .. clickMultiplier)
                    
                    -- Vibración visual
                    local tween = TweenService:Create(autoClickBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.5, 0, 0, 40)})
                    tween:Play()
                    tween.Completed:Connect(function()
                        TweenService:Create(autoClickBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.45, 0, 0, 35)}):Play()
                    end)
                    
                    break
                end
            end
        end)
    end
end)

autoClickBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if touchHoldTime < 1.0 then
            -- Toque corto = toggle auto-click
            clicking = not clicking
            
            if clicking then
                autoClickBtn.Text = "STOP"
                autoClickBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
                statusLabel.Text = "Auto-clicking activo"
                
                if not clickRemote then findClickRemote() end
                
                spawn(function()
                    while clicking do
                        performClick()
                        wait(clickSpeed)
                    end
                end)
            else
                autoClickBtn.Text = "START"
                autoClickBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                statusLabel.Text = "Detenido"
            end
        end
        isTouching = false
    end
end)
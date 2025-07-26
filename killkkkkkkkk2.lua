-- ModMenu Kill All - 2 Métodos (Toque compatible Android/PC)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Esperar que LocalPlayer esté listo
while not LocalPlayer do wait() LocalPlayer = Players.LocalPlayer end

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Función para crear botones
local function createButton(name, position, text, color)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 220, 0, 45)
	btn.Position = position
	btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
	btn.BorderSizePixel = 2
	btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 22
	btn.Parent = gui
	btn.AutoButtonColor = true
	return btn
end

-- Función para conectar botones para PC y Android
local function connectButton(btn, func)
	btn.MouseButton1Click:Connect(func)
	btn.TouchTap:Connect(func)
end

-- ===============================
-- MÉTODO 1: Kill All directo (Health = 0 + TakeDamage)
-- ===============================

local function KillPlayerDirect(player)
	if player and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function()
				humanoid.Health = 0
				humanoid:TakeDamage(humanoid.MaxHealth + 1)
			end)
		end
	end
end

local function ExecuteKillAll_Direct()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			KillPlayerDirect(player)
		end
	end
	print("[ModMenu] Kill All Direct ejecutado.")
end

-- ===============================
-- MÉTODO 2: Kill All con RemoteEvent (requiere que exista)
-- ===============================

-- Buscar RemoteEvent relacionado con daño
local function findDamageRemote()
	for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			if string.find(string.lower(obj.Name), "damage") or string.find(string.lower(obj.Name), "hit") or string.find(string.lower(obj.Name), "shoot") then
				return obj
			end
		end
	end
	return nil
end

local function KillPlayerRemote(player, remote)
	if player and player ~= LocalPlayer and player.Character then
		pcall(function()
			-- ¡Ajustá esta parte si descubrís los parámetros exactos del Remote!
			remote:FireServer(player, 9999)
		end)
	end
end

local function ExecuteKillAll_Remote()
	local remote = findDamageRemote()
	if not remote then
		warn("No se encontró RemoteEvent de daño.")
		return
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			KillPlayerRemote(player, remote)
		end
	end

	print("[ModMenu] Kill All Remote ejecutado.")
end

-- ===============================
-- Crear botones
-- ===============================

local btn1 = createButton("KillAllDirectBtn", UDim2.new(0.05, 0, 0.1, 0), "🔴 Kill All (Direct)", Color3.fromRGB(200, 50, 50))
local btn2 = createButton("KillAllRemoteBtn", UDim2.new(0.05, 0, 0.2, 0), "🟢 Kill All (Remote)", Color3.fromRGB(50, 200, 50))

connectButton(btn1, ExecuteKillAll_Direct)
connectButton(btn2, ExecuteKillAll_Remote)

print("[ModMenu] Cargado con 2 botones de Kill All.")
-- Prison Life - MultiHack GUI (Remington, M9, AK) KRNL Android/PC

local plr = game.Players.LocalPlayer

-- Crear GUI flotante
local gui = Instance.new("ScreenGui")
gui.Parent = plr.PlayerGui
gui.ResetOnSpawn = false

local function makeBtn(txt, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 160, 0, 38)
    b.Position = UDim2.new(0, 25, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 20
    b.Text = txt
    b.Draggable = true
    b.Parent = gui
    return b
end

-- Botón Kill All
local killBtn = makeBtn("🔥 KILL ALL 🔥", 170)
killBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)

-- Botón Infinite Ammo
local ammoBtn = makeBtn("∞ BALAS INFINITAS ∞", 220)
ammoBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 220)

-- Botón No Recoil
local recoilBtn = makeBtn("🚫 SIN RECOIL 🚫", 270)
recoilBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)

-- Función Kill All
killBtn.MouseButton1Click:Connect(function()
    local gun = (plr.Character and plr.Character:FindFirstChildOfClass("Tool")) or (plr.Backpack:FindFirstChildOfClass("Tool"))
    if not gun then
        killBtn.Text = "Equipa un arma"
        wait(1)
        killBtn.Text = "🔥 KILL ALL 🔥"
        return
    end
    local remote = game.ReplicatedStorage:FindFirstChild("ShootEvent")
    if not remote then
        killBtn.Text = "No Remote"
        wait(1)
        killBtn.Text = "🔥 KILL ALL 🔥"
        return
    end
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= plr and target.Character and target.Character:FindFirstChild("Head") then
            for _=1,7 do
                remote:FireServer(target.Character.Head.Position, target)
                wait(0.06)
            end
        end
    end
    killBtn.Text = "Listo!"
    wait(0.8)
    killBtn.Text = "🔥 KILL ALL 🔥"
end)

-- Función Balas Infinitas
ammoBtn.MouseButton1Click:Connect(function()
    local function patch(t)
        if t:FindFirstChild("Ammo") then t.Ammo.Value = 999 end
        if t:FindFirstChild("MaxAmmo") then t.MaxAmmo.Value = 999 end
        if t:FindFirstChild("AmmoGui") then
            local ag = t.AmmoGui:FindFirstChild("Ammo")
            if ag and ag:IsA("TextLabel") then ag.Text = "∞" end
        end
    end
    local function infAmmo(tool)
        for _,v in pairs(tool:GetChildren()) do
            if v:IsA("IntValue") and v.Name:lower():find("ammo") then
                v.Value = 999
            end
        end
        patch(tool)
    end
    local found = false
    for _,tool in pairs({plr.Backpack:GetChildren(), plr.Character:GetChildren()}) do
        if tool:IsA("Tool") then
            infAmmo(tool)
            found = true
        end
    end
    if found then
        ammoBtn.Text = "¡AMMO INFINITO!"
        wait(1)
        ammoBtn.Text = "∞ BALAS INFINITAS ∞"
    else
        ammoBtn.Text = "Equipa un arma"
        wait(1)
        ammoBtn.Text = "∞ BALAS INFINITAS ∞"
    end
end)

-- Función No Recoil
recoilBtn.MouseButton1Click:Connect(function()
    local tools = {}
    for _,tool in pairs({plr.Backpack:GetChildren(), plr.Character:GetChildren()}) do
        if tool:IsA("Tool") then table.insert(tools, tool) end
    end
    local function removeRecoil(tool)
        local gs = tool:FindFirstChild("GunScript_Local")
        if gs and gs:IsA("LocalScript") then
            local src = gs.Source
            src = src:gsub("math%.random%([%d, ]-%)", "0") -- Quita recoil aleatorio
            src = src:gsub("math%.random%(.-%)", "0")
            gs.Source = src
        end
        -- A veces, el recoil es una variable
        if tool:FindFirstChild("Recoil") then tool.Recoil.Value = 0 end
    end
    for _,tool in pairs(tools) do
        removeRecoil(tool)
    end
    recoilBtn.Text = "¡SIN RECOIL!"
    wait(1)
    recoilBtn.Text = "🚫 SIN RECOIL 🚫"
end)
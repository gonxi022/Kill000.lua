-- Prison Life MultiHack GUI (Remington 870, M9, AK) - Optimizado 2024

local plr = game.Players.LocalPlayer

-- GUI flotante
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.ResetOnSpawn = false

local function makeBtn(txt, y, col)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 180, 0, 38)
    b.Position = UDim2.new(0, 25, 0, y)
    b.BackgroundColor3 = col or Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 20
    b.Text = txt
    b.Draggable = true
    b.Parent = gui
    return b
end

local killBtn = makeBtn("🔥 KILL ALL 🔥", 170, Color3.fromRGB(220,40,40))
local ammoBtn = makeBtn("∞ BALAS INFINITAS ∞", 220, Color3.fromRGB(40,110,220))
local recoilBtn = makeBtn("🚫 SIN RECOIL 🚫", 270, Color3.fromRGB(60,180,80))

-- Detecta la Remington 870
local function getRemington()
    local tool = nil
    if plr.Character then tool = plr.Character:FindFirstChild("Remington 870") end
    if not tool then tool = plr.Backpack:FindFirstChild("Remington 870") end
    return tool
end

-- KILL ALL
killBtn.MouseButton1Click:Connect(function()
    local gun = getRemington()
    if not gun then
        killBtn.Text = "Equipa Remington"
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
    local count = 0
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= plr and target.Character and target.Character:FindFirstChild("Head") then
            -- PRIMER MÉTODO: FireServer(pos, target)
            local ok, err = pcall(function()
                for i = 1, 8 do
                    remote:FireServer(target.Character.Head.Position, target)
                    wait(0.03)
                end
            end)
            -- MÉTODO ALTERNATIVO: FireServer(pos) solo
            if not ok then
                for i = 1, 8 do
                    remote:FireServer(target.Character.Head.Position)
                    wait(0.03)
                end
            end
            count = count + 1
        end
    end
    killBtn.Text = count > 0 and "Listo!" or "No hay targets"
    wait(1)
    killBtn.Text = "🔥 KILL ALL 🔥"
end)

-- BALAS INFINITAS
ammoBtn.MouseButton1Click:Connect(function()
    local gun = getRemington()
    if not gun then
        ammoBtn.Text = "Equipa Remington"
        wait(1)
        ammoBtn.Text = "∞ BALAS INFINITAS ∞"
        return
    end
    local found = false
    for _, v in pairs(gun:GetChildren()) do
        if v:IsA("IntValue") and v.Name:lower():find("ammo") then
            v.Value = 999
            found = true
        end
    end
    if gun:FindFirstChild("Ammo") then
        gun.Ammo.Value = 999
        found = true
    end
    if gun:FindFirstChild("MaxAmmo") then
        gun.MaxAmmo.Value = 999
        found = true
    end
    ammoBtn.Text = found and "¡AMMO INFINITO!" or "No se pudo"
    wait(1)
    ammoBtn.Text = "∞ BALAS INFINITAS ∞"
end)

-- NO RECOIL
recoilBtn.MouseButton1Click:Connect(function()
    local gun = getRemington()
    if not gun then
        recoilBtn.Text = "Equipa Remington"
        wait(1)
        recoilBtn.Text = "🚫 SIN RECOIL 🚫"
        return
    end
    local ok = false
    if gun:FindFirstChild("Recoil") and gun.Recoil:IsA("NumberValue") then
        gun.Recoil.Value = 0
        ok = true
    end
    for _, s in pairs(gun:GetChildren()) do
        if s:IsA("LocalScript") and s.Name:lower():find("gun") then
            -- Intenta modificar el recoil por código fuente
            pcall(function()
                if s:FindFirstChild("Recoil") then
                    s.Recoil.Value = 0
                    ok = true
                end
                -- No siempre editable, pero se intenta
            end)
        end
    end
    recoilBtn.Text = ok and "¡SIN RECOIL!" or "No se pudo"
    wait(1)
    recoilBtn.Text = "🚫 SIN RECOIL 🚫"
end)
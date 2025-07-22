-- GUI flotante, compatible Android y PC
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,140,0,50)
btn.Position = UDim2.new(0,20,0.5,0)
btn.BackgroundColor3 = Color3.fromRGB(220,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 22
btn.Text = "🔥 KILL ALL 🔥"
btn.Draggable = true
btn.Parent = gui

-- Kill All usando RemoteEvent del arma (funcional Prison Life)
btn.MouseButton1Click:Connect(function()
    local plr = game.Players.LocalPlayer
    local gun = plr.Character and (plr.Character:FindFirstChildOfClass("Tool") or plr.Backpack:FindFirstChildOfClass("Tool"))
    if not gun or not gun:FindFirstChild("GunScript_Local") then
        btn.Text = "Equipa un arma"
        wait(1.2)
        btn.Text = "🔥 KILL ALL 🔥"
        return
    end
    local remote = game.ReplicatedStorage:FindFirstChild("ShootEvent")
    if not remote then
        btn.Text = "No Remote"
        wait(1.2)
        btn.Text = "🔥 KILL ALL 🔥"
        return
    end

    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= plr and target.Character and target.Character:FindFirstChild("Head") then
            for _=1,7 do -- 7 disparos por jugador para asegurar kill
                remote:FireServer(target.Character.Head.Position, target)
                wait(0.07)
            end
        end
    end
    btn.Text = "Listo!"
    wait(1)
    btn.Text = "🔥 KILL ALL 🔥"
end)
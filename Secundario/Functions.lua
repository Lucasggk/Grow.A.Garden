function getmoney()
  return game:GetService("Players").LocalPlayer.leaderstats.Sheckles.Value
end

function sell()
    local p = game.Players.LocalPlayer
    local h = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not h then return end
    local pos = h.Position
    h.CFrame = CFrame.new(87, 3, 0)
    task.wait(0.3)
    game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
    task.wait(0.3)
    h.CFrame = CFrame.new(pos)
end


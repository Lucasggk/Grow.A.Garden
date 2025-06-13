function byallseedfc()
    local p = game:GetService("Players").LocalPlayer
    local f = p.PlayerGui.Seed_Shop.Frame.ScrollingFrame
    local e = game:GetService("ReplicatedStorage").GameEvents.BuySeedStock
    while true do
        local done = true
        for _,s in ipairs(selectedSeeds) do
            local i = f:FindFirstChild(s)
            local t = i and i:FindFirstChild("Main_Frame") and i.Main_Frame:FindFirstChild("Stock_Text")
            if t and t:IsA("TextLabel") and t.Text ~= "X0 Stock" then
                e:FireServer(s)
                done = false
                task.wait(0.1)
            end
        end
        if done then break end
    end
end

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local scrollingFrame = player.PlayerGui.Seed_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(scrollingFrame:GetChildren()) do
            if not string.find(item.Name, "_") then
                local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                    rs.GameEvents.BuySeedStock:FireServer(item.Name)
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.1) -- intervalo geral entre cada varredura
    end
end)

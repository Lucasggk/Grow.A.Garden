repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui") 

task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)


if game.PlaceId ~= 126884695634066 then
    return 
end



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

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local gearScroll = player.PlayerGui.Gear_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(gearScroll:GetChildren()) do
            if item:IsA("Frame") and not table.find({ "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot" }, item.Name) then
                local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                    rs.GameEvents.BuyGearStock:FireServer(item.Name)
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.5)
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg
local pet = {1, 2, 3}

task.spawn(function()
    while true do
        local t = tick()
        local waitTime = 60 - (t % 60)
        task.wait(waitTime) -- espera até o minuto virar

        for i = 1, 3 do
            for _, pt in ipairs(pet) do
                buyPet:FireServer(pt)
            end
            task.wait(0.1)
        end
    end
end)

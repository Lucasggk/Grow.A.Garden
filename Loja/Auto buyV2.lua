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
        task.wait(0.1) 
    end
end)

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local gearScroll = player.PlayerGui.Gear_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(gearScroll:GetChildren()) do
            if item:IsA("Frame") and not table.find({ "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Magnifying Glass" }, item.Name) then
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

local buyPet = game:GetService("ReplicatedStorage").GameEvents.BuyPetEgg

local petNames = {
    "Common Egg", "Common Summer Egg", "Rare Summer Egg",
    "Mythical Egg", "Paradise Egg", "Bug Egg"
}

task.spawn(function()
    while true do
        local t = tick()
        local waitTime = 60 - (t % 60)
        task.wait(waitTime)

        for i = 1, 3 do
            for _, name in ipairs(petNames) do
                buyPet:FireServer(name)
            end
            task.wait(0.1)
        end
    end
end)

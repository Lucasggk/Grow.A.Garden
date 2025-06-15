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

game:GetService("StarterGui"):SetCore("SendNotification",{Title="Script Executado",Text="O script foi iniciado com sucesso!",Duration=5})

-- false compra
-- true ignora

local ignoreNames = {
    -- Sementes
    ["Carrot"] = false,
    ["Strawberry"] = false,
    ["Blueberry"] = false,
    ["Orange Tulip"] = false,
    ["Tomato"] = false,
    ["Corn"] = false,
    ["Daffodil"] = false,
    ["Watermelon"] = false,
    ["Pumpkin"] = false,
    ["Apple"] = false,
    ["Bamboo"] = false,
    ["Coconut"] = false,
    ["Cactus"] = false,
    ["Dragon Fruit"] = false,
    ["Mango"] = false,
    ["Grape"] = false,
    ["Mushroom"] = false,
    ["Pepper"] = false,
    ["Cacao"] = false,
    ["Beanstalk"] = false,
    ["Ember Lily"] = false,
    ["Sugar Apple"] = false,

    -- Gears
    ["Watering Can"] = false,
    ["Trowel"] = false,
    ["Recall Wrench"] = false,
    ["Basic Sprinkler"] = false,
    ["Advanced Sprinkler"] = false,
    ["Godly Sprinkler"] = false,
    ["Lightning Rod"] = false,
    ["Master Sprinkler"] = false,
    ["Cleaning Spray"] = true,
    ["Favorite Tool"] = true,
    ["Harvest Tool"] = true,
    ["Friendship Pot"] = true,
}

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local scrollingFrame = player.PlayerGui.Seed_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(scrollingFrame:GetChildren()) do
            if not string.find(item.Name, "_") then
                if not ignoreNames[item.Name] then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuySeedStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            else
                local baseName = item.Name:gsub("_P", "")
                if not (string.find(item.Name, "_P") and ignoreNames[baseName]) then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuySeedStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

local gearScroll = player.PlayerGui.Gear_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(gearScroll:GetChildren()) do
            if item:IsA("Frame") then
                if not ignoreNames[item.Name] and not string.find(item.Name, "_P") then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuyGearStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

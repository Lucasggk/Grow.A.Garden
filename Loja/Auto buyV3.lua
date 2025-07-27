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

local ignoreNames = {
    -- Sementes
    ["Carrot"] = true,
    ["Strawberry"] = true,
    ["Blueberry"] = true,
    ["Orange Tulip"] = true,
    ["Tomato"] = true,
    ["Corn"] = true,
    ["Daffodil"] = true,
    ["Watermelon"] = true,
    ["Pumpkin"] = true,
    ["Apple"] = true,
    ["Bamboo"] = true,
    ["Coconut"] = true,
    ["Cactus"] = true,
    ["Dragon Fruit"] = true,
    ["Mango"] = true,
    ["Grape"] = true,
    ["Mushroom"] = true,
    ["Pepper"] = true,
    ["Cacao"] = true,
    ["Beanstalk"] = true,
    ["Ember Lily"] = true,
    ["Sugar Apple"] = true,
    ["Burning Bud"] = true,
    ["Giant Pinecone"] = true,
    ["Elder Strawberry"] = true,

    -- Gears
    ["Watering Can"] = true,
    ["Trowel"] = true,
    ["Recall Wrench"] = true,
    ["Basic Sprinkler"] = true,
    ["Advanced Sprinkler"] = true,
    ["Medium Toy"] = true,
    ["Medium Treat"] = true,
    ["Godly Sprinkler"] = true,
    ["Lightning Rod"] = true,
    ["Master Sprinkler"] = true,
    ["Cleaning Spray"] = false,
    ["Favorite Tool"] = false,
    ["Harvest Tool"] = false,
    ["Friendship Pot"] = false,
    ["Levelup Lollipop"] = true,
}

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local scrollingFrame = player.PlayerGui.Seed_Shop.Frame.ScrollingFrame

task.spawn(function()
    while true do
        for _, item in ipairs(scrollingFrame:GetChildren()) do
            if not string.find(item.Name, "_") then
                if ignoreNames[item.Name] then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuySeedStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            else
                local baseName = item.Name:gsub("_P", "")
                if string.find(item.Name, "_P") and ignoreNames[baseName] then
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
                if ignoreNames[item.Name] and not string.find(item.Name, "_P") then
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

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
--local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
--local buyMoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local seed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"}

local gear = {
    "Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Medium Toy", "Medium Treat", "Grandmaster Sprinkler", "Levelup Lollipop",
    "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Tanning Mirror"
}

--[[
local bloodlit = {"Mysterious Crate", "Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Star Caller", "Blood Owl"}
local moonlit = {"Night Egg", "Night Seed Pack", "Twilight Crate", "Star Caller", "Moon Cat", "Celestiberry", "Moon Mango"}
]]

local pet = {1, 2, 3}

function s()
    for _, sd in ipairs(seed) do
        buySeed:FireServer(sd)
    end
end

function g()
    for _, gr in ipairs(gear) do
        buyGear:FireServer(gr)
    end
end

--[[
function b()
    for _, bl in ipairs(bloodlit) do
        buyMoon:FireServer(bl)
    end
end

function m()
    for _, ml in ipairs(moonlit) do
        buyMoon2:FireServer(ml)
    end
end
]]

function p()
    local petNames = {
        "Common Egg", "Common Summer Egg", "Rare Summer Egg",
        "Mythical Egg", "Paradise Egg", "Bug Egg"
    }

    for i = 1, 3 do
        for _, name in ipairs(petNames) do
            buyPet:FireServer(name)
        end
        task.wait()
    end
end

function buyall()
    s()
    g()
    --b()
    --m()
    p()
end

task.spawn(function()
    local ultimoMinuto = -1
    while true do
        local minuto = os.date("*t").min
        if minuto % 5 == 0 and minuto ~= ultimoMinuto then
            ultimoMinuto = minuto
            for i = 1, 30 do
                task.spawn(buyall)
                task.wait(0.05)
            end
        end
        task.wait(1)
    end
end)

-- Script Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

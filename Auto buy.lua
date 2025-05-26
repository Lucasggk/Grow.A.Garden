local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buyMoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local seeds = {
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"
}

local gears = {
    "Watering Can", "Trowel", "Recall Wrench",
    "Basic Sprinkler", "Advanced Sprinkler",
    "Godly Sprinkler", "Lightning Rod", "Master Sprinkler"
}

local moonItems = {
    "Night Seed Pack", "Night Egg", "Blood Banana",
    "Moon Melon", "Star Caller", "Blood Owl"
}

local moonItems2 = {
    "Night Egg", "Night Seed Pack", "Star Caller", "Celestiberry"
}

local pets = {1, 2, 3}

local function comprarTudo()
    for i = 1, 50 do
        for _, seed in ipairs(seeds) do
            buySeed:FireServer(seed)
        end
        for _, gear in ipairs(gears) do
            buyGear:FireServer(gear)
        end
        for _, moon in ipairs(moonItems) do
            buyMoon:FireServer(moon)
        end
        for _, moon2 in ipairs(moonItems2) do
            buyMoon2:FireServer(moon2)
        end
        for _, pet in ipairs(pets) do
            buyPet:FireServer(pet)
        end
        task.wait(0.1)
    end
end

while true do
    local minutos = os.date("*t").min
    if minutos % 5 == 0 then
        comprarTudo()
        repeat task.wait(1) until os.date("*t").min % 5 ~= 0
    end
    task.wait(1)
end

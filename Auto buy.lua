local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buymoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local seed = {"Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local moon = { "Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Star Caller", "Blood Owl"}
local moon2 = {"Night Egg", "Night Seed Pack", "Star Caller", "Celestiberry"}
local gear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler"}
local pet = {1, 2, 3}

function buy()
  for i = 1, 50 do
    for _, se in ipairs(seed) do
      buySeed:FireServer(se)
    end 
    for _, ge in ipairs(gear) do
      buyGear:FireServer(ge)
    end 
    for _, mo in ipairs(moon) do
      buyMoon:FireServer(mo)
    end 
    for _, mo2 in ipairs(moon2) do
      buyMoon2:FireServer(mo2)
    end  
    for _, pe in ipairs(pet) do 
            buyPet:FireServer(pe)
    end
    task.wait()
  end
end

local lastMinute = -1

while true do
    task.wait(0.5) 
    local minute = os.date("*t").min

    if minute % 5 == 0 and minute ~= lastMinute then
        Buy()
        lastMinute = minute
    end
end




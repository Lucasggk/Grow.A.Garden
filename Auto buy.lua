local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buyMoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local seed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local gear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler"}
local bloodlit = {"Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Blood Owl"}
local moonlit = {"Night Egg", "Night Seed Pack", "Celestiberry"}
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

function p() 
for i = 1, 3 do
  for _, pt in ipairs(pet) do
    buyPet:FireServer(pt)
  end
task.wait()
end
end

function buyall()
  for i = 1, 50 do
    s()
    g()
    b()
    m()
    p()
    task.wait(0.05)
  end
end

task.spawn(function()
	local ultimoMinuto = -1
	while true do
		local minuto = os.date("*t").min
		if minuto % 5 == 0 and minuto ~= ultimoMinuto then
			ultimoMinuto = minuto
			buyall()
		end
		task.wait(1)
	end
end)

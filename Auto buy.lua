local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buymoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

function g()
	return {
		seed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"},
		gear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler"},
		bloodlit = {"Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Blood Owl"},
		moonlit = {"Night Egg", "Night Seed Pack", "Celestiberry"},
		buypet = true
	}
end

local data = g()

local seed = data.seed
local gear = data.gear
local bloodlit = data.bloodlit
local moonlit = data.moonlit
local pet = {0}
if data.buypet then
	pet = {1, 2, 3}
end

function s() 
	for _, sd in ipairs(seed) do
		buySeed:FireServer(sd)
	end
end

function gfunc() 
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
		buymoon2:FireServer(ml)
	end
end

function p() 
	for _, p in ipairs(pet) do
		buyPet:FireServer(p)
	end
end

function buyall()
	for i = 1, 50 do
		s()
		gfunc()
		b()
		m()
		p()
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

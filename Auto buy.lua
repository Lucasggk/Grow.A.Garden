local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buymoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local buyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local seed = g().seed
local gear = g().gear
local bloodlit = g().bloodlit
local moonlit = g().moonlit
local pet = {0}
if g().buypet then
	pet = {1, 2, 3}
end

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
	for _, p in ipairs(pet) do
		buyPet:FireServer(p)
	end
end

function buyall()
	for i = 1, 50 do
		s()
		g()
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

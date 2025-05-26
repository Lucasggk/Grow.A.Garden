-- locais exenciais 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- locais do script game

local buySeed = ReplicatedStorage.GameEvents.BuySeedStock

-- locais de listagem

local nseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}

-- locais de locais 

local farm = hrp.Position
local pos = hrp.CFrame

local lote1 = Vector3.new(33.371002197265625, 2.999999761581421, -64.72699737548828)
local lote2 = Vector3.new(-101.6290054321289, 3, -64.72621154785156)
local lote3 = Vector3.new(-235.37002563476562, 2.999999761581421, -61.78000259399414)
local lote4 = Vector3.new(34.629005432128906, 2.999999761581421, 36.78675842285156)
local lote5 = Vector3.new(-100.3709945678711, 2.999999761581421, 36.793582916259766)

local plant_lote
local tp_lote 

-- locais de funções 

function tpCF(localizacao)
  hrp.CFrame = CFrame.new(localizacao)
end

function tpV3(x, y, z)
  hrp.CFrame = CFrame.new(Vector3.new(x, y, z))
end

-- local de verificação 


if farm == lote1 then
  plan_lote = Vector3.new(42.18696975708008, 0.13552513718605042, -76.71431732177734)
  tp_lote = 33.371002197265625, 2.999999761581421, -64.72699737548828
  print("Lote atual: 1")

elseif farm == lote2 then
  plan_lote = Vector3.new(-91.24068450927734, 0.13552513718605042, -76.4989242553711)
  tp_lote = -101.6290054321289, 3, -64.72621154785156
  print("Lote atual: 2")

elseif farm == lote3 then
  plan_lote = Vector3.new(-227.4713897705078, 0.13552513718605042, -77.53561401367188)
  tp_lote = -235.37002563476562, 2.999999761581421, -61.78000259399414
  print("Lote atual: 3")

elseif farm == lote4 then
  plan_lote = Vector3.new(-227.4713897705078, 0.13552513718605042, -77.53561401367188)
  tp_lote = 34.629005432128906, 2.999999761581421, 36.78675842285156
  print("Lote atual: 4")

elseif farm == lote5 then
  plan_lote = Vector3.new(25.35358428955078, 0.13552513718605042, 49.66905212402344)
  tp_lote = -100.3709945678711, 2.999999761581421, 36.793582916259766
  print("Lote atual: 5")

else
  print("hop server")
end



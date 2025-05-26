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

local lote1 = {33.371002197265625, 2.999999761581421, -64.72699737548828}
local lote2 = {-101.6290054321289, 3, -64.72621154785156}
local lote3 = {-235.37002563476562, 2.999999761581421, -61.78000259399414}
local lote4 = {34.629005432128906, 2.999999761581421, 36.78675842285156}
local lote5 = {-100.3709945678711, 2.999999761581421, 36.793582916259766}
local lote6

local plant_lote

-- locais de funções 

function tp(localizacao)
  hrp.CFrame = CFrame.new(localizacao)
end

-- local de verificação 

if farm == lote1 then
  plan_lote = Vector3.new()
elseif farm == lote2 then
  plan_lote = Vector3.new()
elseif farm == lote3 then
  plan_lote = Vector3.new()
elseif farm == lote4 then
  plan_lote = Vector3.new()
elseif farm == lote5 then
  plan_lote = Vector3.new()
elseif farm == lote6 then
  plan_lote = Vector3.new()
else
  plan_lote = nil
end
  

-- locais exenciais 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- locais do script game



-- locais de listagem

local nseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}

-- locais de locais 

local farm = hrp.Position
local pos = hrp.CFrame

local lote1
local lote2
local lote3
local lote4 = {34.629005432128906, 2.999999761581421, 36.78675842285156}
local lote5
local lote6

local plant_lote

-- locais de funções 

function tp(localizacao)
  hrp.CFrame = CFrame.new(localizacao)
end

-- local de verificação 



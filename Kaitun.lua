-- locais exenciais 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

-- locais do script game

local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local coin = game:GetService("Players").LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Sheckles").Value
local Plant = ReplicatedStorage.GameEvents.Plant_RE

-- locais de listagem

local nseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local eseed = {"Carrot seed", "Strawberry seed", "Blueberry seed", "Orange Tulip seed", "Tomato seed", "Corn seed", "Daffodil seed", "Watermelon seed", "Pumpkin seed", "Apple seed", "Bamboo seed", "Coconut seed", "Cactus seed", "Dragon Fruit seed", "Mango seed", "Grape seed", "Mushroom seed", "Pepper seed", "Cacao seed", "Beanstalk seed"}

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

function ct()
  local coin = game:GetService("Players").LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Sheckles").Value
end

function bseed()
  for i = 1, 50 do
    for _, seed in ipairs(nseed) do
      buySeed:FireServer(seed)
      task.wait()
    end
  end
end

function eq(name)
    name = name:lower()
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find(name) then
            char.Humanoid:EquipTool(item)
            return
        end
    end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find(name) then
            char.Humanoid:EquipTool(item)
            return
        end
    end
end

function plantseed()
  for i = 1, 25 do
    for j = 1, #nseed do
      local planta = nseed[j]
      eq(eseed[j])
      task.wait(0.025)
      local randX = plan_lote.X + math.random(-250, 250) / 1000
      local randZ = plan_lote.Z + math.random(-250, 250) / 1000
      local pos = Vector3.new(randX, plan_lote.Y, randZ)
      Plant:FireServer(pos, planta)
      task.wait(0.05)
    end
  end
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



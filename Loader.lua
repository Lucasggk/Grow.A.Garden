local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plant = ReplicatedStorage.GameEvents.Plant_RE
local fruta = G().fru
local x = G().x
local y = G().y

local corner1 = x
local corner2 = y

local step = 0.2 -- distância mínima entre plantações
local y = corner1.Y -- manter a altura constante

local minX = math.min(corner1.X, corner2.X)
local maxX = math.max(corner1.X, corner2.X)
local minZ = math.min(corner1.Z, corner2.Z)
local maxZ = math.max(corner1.Z, corner2.Z)

for x = minX, maxX, step do
    for z = minZ, maxZ, step do
        local pos = Vector3.new(x, y, z)
        Plant:FireServer(pos, fruta)
        task.wait() -- sem delay pra plantar rápido
    end
end

task.wait(0.1) -- 

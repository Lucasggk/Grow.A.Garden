local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plant = ReplicatedStorage.GameEvents.Plant_RE
local fruta = g().fruta
local posi = g().posi
local startPos = Vector3.new(posi)
local endPos = Vector3.new(posi)
local step = 0.001 -- distância mínima entre plantações (muito pequeno)
local direction = (endPos - startPos).Unit
local distance = (endPos - startPos).Magnitude

for i = 0, distance, step do
    local pos = startPos + direction * i
    Plant:FireServer(pos, fruta)
    task.wait(0.0001) -- sem delay pra plantar rápido
end

task.wait(0) -- mini delay final

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plant = ReplicatedStorage.GameEvents.Plant_RE
local fruta = g().fruta
local posi = g().posi

-- Mantém a altura (Y) e faz variação de 0.5 studs para os lados no eixo X
local startPos = Vector3.new(posi.X - 0.5, posi.Y, posi.Z)
local endPos = Vector3.new(posi.X + 0.5, posi.Y, posi.Z)

local step = 0.0005
local direction = (endPos - startPos).Unit
local distance = (endPos - startPos).Magnitude

for i = 0, distance, step do
    local pos = startPos + direction * i
    Plant:FireServer(pos, fruta)
    task.wait(0.0001)
end

task.wait(0)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local sellf = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
local sellm = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitAllPlants")

function savepos()
    Pos = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
end

function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

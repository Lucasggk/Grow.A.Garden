local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sellfruits = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
local sellmoons = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer(unpack("SubmitAllPlants"))
local hrp = character:WaitForChild("HumanoidRootPart")
local tps = game:GetService("TeleportService")

function savepos()
  Pos = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
end

function tps(pos)
  tps(pos)
end

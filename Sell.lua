local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sellfruits = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
local sellmoons = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer(unpack("SubmitAllPlants"))
local hrp = character:WaitForChild("HumanoidRootPart")

function savepos()
  Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)

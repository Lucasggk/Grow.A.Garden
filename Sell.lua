local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sellfruits = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
local sellmoons = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer(unpack("SubmitAllPlants"))

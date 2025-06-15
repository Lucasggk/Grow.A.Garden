repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui") 

task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)


if game.PlaceId ~= 126884695634066 then
    return 
end

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local scrollingFrame = player.PlayerGui.Seed_Shop.Frame.ScrollingFrame

local ignoreNames = {
    ["Carrot"] = true,
    ["Strawberry"] = true,
    ["Blueberry"] = true,
    ["Orange Tulip"] = true,
    ["Tomato"] = true,
    ["Corn"] = true,
    ["Daffodil"] = true,
    ["Watermelon"] = true,
    ["Pumpkin"] = true,
    ["Apple"] = true,
    ["Bamboo"] = true,
    ["Coconut"] = true,
    ["Cactus"] = true,
    ["Dragon Fruit"] = true,
    ["Mango"] = true,
    ["Grape"] = false,
    ["Mushroom"] = false,
    ["Pepper"] = false,
    ["Cacao"] = false,
    ["Beanstalk"] = false,
    ["Ember Lily"] = false,
    ["Sugar Apple"] = false,
}

task.spawn(function()
    while true do
        for _, item in ipairs(scrollingFrame:GetChildren()) do
            if not string.find(item.Name, "_") then
                if not ignoreNames[item.Name] then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuySeedStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            else
                local baseName = item.Name:gsub("_P", "")
                if not (string.find(item.Name, "_P") and ignoreNames[baseName]) then
                    local stock = item:FindFirstChild("Main_Frame") and item.Main_Frame:FindFirstChild("Stock_Text")
                    if stock and stock:IsA("TextLabel") and stock.Text ~= "X0 Stock" then
                        rs.GameEvents.BuySeedStock:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

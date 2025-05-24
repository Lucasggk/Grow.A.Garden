#Grow a garden 

## Plantação 


```lua
setclipboard([[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plant = ReplicatedStorage.GameEvents.Plant_RE

local planta = "Carrot"

local x = Vector3.new(34.14344024658203, 0.13552513718605042, -112.62083435058594) --inicio
local y = Vector3.new(31.82763671875, 0.13552513718605042, -112.6816635131836) --fim

local step = 0.001
local direction = (y - x).Unit
local distance = (y - x).Magnitude

for i = 0, distance, step do
    local pos = x + direction * i
    Plant:FireServer(pos, planta)
    task.wait()
end

task.wait(0.1)
]])
```


## Auto buy


```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock

local seeds = {
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Beanstalk", "Pepper", "Cacao"
}

local gears = {
    "Watering Can",
    "Basic Sprinkler",
    "Advanced Sprinkler",
    "Godly Sprinkler",
    "Master Sprinkler",
    "Lightning Rod"
}

local moonItems = {
    "Blood Owl",
    "Blood Kiwi",
    "Blood Hedgehog",
    "Star Caller",
    "Moon Melon",
    "Blood Banana",
    "Night Egg",
    "Night Seed Pack",
    "Mysterious Crate"
}

local function comprarItens()
    for i = 1, 50 do
        for _, seed in ipairs(seeds) do
            buySeed:FireServer(seed)
        end
        for _, gear in ipairs(gears) do
            buyGear:FireServer(gear)
        end
        for _, item in ipairs(moonItems) do
            buyMoon:FireServer(item)
        end
        task.wait(0.1)
    end
end

while true do
    local minutos = os.date("*t").min
    if minutos % 5 == 0 then
        comprarItens()
        repeat task.wait(1) until os.date("*t").min % 5 ~= 0
    end
    task.wait(1)
end
end
```

# testes pata hub

```lua
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Menu Flutuante",
    SubTitle = "Clique no botão para abrir/fechar",
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark"
})

Window:Hide()

local ToggleUI = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")

ToggleUI.Name = "FloatingToggleUI"
ToggleUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.92, 0, 0.85, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
ToggleButton.Image = "rbxassetid://94979807066345"
ToggleButton.ScaleType = Enum.ScaleType.Fit
ToggleButton.ZIndex = 999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.Parent = ToggleUI

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
end)

ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
end)

local UIVisible = false

ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    if UIVisible then
        Window:Show()
    else
        Window:Hide()
    end
end)
```

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

# testes para hub

```lua
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden | ",
    SubTitle = "    Made by Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

-- Local Tabs --
local loja = Window:AddTab({
    Title = "loja",
    Icon = "home"
})

-- Local Variáveis --
local byallseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local byallmoon = {"Blood Owl", "Blood Kiwi", "Blood Hedgehog", "Star Caller", "Moon Melon", "Blood Banana", "Night Egg", "Night Seed Pack", "Mysterious Crate"}
local bygear = {"Watering Can", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Harvest Tool"}

local bsa = false
local bsm = false
local bsg = false

local selectedSeeds = {}
local selectedMoons = {}
local selectedGears = {}

-- Local functions --
function byallseedfc()
    for i = 1, 50 do
        for _, seed in ipairs(selectedSeeds) do
            buySeed:FireServer(seed)
        end
    end
end

function byallmoonfc()
    for i = 1, 50 do
        for _, moon in ipairs(selectedMoons) do
            buyMoon:FireServer(moon)
        end
    end
end

function byallgearfc()
    for i = 1, 50 do
        for _, gear in ipairs(selectedGears) do
            buyGear:FireServer(gear)
        end
    end
end

-- Local Script --

local section = loja:AddSection("Seeds")

loja:AddToggle("", {
    Title = "Buy all shop seed",
    Description = "Buy all shop seed",
    Default = false,
    Callback = function(Value)
        bsa = Value
    end
})

local dropdownSeed = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione seeds para comprar\n",
    Description = "Selecione seeds para comprar\n",
    Values = byallseed,
    Multi = true,
    Default = {},
})

dropdownSeed:OnChanged(function(Value)
    selectedSeeds = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedSeeds, v)
        end
    end
end)

local section = loja:AddSection("Moons")

loja:AddToggle("", {
    Title = "Buy all shop moon",
    Description = "Buy all shop moon",
    Default = false,
    Callback = function(Value)
        bsm = Value
    end
})

local dropdownMoon = loja:AddDropdown("DropdownMoon", {
    Title = "Selecione itens da loja moon\n",
    Description = "Selecione itens da loja moon\n",
    Values = byallmoon,
    Multi = true,
    Default = {},
})

dropdownMoon:OnChanged(function(Value)
    selectedMoons = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedMoons, v)
        end
    end
end)

local section = loja:AddSection("Gears")

loja:AddToggle("", {
    Title = "Buy shop gear",
    Description = "Buy shop gear",
    Default = false,
    Callback = function(Value)
        bsg = Value
    end
})

local dropdownGear = loja:AddDropdown("DropdownGear", {
    Title = "Selecione gears para comprar\n",
    Description = "Selecione gears para comprar\n",
    Values = bygear,
    Multi = true,
    Default = {},
})

dropdownGear:OnChanged(function(Value)
    selectedGears = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedGears, v)
        end
    end
end)

task.spawn(function()
    while true do
        local minutos = os.date("*t").min
        if minutos % 5 == 0 then
            if bsa then
                byallseedfc()
            end
            if bsm then
                byallmoonfc()
            end
            if bsg then
                byallgearfc()
            end
            repeat task.wait(1) until os.date("*t").min % 5 ~= 0
        end
        task.wait(1)
    end
end)
```

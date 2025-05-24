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
local selectedGears = {}

-- Local functions --

function byallseedfc()
    for i = 1, 50 do
        for _, seed in ipairs(byallseed) do
            buySeed:FireServer(seed)
        end
    end
end

function byallmoonfc()
    for i = 1, 50 do
        for _, moon in ipairs(byallmoon) do
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

loja:AddToggle("", {
    Title = "Buy all shop seed",
    Description = "Buy all shop seed",
    Default = false,
    Callback = function(Value)
        bsa = Value
    end
})

loja:AddToggle("", {
    Title = "Buy all shop moon",
    Description = "Buy all shop moon",
    Default = false,
    Callback = function(Value)
        bsm = Value
    end
})

loja:AddToggle("", {
    Title = "Buy shop gear",
    Description = "Buy shop gear",
    Default = false,
    Callback = function(Value)
        bsg = Value
    end
})

local Dropdown = loja:AddDropdown("MultiDropdown", {
    Title = "Selecione gears para comprar",
    Description = "Selecione gears para comprar",
    Values = bygear,
    Multi = true,
    Default = {},
})

Dropdown:OnChanged(function(Value)
    selectedGears = {}
    for gear, state in pairs(Value) do
        if state then
            table.insert(selectedGears, gear)
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

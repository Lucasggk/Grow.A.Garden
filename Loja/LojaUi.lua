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





local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local allowedIds = {
    [5557980719] = true,
    [2400571180] = true,
    [2000903030] = true,
}

if not allowedIds[localPlayer.UserId] then
    localPlayer:Kick("Você não tem permissão para usar este script.")
end





loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BlueLock/refs/heads/main/Fix.name.ui.lua"))() 

local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local BuyPet = ReplicatedStorage.GameEvents.BuyPetEgg

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/alpha.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden |",
    SubTitle = "Made by Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true,
})

local loja = Window:AddTab({
    Title = "loja",
    Icon = "home"
})

local byallseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud"}


local bygear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot"}

local bsa = false
local bsg = false
local bsp = false 

local selectedSeeds = {}
local selectedGears = {}
local buypets = {1, 2, 3}

function byallseedfc()
    for i = 1, 25 do
        for _, seed in ipairs(selectedSeeds) do
            buySeed:FireServer(seed)
            task.wait()
        end
    end
end

function byallgearfc()
    for i = 1, 25 do
        for _, gear in ipairs(selectedGears) do
            buyGear:FireServer(gear)
            task.wait()
        end
    end
end

function buypetegg()
    for i = 1, 3 do
        for _, pet in ipairs(buypets) do 
            BuyPet:FireServer(pet)
            task.wait()
        end
    end
end

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
    for seedName, selected in pairs(Value) do
        if selected then
            table.insert(selectedSeeds, seedName)
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
    for gearName, selected in pairs(Value) do
        if selected then
            table.insert(selectedGears, gearName)
        end
    end
end)

local section = loja:AddSection("Pets buy")

loja:AddButton({
    Title = "comprar todos pets",
    Description = "auto se explica",
    Callback = function()
        buypetegg()
    end
})

loja:AddToggle("", {
    Title = "comprar todos pets afk",
    Description = "auto se explica",
    Default = false,
    Callback = function(value)
        bsp = value
    end
})

local event = Window:AddTab({
    Title = "Eventos",
    Icon = "list"
})

local byallBee = { "Flower Seed Pack", "Lavender", "Nectarshade", "Nectarine", "Hive Fruit", "Pollen Radar", "Nectar Staff", "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway" }

local buyBee = game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock
local selectedBees = {}
local bsb = false

function byallbeefc()
    for i = 1, 25 do
        for _, bee in ipairs(selectedBees) do
            buyBee:FireServer(bee)
            task.wait()
        end
    end
end

local section = event:AddSection("Shop Honey")

event:AddToggle("", {
    Title = "Buy all Bee Shop",
    Description = "Buy all Bee shop",
    Default = false,
    Callback = function(Value)
        bsb = Value
    end
})

local dropdownBee = event:AddDropdown("DropdownSeed", {
    Title = "Selecione Beeshop para comprar\n",
    Description = "Selecione Beeshop para comprar\n",
    Values = byallBee,
    Multi = true,
    Default = {},
})

dropdownBee:OnChanged(function(Value)
    selectedBees = {}
    for beeName, selected in pairs(Value) do
        if selected then
            table.insert(selectedBees, beeName)
        end
    end
end)

task.spawn(function()
    local lastMinute = -1
    while true do
        local minutos = os.date("*t").min
        if minutos ~= lastMinute then
            lastMinute = minutos
            if bsb then
                task.spawn(byallbeefc)
            end
            if bsa then
                task.spawn(byallseedfc)
            end
            if bsg then
                task.spawn(byallgearfc)
            end
            if bsp then
                task.spawn(buypetegg)
            end
        end
        task.wait(1)
    end
end)

event:AddButton({
    Title = "Honey Shop UI",
    Description = "Ativa/Desativa a loja de Honey",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.HoneyEventShop_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Honey Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

event:AddSection("Summer")

local function submitalls()
    local args = {
        [1] = "SubmitAllPlants"
    }
    game:GetService("ReplicatedStorage").GameEvents.SummerHarvestRemoteEvent:FireServer(unpack(args))
end

local tsas = 5
event:AddSlider("Slider", {
    Title = "Delay to submit all",
    Description = "",
    Default = tsas,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(v)
        tsas = v
    end
})

_G.AutoUsarItens = false

event:AddToggle("AutoUsarItens", {
    Title = "Auto Usar Itens",
    Default = false,
    Callback = function(Value)
        _G.AutoUsarItens = Value
        task.spawn(function()
            while _G.AutoUsarItens do
                submitalls()
                task.wait(tsas)
            end
        end)
    end
})

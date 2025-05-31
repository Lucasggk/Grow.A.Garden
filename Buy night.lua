local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buyMoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock

local byallmoon = {"Mysterious Crate", "Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Star Caller", "Blood Hedgehog", "Blood Kiwi", "Blood Owl"}
local byallmoon2 = {"Night Egg", "Night Seed Pack", "Twilight Crate", "Star Caller", "Moon Cat", "Celestiberry", "Moon Mango"}

local bsm = false
local bsm2 = false
local selectedMoons = {}
local selectedMoons2 = {}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/FluentPlus/main/Loader.lua"))() -- exemplo, adapte para seu GUI
local loja = library:CreateWindow("Bloodlit moon shop")

local function byallmoonfc()
    for i = 1, 25 do
        for _, moon in ipairs(selectedMoons) do
            buyMoon:FireServer(moon)
            task.wait()
        end
    end
end

local function byallmoon2fc()
    for i = 1, 25 do
        for _, moon2 in ipairs(selectedMoons2) do
            buyMoon2:FireServer(moon2)
            task.wait()
        end
    end
end

local section1 = loja:AddSection("Bloodlit moon shop")

loja:AddToggle("", {
    Title = "Buy all shop Bloodlit",
    Description = "Buy all shop moon",
    Default = false,
    Callback = function(value)
        bsm = value
        if bsm then byallmoonfc() end
    end,
})

local dropdownMoon = loja:AddDropdown("DropdownMoon", {
    Title = "Selecione itens da loja moon",
    Description = "Selecione itens da loja moon",
    Values = byallmoon,
    Multi = true,
    Default = {},
})

dropdownMoon:OnChanged(function(value)
    selectedMoons = {}
    for v, state in pairs(value) do
        if state then
            table.insert(selectedMoons, v)
        end
    end
end)

local section2 = loja:AddSection("Moonlit moon shop")

loja:AddToggle("", {
    Title = "Buy all shop moonlit",
    Description = "Buy all shop seed",
    Default = false,
    Callback = function(value)
        bsm2 = value
        if bsm2 then byallmoon2fc() end
    end,
})

local dropdownMoon2 = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione seeds para comprar",
    Description = "Selecione seeds para comprar",
    Values = byallmoon2,
    Multi = true,
    Default = {},
})

dropdownMoon2:OnChanged(function(value)
    selectedMoons2 = {}
    for v, state in pairs(value) do
        if state then
            table.insert(selectedMoons2, v)
        end
    end
end)

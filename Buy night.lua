local buyMoon = ReplicatedStorage.GameEvents.BuyEventShopStock
local buymoon2 = ReplicatedStorage.GameEvents.BuyNightEventShopStock
local byallmoon = {"Mysterious Crate", "Night Seed Pack", "Night Egg", "Blood Banana", "Moon Melon", "Star Caller", "Blood Hedgehog", "Blood Kiwi", "Blood Owl"}
local byallmoon2 = {"Night Egg", "Night Seed Pack", "Twilight Crate", "Star Caller", "Moon Cat", "Celestiberry", "Moon Mango"}
local bsm = false
local bsm2 = false
local selectedMoons = {}
local selectedMoons2 = {}

function byallmoonfc()
    for i = 1, 25 do
        for _, moon in ipairs(selectedMoons) do
            buyMoon:FireServer(moon)
            task.wait()
        end
    end
end

function byallmoon2fc()
    for i = 1, 25 do
        for _, moon2 in ipairs(selectedMoons2) do
            buymoon2:FireServer(moon2)
            task.wait()
        end
    end
end

local section = loja:AddSection("Bloodlit moon shop")

loja:AddToggle("", {
    Title = "Buy all shop Bloodlit",
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

local section = loja:AddSection("Moonlit moon shop")

loja:AddToggle("", {
    Title = "Buy all shop moonlit",
    Description = "Buy all shop seed",
    Default = false,
    Callback = function(Value)
        bsm2 = Value
    end
})

local dropdownMoon2 = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione seeds para comprar\n",
    Description = "Selecione seeds para comprar\n",
    Values = byallmoon2,
    Multi = true,
    Default = {},
})

dropdownMoon2:OnChanged(function(Value)
    selectedMoons2 = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedMoons2, v)
        end
    end
end)

-- isto é para adicionar no script teste.lua caso a loja volte


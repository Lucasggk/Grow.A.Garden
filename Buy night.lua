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

local vful = getgenv().vers or "h"

local Windowuimoon = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()

local Window = Windowuimoon:CreateWindow({
    Title = "Moon event |",
    SubTitle = "Made by Lucas | Version: " .. vful,
    TabWidth = 120,
    Size = UDim2.fromOffset(390, 390),
    Acrylic = false,
    Theme = "Dark",
})

local loja = Window:AddTab({ Title = "Loja", Icon = "home" })
local ui = Window:AddTab({ Title = "UIs", Icon = "list" })
local sell = Window:AddTab({ Title = "Sell", Icon = "list" })
local event = Window:AddTab({ Title = "Event", Icon = "list" })
local config = Window:AddTab({ Title = "Config", Icon = "settings" })

config:AddButton({
    Title = "Delete ui",
    Callback = function()
        Window:Destroy()
    end
})



local buyMoon = game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock
local buymoon2 = game:GetService("ReplicatedStorage").GameEvents.BuyNightEventShopStock
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

ui:AddButton({
    Title = "BloodMoon Shop UI | não funcionando",
    Description = "Ativa/Desativa a loja BloodMoon",
    Callback = function()
        local eventShop = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EventShop_UI")
        if eventShop then
            eventShop.Enabled = not eventShop.Enabled  -- Inverte o estado atual
            print("BloodMoon Shop UI:", eventShop.Enabled and "Ativada" or "Desativada")
        else
            warn("EventShop_UI não encontrada!")
        end
    end
})


ui:AddButton({
    Title = "Moonlit Shop UI | não funcionando",
    Description = "Ativa/Desativa a loja Moonlit",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("NightEventShop_UI")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Moonlit Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})


ui:AddButton({
    Title = "Event Quest UI | não funcionando",
    Description = "Ativa/Desativa a UI de missões do evento",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("NightQuest_UI")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Event Quest UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

sell:AddButton({
    Title = "Vender bloodlit/bloodmon",
    Description = "vende para a coruja",
    Callback = function()
        tsm()       
    end
})



task.spawn(function()
    local lastMinute = -1
    while true do
        local minutos = os.date("*t").min
        if minutos ~= lastMinute then
            lastMinute = minutos

            if bsm then
                byallmoonfc()
            end
            if bsm2 then
                byallmoon2fc()
            end
        end
        task.wait(1)
    end
end)

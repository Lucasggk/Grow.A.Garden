local vful = getgenv().vers or "h"

local Windowuibee = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()

local Window = Windowuibee:CreateWindow({
    Title = "Bee event |",
    SubTitle = "Made by Lucas | Version: " .. vful,
    TabWidth = 120,
    Size = UDim2.fromOffset(510, 390),
    Acrylic = false,
    Theme = "Dark",
})

local loja = Window:AddTab({ Title = "Loja", Icon = "home" })
local ui = Window:AddTab({ Title = "UIs", Icon = "list" })
local event = Window:AddTab({ Title = "Event", Icon = "list" })
local config = Window:AddTab({ Title = "Config", Icon = "settings" })

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
InterfaceManager:SetLibrary(Windowuibee)
InterfaceManager:SetFolder("GrowAGardenBee")
InterfaceManager:BuildInterfaceSection(config)

config:AddButton({
    Title = "Delete ui",
    Callback = function()
        Windowuibee:Destroy()
    end
})


local section = event:AddSection("Honey | bizze")
local ativo = false

event:AddToggle("Auto Trade Machine", {
    Title = "Auto trade event machine\n",
    Description = "Equips only Pollinated items and interacts with machine",
    Default = false,
    Callback = function(toggle)
        ativo = toggle
        if not toggle then return end

        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local rs = game:GetService("ReplicatedStorage")

            local function temPollinated(nome)
                return nome:lower():find("pollinated") ~= nil
            end

            while ativo do
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local mochila = player:FindFirstChild("Backpack")
                local itens = {}

                for _, container in ipairs({char, mochila}) do
                    if container then
                        for _, item in ipairs(container:GetChildren()) do
                            if item:IsA("Tool") and temPollinated(item.Name) then
                                table.insert(itens, item)
                            end
                        end
                    end
                end

                for _, item in ipairs(itens) do
                    if not ativo then return end

                    humanoid:EquipTool(item)
                    task.wait(0.1)

                    ufav()
                    rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")

                    local tempo = tick()
                    while ativo and char:FindFirstChildOfClass("Tool") == item do
                        if tick() - tempo >= 2 then
                            rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                            tempo = tick()
                        end
                        task.wait(0.5)
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

ui:AddButton({
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

local byallBee = { "Flower Seed Pack", "Nectarine", "Hive Fruit", "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway" }
local buyBee = game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock
local selectedBees = {}
local bsb = false

function byallbeefc()
    for i = 1, 25 do
        for _, bee in ipairs(selectedBees) do
            local args = {
                [1] = bee
            }
            game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock:FireServer(unpack(args))
            task.wait()
        end
    end
end

local section = loja:AddSection("Shop Honey")

loja:AddToggle("", {
    Title = "Buy all Bee Shop",
    Description = "Buy all Bee shop",
    Default = false,
    Callback = function(Value)
        bsb = Value
    end
})

local dropdownBee = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione Beeshop para comprar\n",
    Description = "Selecione Beeshop para comprar\n",
    Values = byallBee,
    Multi = true,
    Default = {},
})

dropdownBee:OnChanged(function(Value)
    selectedBees = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedBees, v)
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
                byallbeefc()
            end
        end
        task.wait(1)
    end
end)

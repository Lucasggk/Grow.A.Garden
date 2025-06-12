local section = event:AddSection("Honey | bizze")
local ativo = false
local itensOrdenados = {}

event:AddToggle("Auto Trade Machine", {
    Title = "Auto trade event machine\n",
    Description = "Equips only Pollinated items and interacts with machine (sorted by weight)",
    Default = false,
    Callback = function(toggle)
        ativo = toggle
        if not toggle then return end

        local player = game:GetService("Players").LocalPlayer
        local rs = game:GetService("ReplicatedStorage")

        local function temPollinated(nome)
            return nome:lower():find("pollinated") ~= nil
        end

        task.spawn(function()
            while ativo do
                local novaLista = {}
                local char = player.Character or player.CharacterAdded:Wait()
                local mochila = player:FindFirstChild("Backpack")

                for _, container in ipairs({char, mochila}) do
                    if container then
                        for _, item in ipairs(container:GetChildren()) do
                            if item:IsA("Tool") and temPollinated(item.Name) then
                                local success, weight = pcall(function()
                                    return item:FindFirstChild("Weight").Value
                                end)
                                if success then
                                    table.insert(novaLista, {Tool = item, Weight = weight})
                                end
                            end
                        end
                    end
                end

                table.sort(novaLista, function(a, b)
                    return a.Weight < b.Weight
                end)

                itensOrdenados = novaLista
                task.wait(2)
            end
        end)

        task.spawn(function()
            while ativo do
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local label

                pcall(function()
                    label = workspace.HoneyEvent.HoneyCombpressor.Sign.SurfaceGui.TextLabel
                end)

                for _, itemData in ipairs(itensOrdenados) do
                    if not ativo then return end
                    local tool = itemData.Tool

                    if tool and tool.Parent then
                        humanoid:EquipTool(tool)
                        task.wait(0.1)
                        ufav()

                        while ativo and char:FindFirstChildOfClass("Tool") == tool do
                            if label then
                                local texto = label.Text
                                if texto == "READY" or texto:match("^%d*%.?%d+/10 KG$") then
                                    task.wait(0.1)
                                    rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                                    break
                                end
                            end
                            task.wait(0.25)
                        end
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

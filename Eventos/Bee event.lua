local section = event:AddSection("Honey | bizze")
local ativo = false
local itensOrdenados = {}

event:AddToggle("Auto Máquina de Troca", {
    Title = "Auto Máquina de Troca",
    Description = "Equipe apenas itens Polinizados e interaja com a máquina do evento (ordenado por peso)",
    Default = false,
    Callback = function(toggle)
        ativo = toggle
        if not toggle then return end

        local player = game:GetService("Players").LocalPlayer
        local rs = game:GetService("ReplicatedStorage")

        local function temPollinated(nome)
            return nome:lower():find("pollinated") ~= nil
        end

        -- Atualiza a lista de itens ordenados por peso
        task.spawn(function()
            while ativo do
                local novaLista = {}
                local char = player.Character or player.CharacterAdded:Wait()
                local mochila = player:FindFirstChild("Backpack")

                for _, container in ipairs({char, mochila}) do
                    if container then
                        for _, item in ipairs(container:GetChildren()) do
                            if item:IsA("Tool") and temPollinated(item.Name) then
                                local weightObj = item:FindFirstChild("Weight")
                                if weightObj and weightObj:IsA("NumberValue") then
                                    table.insert(novaLista, {Tool = item, Weight = weightObj.Value})
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

        -- Interação com a máquina
        task.spawn(function()
            while ativo do
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local label

                pcall(function()
                    label = workspace.HoneyEvent.HoneyCombpressor.Sign.SurfaceGui.TextLabel
                end)

                local listaLocal = table.clone(itensOrdenados)

                for _, itemData in ipairs(listaLocal) do
                    if not ativo then break end
                    local tool = itemData.Tool
                    if tool and tool.Parent and label then
                        local texto = label.Text
                        if texto == "READY" or texto:match("^%d*%.?%d+/10 KG$") then

                            if tool.Parent == player.Backpack or tool.Parent == player.Character then
                                local sucesso, erro = pcall(function()
                                    humanoid:EquipTool(tool)
                                end)

                                if sucesso then
                                    task.wait(0.1)
                                    ufav()
                                    rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                                    task.wait(0.6)
                                end
                            end

                        end
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

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

local byallBee = { "Flower Seed Pack", "Lavender", "Nectarshade", "Nectarine", "Hive Fruit", "Pollen Radar", "Nectar Staff", "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway" }
local buyBee = game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock
local selectedBees = {}
local bsb = false

function byallbeefc()
    for i = 1, 25 do
        for _, bee in ipairs(selectedBees) do
            game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock:FireServer(bee)
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
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedBees, v)
        end
    end
end)

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

local byallseed = {
    "Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower", "Watermelon", "Green Apple",
    "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat",
    "Feijoa", "Sugar Apple"
}
local bygear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Tanning Mirror", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot"}

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

event:AddSection("Summer")

event:AddToggle("AutoUsarItens", {
    Title = "Auto Usar Itens",
    Default = false,
    Callback = function(Value)
        print("AutoUsarItens:", Value)
        _G.AutoUsarItens = Value

        if not Value then return end

        task.spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Remote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SummerHarvestRemoteEvent")

            local nomesValidos = {
                "Carrot", "Strawberry", "Blueberry", "Tomato",
                "Cauliflower", "Watermelon", "Green Apple", "Avocado",
                "Banana", "Pineapple", "Kiwi", "Bell Pepper",
                "Prickly Pear", "Loquat", "Feijoa", "Sugar Apple"
            }

            local lista = {}
            for _, nome in ipairs(nomesValidos) do
                lista[nome] = true
            end

            while _G.AutoUsarItens do
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local Backpack = LocalPlayer:FindFirstChild("Backpack")

                if not (Character and Humanoid and Backpack and Humanoid.Health > 0) then
                    print("Aguardando personagem válido...")
                    task.wait(0.5)
                    continue
                end

                for _, tool in ipairs(Backpack:GetChildren()) do
                    if tool:IsA("Tool") and not tool.Name:lower():find("seed") and lista[tool.Name] then
                        print("Equipando:", tool.Name)

                        local sucesso = pcall(function()
                            Humanoid:EquipTool(tool)
                        end)

                        if sucesso then
                            task.wait(0.15)
                            Remote:FireServer("SubmitHeldPlant")
                            task.wait(0.15)
                        end
                    end
                end

                task.wait(0.1)
            end
        end)
    end
})



loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BlueLock/refs/heads/main/Fix.name.ui.lua"))()

local script_version = {
    -- version
    version = "3.52{Teste-1/9Delay}",
    alpha = true,
}
if script_version.alpha then
    script_version.alpha = "Alpha version"
else
    script_version.alpha = "Release version"
end
print("MADE BY LUCAS\nScript Version " .. script_version.version .. " - " .. script_version.alpha)
local vful = script_version.version .." - ".. script_version.alpha
getgenv().vers = vful

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui") 

local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local Plant = ReplicatedStorage.GameEvents.Plant_RE
local BuyPet = ReplicatedStorage.GameEvents.BuyPetEgg
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local scrollingFrame = game:GetService("Players").LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.ScrollingFrame
local feedsc = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("ActivePetService")

-- event local

player.CharacterAdded:Connect(function(char)
    character = char
    hrp = character:WaitForChild("HumanoidRootPart")
end)


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden |",
    SubTitle = "Made by Lucas | Version: ".. vful,
    TabWidth = 180,
    Size = UDim2.fromOffset(600, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true,
    Keybind = Enum.KeyCode.LeftControl
})

-- Local Tabs --

local player = Window:AddTab({
    Title = "Jogador",
    Icon = "user"
})

local loja = Window:AddTab({
    Title = "Loja",
    Icon = "shopping-cart" 
})

local pet = Window:AddTab({
    Title = "Mascotes",
    Icon = "rbxassetid://130754538725129"
})

local plant = Window:AddTab({
    Title = "plant/water",
    Icon = "rbxassetid://91815274279491"
})

local sell = Window:AddTab({
    Title = "Vender",
    Icon = "rbxassetid://87631616608256" 
})

local event = Window:AddTab({
    Title = "Eventos",
    Icon = "rbxassetid://88058653294248"
})

local vuln = Window:AddTab({
    Title = "Vulnerabilidade",
    Icon = "rbxassetid://92158036430997"
})

local utility = Window:AddTab({
    Title = "utility",
    Icon = "wrench"
})

local config = Window:AddTab({
    Title = "Settings",
    Icon = "settings"  
})

local ui = Window:AddTab({
    Title = "Interface",
    Icon = "rbxassetid://133691553274983"
})

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("GrowAGarden")
InterfaceManager:BuildInterfaceSection(config)

-- Local VariÃ¡veis --




local byallseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"}

local bygear = {"Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Medium Toy", "Medium Treat", "Godly Sprinkler", "Lightning Rod", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Grandmaster Sprinkler", "Levelup Lollipop"}





local bsa = false
local bsg = false

local selectedSeeds = {}
local selectedGears = {}

local step = 0.001
local x = Vector3.new(34.14344024658203, 0.13552513718605042, -112.62083435058594)
local y = Vector3.new(31.82763671875, 0.13552513718605042, -112.6816635131836)

local Pos = hrp.Position
local pos = tostring(Pos)

local walkSpeed = humanoid.WalkSpeed

local PetsId = {}

-- Local functions --

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

function svp()
    Pos = hrp.Position
    pos = tostring(Pos)
end

function tpt(v3)
    if typeof(v3) == "Vector3" then
        hrp.CFrame = CFrame.new(v3)
    elseif typeof(v3) == "string" then
        local x, y, z = string.match(v3, "Vector3%s*%(([^,]+),%s*([^,]+),%s*([^)]+)%)")
        if x and y and z then
            hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
end

function sf()
    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
end

function sm()
    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitAllPlants")
end

function tsf()
    svp()
    hrp.CFrame = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
    task.wait(0.25)
    sf()
    task.wait(0.2)
    tpt(Pos)
end

function tsm()
    svp()
    hrp.CFrame = CFrame.new(-101.0422592163086, 4.400012493133545, -10.985257148742676)
    task.wait(0.25)
    sm()
    task.wait(0.2)
    tpt(Pos)
end

-- Local Script --

local section = loja:AddSection("Seeds")

loja:AddToggle("", {
    Title = "Buy shop seed",
    Description = "Buy select shop seed",
    Default = false,
    Callback = function(Value)
        bsa = Value
    end
})

local dropdownSeed = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione seeds para comprar\n",
    Description = "Selecione select para comprar\n",
    Values = byallseed,
    Multi = true,
    Default = {},
})

dropdownSeed:OnChanged(function(Value)
    selectedSeeds = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedSeeds, v)
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
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedGears, v)
        end
    end
end)

local section = loja:AddSection("Auto Buy egg")

local selected = {}

local mdp = loja:AddDropdown("MultiDropdown", {
    Title = "Selecionar Eggs",
    Description = "",
    Values = {
        "Common Egg", "Common Summer Egg", "Rare Summer Egg",
        "Mythical Egg", "Paradise Egg", "Bug Egg"
    },
    Multi = true,
    Default = {},
})

mdp:OnChanged(function(Value)
    selected = {}
    for name, state in next, Value do
        selected[#selected + 1] = name
    end
end)

_G.bpd = false

loja:AddToggle("", {
    Title = "Comprar Automaticamente Eggs selecionados. \n",
    Description = "",
    Default = false,
    Callback = function(state)
        _G.bpd = state
        task.spawn(function()
            while _G.bpd do
                for _, name in ipairs(selected) do
                    game:GetService("ReplicatedStorage").GameEvents.BuyPetEgg:FireServer(name)
                end
                task.wait(1)
            end
        end)
    end
})






-- 

plant:AddSection("Plant spam (Pos set)")

plant:AddButton({
        Title = "Set local X",
        Description = "click para setar o inicio do auto plant\n",
        Callback = function()
          x = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(x)
            
        end
    })

plant:AddButton({
        Title = "Set local Y",
        Description = "click para setar o fim do auto plant\n",
        Callback = function()
          y = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(y)
        end
    })

local Slider = plant:AddSlider("Slider", 
{
    Title = "Distancia de uma seed para outra\n",
    Description = "step seed\n",
    Default = 0.001,
    Min = 0.001,
    Max = 0.1,
    Rounding = 3,
    Callback = function(Value)
        step = Value
    end
})

plant:AddButton({
    Title = "click para plantar",
    Description = "esteja com a seed na mão",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not tool then return end

        local baseName = tool.Name:match("^(.-)%s+[Ss]eed") or tool.Name
        baseName = baseName:gsub("%s+$", "")

        local direction = (y - x).Unit
        local distance = (y - x).Magnitude
        for i = 0, distance, step do
            local pos = x + direction * i
            Plant:FireServer(pos, baseName)
            task.wait()
        end
    end
})

plant:AddSection("plant spam (Pos player)")

local dlayp = 0.1

plant:AddSlider("Slider", {
    Title = "Delay do spam plant",
    Default = dlayp,
    Min = 0.05,
    Max = 1,
    Rounding = 2, -- arredonda até duas casas decimais (0.05, 0.10, etc)
    Callback = function(v)
        dlayp = tonumber(string.format("%.2f", v))
    end
})

_G.AutoSpamPlant = false

local function platse()
    local p = game.Players.LocalPlayer
    local c = p.Character or p.CharacterAdded:Wait()
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local tool = c:FindFirstChildOfClass("Tool")
    if not (tool and hrp) then return end

    local name = tool.Name:match("^(.-)%s+[Ss]eed") or tool.Name
    name = name:gsub("%s+$", "")
    local pos = hrp.Position
    local y = math.random() * (10 - 0.13) + 0.13

    game:GetService("ReplicatedStorage").GameEvents.Plant_RE:FireServer(Vector3.new(pos.X, y, pos.Z), name)
end

plant:AddToggle("AutoSpamPlant", {
    Title = "Auto Spam Plant",
    Default = false,
    Callback = function(v)
        _G.AutoSpamPlant = v
        task.spawn(function()
            while _G.AutoSpamPlant do
                platse()
                task.wait(dlayp)
            end
        end)
    end
})

plant:AddSection("Water spam (Pos Dropdown)")

local Player = game.Players.LocalPlayer
local HRP = Player.Character and Player.Character:WaitForChild("HumanoidRootPart")
local Locations = {}
local wms = 0.1
local pwms = Vector3.new(-204.42526245117188, 0.13552704453468323, -83.74856567382812)
local running = false

local dropdown = plant:AddDropdown("Locais", {
    Title = "Destinos",
    Values = {},
    Multi = false,
    Default = nil
})

local function formatPos(vec)
    return string.format("X:%.1f Y:%.2f Z:%.1f", vec.X, vec.Y, vec.Z)
end

local function UpdateDropdown()
    local keys = {}
    for name, pos in pairs(Locations) do
        table.insert(keys, name .. " [" .. formatPos(pos) .. "]")
    end
    dropdown:SetValues(keys)
end

plant:AddButton({
    Title = "Adicionar Local",
    Callback = function()
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local p = Vector3.new(HRP.Position.X, 0.14, HRP.Position.Z)

            -- Gera um nome único como "Local 1", "Local 2", etc.
            local id = 1
            local name
            repeat
                name = "Local " .. id
                id += 1
            until not Locations[name]

            Locations[name] = p
            UpdateDropdown()
        end
    end
})

plant:AddButton({
    Title = "Limpar Locais",
    Callback = function()
        Locations = {}
        pwms = nil
        dropdown:SetValue(nil)
        dropdown:SetValues({})
    end
})

dropdown:OnChanged(function(selected)
    for name, pos in pairs(Locations) do
        if selected:match("^" .. name .. " ") then
            pwms = pos
            break
        end
    end
end)



plant:AddSlider("Velocidade", {
    Title = "Delay entre uso",
    Min = 0.1,
    Max = 1,
    Default = wms,
    Rounding = 1,
    Callback = function(v)
        wms = v
    end
})

plant:AddToggle("w", {
    Title = "Ativar spam water (pos do dropdown)",
    Default = false,
    Callback = function(v)
        running = v
        if running then
            task.spawn(function()
                while running do
                    game:GetService("ReplicatedStorage").GameEvents.Water_RE:FireServer(pwms)
                    task.wait(wms)
                end
            end)
        end
    end
})
plant:AddSection("Water spam (Pos player)")
plant:AddSlider("DelayWater", {
    Title = "Delay entre usos",
    Min = 0.1,
    Max = 1,
    Default = 0.1,
    Rounding = 1,
    Callback = function(value)
        getgenv().wms_spam = value
    end
})

plant:AddToggle("ToggleWaterSpam", {
    Title = "Ativar spam water (pos do player)",
    Default = false,
    Callback = function(state)
        getgenv().running_spam = state
        if state then
            task.spawn(function()
                while getgenv().running_spam do
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos = Vector3.new(hrp.Position.X, 0.14, hrp.Position.Z)
                        game:GetService("ReplicatedStorage").GameEvents.Water_RE:FireServer(pos)
                    end
                    task.wait(getgenv().wms_spam or 0.1)
                end
            end)
        end
    end
})

--

local tmpps = 30

sell:AddButton({
    Title = "Vender Colheitas",
    Description = "Vende para o vendedor imediatamente.",
    Callback = function()
        tsf()
    end
})

sell:AddSlider("SellDelaySlider", {
    Title = "Delay do Auto Sell (segundos)",
    Description = "Define o intervalo entre cada venda automática.",
    Default = tmpps,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        tmpps = value
    end
})

_G.Atsell = false
sell:AddToggle("", {
    Title = "Vender Colheitas automaticamente",
    Description = "Ativa a venda automática com base no delay definido.",
    Default = false,
    Callback = function(enabled)
        _G.Atsell = enabled 
			if _G.Atsell then 
        task.spawn(function()
            while _G.Atsell do
                tsf()
                task.wait(tmpps)
            end
        end)
			end
    end
})
        
--

player:AddSlider("", {
    Title = "WalkSpeed",
    Description = "Ajuste a velocidade de caminhada",
    Min = 20,
    Max = 250,
    Default = 20,
    Rounding = 1,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
     end      
})

player:AddSlider("", {
    Title = "Jump Power",
    Description = "Ajuste a velocidade de caminhada",
    Min = 50,
    Max = 250,
    Default = 50,
    Rounding = 1,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
     end      
})

--

function prefsh()
    PetsId = {}
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child.Name ~= "PetTemplate" and child:FindFirstChild("PetStats") then
            table.insert(PetsId, child.Name)
        end
    end
    print("Pets atualizados:")
    --[[for _, id in ipairs(PetsId) do
        print(id)
    end]]
    return PetsId
end

local pDropdown = pet:AddDropdown("Dropdown", {
    Title = "Escolha o pet para feed\n",
    Description = "auto se explica\n",
    Values = {},
    Multi = false,
    Default = nil,
})

local function updatePetDropdown()
    local pets = prefsh()
    pDropdown:SetValues(pets)
    if #pets > 0 then
        pDropdown:SetValue(pets[1])
    end
end

pet:AddButton({
    Title = "atualizar pet",
    Description = "Atualiza pets",
    Callback = function()
        updatePetDropdown()
    end
})

local pfeed

pDropdown:OnChanged(function(Value)
    pfeed = Value
    print("Pet selecionado:", pfeed)
end)

updatePetDropdown()


local autoFeed = false

local tpfeed = pet:AddToggle("AutoFeedToggle", {
    Title = "Alimentação Automática\n",
    Description = "Alimenta o pet selecionado automaticamente\nPorem pegue a comida na mão!\n",
    Default = false,
    Callback = function(Value)
        autoFeed = Value
        if Value then
            spawn(function()
                while autoFeed do
                    if pfeed then
                        feedsc:FireServer("Feed", pfeed)
                        print("Pet alimentado:", pfeed)
                    else
                        print("Nenhum pet selecionado para alimentar")
                    end
                    wait(0.3) 
                end
            end)
        end
    end
})

pet:AddButton({
    Title = "Alimentar pet selecionado",
    Description = "Segure comida na mão!",
    Callback = function()
        if pfeed then
            feedsc:FireServer("Feed", pfeed)
            print("Pet alimentado:", pfeed)
        else
            print("Nenhum pet selecionado")
        end
    end
})

--

ui:AddSection("Controle de UIs")

ui:AddButton({
    Title = "Cosmetic Shop UI",
    Description = "Ativa/Desativa a loja de cosmeticos",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CosmeticShop_UI")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Cosmetic Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})


ui:AddButton({
    Title = "Gear Shop UI",
    Description = "Ativa/Desativa a loja de equipamentos",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Gear Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})


ui:AddButton({
    Title = "Seed Shop UI",
    Description = "Ativa/Desativa a loja de sementes",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Seed Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

ui:AddButton({
    Title = "Daily quest UI",
    Description = "Ativa/Desativa a Daily quest ui",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Daily Quest UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

--

task.spawn(function()
    local lastMinute = -1
    while true do
        local minutos = os.date("*t").min
        if minutos ~= lastMinute then
            lastMinute = minutos

            if bsb then
                byallbeefc()
            end
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
--





--



local versgame = (game:GetService("Players").LocalPlayer.PlayerGui.Version_UI.Version.Text):gsub("^v", "")
function svvererr(v)
    local newv = tonumber(v)
    local numvers = tonumber(versgame)
    if numvers and newv and numvers > newv then
        Fluent:Notify({
            Title = "Versão necessária errada!",
            Content = "Versão Atual: " .. versgame,
            SubContent = "Você tem que estar na versão: " .. newv .. " ou menos!",
            Duration = 5
        })
    end
end
vuln:AddParagraph({
        Title = "Versao atual do serve: ", Content = versgame
    })

--




function fav(Status)
	local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
           tool:SetAttribute("d", Status)
	end
end

utility:AddSection("Auto collect Fruit")


_G.AutoCollect = false
local frutaSelecionada = nil

utility:AddDropdown("", {
    Title = "Fruta para Auto Collect",
    Description = "Escolha uma fruta para coleta.",
    Values = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Frutas%20(auto%20collect).lua"))(),
    Multi = false,
    Default = nil,
    Callback = function(v)
        frutaSelecionada = v
    end
})

utility:AddToggle("", {
    Title = "Auto Collect",
    Description = "Ativa coleta automática.",
    Default = false,
    Callback = function(v)
        _G.AutoCollect = v
        if v then
            task.spawn(function()
                while _G.AutoCollect and frutaSelecionada ~= "None" do
                    local minhaFarm = nil
                    for _, farm in ipairs(workspace.Farm:GetChildren()) do
                        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
                        if data and data:FindFirstChild("Owner") and data.Owner.Value == game.Players.LocalPlayer.Name then
                            minhaFarm = farm
                            break
                        end
                    end
                    if minhaFarm then
                        local plantas = minhaFarm.Important:FindFirstChild("Plants_Physical")
                        if plantas then
                            for _, p in ipairs(plantas:GetChildren()) do
                                if p.Name == frutaSelecionada then
                                    local f = p:FindFirstChild("Fruits")
                                    if f and #f:GetChildren() > 0 then
                                        for _, fruta in ipairs(f:GetChildren()) do
                                            if not fruta:GetAttribute("Favorited") then
                                                game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(
                                                    buffer.fromstring("\1\1\0\1"),
                                                    {fruta}
                                                )
                                                task.wait(0.04)
                                            end
                                        end
                                    elseif not p:GetAttribute("Favorited") then
                                        game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable"):FireServer(
                                            buffer.fromstring("\1\1\0\1"),
                                            {p}
                                        )
                                        task.wait(0.04)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})






utility:AddSection("Auto collect Fruit Mutation")

function cpm(nomeAtributo)
    local ByteNetReliable = game:GetService("ReplicatedStorage"):WaitForChild("ByteNetReliable")
    local farmPlayer = nil

    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local success, owner = pcall(function()
            return farm.Important.Data.Owner.Value
        end)
        if success and owner == game.Players.LocalPlayer.Name then
            farmPlayer = farm
            break
        end
    end

    if not farmPlayer then return end

    local pasta = farmPlayer:WaitForChild("Important"):WaitForChild("Plants_Physical")

    for _, planta in ipairs(pasta:GetChildren()) do
        local frutas = planta:FindFirstChild("Fruits")
        local enviado = false

        if planta:GetAttribute(nomeAtributo) == true and not planta:GetAttribute("Favorited") then
            ByteNetReliable:FireServer(buffer.fromstring("\1\1\0\1"), {planta})
            enviado = true
        end

        if frutas and not enviado then
            for _, fruta in ipairs(frutas:GetChildren()) do
                if fruta:GetAttribute(nomeAtributo) == true and not fruta:GetAttribute("Favorited") then
                    ByteNetReliable:FireServer(buffer.fromstring("\1\1\0\1"), {fruta})
                    task.wait(0.05)
                end
            end
        end
    end
end

_G.cfm = false
local mtcc
local mtc = {"None", "Wet", "Windstruck", "Moonlit", "Chilled", "Shocked", "Frozen", "Bloodlit", "Celestial", "Zombified", "HoneyGlazed", "Heavenly", "Fried", "Amber", "Clay", "Ceramic", "Sundried", "Aurora", "Alienlike", "Galactic", "Disco", "Plasma", "Tranquil", "Jackpot", "Corrupt", "Subzero", "Enlightened", "Equinox", "Cooked", "Burnt", "Sandy", "Pollinated", "Friendbound", "Radioactive", "Foxfire Chakra", "Twisted", "Molten", "Meteoric", "Voidtouched", "Dawnbound"}

utility:AddDropdown("", {
    Title = "Selecione a Mutação.",
    Description = "Auto se explica.",
    Values = mtc,
    Multi = false,
    Default = nil,
    Callback = function(v)
        mtcc = v
    end
})

utility:AddToggle("", {
    Title = "Coletar frutas com a Mutação selecionada.",
    Description = "",
    Default = false,
    Callback = function(v)
        _G.cfm = v
        if _G.cfm then
            task.spawn(function()
                while _G.cfm do
                    task.wait(0.1)
                    if mtcc == nil or mtcc == "None" then
                        task.wait()
                    else
                        cpm(mtcc)
                    end
                end
            end)
        end
    end
})









--







--

task.spawn(function()
    local lastMinute = -1
    while true do
        local minutos = os.date("*t").min
        if minutos ~= lastMinute then
            lastMinute = minutos

            if bsa then
                task.spawn(byallseedfc)
            end
            if bsg then
                task.spawn(byallgearfc)
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    player.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

--

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local decalId = "rbxassetid://122755768466240"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableImageButtonGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local imageButton = Instance.new("ImageButton")
imageButton.Name = "DraggableButton"
imageButton.Image = decalId
imageButton.Size = UDim2.new(0, 65, 0, 65)
imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
imageButton.Position = UDim2.new(0, 100, 1, -400)
imageButton.BackgroundTransparency = 0
imageButton.AutoButtonColor = false
imageButton.Parent = screenGui

local dragging, dragInput, mousePos, buttonPos = false

imageButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging, mousePos, buttonPos = true, input.Position, imageButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

imageButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		imageButton.Position = UDim2.new(
			buttonPos.X.Scale, buttonPos.X.Offset + delta.X,
			buttonPos.Y.Scale, buttonPos.Y.Offset + delta.Y
		)
	end
end)

imageButton.MouseButton1Click:Connect(function()
	Window:Minimize()
end)

local gui = Fluent.GUI
local playerGui = player.PlayerGui

if _G.fluentLoopRunning then
    _G.fluentLoopRunning = _G.fluentLoopRunning + 1
else
    _G.fluentLoopRunning = 1
end
local runId = _G.fluentLoopRunning

task.spawn(function()
    while gui and gui:IsDescendantOf(game) do
        if _G.fluentLoopRunning ~= runId then break end
        task.wait(0.05)
    end
    if _G.fluentLoopRunning == runId then
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = true end
    end
end)

task.spawn(function()
    while true do
        if _G.fluentLoopRunning ~= runId then break end
        if not gui or not gui:IsDescendantOf(game) then
            local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
            if drag then drag:Destroy() end
            break
        end
        local minimized = Fluent and Fluent.Window and Fluent.Window.Minimized
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = minimized end
        task.wait(0.025)
    end
    if _G.fluentLoopRunning == runId then
        local drag = playerGui:FindFirstChild("DraggableImageButtonGui")
        if drag then drag.Enabled = true end
    end
end)

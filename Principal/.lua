function gne(n)
    local f, l, r = workspace.NPCS["Pet Stand"].EggLocations:GetChildren(), {}, {}
    for _, v in ipairs(f) do if v.Name:lower():find("egg") then l[#l+1] = v.Name end end
    n = n:lower()
    for i = 1, #l do if l[i]:lower() == n then r[#r+1] = i end end
    return r
end
local selected = {}
local mdp = loja:AddDropdown("MultiDropdown", {
    Title = "Selecionar Eggs",
    Description = "",
    Values = {
        "Common Egg", "Common Summer Egg", "Rare Summer Egg",
        "Mythical Egg", "Paradise Egg", "Bee Egg", "Bug Egg"
    },
    Multi = true,
    Default = {},
})
mdp:OnChanged(function(Value)
    selected = {}
    for name, state in next, Value do
        selected[#selected+1] = name
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
            while _G.buying do
                for _, name in ipairs(selected) do
                    local indices = gne(name)
                    for _, i in ipairs(indices) do
                        BuyPet:FireServer(i)
                    end
                end
                task.wait(1)
            end
        end)
    end
})

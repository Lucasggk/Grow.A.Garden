loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Secundario/Verifica%C3%A7%C3%A3o.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BlueLock/refs/heads/main/Fix.name.ui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Secundario/Functions.lua"))()

local sv = {
    version = "0.1", 
    patch = "Adicionando itens"
}

local vful = sv.version .." - ".. sv.patch

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Grow a Garden | ",
    SubTitle = "Made by Lucas | ".. vful,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local home = Window:AddTab({
        Title = "Home",
        Icon = "user"
    })

local main = Window:AddTab({
        Title = "main",
        Icon = "home"
    })

local autom = Window:AddTab({
        Title = "automatically",
        Icon = "play"
    })

local inv = Window:AddTab({
        Title = "inventory",
        Icon = "bag"
    })

local shop = Window:AddTab({
        Title = "shop",
        Icon = "shopping-cart"
    })

local misc = Window:AddTab({
        Title = "misc",
        Icon = "list"
    })

local settings = Window:AddTab({
        Title = "settings",
        Icon = "settings"
    })

local utl = Window:AddTab({
        Title = "utility",
        Icon = "list"
    })



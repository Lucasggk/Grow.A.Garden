repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Fluent = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden | ",
    SubTitle = "  Made by Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

-- Local Tabs --

local loja = Window:AddTab({
        Title = "loja",
        Icon = "home"
    })

-- Local Variáveis --

local commun = {"Carrot", "Strawberry"}
local uncommun = {"Blueberry", "Orange Tulip"}
local rare = {"Tomato", "Corn", "Daffodil"}
local legendery = {"Watermelon", "Pumpkin", "Apple", "Bamboo"}
local mythical = {"Coconut", "Cactus", "Dragon Fruit", "Mango"}
local divine = {"Grape", "Mushroom", "Pepper", "Cacao"}
local prismatic = {"Beanstalk"}
local gear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool"}

local dfb = {prismatic, divine, mythical, legendery}
local byall = {prismatic, divine, mythical, legendery, rare, uncommun, commun}
-- Local Script --

loja:AddToggle("", {
        Title = "Buy all shop seed"
        Description = "Buy all shop seed"
        Default = false
        Callback = function(Value)


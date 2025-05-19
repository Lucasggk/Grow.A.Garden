loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/df0359e8a230912f5cf76c6d7edc9cab743fe9dc/Loja.lua"))()
local values = {"Commun", "Uncommun", "Rare", "Legendery", "Mythical", "Divine", "Prismatic"}
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
 
local Fluent = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))() 

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden",
    SubTitle = "Made by Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

local loja = Window:AddTab({
  Title = "Auto buy",
  Icon = "home"
 })

local section = loja:AddSection("Seeds (select by rarity)")

local Dropdown = loja:AddDropdown("", {
    Title = "auto buy seeds",
    Values = values,
    Multi = true,
    Default = values
})

Dropdown:OnChanged(function(value)
    print(value)
end)

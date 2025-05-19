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


local GearDropdown = loja:AddDropdown("GearMultiSelector", {
    Title = "Select Gears to Buy",
    Values = gear,
    Multi = true,
    Default = {gear[1], gear[2]}
})

loja:AddToggle("AutoBuyInstant", {
    Title = "Instant Buy Selected",
    Description = "Buys selected gears as fast as possible",
    Default = false,
    Callback = function(Value)
        while Value do
            for _, selected in pairs(GearDropdown.Value) do
                game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer(selected)
            end
            task.wait(0.1) 
        end
    end
})

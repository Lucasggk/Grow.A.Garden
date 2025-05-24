repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Show_Button = false -- Shows the button for toggle fluent ui manually. If "false", works only on mobile, if "true", works everytime.
local Button_Icon = "rbxassetid://10734897102" -- Icon of the button for toggle fluent ui.
local Button_Transparency = 1 -- Transparency of button background (check line #6365).


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



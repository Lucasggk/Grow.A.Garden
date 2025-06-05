game:GetService("StarterGui"):SetCore("SendNotification", {Title="Script loading...", Text="Made by Lucas", Duration=5})


local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()
local Window = l:CreateWindow({
    Title = "",
    SubTitle = "",
    TabWidth = 0,
    Size = UDim2.fromOffset(0, 0),
    Acrylic = false,
    Theme = "Dark",
})
l:Destroy()

wait(0.005)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Principal/Lucas%20hub.lua"))()

wait(0.1)

game:GetService("StarterGui"):SetCore("SendNotification", {Title="script loaded...", Text="Made by Lucas", Duration=5})

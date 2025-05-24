local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Grow a Garden",
    SubTitle = "Made by Lucas",
    Size = UDim2.fromOffset(500, 400),
    Acrylic = false,
    Theme = "Dark"
})

Window:Hide()

local ToggleUI = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")

ToggleUI.Name = "FloatingToggleUI"
ToggleUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.92, 0, 0.85, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
ToggleButton.Image = "rbxassetid://123456789"
ToggleButton.ScaleType = Enum.ScaleType.Fit
ToggleButton.ZIndex = 999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.Parent = ToggleUI

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
end)

ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
end)

local UIVisible = false

ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    if UIVisible then
        Window:Show()
    else
        Window:Hide()
    end
end)

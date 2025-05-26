local Candy = game:GetService("ReplicatedStorage").GameEvents.BuyEasterStock

local stock = {
    "Chocolate Carrot Seed",   -- Comum
    "Red Lollipop",            -- Incomum
    "Candy Sunflower",         -- Raro
    "Easter Egg",              -- Lendário
    "Chocolate Sprinkler",     -- Mítico
    "Candy Blossom"            -- Divino
}

if game.PlaceId == 12688469563 then 
    while true do 
        for _, candy in ipairs(stock) do
            Candy:FireServer(candy)
        end 
        task.wait(0.1)
    end
else
    print("jogo errado: " .. game.PlaceId .. " | jogo correto: 12688469563")
end

local Candy = game:GetService("ReplicatedStorage").GameEvents.BuyEasterStock

if game.PlaceId == 12688469563 then 
while true do 
    Candy:FireServer("Candy Blossom")
    task.wait(0.1)
  end
else
  print("jogo errado: ".. game.PlaceId .."jogo correto: 12688469563")
end

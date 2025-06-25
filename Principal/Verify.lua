local player = game.Players.LocalPlayer

local nome = player.Name
local dnome = player.DisplayName
local id = player.UserId 
--
local gid = game.PlaceId
local gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
--
local player_id = {
    [12345678] = true,
    [87654321] = true,
}
--
local v1 = false
local v2 = false
local v3 = false
local v4 = false
--
if player_id[id] then 
    print("Verificação 1: 🟢")
    v1 = true
else 
    print("Verificação 1: 🔴")
    v1 = false
end
--
if gid == 126884695634066 then
    print("Verificação 2: 🟢")
    v2 = true
else
    print("Verificação 2: 🔴")
    v2 = false
end

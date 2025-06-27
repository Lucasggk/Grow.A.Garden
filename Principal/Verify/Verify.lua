loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Verify/SendWebhook_verify.lua"))()
--

local player = game.Players.LocalPlayer
local exec = identifyexecutor()
local hwid = get_hwid()
local tempo = os.date("%H:%M:%S - %d/%m")

--

local nome = player.Name
local dnome = player.DisplayName
local id = player.UserId 

--

local gid = game.PlaceId
local gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

--

local player_id = {
    [5557980719] = true,
    [] = true,
    [] = true,
}

--

local v1 = false
local v2 = false
local v3 = false
local v4 = false

print("")

--

if player_id[id] then 
    print("Verificação 1: 🟢 ".. id)
    v1 = true
else 
    print("Verificação 1: 🔴")
    v1 = false
end

--

if gid == 126884695634066 and player_id[id] then
    print("Verificação 2: 🟢 ".. gid)
    v2 = true
else
    print("Verificação 2: 🔴")
    v2 = false
end

--

if hwid and player_id[id] then
    print("Verificação 3: 🟢 " .. hwid)
    v3 = true
else 
    print("Verificação 3: 🔴 ")
    v3 = false
end

--

if exec and player_id[id] then
    print("Verificação 4: 🟢 ".. exec)
    v4 = true 
else 
    print("Verificação 4: 🔴 ")
    v4 = false
end

--
print("")
print("Pegando dados do player: DADOS SEGUROS!")
print("")
local dados = {
    DisplayNome = dnome,
    Nome = nome,
    PlayerId = id,
    GameId = gid,
    JobId = game.JobId,
    GameName = gname,
    Hwid = get_hwid(),
    Exec = exec,
    Time = tempo,
    Status = 
        "v1: " .. (v1 and "🟢 PlayerId" or "🔴 PlayerId") .. "\n" ..
        "v2: " .. (v2 and "🟢 GameId" or "🔴 GameId") .. "\n" ..
        "v3: " .. (v3 and "🟢 Hwid" or "🔴 Hwid") .. "\n" ..
        "v4: " .. (v4 and "🟢 Exec" or "🔴 Exec")
}
for k, v in pairs(dados) do
    print(k .. ": " .. tostring(v))
end
print("")
--  
webhook(dados) 

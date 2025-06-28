loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Verify/SendWebhook_verify.lua"))()
--

local player = game.Players.LocalPlayer
local exec = identifyexecutor()
local hwid = (get_hwid and get_hwid()) or (gethwid and gethwid())
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
    [2000903030] = true,
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

local tempo = os.date("%H:%M")
for k, v in pairs(dados) do
    if k == "Status" then
        print(tempo .. " -- status:")
        for line in v:gmatch("[^\n]+") do
            print(line)
        end
    else
        print(k .. ": " .. tostring(v))
    end
end

print("")

print("indo para Webhook..")
task.wait(math.random())
webhook(dados)
task.wait(math.random())
print("Webhook Enviado!")
print("")
print("Fazendo Verificações de Kick!")

--  

local motivo
if hwid_blc[hwid] then
    motivo = "Seu HWID está na blacklist."
elseif not player_id[id] then
    motivo = "Seu ID não está na lista autorizada."
elseif not (v1 and v2 and v3 and v4) then
    motivo = "Você não passou em uma ou mais verificações."
end

if motivo then
    game.Players.LocalPlayer:Kick(motivo)
else 
    print("Você Passou Em todas Verificações!")
end


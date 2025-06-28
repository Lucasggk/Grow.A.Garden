loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Verify/SendWebhook_verify.lua"))()

local player = game.Players.LocalPlayer
local id = player.UserId
local gid = game.PlaceId
local hwid = (get_hwid and get_hwid()) or (gethwid and gethwid())
local exec = identifyexecutor()
local gname = game:GetService("MarketplaceService"):GetProductInfo(gid).Name
local tempo = os.date("%H:%M:%S - %d/%m")
local tempo2 = os.date("%H:%M")

local player_id = {
    [5557980719] = true,
    [2000903030] = true,
}

local v1 = player_id[id] == true
local v2 = gid == 126884695634066 and v1
local v3 = hwid and v1
local v4 = exec and v1

print("Verificação 1: " .. (v1 and "🟢 "..id or "🔴"))
print("Verificação 2: " .. (v2 and "🟢 "..gid or "🔴"))
print("Verificação 3: " .. (v3 and "🟢 "..hwid or "🔴"))
print("Verificação 4: " .. (v4 and "🟢 "..exec or "🔴"))

print("\nPegando dados do player: DADOS SEGUROS!")

local dados = {
    DisplayNome = player.DisplayName,
    Nome = player.Name,
    PlayerId = id,
    GameId = gid,
    JobId = game.JobId,
    GameName = gname,
    Hwid = hwid,
    Exec = exec,
    Time = tempo,
    Status = 
        "v1: " .. (v1 and "🟢 PlayerId" or "🔴 PlayerId") .. "\n" ..
        "v2: " .. (v2 and "🟢 GameId" or "🔴 GameId") .. "\n" ..
        "v3: " .. (v3 and "🟢 Hwid" or "🔴 Hwid") .. "\n" ..
        "v4: " .. (v4 and "🟢 Exec" or "🔴 Exec")
}

for k,v in pairs(dados) do
    if k == "Status" then
        print(tempo2 .. " -- status:")
        for line in v:gmatch("[^\n]+") do
            print(line)
        end
    else
        print(k .. ": " .. tostring(v))
    end
end

print("\nindo para Webhook..")
task.wait(math.random())
webhook(dados)
task.wait(math.random())
print("Webhook Enviado!")
print("Fazendo Verificações de Kick!")

local motivo
if not player_id[id] then
    motivo = "Seu ID não está na lista autorizada."
elseif not (v1 and v2 and v3 and v4) then
    motivo = "Você não passou em uma ou mais verificações."
end

if motivo then
    player:Kick(motivo)
else
    print("\nVocê Passou Em todas Verificações!\nIndo para proxima Verificação!")
end

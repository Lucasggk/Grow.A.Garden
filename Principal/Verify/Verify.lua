loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Verify/SendWebhook_verify.lua"))()

local player = game.Players.LocalPlayer
local id = player.UserId
local gid = game.PlaceId
local hwid = (get_hwid and get_hwid()) or (gethwid and gethwid())
local exec = identifyexecutor()
local gname = game:GetService("MarketplaceService"):GetProductInfo(gid).Name
local tempo = os.date("%H:%M:%S - %d/%m")

local player_id = {
    [5557980719] = true,
    [2000903030] = true,
}

local v1 = player_id[id] == true
local v2 = gid == 126884695634066 and v1
local v3 = hwid and v1
local v4 = exec and v1

local dados = {
    DisplayNome = player.DisplayName,
    Nome = player.Name,
    PlayerId = id,
    JobId = game.JobId,
    Hwid = hwid,
    Exec = exec,
    Time = tempo,
    Status = 
        "v1: " .. (v1 and "🟢 PlayerId" or "🔴 PlayerId") .. "\n" ..
        "v2: " .. (v2 and "🟢 GameId" or "🔴 GameId") .. "\n" ..
        "v3: " .. (v3 and "🟢 Hwid" or "🔴 Hwid") .. "\n" ..
        "v4: " .. (v4 and "🟢 Exec" or "🔴 Exec")
}

webhook(dados)

local motivo
if not player_id[id] then
    motivo = "Seu ID não está na lista autorizada."
end

if motivo then
    player:Kick(motivo)
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Principal/Verify/Verify%20etapa%202.lua"))()
end

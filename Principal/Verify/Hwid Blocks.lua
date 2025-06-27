loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Verify/SendWebhook_verify.lua"))()
local hw = {
  [""] = true,
  [""] = true,
}
-- true bloqueia a pessoa

local msg = [[
Você não tem permissão para usar o script!
Dono do script já foi avisado!
]]

local hwp = get_hwid()  

local dds = {
    DisplayNome = game.Players.LocalPlayer.DisplayName,
    Nome = game.Players.LocalPlayer.Name,
    PlayerId = game.Players.LocalPlayer.UserId,
    GameId = game.PlaceId,
    JobId = game.JobId,
    GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Hwid = get_hwid(),
    Exec = identifyexecutor(),
    Time = os.date("%H:%M:%S - %d/%m"),
    Invasor = "Invasor detectado!"
}

if hw[hwp] then
  webhook(dds)
  task.wait(0.1)
  game.Players.LocalPlayer:Kick(msg)
end

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

if hw[hwp] then
  game.Players.LocalPlayer:Kick(msg)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Principal/Verify/Sendwebhook_Player_autorizado.lua"))()

local hwid = (get_hwid and get_hwid()) or (gethwid and gethwid())
local id = game.Players.LocalPlayer.UserId
local exec = identifyexecutor()

function kick(text)
    game.Players.LocalPlayer:Kick(text)
end

function lp(n)
    for i = 1, n do
        print("")
    end
end

local block_hwid = {
    ["Nada ainda"] = true
}

if block_hwid[hwid] then 
    kick("Hwid blocked")
end

local miguel = {
  Id = 2000903030,
  Exec = "Delta",
  Hwid = "d6c128b73f1a4064ae284db85ed1964134f764bd53476d81e44c036ce46c2b6a",
}

local px4 = {
    Id = 2904651643,
    Exec = "Arceus X",
    Hwid = "b4d60eedb11a24dd",
}

local Lucas = {
    Id = 5557980719,
    Exec = "RonixExploit",
    Hwid = "d2ca17f317d62734",
}

if (miguel.Id == id and miguel.Exec == exec and miguel.Hwid == hwid) then
    print("Fazendo Outras Verificações...")
    task.wait(0.1)
    print("Usuário Miguel verificado.")
    print("Executando...")
    lp(5)
    webhookpass("Miguel passou! HWID: ".. hwid)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Lucas%20hub.lua"))()

elseif (px4.Id == id and px4.Exec == exec and px4.Hwid == hwid) then
    print("Fazendo Outras Verificações...")
    task.wait(0.1)
    print("Usuário PX4 verificado.")
    print("Executando...")
    lp(5)
    webhookpass("PX4 passou! HWID: ".. hwid)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Lucas%20hub.lua"))()

elseif (Lucas.Id == id and Lucas.Exec == exec and Lucas.Hwid == hwid) then
    print("Fazendo Outras Verificações...")
    task.wait(0.1)
    print("Usuário Lucas verificado.")
    print("Executando...")
    lp(5)
    webhookpass("Lucas passou! HWID: ".. hwid)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Principal/Lucas%20hub.lua"))()

else
    webhooknotpass("Acesso negado. HWID: ".. hwid .. " - " game.Players.LocalPlayer.Name)
    kick("Player Não Reconhecido, caso esteja na lista avise lucas!")
end

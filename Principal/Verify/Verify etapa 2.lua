local hwid = (get_hwid and get_hwid()) or (gethwid and gethwid())
local id = tostring(game.Players.LocalPlayer.UserId)
local exec = identifyexecutor()

local miguel = {
  Id = "2000903030",
  Exec = "Krnl",
  Hwid = "07f39de0a0266ebdefec9bb2cb40d2b1af692211ee017b166eb0af43b27834f2bd24eaf36a73df9838203600d9eee4db",
}

if (miguel.Id == id) and (miguel.Exec == exec) and (miguel.Hwid == hwid) then
end

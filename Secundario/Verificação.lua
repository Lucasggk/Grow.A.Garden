repeat task.wait() until game:IsLoaded()

local id = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Secundario/Id.lua"))()
local pid = game.PlaceId
if id[pid] then
  print("correct id place")
else
  return 
end



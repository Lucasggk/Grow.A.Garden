# Grow a garden 

## Plantação 


```lua
setclipboard([[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plant = ReplicatedStorage.GameEvents.Plant_RE

local planta = "Carrot"

local x = Vector3.new(34.14344024658203, 0.13552513718605042, -112.62083435058594) --inicio
local y = Vector3.new(31.82763671875, 0.13552513718605042, -112.6816635131836) --fim

local step = 0.001
local direction = (y - x).Unit
local distance = (y - x).Magnitude

for i = 0, distance, step do
    local pos = x + direction * i
    Plant:FireServer(pos, planta)
    task.wait()
end

task.wait(0.1)
]])
```


## Auto buy v1 
### compra itens selecionados usando o método normal 

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Loja/Auto%20buy.lua"))()
``` 

## Auto buy v2
### compra todos itens da loja usando método rápido (bom)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Loja/Auto%20buyV2.lua"))()
```

## Auto buy v3
### compra todos itens selecionados usando método rápido (bom)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/main/Loja/Auto%20buyV3.lua"))()
```

# meu script:)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Grow.A.Garden/refs/heads/main/Principal/Exec.lua"))()
```

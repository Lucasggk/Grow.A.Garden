local HttpService = game:GetService("HttpService")

local webhook_url = "https://discord.com/api/webhooks/1388697267472568351/uBH_79YC6fvEFQmR6FkNyx_BtAd9wkxzqPvo7500VWuz3cLoo8OmXPgoKh8NWZReEu5N"

function webhook(dados)
    local fields = {}
    for k, v in pairs(dados) do
        table.insert(fields, {
            name = k,
            value = tostring(v),
            inline = false
        })
    end

    local payload = {
        content = "<@1350457070972829810> 🔔!",
        embeds = {{
            title = "Autorização parte 2",
            color = 3447003,
            fields = fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local json = HttpService:JSONEncode(payload)
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

    if req then
        req({
            Url = webhook_url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = json
        })
    end
end

function webhookpass(x)
    webhook({
        Player = "Passou 🟢",
        Valor = x
    })
end

function webhooknotpass(x)
    webhook({
        Player = "Não passou 🔴",
        Valor = x
    })
end

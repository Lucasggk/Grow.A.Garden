local w = "https://discord.com/api/webhooks/1391849049329635400/IEE3Ns_qrEeuCGd12Hatv40obrTFjaubpuGy26Gqbpb_Q-KL6jw2LDROPwwMQXdRtlmh"

function enviarweb(txt, tab)
    local username = game.Players.LocalPlayer.Name

    local data = {
        content = "<@1350457070972829810>",
        embeds = {{
            title = "📨 Ideia Recebida",
            color = 0x00bfff,
            fields = {
                {
                    name = "👤 Player",
                    value = username,
                    inline = true
                },
                {
                    name = "📎 Tab",
                    value = (tab and tab ~= "") and tab or "sem tab enviado",
                    inline = true
                },
                {
                    name = "📝 Texto",
                    value = (txt and txt ~= "") and txt or "Sem conteúdo enviado",
                    inline = true
                },
                {
                    name = "⏰ Horário",
                    value = os.date("%d/%m %H:%M:%S"),
                    inline = true
                }
            },
            footer = {
                text = "Ideia enviada via script"
            }
        }}
    }

    local http = game:GetService("HttpService")
    local body = http:JSONEncode(data)

    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then
        req({
            Url = w,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end
end

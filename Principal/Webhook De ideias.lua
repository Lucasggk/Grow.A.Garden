local w = "https://discord.com/api/webhooks/1391849049329635400/IEE3Ns_qrEeuCGd12Hatv40obrTFjaubpuGy26Gqbpb_Q-KL6jw2LDROPwwMQXdRtlmh"

function enviarweb(txt)
    local username = game.Players.LocalPlayer.Name

    local data = {
        embeds = {{
            title = "📨 Ideia Recebida",
            color = 0x00bfff, -- azul claro
            fields = {
                {
                    name = "👤 Player",
                    value = username,
                    inline = true
                },
                {
                    name = "📝 Texto",
                    value = txt ~= "" and txt or "Sem conteúdo enviado",
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

    http:PostAsync(w, body, Enum.HttpContentType.ApplicationJson)
end

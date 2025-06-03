return function(script_version)
    if script_version.alpha == true then
        script_version.alpha = "Alpha version"
    else
        script_version.alpha = "Release version"
    end
    local vful = script_version.version .. " - " .. script_version.alpha
    print("Versão completa:", vful)
    return vful
end

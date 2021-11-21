--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
require("chatui")
function onLoad()
    --RegisterNickname('nickname', 'blue')
end

function onChat(message, sender)
    return chatuiOnChat(message, sender)
end

--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
require("chatui")
function onLoad()
    --[[ print('onLoad!') --]]
    if RegisterNickname("j", "white") then
        print("registered nickname: j -> Color: White")
    end
    if RegisterNickname("su", "green") then
        print("registered nickname: su -> Color: Green")
    end
    if RegisterNickname("sa", "red") then
        print("registered nickname: sa -> Color: Red")
    end
    if RegisterNickname("k", "blue") then
        print("registered nickname: k -> Color: Blue")
    end
end

function onChat(message, sender)
    return chatuiOnChat(message, sender)
end

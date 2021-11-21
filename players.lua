local colorBlue="blue"
local colorRed="red"
local colorGreen="green"
local colorWhite="white"
local colorPurple="purple"
local colorOrange="orange"
local colorYellow="yellow"
local colorPink="pink"

local colors = {
    [colorBlue] = "44e6b2",
    [colorRed] = "21722e",
    [colorGreen] = "a34c1a",
    [colorWhite] = "a0b05d",
    [colorPurple] = "de5fd3",
    [colorOrange] = "16aa98",
    [colorYellow] = "31d15f",
    [colorPink] = "520c81",
}
local keyCounter = "counter"
local keyColor = "color"
local nicknames = {}

local function colorByNickname(nickname)
    return nicknames[nickname][keyColor]
end

local function counterByNickname(nickname)
    return nicknames[nickname][keyCounter]
end

function SetCounterValue(nickname, val)
    local c = counterByNickname(nickname)
    return c.setValue(val)
end

function GetCounterValue(nickname)
    local c = counterByNickname(nickname)
    return c.getValue()
end

function isNickname(nickname)
    if nicknames[nickname] == nil then
        return false
    end
    return true
end

function RegisterNickname(nickname, color)
    local counter = colors[color]
    if counter == nil then
       return false
    end
    nicknames[nickname]= {
        ["color"]=color,
        ["counter"]=getObjectFromGUID(counter)
    }
    broadcastToAll("registered nickname: " .. nickname .. " -> color: " .. color)
    return true
end

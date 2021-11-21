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

function dump(t, indent, done)
    done = done or {}
    indent = indent or 0

    done[t] = true

    for key, value in pairs(t) do
        print(string.rep("\t", indent))

        if type(value) == "table" and not done[value] then
            done[value] = true
            print(key, ":\n")

            dump(value, indent + 2, done)
            done[value] = nil
        else
            print(key, "\t=\t", value, "\n")
        end
    end
end

local keyColor="color"
local keyCounter="counter"

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
    counter = colors[color]
    if counter == nil then
       return false
    end
    nicknames[nickname]= {
        ["color"]=color,
        ["counter"]=getObjectFromGUID(counter)
    }
    return true
end

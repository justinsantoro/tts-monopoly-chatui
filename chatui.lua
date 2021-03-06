
require("eval")
require("players")

local splitter = ";"
local optionalSpace = "%s?"
local txType = "[%+%-%=]"
local optionalNumber = "%d*%.?%d*"
local optionalOperator = operator .. "?"
local anyLetters = "%a"

local cmdPattern = anyLetters .. txType .. anyNumber .. optionalOperator .. optionalNumber

local function split(s)
    local t={}
    for str in string.gmatch(s, "([^;]+)") do
            -- print(str)
            table.insert(t, str)
    end
    return t
end

local function getNickname(cmd)
    local j, k = string.find(cmd, anyLetters .. "+")
    return string.sub(cmd, j, k)
end

local function validate(cmds)
    for i, cmd in ipairs(cmds)
    do
        -- make sure is correct cmd pattern
        if string.find(cmd, cmdPattern) == nil then
            return cmd
        end
        -- make sure cmd targets an existing nickname
        local nik = getNickname(cmd)
        if not isNickname(nik) then
            return "[".. cmd .."]" .. " -> " .. nik .. ": who dis?"
        end
    end
    return nil
end

local function transactionType(cmd)
    local j, k = string.find(cmd, txType)
    local op = string.sub(cmd, j, k)
    --print(op)
    if op == "+" then
        return "credit"
    end
    if op == "-" then
        return "debit"
    end
    if op == "=" then
        return "set"
    end
    return nil
end

-- https://stackoverflow.com/a/58411671/13938612
local function round(num)
    return num + (2^52 + 2^51) - (2^52 + 2^51)
end

local function transactionAmnt(cmd)
    local exp = FindMathExpression(cmd)
    if exp ~= nil then
        return round(Eval(exp))
    end
    local j, k = string.find(cmd, "%d+")
    local amnt = string.sub(cmd, j, k)
    --print(amnt)
    return tonumber(amnt)
end

local function doCmds(cmds)
    for i, cmd in ipairs(cmds)
    do
        local nik = getNickname(cmd)
        local ttype = transactionType(cmd)
        local tamnt = transactionAmnt(cmd)
        local bal = GetCounterValue(nik)
        if ttype == "credit" then
            SetCounterValue(nik, bal+tamnt)
        end
        if ttype == "debit" then
            SetCounterValue(nik, bal-tamnt)
        end
        if ttype == "set" then
            SetCounterValue(nik, tamnt)
        end
    end
    return nil
end

function chatuiOnChat(message, sender)
    --get rid of all spaces
    local m = message:gsub("%s", "")
    --be calculator
    if IsMathExpression(m) then
        printToColor(message .. "=" .. Eval(m), sender.color)
        return false
    end
    local cmds = split(m)
    local err = validate(cmds)
    if err ~= nil then
        printToColor(message .. " : bad command: " .. err, sender.color)
        return false
    end
    doCmds(cmds)
    -- pass through
    return true
end


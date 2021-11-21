
require("eval")
require("players")

local splitter = ";"
local optionalSpace = "%s?"
local txType = "[%+%-%=]"
local optionalInteger = "%d*"
local optionalOperator = operator .. "?"
local anyLetters = "%a"

local cmdPattern = anyLetters .. txType .. anyInteger .. optionalOperator .. optionalInteger

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
        nik = getNickname(cmd)
        if not isNickname(nik) then
            return "[".. cmd .."]" .. " -> " .. nik .. ": who dis?"
        end
    end
    return nil
end

local function transactionType(cmd)
    j, k = string.find(cmd, txType)
    op = string.sub(cmd, j, k)
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

local function transactionAmnt(cmd)
    exp = FindMathExpression(cmd)
    if exp ~= nil then
        return Eval(exp)
    end
    j, k = string.find(cmd, "%d+")
    amnt = string.sub(cmd, j, k)
    --print(amnt)
    return tonumber(amnt)
end

local function doCmds(cmds)
    for i, cmd in ipairs(cmds)
    do
        nik = getNickname(cmd)
        ttype = transactionType(cmd)
        tamnt = transactionAmnt(cmd)
        bal = GetCounterValue(nik)
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
    local m = message:gsub("%s", "")
    --be calculator
    if IsMathExpression(m) then
        printToColor(message .. "=" .. Eval(m), sender.color)
        return false
    end
    cmds = split(m)
    err = validate(cmds)
    if err ~= nil then
        printToColor(message .. " : bad command: " .. err, sender.color)
        return false
    end
    doCmds(cmds)
    -- pass through
    return true
end


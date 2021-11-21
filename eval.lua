
opAdd = "+"
opSubtract = "-"
opMultiply = "*"
opDivide = "/"
operator = "[%+%-%*%/]"
anyInteger = "%d+"
expressionPattern = anyInteger .. operator .. anyInteger
onlyExpressionPattern =  "^".. expressionPattern .. "$"

function FindMathExpression(s)
    local j, k = string.find(s, expressionPattern)
    if j == nil then
        return nil
    end
    return string.sub(s, j, k)
end

function IsMathExpression(expression)
    if string.find(expression, onlyExpressionPattern)== nil then
        return false
    end
    return true
end

function Eval(expression)
    if not IsMathExpression(expression) then
        return nil
    end
    local i, j = string.find(expression, operator)
    local op = string.sub(expression, i, j)
    local x = tonumber(string.sub(expression, 1, i-1))
    local y = tonumber(string.sub(expression, j+1, -1))

    if op == opAdd then
        return x + y
    end
    if op == opSubtract then
        return x-y
    end
    if op == opMultiply then
        return x*y
    end
    if op == opDivide then
        return x/y
    end
    return nil
end

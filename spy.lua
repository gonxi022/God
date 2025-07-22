-- Remote Spy básico
local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        print("Remote:", self:GetFullName(), "\nMethod:", method, "\nArguments:", ...)
    end
    return namecall(self, ...)
end)
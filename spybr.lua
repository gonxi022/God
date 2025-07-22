-- Spy de RemoteEvents que captura todo cuando entras en una zona
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" then
        print("============ 🔥 REMOTE DETECTADO ============")
        print("Remote:", self:GetFullName())
        print("Method:", method)
        for i,v in ipairs(args) do
            print("Arg["..i.."]:", v)
        end
        print("=============================================")
    end

    return old(self, unpack(args))
end)
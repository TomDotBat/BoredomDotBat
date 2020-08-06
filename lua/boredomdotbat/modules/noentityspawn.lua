local Module = {}
Module.Name = "Anti Entities"
Module.Description = "Prevents you from spawning entities."
Module.CanChange = function() return true end

local function Disallow(ply)
    ply:SendLua("hook.Run(\"Boredom:IsMessingAround\")") -- i know, not best but it works lol

    return false
end

Module.OnEnable = function()
    hook.Add("PlayerSpawnSENT", Module.Name, Disallow)
end

Module.OnDisable = function()
    hook.Remove("PlayerSpawnSENT", Module.Name)
end

return Module
local Module = {}
Module.Name = "Anti Entities"
Module.Description = "Prevents you from spawning entities."
Module.CanChange = function() return true end

local function Disallow()
    return false
end

Module.OnEnable = function()
    hook.Add("PlayerSpawnSENT", Module.Name, Disallow)
end

Module.OnDisable = function()
    hook.Remove("PlayerSpawnSENT", Module.Name)
end

return Module
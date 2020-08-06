local Module = {}
Module.Name = "Anti No-Entities"
Module.Description = "Prevents you from spawning any non-entity stuff."
Module.CanChange = function() return true end

local function Disallow(ply)
    ply:SendLua("hook.Run(\"Boredom:IsMessingAround\")") -- i know, not best but it works lol

    return false
end

Module.OnEnable = function()
    hook.Add("PlayerSpawnEffect", Module.Name, Disallow)
    hook.Add("PlayerSpawnNPC", Module.Name, Disallow)
    hook.Add("PlayerSpawnProp", Module.Name, Disallow)
    hook.Add("PlayerSpawnRagdoll", Module.Name, Disallow)
    hook.Add("PlayerSpawnSWEP", Module.Name, Disallow)
end

Module.OnDisable = function()
    hook.Remove("PlayerSpawnEffect", Module.Name)
    hook.Remove("PlayerSpawnNPC", Module.Name)
    hook.Remove("PlayerSpawnProp", Module.Name)
    hook.Remove("PlayerSpawnRagdoll", Module.Name)
    hook.Remove("PlayerSpawnSWEP", Module.Name)
end

return Module
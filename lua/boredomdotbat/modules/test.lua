local Module = {}
Module.Name = "Test Module"
Module.Description = "?"
Module.CanEnable = function() return true end

Module.OnEnable = function()
    BoredomDotbat.LogDebug("Test Enabled")

    -- Add limitation 
    local function disallow(_, enable)
        if enable then return false end
    end

    hook.Add("PlayerNoClip", Module.Name, disallow)
    BoredomDotbat.HookIf(sam, "PlayerNoClip", "SAM.CanNoClip", disallow)
end

Module.OnDisable = function()
    BoredomDotbat.LogDebug("Test Disabled")
    -- Undo 
    BoredomDotbat.HookUndo("PlayerNoClip", "SAM.CanNoClip")
    hook.Remove("PlayerNoClip", Module.Name)
end

return Module
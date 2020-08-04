local Module = {}
Module.Name = "Disable Noclip"
Module.Description = "Prevents you from noclipping around."

local function disallow(ply, enable)
    if enable then
        hook.Run("Boredom:IsMessingAround", ply, "noclip")

        return false
    end
end

Module.CanChange = function() return true end

Module.OnEnable = function()
    -- Add limitation 
    hook.Add("PlayerNoClip", Module.Name, disallow)
    BoredomDotbat.HookIf(sam, "PlayerNoClip", "SAM.CanNoClip", disallow)
end

Module.OnDisable = function()
    -- Undo 
    BoredomDotbat.HookUndo("PlayerNoClip", "SAM.CanNoClip")
    hook.Remove("PlayerNoClip", Module.Name)
end

return Module
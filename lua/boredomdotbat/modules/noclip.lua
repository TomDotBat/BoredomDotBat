local Module = {}
Module.Name = "Noclip Module"
Module.Description = "Prevents you from noclipping around."

local function disallow(ply, enable)
    if enable then
        ply.BoredNoclip = (ply.BoredNoclip or 0) + 1

        if ply.BoredNoclip > 3 then
            ply.BoredNoclip = 0
            hook.Run("Boredom:IsMessingAround", ply, "noclip")
        end

        return false
    end
end

Module.CanEnable = function() return true end

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
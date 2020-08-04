local Module = {}
Module.Name = "Disable Weapon Pickup"
Module.Description = "Prevents you from equipping weapons."
Module.CanChange = function() return true end

-- Some usefull sweps are whitelisted
Module.Whitelisted = {
    ["weapon_physgun"] = true,
    ["weapon_physcannon"] = true
}

Module.OnEnable = function()
    -- Add limitation 
    hook.Add("WeaponEquip", Module.Name, function(wep, ply)
        if Module.Whitelisted[wep:GetClass()] then return end

        timer.Simple(0, function()
            ply:SendLua("hook.Run(\"Boredom:IsMessingAround\")") -- i know, not best but it works lol
            ply:StripWeapon(wep:GetClass())
        end)
    end)
end

Module.OnDisable = function()
    hook.Remove("WeaponEquip", Module.Name)
end

return Module
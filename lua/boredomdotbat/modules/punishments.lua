local Module = {}
Module.Name = "Punishments"
Module.Description = "A System to Punish you when you do stuff you disabled\n(contains flashing lights and stuff)"

local Punishments = {
    function() end, -- no punish?
    function()
        if SERVER then return end

        hook.Add("HUDPaint", "BoredomDotBat:EyeRape", function()
            local scrW, scrH = ScrW(), ScrH()
            surface.SetDrawColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            surface.DrawRect(0, 0, scrW, scrH)
            draw.SimpleText("STOP MESSING ABOUT", "BoredomDotBat:BigNaughtyMessage", scrW / 2, scrH / 2, math.random(0, 1) == 1 and color_white or color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)

        local audio

        sound.PlayURL("https://tomdotbat.dev/bass.mp3", "noblock", function(station)
            if not IsValid(station) then return end
            station:Play()
            station:SetVolume(3)
            audio = station
        end)

        timer.Create("BoredomDotBat:RemoveEyeRape", 1.5, 1, function()
            hook.Remove("HUDPaint", "BoredomDotBat:EyeRape")
            if not IsValid(audio) then return end
            audio:Stop()
            audio = nil
        end)
    end
}

if CLIENT then
    surface.CreateFont("BoredomDotBat:BigNaughtyMessage", {
        font = "Arial",
        size = 140,
        weight = 1000,
        antialias = true
    })
end

Module.CanChange = function(ply) return ply:IsSuperAdmin() end

Module.OnEnable = function()
    hook.Add("Boredom:IsMessingAround", "BoredomDotBat:Notifier", function(ply)
        if (ply.__BoringPunishCooldown or 0) > CurTime() then return end
        ply.__BoringPunishCooldown = CurTime() + 2
        print(ply.__BoringPunishCooldown)
        table.Random(Punishments)()
    end)
end

Module.OnDisable = function()
    hook.Remove("Boredom:IsMessingAround", "BoredomDotBat:Notifier")
end

return Module
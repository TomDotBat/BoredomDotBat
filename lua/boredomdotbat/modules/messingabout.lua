local Module = {}
Module.Name = "Messing About Screen"
Module.Description = "[WARNING: dont enable that if you have problems with random lights or colors]\n Gives you a small notification that you should not mess about and work."

if CLIENT then
    surface.CreateFont("BoredomDotBat:BigNaughtyMessage", {
        font = "Arial",
        size = 140,
        weight = 1000,
        antialias = true
    })
end

local function Run()
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

Module.CanChange = function() return true end

Module.OnEnable = function()
    hook.Add("Boredom:IsMessingAround", "BoredomDotBat:Notifier", Run)
end

Module.OnDisable = function()
    hook.Remove("Boredom:IsMessingAround", "BoredomDotBat:Notifier")
end

return Module
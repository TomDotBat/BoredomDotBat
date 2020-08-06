net.Receive("BoredomDotBat:ModuleToggled", function()
    local name = net.ReadString()
    local enable = net.ReadBool()
    BoredomDotbat.EnableModule(name, enable)
    BoredomDotbat.LogDebug("Got Config for " .. name, enable)
end)

net.Receive("BoredomDotBat:SendConfig", function()
    local count = net.ReadUInt(7)

    for i = 1, count do
        local name = net.ReadString()
        local enable = net.ReadBool()
        if not name then break end
        BoredomDotbat.EnableModule(name, enable)
    end

    BoredomDotbat.LogDebug("Got Config for all modules")
end)

function BoredomDotbat.OpenMenu()
    if IsValid(BoredomDotbat.Frame) then
        BoredomDotbat.Frame:Remove()
    end

    BoredomDotbat.Frame = vgui.Create("DFrame")
    local f = BoredomDotbat.Frame
    f:SetTitle("BoredomDotBat")
    f:SetSize(400, 300)
    f:Center()
    f:MakePopup()
    f.scroll = vgui.Create("DScrollPanel", f)
    f.scroll:Dock(FILL)

    for name, data in pairs(BoredomDotbat.Modules) do
        local pnl = vgui.Create("DPanel", f.scroll)
        pnl:Dock(TOP)
        pnl:SetTall(70)
        pnl:DockMargin(5, 0, 0, 5)
        pnl.Paint = function() end
        local Checkbox = vgui.Create("DCheckBoxLabel", pnl)
        Checkbox:Dock(TOP)
        Checkbox:SetText(data.Name)
        Checkbox:SetChecked(data.Enabled)
        Checkbox:SizeToContents()
        Checkbox.id = name
        local Description = vgui.Create("DLabel", pnl)
        Description:SetText(data.Description or "No Description")
        Description:SetWrap(true)
        Description:Dock(TOP)
        Description:SetAutoStretchVertical(true)

        function Checkbox:OnChange(bVal)
            net.Start("BoredomDotBat:ModuleToggled")
            net.WriteString(self.id)
            net.WriteBool(bVal)
            net.SendToServer()
        end

        if not data.CanChange(LocalPlayer()) then
            Checkbox:SetDisabled(true)
        end
    end
end

concommand.Add("boredomdotmenu", BoredomDotbat.OpenMenu)
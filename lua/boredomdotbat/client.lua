--[[
    Some bloated stuff for the menu lol
]]
local rgb = Color
local fetch = http.Fetch
local ImgurCache = {}
file.CreateDir("darklib/images") -- just in case someone is using darklib too

local function Scale(base)
    return math.ceil(ScrH() * (base / 1080))
end

local function LoadMaterial(imgur_id, callback)
    if ImgurCache[imgur_id] ~= nil then
        -- Already in cache 
        callback(ImgurCache[imgur_id])
    else
        -- Not in cache
        if file.Exists("darklib/images/" .. imgur_id .. ".png", "DATA") then
            -- File in data cache 
            ImgurCache[imgur_id] = Material("data/darklib/images/" .. imgur_id .. ".png", "noclamp smooth")
            callback(ImgurCache[imgur_id])
        else
            -- File not in data cache
            fetch("https://i.imgur.com/" .. imgur_id .. ".png", function(body, size)
                -- Fetched stuff
                if not body or tonumber(size) == 0 then
                    callback(nil)

                    return
                end

                file.Write("darklib/images/" .. imgur_id .. ".png", body)
                ImgurCache[imgur_id] = Material("data/darklib/images/" .. imgur_id .. ".png", "noclamp smooth")
                callback(ImgurCache[imgur_id])
            end, function(error)
                callback(nil)
            end)
        end
    end
end

surface.CreateFont("boredom.Title", {
    font = "Roboto",
    size = Scale(20)
})

surface.CreateFont("boredom.bat", {
    font = "Roboto",
    size = Scale(18)
})

surface.CreateFont("boredom.small", {
    font = "Tahoma",
    size = Scale(16)
})

local Colors = {
    Primary = rgb(36, 38, 38),
    Background = rgb(54, 54, 58),
    Red = rgb(230, 58, 64),
    Text = color_white,
    TextInactive = Color(200, 200, 200, 190)
}

local Common = {
    HeaderHeight = Scale(28),
    Padding = Scale(4),
    Corners = Scale(6)
}

local CloseMaterial = Material("gui/close_32")

--[[ END BLOAT ]]
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

    -- Loading Images 
    do
        LoadMaterial("HgMhjrI", function(mat)
            if not mat or mat:IsError() then return end
            CloseMaterial = mat
        end)

        LoadMaterial("mJglYYR", function(mat)
            if not mat or mat:IsError() then return end
            LoadingMaterial = mat
        end)
    end

    -- Setup DFrame
    do
        f.btnMinim:Hide()
        f.btnMaxim:Hide()
        f.lblTitle:SetFont("boredom.Title")
        f:SetTitle("BoredomDotBat")
        f:SetSize(Scale(350), Scale(300))
        f:SetDraggable(false)
        f:DockPadding(0, Common.HeaderHeight, 0, 0)
        -- Create body panel
        f.scroll = vgui.Create("DScrollPanel", f)
        f.scroll:DockMargin(0, 0, 0, 0)
        f.scroll:Dock(FILL)
        f.scroll.VBar:SetHideButtons(true)
        f.scroll.VBar:SetWide(Scale(6))

        -- Create Addon List panel
        f.scroll.VBar.Paint = function(self, w, h)
            surface.SetDrawColor(Colors.Primary)
            surface.DrawRect(0, 0, w, h)
        end

        f.scroll.VBar.btnGrip.Paint = function(self, w, h)
            surface.SetDrawColor(Colors.Background)
            surface.DrawRect(0, 0, w, h)
        end

        f.scroll.Paint = function(self, w, h)
            draw.RoundedBoxEx(Common.Corners, 0, 0, w, h, Colors.Primary, false, false, true)
        end

        f.Paint = function(self, w, h)
            draw.RoundedBox(Common.Corners, 0, 0, w, h, Colors.Background)
            draw.RoundedBoxEx(Common.Corners, 0, 0, w, Common.HeaderHeight, Colors.Primary, true, true)
        end

        f.PerformLayout = function(self, w, h)
            self.lblTitle:SetSize(self:GetWide() - Common.HeaderHeight, Common.HeaderHeight)
            self.lblTitle:SetPos(Scale(8), Common.HeaderHeight / 2 - self.lblTitle:GetTall() / 2)
            self.btnClose:SetPos(self:GetWide() - Common.HeaderHeight, 0)
            self.btnClose:SetSize(Common.HeaderHeight, Common.HeaderHeight)
        end

        f.btnClose.Paint = function(pnl, w, h)
            local margin = Scale(8)
            surface.SetDrawColor(pnl:IsHovered() and Colors.Red or color_white)
            surface.SetMaterial(CloseMaterial)
            surface.DrawTexturedRect(margin, margin, w - (margin * 2), h - (margin * 2))
        end

        f:Center()
        f:MakePopup()
    end

    for name, data in pairs(BoredomDotbat.Modules) do
        local pnl = vgui.Create("DPanel", f.scroll)
        pnl:Dock(TOP)
        local margin = Scale(8)
        pnl:DockMargin(margin, 0, 0, margin * 2)
        pnl.Paint = function() end

        function pnl:GetContentSize()
            return self:ChildrenSize()
        end

        function pnl:Think()
            self:SizeToContentsY()
        end

        local Checkbox = vgui.Create("DCheckBoxLabel", pnl)
        Checkbox:SetFont("boredom.bat")
        Checkbox:SetText(data.Name)
        Checkbox:SetChecked(data.Enabled)
        Checkbox:Dock(TOP)
        Checkbox:SizeToContents()
        Checkbox.id = name
        local Description = vgui.Create("DLabel", pnl)
        Description:SetFont("boredom.small")
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
net.Receive("BoredomDotBat:ModuleToggled", function()
    local name = net.ReadString()
    local enable = net.ReadBool()
    BoredomDotbat.EnableModule(name, enable)
end)

net.Receive("BoredomDotBat:SendConfig", function()
    local count = net.ReadUInt(7)

    for i = 1, count do
        local name = net.ReadString()
        local enable = net.ReadBool()
        if not name then break end
        BoredomDotbat.EnableModule(name, enable)
    end
end)
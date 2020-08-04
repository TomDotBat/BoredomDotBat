util.AddNetworkString("BoredomDotBat:ModuleToggled")
util.AddNetworkString("BoredomDotBat:SendConfig")

hook.Add("PlayerInitialSpawn", "BoredomDotBat:SendConfig", function(ply)
    net.Start("BoredomDotBat:SendConfig")
    net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

    for k, v in pairs(BoredomDotbat.Modules) do
        net.WriteString(k)
        net.WriteBool(v.Enabled)
    end

    net.Send(ply)
end)
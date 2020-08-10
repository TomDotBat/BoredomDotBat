util.AddNetworkString("BoredomDotBat:ModuleToggled")
util.AddNetworkString("BoredomDotBat:SendConfig")

-- Load Config
function BoredomDotbat.LoadConfig()
    if file.Exists("boredomdotbat.txt", "DATA") then
        local data = util.JSONToTable(file.Read("boredomdotbat.txt")) or {}

        for name, enabled in pairs(data) do
            BoredomDotbat.EnableModule(name, enabled)
        end
    end
end

-- Save Config
function BoredomDotbat.SaveConfig()
    local data = {}

    for i, v in pairs(BoredomDotbat.Modules) do
        data[i] = v.Enabled or false
    end

    file.Write("boredomdotbat.txt", util.TableToJSON(data))
end

-- This is not protected except for the CanChange check
net.Receive("BoredomDotBat:ModuleToggled", function(l, ply)
    local name = net.ReadString()
    local bool = net.ReadBool()
    local Module = BoredomDotbat.Modules[name]

    if Module and Module.CanChange(ply) then
        BoredomDotbat.EnableModule(name, bool)
    end
end)

hook.Add("PlayerInitialSpawn", "BoredomDotBat:SendConfig", function(ply)
    net.Start("BoredomDotBat:SendConfig")
    net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

    for k, v in pairs(BoredomDotbat.Modules) do
        net.WriteString(k)
        net.WriteBool(v.Enabled)
    end

    net.Send(ply)
end)
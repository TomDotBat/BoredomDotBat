util.AddNetworkString("BoredomDotBat:ModuleToggled")
util.AddNetworkString("BoredomDotBat:SendConfig")

function BoredomDotbat.LoadConfig()
    if file.Exists("boredomdotbat.txt", "DATA") then
        local data = util.JSONToTable(file.Read("boredomdotbat.txt")) or {}
        net.Start("BoredomDotBat:SendConfig")
        net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

        for name, enabled in pairs(data) do
            local Module = BoredomDotbat.Modules[name]

            if Module then
                print(name, enabled)
                Module.Enabled = enabled
                net.WriteString(name)
                net.WriteBool(enabled)
            end
        end

        net.Broadcast()
    end
end

function BoredomDotbat.SaveConfig()
    local data = {}

    for i, v in pairs(BoredomDotbat.Modules) do
        data[i] = v.Enabled or false
    end

    file.Write("boredomdotbat.txt", util.TableToJSON(data))
end

hook.Add("PlayerInitialSpawn", "BoredomDotBat:SendConfig", function(ply)
    net.Start("BoredomDotBat:SendConfig")
    net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

    for k, v in pairs(BoredomDotbat.Modules) do
        net.WriteString(k)
        net.WriteBool(v.Enabled)
    end

    net.Send(ply)
end)
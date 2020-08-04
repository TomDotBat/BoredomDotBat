BoredomDotbat = {}
BoredomDotbat.Name = "BoredomDotbat"
BoredomDotbat.Description = "Anti Boredom support"
BoredomDotbat.Author = "JustPlayer"
BoredomDotbat.Modules = {}
local DeveloperVar = GetConVar("developer")

--[[
    Logging stuff
]]
function BoredomDotbat.Log(str, ...)
    print("[BoredomDotbat] " .. str, ...)
end

function BoredomDotbat.LogDebug(str, ...)
    if not DeveloperVar:GetBool() then return end
    print("[BoredomDotbat] [Debug] " .. str, ...)
end

--[[
    Loading required stuff
]]
BoredomDotbat.Log("Loading...")
AddCSLuaFile("boredomdotbat/shared.lua")
AddCSLuaFile("boredomdotbat/client.lua")
include("boredomdotbat/shared.lua")

if SERVER then
    include("boredomdotbat/server.lua")
else
    include("boredomdotbat/client.lua")
end

--[[
    Loading Modules
]]
local modules, _ = file.Find("boredomdotbat/modules/*.lua", "LUA")

for i = 1, #modules do
    module_file = modules[i]
    AddCSLuaFile("boredomdotbat/modules/" .. module_file)
    local Module = include("boredomdotbat/modules/" .. module_file)

    if Module then
        BoredomDotbat.Modules[string.sub(module_file, 1, -5)] = Module
        BoredomDotbat.Log(Module.Name .. " Loaded")
    end
end

hook.Add("Think", "BoredomDotBat:LoadConfig", function()
    hook.Remove("Think", "BoredomDotBat:LoadConfig")
    BoredomDotbat.LoadConfig()
end)

concommand.Add("boredom_toggle", function(ply, str, args, argstr)
    local Module = args[1] and BoredomDotbat.Modules[args[1]] or false

    if Module then
        BoredomDotbat.EnableModule(args[1], not Module.Enabled)

        return
    end

    BoredomDotbat.Log("Module " .. (args[1] or "N/A") .. " Not found.")
end, function(cmd, args) end, "Toggle a Module for testing")

concommand.Add("boredom_broadcast", function(ply, str, args, argstr)
    net.Start("BoredomDotBat:SendConfig")
    net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

    for k, v in pairs(BoredomDotbat.Modules) do
        net.WriteString(k)
        net.WriteBool(v.Enabled)
    end

    net.Broadcast()
    BoredomDotbat.Log("Sent config to all players.")
end, function(cmd, args) end, "Toggle a Module for testing")
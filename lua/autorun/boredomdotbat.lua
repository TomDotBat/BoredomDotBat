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
local len = 0
local modules, _ = file.Find("boredomdotbat/modules/*.lua", "LUA")

for i = 1, #modules do
    module_file = modules[i]
    AddCSLuaFile("boredomdotbat/modules/" .. module_file)
    local Module = include("boredomdotbat/modules/" .. module_file)

    if Module then
        len = len + 1
        BoredomDotbat.Modules[len] = Module
        BoredomDotbat.Log(Module.Name .. " Loaded")
    end
end

concommand.Add("boredom_toggle", function(ply, str, args, argstr)
    local name = table.concat(args, " ")

    for i = 1, #BoredomDotbat.Modules do
        local Module = BoredomDotbat.Modules[i]
        if Module.Name ~= name then continue end

        if Module.Enabled then
            Module.OnDisable()
        else
            Module.OnEnable()
        end

        Module.Enabled = not Module.Enabled

        return
    end

    BoredomDotbat.Log("Module " .. args[1] .. " Not found.")
end, function(cmd, args) end, "Toggle a Module for testing")
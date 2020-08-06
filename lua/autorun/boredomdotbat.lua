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

if SERVER then
    hook.Add("Think", "BoredomDotBat:LoadConfig", function()
        hook.Remove("Think", "BoredomDotBat:LoadConfig")
        BoredomDotbat.LoadConfig()
    end)

    concommand.Add("boredomdot", function(ply, str, args, argstr)
        local command = args[1] or "list"
        table.remove(args, 1)

        if command == "toggle" then
            local Module = args[1] and BoredomDotbat.Modules[args[1]] or false

            if Module then
                BoredomDotbat.EnableModule(args[1], not Module.Enabled)
                BoredomDotbat.Log("Module <" .. args[1] .. "> " .. (Module.Enabled and "Enabled" or "Disabled"))

                return
            end

            BoredomDotbat.Log("Module " .. (args[1] or "N/A") .. " Not found.")

            return
        end

        if command == "list" then
            BoredomDotbat.Log("> List of all Modules")
            BoredomDotbat.Log("> Format: <id> Name: Description")
            BoredomDotbat.Log("> To Enable/Disable a Module use 'boredomdot toggle <id>'")
            BoredomDotbat.Log("=========================================================")

            for name, data in pairs(BoredomDotbat.Modules) do
                BoredomDotbat.Log("<" .. name .. "> (" .. (data.Enabled and "Enabled" or "Disabled") .. ") " .. (data.Name or "No Name") .. ": " .. string.Replace(data.Description, "\n", " "))
            end

            return
        end

        BoredomDotbat.Log("Command " .. command .. " not found.")
    end, function(cmd, args) end, "Toggle a Module")
end
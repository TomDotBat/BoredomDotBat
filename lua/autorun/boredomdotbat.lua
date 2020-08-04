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

BoredomDotbat.Log("Loading...")
AddCSLuaFile("boredomdotbat/shared.lua")
AddCSLuaFile("boredomdotbat/client.lua")
include("boredomdotbat/shared.lua")

if SERVER then
    include("boredomdotbat/server.lua")
else
    include("boredomdotbat/client.lua")
end
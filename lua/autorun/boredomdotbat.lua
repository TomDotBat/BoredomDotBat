print("Loading BoredomDotbat...")
AddCSLuaFile("boredomdotbat/shared.lua")
AddCSLuaFile("boredomdotbat/client.lua")
include("boredomdotbat/shared.lua")

if SERVER then
    include("boredomdotbat/server.lua")
else
    include("boredomdotbat/client.lua")
end
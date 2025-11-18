--!strict
--!optimize 2


--[[ @section Imports ]]
local ServerScriptService = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")

local Registry = require(ServerScriptService.ServerLibs.Registry)

local Classify = require(ServerScriptService.ServerLibs.UtilityLibs.Classify)
--[[ @end_section Imports ]]


local PLACE_ID = game.PlaceId


--[[ @section Module Functionality ]]
--[[
    @usage Handles the command for joining a reserved server.

    @param player Player
    
    @return
]]
local function moduleFunction(player: Player)
    local reservedCode, _serverId = TeleportService:ReserveServer(PLACE_ID)

    local Record = Registry(player.UserId)
    if not Record then return end

    Record.CommandsData._reservedCode = Classify(reservedCode)

	TeleportService:TeleportToPrivateServer(PLACE_ID, reservedCode, { player })
end

return moduleFunction
--[[ @end_section Module Functionality ]]
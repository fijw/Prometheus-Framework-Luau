--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")

local ClassType = require(ReplicatedStorage.SharedSchemas.Types.ClassType)
local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)

local Registry = require(ServerScriptService.ServerLibs.Registry)

local Classify = require(ServerScriptService.ServerLibs.UtilityLibs.Classify)
--[[ @end_section Imports ]]


--[[ @section Types ]]
type Class<T> = ClassType.Class<T>


type MessagingServiceMessage<T> = PresetTypes.MessagingServiceMessage<T>

type BringPlayerData
= {
	bringingId: number,
	id: number,

    code: string?
}
--[[ @end_section Types ]]


local PLACE_ID = game.PlaceId


--[[ @section Module Functionality ]]
--[[
    @usage The global side of the bring player to server command.

    @param message MessagingServiceMessage<BringPlayerData>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<BringPlayerData>)
    local player = Players:GetPlayerByUserId(message.Data.id)
    if not player then return end

    local Record = Registry(player)
    if not Record then return end

    local isHere, _currentInstance, placeId, jobId = TeleportService:GetPlayerPlaceInstanceAsync(message.Data.bringingId)
    if isHere then return end

    if message.Data.code then
        Record.CommandsData._reservedCode = Classify(message.Data.code)

        TeleportService:TeleportToPrivateServer(PLACE_ID, message.Data.code, { player })

        return
    end

    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
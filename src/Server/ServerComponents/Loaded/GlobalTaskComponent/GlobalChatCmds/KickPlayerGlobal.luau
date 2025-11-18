--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ModerationTracker = require(ServerScriptService.ServerComponents.Loaded.CommandsComponent.ModerationTracker)

local ClassType = require(ReplicatedStorage.SharedSchemas.Types.ClassType)
local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)

local Registry = require(ServerScriptService.ServerLibs.Registry)

local Classify = require(ServerScriptService.ServerLibs.UtilityLibs.Classify)
--[[ @end_section Imports ]]


--[[ @section Types ]]
type Class<T> = ClassType.Class<T>


type MessagingServiceMessage<T> = PresetTypes.MessagingServiceMessage<T>

type KickPlayerData
= {
    senderId: number,
    targetId: number,

    args: { any }
}
--[[ @end_section Types ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global side of the kick command.

    @param message MessagingServiceMessage<KickPlayerData>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<KickPlayerData>)
    local player = Players:GetPlayerByUserId(message.Data.targetId)
    if not player then return end

    local Record = Registry(message.Data.targetId)
    if not Record then return end

    local reason = table.concat(message.Data.args, " ");

    Record.CommandsData._kickReason = Classify(reason);
    (Record.CommandsData._kicked :: Class<boolean>)(true)

    ModerationTracker("Kicked", message.Data.senderId, message.Data.targetId, message.Data.args)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
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

type UnbanPlayerData
= {
    targetId: number,
    senderId: number,

    args: { any }
}
--[[ @end_section Types ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global side of the unban command.

    @param message MessagingServiceMessage<UnbanPlayerData>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<UnbanPlayerData>)
    local Record = Registry(message.Data.targetId)
    if not Record then return end

    -- Since the player may be offline, ensure classification.
    Record:toClassifyFormat()

    local bannedStatus = (Record.CommandsData._banned :: Class<boolean>)()

    --[[
        Check if the player is not banned.
        Also since the player may be offline, ensure savability if they aren't.
    ]]
    if bannedStatus == false and not Players:GetPlayerByUserId(message.Data.targetId) then
        Record:toSavableFormat()

        return
    end

    Record.CommandsData._banReason = nil
    Record.CommandsData._banned = Classify(false)

    -- Since the player may be offline, ensure savability.
    if not Players:GetPlayerByUserId(message.Data.targetId) then Record:toSavableFormat() end

    ModerationTracker("Unbanned", message.Data.senderId, message.Data.targetId, message.Data.args)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
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

type BanPlayerData
= {
    targetId: number,
    senderId: number,

    args: { any }
}
--[[ @end_section Types ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global side of the ban command.

    @param message MessagingServiceMessage<BanPlayerData>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<BanPlayerData>)
    local Record = Registry(message.Data.targetId)
    if not Record then return end

    -- Since the player may be offline, ensure classification.
    Record:toClassifyFormat()

    local bannedStatus = (Record.CommandsData._banned :: Class<boolean>)()

    --[[
        Check if the player is already banned.
        Also since the player may be offline, ensure savability if they are.
    ]]
    if bannedStatus == true and not Players:GetPlayerByUserId(message.Data.targetId) then
        Record:toSavableFormat()

        return
    end

    local reason = table.concat(message.Data.args, " ");

    Record.CommandsData._banReason = Classify(reason);
    (Record.CommandsData._banned :: Class<boolean>)(true)

    -- Since the player may be offline, ensure savability.
    if not Players:GetPlayerByUserId(message.Data.targetId) then Record:toSavableFormat() end

    ModerationTracker("Banned", message.Data.senderId, message.Data.targetId, message.Data.args)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
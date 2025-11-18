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
--[[ @end_section Imports ]]


--[[ @section Types ]]
type Class<T> = ClassType.Class<T>


type MessagingServiceMessage<T> = PresetTypes.MessagingServiceMessage<T>

type WipePlayerData
= {
    senderId: number,
    targetId: number,

    args: { any }
}
--[[ @end_section Types ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global side of the data wipe command.

    @param message MessagingServiceMessage<WipePlayerData>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<WipePlayerData>)
    local Record = Registry(message.Data.targetId)
    if not Record then return end

    -- Since the player may be offline, ensure classification.
    Record:toClassifyFormat()

    local isDataWiped = Record.CommandsData._dataWiped

    --[[
        Check if the player's data has already been wiped.
        Also since the player may be offline, ensure savability if so.
    ]]
    if isDataWiped and not Players:GetPlayerByUserId(message.Data.targetId) then
        Record:toSavableFormat()

        return
    end

    (Record.CommandsData._dataWiped :: Class<boolean>)(true)

    -- Since the player may be offline, ensure savability.
    if not Players:GetPlayerByUserId(message.Data.targetId) then Record:toSavableFormat() end

    ModerationTracker("Wiped Data", message.Data.senderId, message.Data.targetId, message.Data.args)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
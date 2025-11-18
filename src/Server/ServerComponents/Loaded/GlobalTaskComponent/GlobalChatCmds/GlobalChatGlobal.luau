--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)
--[[ @end_section Imports ]]


type MessagingServiceMessage<T> = PresetTypes.MessagingServiceMessage<T>


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global side of the global chat command.

    @param message MessagingServiceMessage<{ string }>
    
    @return
]]
local function moduleFunction(message: MessagingServiceMessage<{ string }>)
    local readableString = table.concat(message.Data, " ")

    local CurrentPlayers = Players:GetPlayers()
    ChatCommandsNamespace.packets.ClientDisplayGlobalChat.sendToList(readableString, CurrentPlayers)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
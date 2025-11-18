--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)
--[[ @end_section Imports ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the fly command.

    @param id number
    
    @return
]]
local function moduleFunction(id: number)
    local targetPlayer = Players:GetPlayerByUserId(id)
    if not targetPlayer then return end

    ChatCommandsNamespace.packets.ClientFlyCharacter.sendTo(nil, targetPlayer)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
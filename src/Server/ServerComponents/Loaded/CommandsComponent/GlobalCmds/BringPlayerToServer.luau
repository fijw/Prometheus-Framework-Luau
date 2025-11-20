--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Registry = require(ServerScriptService.ServerLibs.Registry)

local ClassType = require(ReplicatedStorage.SharedSchemas.Types.ClassType)
--[[ @end_section Imports ]]


type Class<T> = ClassType.Class<T>


local PRIVATE_SERVER_ID = game.PrivateServerId


--[[ @section Module Functionality ]]
--[[
    @usage Handles the command for bringing players to requested servers.

    @param player Player
    @param id number
    
    @return
]]
local function moduleFunction(player: Player, id: number)
    local foundPlayer = Players:GetPlayerByUserId(id)
    if foundPlayer then return end

    if PRIVATE_SERVER_ID ~= "" then
        local BringerRecord = Registry(player.UserId)
        if not BringerRecord then return end

        local reservedCode = if BringerRecord.CommandsData._reservedCode then (BringerRecord.CommandsData._reservedCode :: Class<string>)() else nil
        if not reservedCode then return end

        MessagingService:PublishAsync("bring player", { bringingId = player.UserId, id = id, code = reservedCode })
        
        return
    end

    MessagingService:PublishAsync("bring player", { bringingId = player.UserId, id = id })
end

return moduleFunction
--[[ @end_section Module Functionality ]]
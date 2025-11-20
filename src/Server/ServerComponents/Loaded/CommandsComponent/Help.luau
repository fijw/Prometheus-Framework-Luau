--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)
--[[ @end_section Imports ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles the help command.

    @param player Player
    
    @return
]]
local function moduleFunction(player: Player, CommandsListArray: { [string]: any })
    local CommandsList = {}

    for i: string, v: any in CommandsListArray do
        local commandEntry = `{i}{if v.commandArgsTag then " "..v.commandArgsTag :: string else ""}`
        table.insert(CommandsList, commandEntry)
    end

    ChatCommandsNamespace.packets.ClientDisplayHelpListChat.sendTo(CommandsList, player)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
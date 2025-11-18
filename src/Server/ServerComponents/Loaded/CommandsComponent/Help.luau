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
local function moduleFunction(player: Player)
    ChatCommandsNamespace.packets.ClientDisplayHelpListChat
    .sendTo(
        {
            "fly {id}",
            "unfly {id}",

            "freeze {id}",
            "unfreeze {id}",

            "invisible {id}",
            "visible {id}",

            "teleport {id} {id}",
            "bring {id}",
            "goto {id}",

            "gotoserver {id}",
            "bringtoserver {id}",
            "gotoreserved",

            "wipedata {id}",
            "unban {id}",
            "ban {id} {reason}",
            "kick {id} {reason}",

            "globalchat {message}",

            "wait {seconds}",

            "help",
        },
        
        player
    )
end

return moduleFunction
--[[ @end_section Module Functionality ]]
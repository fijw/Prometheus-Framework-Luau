--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)
--[[ @end_section Imports ]]


local LUCKIEST_GUY_START = `<font face="LuckiestGuy">`
local RED_FONT_COLOR = `<font color="#FF5757">`
local FONT_END = `</font>`


--[[ @section Module Functionality ]]
--[[
    @usage Handled displaying the help list & global chat messages.
    
    @return
]]
local function moduleFunction()
    ChatCommandsNamespace.packets.ClientDisplayGlobalChat
    .listen(
        function(data: string, player: Player?)
            if not data then return end
            assert(typeof(data) == "string", "Data must be a string.");

            local announcementTag = `{LUCKIEST_GUY_START}{RED_FONT_COLOR}<b>[GLOBAL MESSAGE]:</b>{FONT_END}{FONT_END}`
            local announcementMessage = `{announcementTag} {data}`

            (TextChatService :: any).TextChannels.RBXGeneral:DisplaySystemMessage(announcementMessage);
        end
    )
end

return moduleFunction
--[[ @end_section Module Functionality ]]
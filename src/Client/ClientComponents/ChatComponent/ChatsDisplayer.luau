--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local LUCKIEST_GUY_START = `<font face="LuckiestGuy">`

local PURPLE_FONT_COLOR = `<font color="#9257FF">`
local BLUE_FONT_COLOR = `<font color="#57C7FF">`
local RED_FONT_COLOR = `<font color="#FF5757">`

local FONT_END = `</font>`
--[[ @end_section Variables ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handled displaying the help list & global chat messages.
    
    @return
]]
local function moduleFunction()
    ChatCommandsNamespace.packets.ClientDisplayHelpListChat
    .listen(
        function(data: { string }, player: Player?)
            if not data then return end
            assert(typeof(data) == "table", "Data must be a table.");

            local noteTag = `{LUCKIEST_GUY_START}{PURPLE_FONT_COLOR}<b>[NOTE]:</b>{FONT_END}{FONT_END}`
            local commandTag = `{LUCKIEST_GUY_START}{BLUE_FONT_COLOR}<b>[COMMAND]:</b>{FONT_END}{FONT_END}`

            local noteMessage1 = `{noteTag} You can simply put "me" in place of an id to target yourself in an argument.`
            local noteMessage2 = noteTag..' You can also chain commands by simply placing ";" between commands: "{command} {args?}; {command} {args?}; {command} {args?}"'

            (TextChatService :: any).TextChannels.RBXGeneral:DisplaySystemMessage(noteMessage1);
            (TextChatService :: any).TextChannels.RBXGeneral:DisplaySystemMessage(noteMessage2);

            for i: number, command: string in ipairs(data :: { string }) do
                local displayMessage = `{commandTag} {command}`;
                (TextChatService :: any).TextChannels.RBXGeneral:DisplaySystemMessage(displayMessage)
            end
        end
    )

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
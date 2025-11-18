--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)
--[[ @end_section Imports ]]


--[[
    @usage Checks if the text has a command prefix.
    
    @return boolean
]]
local function doesTextHavePrefix(text: string): boolean
    for i: number, prefix: string in ipairs(FrameworkSettings.Commands.ChatCommandPrefixes) do
        if text:sub(1, #prefix) == prefix then return true end
    end

    return false
end


--[[ @section Module Functionality ]]
--[[
    @usage Handles the sending of commands.

    @return
]]
local function moduleFunction(message: TextChatMessage)
    if not message.TextSource or not doesTextHavePrefix(message.Text) then return end
            
    -- Send the command to the server & clear the text.
    do
        ChatCommandsNamespace.packets.ServerHandleCommandMessage.send(message.Text)

        message.Text = ""
    end
end

return moduleFunction
--[[ @end_section Module Functionality ]]
--!strict
--!optimize 2


local MessagingService = game:GetService("MessagingService")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the global chat command.

    @param message { string }
    
    @return
]]
local function moduleFunction(message: { string })
    -- Clear the arguments.
    if message[1] ~= "globalchat" then
        message[1] = nil
        message[2] = nil

        message = table.move(message, 3, #message, 1, {})
    else
        message[1] = nil

        message = table.move(message, 2, #message, 1, {})
    end

    MessagingService:PublishAsync("global chat", message)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
--!strict
--!optimize 2


local MessagingService = game:GetService("MessagingService")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the data wipe command.

    @param sender Player
    @param id number
    @param args { any }
    
    @return
]]
local function moduleFunction(sender: Player, id: number, args: { any })
    -- Clear the arguments.
    if args[1] ~= "wipedata" then
        args[1] = nil
        args[2] = nil
        args[3] = nil

        args = table.move(args, 4, #args, 1, {})
    else
        args[1] = nil
        args[2] = nil

        args = table.move(args, 3, #args, 1, {})
    end

    MessagingService:PublishAsync("wipe data", { senderId = sender.UserId, targetId = id, args = args })
end

return moduleFunction
--[[ @end_section Module Functionality ]]
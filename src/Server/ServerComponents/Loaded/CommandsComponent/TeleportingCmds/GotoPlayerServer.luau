--!strict
--!optimize 2


local TeleportService = game:GetService("TeleportService")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the command for traveling to requested servers.

    @param player Player
    @param id number

    @return
]]
local function moduleFunction(player: Player, id: number)
    local isHere, _currentInstance, placeId, jobId = TeleportService:GetPlayerPlaceInstanceAsync(id)
    if isHere then return end

    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
--!strict
--!optimize 2


local Players = game:GetService("Players")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the goto player command.

    @param player Player
    @param id number

    @return
]]
local function moduleFunction(player: Player, id: number)
    local targetPlayer = Players:GetPlayerByUserId(id)
    if not targetPlayer then return end

    local targetCharacter = targetPlayer.Character
    if not targetCharacter then return end

    local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart") :: BasePart
    if not targetRootPart then return end

    local playerCharacter = player.Character
    if not playerCharacter then return end

    local playerRootPart = playerCharacter:FindFirstChild("HumanoidRootPart") :: BasePart
    if not playerRootPart then return end

    playerRootPart.CFrame = targetRootPart.CFrame
end

return moduleFunction
--[[ @end_section Module Functionality ]]
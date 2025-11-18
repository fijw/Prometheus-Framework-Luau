--!strict
--!optimize 2


local Players = game:GetService("Players")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the player to player teleporting command.

    @param id number
    @param args { any }

    @return
]]
local function moduleFunction(id: number, args: { any })
    local positionTarget = tonumber(args[3])
    if not positionTarget then return end

    local positionTargetPlayer = Players:GetPlayerByUserId(positionTarget)
    if not positionTargetPlayer then return end

    local positionTargetCharacter = positionTargetPlayer.Character
    if not positionTargetCharacter then return end

    local positionTargetRootPart = positionTargetCharacter:FindFirstChild("HumanoidRootPart") :: BasePart
    if not positionTargetRootPart then return end

    local targetPlayer = Players:GetPlayerByUserId(id)
    if not targetPlayer then return end

    local targetCharacter = targetPlayer.Character
    if not targetCharacter then return end

    local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart") :: BasePart
    if not targetRootPart then return end

    targetRootPart.CFrame = positionTargetRootPart.CFrame
end

return moduleFunction
--[[ @end_section Module Functionality ]]
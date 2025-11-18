--!strict
--!optimize 2


local Players = game:GetService("Players")


--[[ @section Module Functionality ]]
--[[
    @usage Handles the freeze command.

    @param id number
    
    @return
]]
local function moduleFunction(id: number)
    local targetPlayer = Players:GetPlayerByUserId(id)
    if not targetPlayer then return end

    local targetCharacter = targetPlayer.Character
    if not targetCharacter then return end

    local CharacterDescendants = targetCharacter:GetDescendants()

    for i: number, child: Instance in ipairs(CharacterDescendants) do
        if not child:IsA("BasePart") or child.Anchored == true then continue end
        child.Anchored = true
    end
end

return moduleFunction
--[[ @end_section Module Functionality ]]
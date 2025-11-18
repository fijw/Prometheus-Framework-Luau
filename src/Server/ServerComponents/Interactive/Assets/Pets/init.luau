--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)
--[[ @end_section Imports ]]


type HatchableItem = DataTypes.HatchableItem
type ItemClass = DataTypes.ItemClass


--[[ @section Variables ]]
local PetModules = script:GetChildren()

local Pets: { [string]: HatchableItem } = {}
--[[ @end_section Variables ]]


-- Add up all of the collective pet modules.
for i: number, PetModule: ModuleScript in ipairs(PetModules) do
    local RequiredModule = require(PetModule) :: HatchableItem
    if not RequiredModule.class or not RequiredModule.rarity then continue end

    Pets[RequiredModule.name] = RequiredModule
end


table.freeze(Pets)
return Pets
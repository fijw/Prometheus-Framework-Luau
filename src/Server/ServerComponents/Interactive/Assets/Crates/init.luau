--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)
--[[ @end_section Imports ]]


type CrateSchema = DataTypes.CrateSchema


--[[ @section Variables ]]
local CrateModules = script:GetChildren()

local Crates: { [string]: CrateSchema } = {}
--[[ @end_section Variables ]]


-- Add up all of the collective crate modules.
for i: number, CrateModule: ModuleScript in ipairs(CrateModules) do
    local RequiredModule = require(CrateModule) :: CrateSchema
    if not RequiredModule.name then continue end

    Crates[RequiredModule.name] = RequiredModule
end


table.freeze(Crates)
return Crates
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Pets = require(ServerScriptService.ServerComponents.Interactive.Assets.Pets)

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)
--[[ @end_section Imports ]]


type CrateSchema = DataTypes.CrateSchema


--[[ @section Variables ]]
local hundredDivBySix = 100 / 6

local CrateData: CrateSchema
= {
    name = script.Name,

    Chances
    = {
        [Pets.Pet1] = hundredDivBySix,
        [Pets.Pet2] = hundredDivBySix,
        [Pets.Pet3] = hundredDivBySix,
        [Pets.Pet4] = hundredDivBySix,
        [Pets.Pet5] = hundredDivBySix,
        [Pets.Pet6] = hundredDivBySix
    }
}
--[[ @end_section Variables ]]


table.freeze(CrateData)
return CrateData
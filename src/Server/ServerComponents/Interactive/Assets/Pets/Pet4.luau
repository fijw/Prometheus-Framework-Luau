--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)

local PresetData = require(ServerScriptService.ServerComponents.Interactive.Assets.Pets.PresetData)
--[[ @end_section Imports ]]


type HatchableItem = DataTypes.HatchableItem


--[[ @section Variables ]]
local PetData: HatchableItem
= {
    name = script.Name,

    class = PresetData.CLASS,
    rarity = PresetData.RARITIES[1],

    basePower = 0,

    sellable = true,
    tradeable = true
}
--[[ @end_section Variables ]]


table.freeze(PetData)
return PetData
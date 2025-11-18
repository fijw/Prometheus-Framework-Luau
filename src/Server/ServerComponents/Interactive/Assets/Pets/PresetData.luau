--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)
--[[ @end_section Imports ]]


type ItemClass = DataTypes.ItemClass
type ItemRarity = DataTypes.ItemRarity


--[[ @section Variables ]]
local SIZE_CHANCE_NUMBERS
= {
    Default = 100 - 0.0002 - 0.0001,

    Giant = 1 / 500_000 * 100, -- 0.0002% chance
    Colossal = 1 / 1_000_000 * 100 -- 0.0001% chance
}

local COLOR_CHANCE_NUMBERS
= {
    Default = 100 - 10 - 1 - 0.1,

    Shiny = 1 / 10 * 100, -- 10% chance
    Prismatic = 1 / 100 * 100, -- 1% chance
    Rainbow = 1 / 1000 * 100 -- 0.1% chance
}
--[[ @end_section Variables ]]


local Data
: {
    CLASS: ItemClass,
    RARITIES: { ItemRarity },
    STAT_CHANCES: { [string]: { [string]: number } }
}
= {
    CLASS = "Pet",

    RARITIES
    = {
        [1] = "Basic",
        [2] = "Rare",
        [3] = "Epic",
        [4] = "Mythical",
        [5] = "Divine",
        [6] = "Limited"
    },

    STAT_CHANCES
    = {
        Sizes
        = {
            Default = SIZE_CHANCE_NUMBERS.Default,
            Giant = SIZE_CHANCE_NUMBERS.Giant,
            Colossal = SIZE_CHANCE_NUMBERS.Colossal
        },

        Colors
        = {
            Default = COLOR_CHANCE_NUMBERS.Default,
            Shiny = COLOR_CHANCE_NUMBERS.Shiny,
            Prismatic = COLOR_CHANCE_NUMBERS.Prismatic,
            Rainbow = COLOR_CHANCE_NUMBERS.Rainbow
        }
    }
}


table.freeze(Data)
return Data
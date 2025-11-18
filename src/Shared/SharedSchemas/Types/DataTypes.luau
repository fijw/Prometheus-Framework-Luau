--!strict
--!optimize 2


--[[ @section Types ]]
export type ItemClass = "Pet" | "undefined"

export type ItemRarity
= "Basic"
| "Rare"
| "Epic"
| "Mythical"
| "Divine"
| "Limited"

export type ItemColor
= "Default"
| "Shiny"
| "Prismatic"
| "Rainbow"

export type ItemSize
= "Default"
| "Giant"
| "Colossal"


export type CrateSchema
= {
    name: string,
    Chances: { [HatchableItem]: number }
}


export type HatchableItem
= {
    name: string,

    class: ItemClass,
    rarity: ItemRarity,

    basePower: number?,

    sellable: boolean,
    tradeable: boolean
}

export type ItemSchema
= {
    name: string,
    id: string,

    class: ItemClass,
    rarity: ItemRarity,

    power: number?,
    color: ItemColor?,
    size: ItemSize?,
    
    sellable: boolean,
    tradeable: boolean
}
--[[ @end_section Types ]]


local ReturningValue = {}


table.freeze(ReturningValue)
return ReturningValue
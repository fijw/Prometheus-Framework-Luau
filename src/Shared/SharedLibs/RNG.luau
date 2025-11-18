--[[
    @Banner
    ```
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  
                                                                            
                                                                            
                                                                            
                                                                            
        █           ▄    ▄          ▀                                  █   
        █           █  ▄▀   ▄▄▄   ▄▄▄     ▄ ▄▄   ▄▄▄    ▄▄▄            █   
        █           █▄█    ▀   █    █     █▀  ▀ █▀ ▀█  █   ▀           █   
        █           █  █▄  ▄▀▀▀█    █     █     █   █   ▀▀▀▄           █   
        █           █   ▀▄ ▀▄▄▀█  ▄▄█▄▄   █     ▀█▄█▀  ▀▄▄▄▀           █   
        █                                                              █   
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  

        @Author Kairos (Roblox @: roblox_user_5618502527)
        @Version 1.0.1
    ```

    @Description RNG Library for Chance Pools, Value Pools, and
    @Description random string generation.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Logger = require(ReplicatedStorage.SharedLibs.Logger)("RNG")
--[[ @end_section Imports ]]


--[[ @section Types ]]
type WeightsSchema
= {
    value: any,
    weight: number
}
--[[ @end_section Types ]]


--[[ @section Variables ]]
local ALLOWED_CHARACTERS
= {
    "a", "b", "c", "d", "e", "f",
    "g", "h", "i", "j", "k", "l",
    "m", "n", "o", "p", "q", "r",
    "s", "t", "u", "v", "w", "x",
    "y", "z", "A", "B", "C", "D",
    "E", "F", "G", "H", "I", "J",
    "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V",
    "W", "X", "Y", "Z", "0", "1",
    "2", "3", "4", "5", "6", "7",
    "8", "9"
}
--[[ @end_section Variables ]]


--[[ @end_section RNG Functionality ]]
--[[
    @usage Get a random type from a chances pool,
    @usage a random generated string,
    @usage or a random type from a pool with no chances.

    @param input { [any]: number } | number
    @param isPoolWithNoChances "no_chances"?

    @return any
]]
local function randomNumberGenerator(input: { [any]: any } | number, isPoolWithNoChances: "no_chances"?): any
    local Top3Random: { any } = {}

    -- If input is a pool with no chances, generate a random type.
    if isPoolWithNoChances == "no_chances" then 
        assert(typeof(input) == "table", "Pool must be a table.")

        local numOfValues = 0

        -- Count the number of values and ensure it isn't 0.
        do
            for i: any, value: any in pairs(input) do
                numOfValues += 1
            end

            if numOfValues == 0 then return nil end
        end

        local chosenValue: any

        -- Better randomized chances.
        do
            for i = 1, 3 do
                local randomIndex = math.random(1, numOfValues)
                table.insert(Top3Random, input[randomIndex])
            end

            local randomIndexFromTop3 = math.random(1, #Top3Random)
            local chosenIndex = Top3Random[randomIndexFromTop3]

            chosenValue = input[chosenIndex]
        end

        return chosenValue
    end

    -- If input is a number, generate a random string.
    if typeof(input) == "number" then
        if input <= 1 then return "" end

        local generatedString = ""

        for i = 1, input do
            local randomIndex = math.random(1, #ALLOWED_CHARACTERS)
            local randomCharacter = ALLOWED_CHARACTERS[randomIndex]

            generatedString = generatedString..randomCharacter
        end

        return generatedString
    end

    assert(typeof(input) == "table", "ChancesPool must be a table.")

    local CumulativeWeights: { WeightsSchema } = {}
	local totalWeight = 0

	for value: any, chance: number in pairs(input) do
        assert(typeof(chance) == "number", "ChancesPool values must be numbers.")

		totalWeight += chance

		table.insert(CumulativeWeights,
            {
                value = value :: any,
                weight = totalWeight
            }
        )
	end

    local randomNumber: number

    -- Better randomized chances.
    do
        for i = 1, 3 do
	        randomNumber = math.random() * totalWeight
            table.insert(Top3Random, randomNumber)
        end

        local randomIndexFromTop3 = math.random(1, #Top3Random)
        randomNumber = Top3Random[randomIndexFromTop3]
    end

    -- Get a type from the chances pool.
	for i: number, entry: WeightsSchema in ipairs(CumulativeWeights) do
        if randomNumber <= entry["weight"] then return entry["value"] end
	end

    Logger:outputError("Failed to get a type from the chances pool.")

    return nil
end

return randomNumberGenerator
--[[ @end_section RNG Functionality ]]
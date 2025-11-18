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
        @Version 1.0.0
    ```

    @Description Allows you to convert any inputted string into a string of bytes
    @Description or an array of bytes, also vice versa.
]]
--!strict
--!optimize 2


--[[ @section Variables ]]
local Constructor = {}

local StringToBytes = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Encrypt or decrypt an inputted string or array of bytes.
    @usage Can also choose to output encrypted input as a string.

    @param input string | { number }
    @param action "decrypt" | "encrypt"
    @param stringOutput true?

    @return ({ number } | string)?
]]
function Constructor:__call
(
    input: string | { number },
    action: "decrypt" | "encrypt",
    stringOutput: true?
): ({ number } | string)?
    if action == "decrypt" and stringOutput then return nil end

    if action == "encrypt" then
        local encryptedInput = {}

        for i = 1, #input do
            local byte = string.byte(input :: string, i)
            table.insert(encryptedInput, byte)
        end

        if stringOutput then
            local concatEncryptedInput = table.concat(encryptedInput, " ")
            return concatEncryptedInput
        end

        return encryptedInput
    end

    if typeof(input) == "string" then input = string.split(input, " ") :: { number } end

    local decryptedInput = ""

    for i: number, byte: number in ipairs(input :: { number }) do
        local char = string.char(byte)
        decryptedInput = `{decryptedInput}{char}`
    end

    return decryptedInput
end

setmetatable(StringToBytes, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(StringToBytes)
return StringToBytes
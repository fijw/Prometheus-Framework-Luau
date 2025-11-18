--[[
    @NOTE This is just an example library that uses OOP.

    @NOTE The entire column of text below is only for modules related to the framework of games.
    @NOTE Meaning, any module unrelated to the framework will not have this column / banner.
]]
--[[
    @Framework
    ```
         ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ 
        |___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|
                                                                                                    
                                                                                                    
         _                                                                                       _   
        | |                     _____                   _   _                                   | |  
        | |                    |  _  |___ ___ _____ ___| |_| |_ ___ _ _ ___                     | |  
        | |                    |   __|  _| . |     | -_|  _|   | -_| | |_ -|                    | |  
        | |                    |__|  |_| |___|_|_|_|___|_| |_|_|___|___|___|                    | |  
        |_|                                                                                     |_|  
         _                                                                                       _   
        | |            _____     _   _            _____                                 _       | |  
        | |     ___   | __  |___| |_| |___ _ _   |   __|___ ___ _____ ___ _ _ _ ___ ___| |_     | |  
        | |    | .'|  |    -| . | . | | . |_'_|  |   __|  _| .'|     | -_| | | | . |  _| '_|    | |  
        | |    |__,|  |__|__|___|___|_|___|_,_|  |__|  |_| |__,|_|_|_|___|_____|___|_| |_,_|    | |  
        |_|                                                                                     |_|  
         _                                                                                       _   
        | |                           _        _          _____     _                           | |  
        | |               _____ ___ _| |___   | |_ _ _   |  |  |___|_|___ ___ ___               | |  
        | |              |     | .'| . | -_|  | . | | |  |    -| .'| |  _| . |_ -|              | |  
        | |              |_|_|_|__,|___|___|  |___|_  |  |__|__|__,|_|_| |___|___|              | |  
        |_|                                       |___|                                         |_|  
                                                                                                    
                                                                                                    
         ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ 
        |___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|___|

        Both of the lines below are meant for the bootstrapper / main framework script only.
        @Author Kairos (Roblox @: roblox_user_5618502527)
        @Version 1.0.0
    ```

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

    @Description Lorem ipsum dolor sit amet, consectetur adipiscing elit,
    @Description sed do eiusmod tempor incididunt ut labore et dolore
    @Description magna aliqua.

    @NOTE Lorem ipsum dolor sit amet, consectetur adipiscing elit,
    @NOTE sed do eiusmod tempor incididunt ut labore et dolore
    @NOTE magna aliqua.
]]
--!strict
--!optimize 2


--[[ @section Types ]]
type InputCallbackType = <T>(self: Test, input: T) -> (Test)
type OutputCallbackType = (self: Test) -> (Test)

type UtilitiesSchema
= {
    __call: OutputCallbackType,

    __add: InputCallbackType,
    __sub: InputCallbackType,

    __mul: InputCallbackType,
    __div: InputCallbackType
}

type TestSchema
= {
    [number]: any,

    a1: "1a",
    b2: "2b",
    c3: "3c"
}

type Test = setmetatable
<
    TestSchema,

    {
        __call: OutputCallbackType,

        __add: InputCallbackType,
        __sub: InputCallbackType,

        __mul: InputCallbackType,
        __div: InputCallbackType,

        __index: { This: "..." }
    }
>
--[[ @end_section Types ]]


--[[ @section Variables ]]
local Utilities = {} :: UtilitiesSchema
local Constructor = {}

local Test = {}
--[[ @end_section Variables ]]


--[[ @section Documentation Example ]]
--[[
    @NOTE Section documentation, not function-specific.


    @usage Simple documentation example stuff.

    @generic V Inputted value type
    @generic K Inputted key type
    @generic T Inputted thing type
    
    @generic_pack P... Inputted parent directory types
    @variadic_pack ...T Inputted types of thing

    @param value V
    @param key K
    @param ... P...

    @return ...T
]]
type Example = <V, K, T, P...>(value: V, key: K, thing: T, P...) -> (...T)

local _example: Example
= function<V, K, T, P...>(value: V, key: K, thing: T, ...: P...): ...T
    return thing, thing, thing
end
--[[ @section Documentation Example ]]


--[[
    @NOTE Section documentation, not function-specific.


    @usage Lorem ipsum dolor sit amet.

    @param self Test
    @param input? T
    
    @return Test
]]
--[[ @section Utilities ]]
function Utilities:__call(): (Test)
    print(self)

    return self
end

function Utilities:__add<T>(input: T): Test
    table.insert(self, input)

    return self
end

function Utilities:__sub<T>(input: T): Test
    table.insert(self, input)

    return self
end

function Utilities:__mul<T>(input: T): Test
    table.insert(self, input)

    return self
end

function Utilities:__div<T>(input: T): Test
    table.insert(self, input)

    return self
end
--[[ @end_section Utilities ]]


--[[ @section Constructor ]]
--[[
    @usage Create a new test.

    @param input1 string
    @param input2 boolean

    @return Test
]]
function Constructor:__call(input1: string, input2: boolean): Test
    print(input1, input1, "Inputs!")

    local NewTest: Test
    = setmetatable(
        {
            a1 = "1a",
            b2 = "2b",
            c3 = "3c"
        } :: TestSchema,

        {
            __call = Utilities.__call,

            __add = Utilities.__add,
            __sub = Utilities.__sub,

            __mul = Utilities.__mul,
            __div = Utilities.__div,

            __index = { This = "..." }
        }
    )

    -- Trying out functionality.
    do
        NewTest += "[+] Added"
        NewTest -= "[-] Added"

        NewTest *= "[*] Added"
        NewTest /= "[/] Added"

        NewTest()
    end

    return NewTest
end

setmetatable(Test, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(Test)
return Test
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
    
    @Description Quick handler for keybind mapping and grouping together input events.
    @Description Also makes it easier to stop groups of input events and manage them
    @Description all at the same time.    

    @Example
    ```luau
        local TestInputMapper = InputMapper(Enum.KeyCode.Space, function(thing: string) print(thing) end, "Testing String for Space")
        TestInputMapper(Enum.KeyCode.F, function(thing: string) print(thing) end, "Testing String for F")

        task.wait(10)

        TestInputMapper:wipeConnections()
    ```
]]
--!strict
--!optimize 2


local UserInputService = game:GetService("UserInputService")


--[[ @section Types ]]
type InputMapperCallback = <A...>(self: InputMapper, keybind: Enum.KeyCode, func: (A...) -> (...any), A...) -> (InputMapper)


type InputMapperInheritance = { wipeConnections: (self: InputMapper) -> () }

type UtilityFunctions = { inputMapperCallback: InputMapperCallback }

type InputMapper = setmetatable
<
    { Connections: { RBXScriptConnection } },

    {
        __index: InputMapperInheritance,
        __call: InputMapperCallback
    }
>
--[[ @end_section Types ]]


--[[ @section Variables ]]
local UtilityFunctions = {} :: UtilityFunctions
local Inheritance = {} :: InputMapperInheritance
local Constructor = {}

local InputMapper = {}
--[[ @end_section Variables ]]


--[[ @section Utility Functions ]]
--[[
    @usage Maps an input to a function.

    @generic_pack T... Inputted parameters for the binded function.

    @param input InputObject
    @param gameProcessed boolean

    @param keybind Enum.KeyCode

    @param func (T...) -> (...any)
    @param ... T...

    @return
]]
local function onInputBegan
<T...>(
    input: InputObject,
    gameProcessed: boolean,

    keybind: Enum.KeyCode,

    func: (T...) -> (...any),
    ...: T...
)
    if gameProcessed or input.KeyCode ~= keybind then return end

    func(...)
end

--[[
    @usage Maps an input to a function within an existing InputMapper.

    @generic_pack F... Inputted parameters for the binded function.

    @param self InputMapper

    @param keybind Enum.KeyCode
    @param func (F...) -> (...any)
    @param ... F...

    @return InputMapper
]]
function UtilityFunctions:inputMapperCallback<F...>(keybind: Enum.KeyCode, func: (F...) -> (...any), ...: F...): InputMapper
    local Args = { ... }
    local UnpackedArgs = table.unpack(Args :: any)

    local Connection = UserInputService.InputBegan
    :Connect(
        function(input: InputObject, gameProcessed: boolean) onInputBegan(input, gameProcessed, keybind, func, UnpackedArgs) end
    )

    table.insert(self.Connections, Connection)

    return self
end
--[[ @end_section Utility Functions ]]


--[[ @section Constructor ]]
--[[
    @usage Creates a new InputMapper.

    @generic_pack P... Inputted parameters for the binded function.

    @param keybind Enum.KeyCode
    @param func (P...) -> (...any)
    @param ... P...

    @return InputMapper
]]
function Constructor:__call<P...>(keybind: Enum.KeyCode, func: (P...) -> (...any), ...: P...): InputMapper
    local NewInputMapper = { Connections = {} }

    setmetatable(NewInputMapper,
        {
            __index = Inheritance,
            __call = UtilityFunctions.inputMapperCallback
        }
    )

    UtilityFunctions.inputMapperCallback(NewInputMapper, keybind, func, ...)

    return NewInputMapper :: InputMapper
end

setmetatable(InputMapper, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


--[[
    @usage Wipes all connections from the InputMapper.

    @param self InputMapper

    @return
]]
function Inheritance:wipeConnections()
    for i: number, Connection: RBXScriptConnection in ipairs(self.Connections) do Connection:Disconnect() end
end


table.freeze(InputMapper)
return InputMapper
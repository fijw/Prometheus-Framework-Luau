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
        @Version 1.0.4
    ```

    @Description Classify is a state management library for Roblox.

    @NOTE Anything and everything (including instances) can
    @NOTE be Classified & have extra functionality added to
    @NOTE it.

    @NOTE Can range from making the Classified object
    @NOTE callable, subscribing to the object, locking the
    @NOTE object, and adding extra functionality to it, such
    @NOTE as addition, subtraction, division, and more,
    @NOTE methods.

    @NOTE By default, the callback functionality for a
    @NOTE Classified object is to change the Classified
    @NOTE object's data.
    @NOTE This can be used to do things like: add, change, or
    @NOTE completely remove values in the Classified object.
    @NOTE This usually applies to Arrays and Dictionaries.

    @Example
    ```luau
        local Test = Classify({ cat = 5 })

        -- Subscribe to the classes changes.
        do
            Test:subscribe(
                function<K, V>(key: K, value: V)
                    print(key, value, "SUBSCRIPTION CALLBACK (NOT ONCE)")
                end
            )

            Test(999, "cat")

            Test:subscribeOnce(
                function<K, V>(key: K, value: V)
                    print(key, value, "SUBSCRIPTION CALLBACK (ONCE!)")
                end
            )
        end

        -- Test the subscriptions & then test unsubscribing.
        do
            Test(44, "cat")
            Test(1000, "dog", "bark")

            Test:unsubscribe()

            print(Test(), "DOG & BARK ADDED")

            Test(10, "dog", "bark")
        end

        -- Test the metamethod setting method.
        do
            Test
            += {
                methodName = "__div",
                    
                methodData
                = function<V>(self: Class<any>, value: V): Class<any>
                    print("input:", value)

                    return self
                end
            }

            Test /= 2
        end

        -- Test the classes locking method.
        do
            Test:lock()

            Test(103, "dog", "bark")
        end

        print(Test(), "FINAL RESULT, BARK SHOULD BE 10 BECAUSE IT WAS LOCKED, NOT 103")
        print(Test, "BASE SCHEMA FINAL RESULT")
        print(getmetatable(Test), "METATABLE FINAL RESULT")
    ```
]]
--!strict
--!optimize 2


--[[ @section Types ]]
type AbstractedType<T> = T
type AbstractionLayer<T> = AbstractedType<AbstractedType<T>>


type UtilityFunctionsSchema
= {
    subscribedOnceCheck: (self: Class<unknown>) -> (),

    DEFAULT_ADD_CALLBACK: AbstractedClassAddCallbackType,
    DEFAULT_CLASS_CALLBACK: AbstractedClassCallbackType
}


type ClassUnknownCallbackType<T> = <A...>(self: Class<T>, A...) -> (Class<T>)
type ClassAddCallbackType<T> = (self: Class<T>, PushingArgs: PushingMetamethodType) -> (Class<T>)
type ClassCallbackType<T> = <K, V, P...>(self: Class<T>, key: K?, value: V?, P...) -> (T)

type AbstractedClassCallbackType = AbstractionLayer<ClassCallbackType<unknown>>
type AbstractedClassAddCallbackType = AbstractionLayer<ClassAddCallbackType<unknown>>

type PushingMetamethodType = { methodName: string, methodData: any | (...any) -> (...any) }
type SubscriptionCallbackType = <K, V>(key: K?, value: V) -> (...any)


type ClassInheritance<T>
= {
    subscribe: (self: Class<T>, subscribeCallback: SubscriptionCallbackType) -> (),
    subscribeOnce: (self: Class<T>, subscribeCallback: SubscriptionCallbackType) -> (),
    unsubscribe: (self: Class<T>) -> (),

    lock: (self: Class<T>) -> ()
}

type ClassSchema<T>
= {
    source: T,
    
    onlySubscribeOnce: boolean?,
    subscriptionCallback: SubscriptionCallbackType?
}

export type Class<T> = setmetatable
<
    ClassSchema<T>,

    {
        __index: ClassInheritance<T>,
        __call: ClassCallbackType<T>,
        __add: ClassAddCallbackType<T>,

        -- All available metamethods to use below.
        __tostring: ClassUnknownCallbackType<T>,
        __concat: ClassUnknownCallbackType<T>,
        __div: ClassUnknownCallbackType<T>,
        __unm: ClassUnknownCallbackType<T>,
        __sub: ClassUnknownCallbackType<T>,
        __mul: ClassUnknownCallbackType<T>,
        __idiv: ClassUnknownCallbackType<T>,
        __mod: ClassUnknownCallbackType<T>,
        __pow: ClassUnknownCallbackType<T>,
        __eq: ClassUnknownCallbackType<T>,
        __lt: ClassUnknownCallbackType<T>,
        __le: ClassUnknownCallbackType<T>,
        __len: ClassUnknownCallbackType<T>,
        __iter: ClassUnknownCallbackType<T>
    }
>
--[[ @end_section Types ]]


--[[ @section Variables ]]
local ClassConstructor = {}
local ClassInheritance = {} :: AbstractedType<ClassInheritance<unknown>>
local UtilityFunctions = {} :: UtilityFunctionsSchema

local Classify = {}
--[[ @end_section Variables ]]


--[[ @section Utility Functions ]]
--[[
    @usage Check if the class is only subscribed once.

    @param self Class<unknown>
    
    @return
]]
function UtilityFunctions:subscribedOnceCheck()
    if table.isfrozen(self :: any)
        or not self.onlySubscribeOnce
        or not self.subscriptionCallback
    then return end

    self.onlySubscribeOnce = nil
    self.subscriptionCallback = nil
end

--[[
    @usage Add a metamethod to the class.

    @param PushingArgs PushingMetamethodType

    @return Class<unknown>?
]]
function UtilityFunctions:DEFAULT_ADD_CALLBACK(PushingArgs: PushingMetamethodType): Class<unknown>?
    if table.isfrozen(self :: any) then return nil end

    local TempMetatable = getmetatable(self :: Class<unknown>) :: { [unknown]: unknown }
    TempMetatable[PushingArgs.methodName] = PushingArgs.methodData

    setmetatable(self, TempMetatable)

    return self :: any
end

--[[
    @usage Call the class to either read or write data.

    @generic V Inputted value type
    @generic K Inputted key type

    @generic_pack P... Inputted parent directory types

    @param value V?
    @param key K?
    @param ... P...

    @return any
]]
function UtilityFunctions:DEFAULT_CLASS_CALLBACK
<
    V,
    K,
    P...
>(
    value: V?,
    key: K?,
    ...: P...
): any
    if table.isfrozen(self :: any) or not value then return self.source end
    
    local PathArgs = { ... }
	local pushScope = self.source

    -- Find the parent directory.
	for i = 1, #PathArgs do
	    if not pushScope[PathArgs[i]] then pushScope[PathArgs[i]] = {} end
	    pushScope = pushScope[PathArgs[i]]
	end

    -- If there's a key set the value with a key.
	if key then
	    pushScope[key] = value
	    if not self.subscriptionCallback then return self.source end

	    self.subscriptionCallback(key :: K?, value)
        UtilityFunctions.subscribedOnceCheck(self)

        return self.source
	end

    -- If there's no key set the value directly.
    do
        self.source = value
        if not self.subscriptionCallback then return self.source end

        self.subscriptionCallback(key, value)
        UtilityFunctions.subscribedOnceCheck(self)
    end
                        
    return self.source
end
--[[ @end_section Utility Functions ]]


--[[ @section Class Constructor ]]
--[[
    @usage Call the Class Constructor.

    @generic T Inputted value

    @param input T
    @param subscriptionCallback SubscriptionCallbackType?

    @return Class<T>
]]
function ClassConstructor:__call<T>(input: T, subscriptionCallback: SubscriptionCallbackType?): Class<T>
    local NewClass: ClassSchema<T>
    = {
        source = input,
        subscriptionCallback = subscriptionCallback
    }

    setmetatable(NewClass,
        {
            __index = ClassInheritance,
            __call = UtilityFunctions.DEFAULT_CLASS_CALLBACK,
            __add = UtilityFunctions.DEFAULT_ADD_CALLBACK
        }
    )

    return NewClass :: Class<T>
end

setmetatable(Classify, { __call = ClassConstructor.__call })
--[[ @end_section Class Constructor ]]


--[[ @section Class Inheritance Methods ]]
--[[
    @usage Subscribe to the class.

    @param subscribeCallback SubscriptionCallbackType

    @return
]]
function ClassInheritance:subscribe(subscribeCallback: SubscriptionCallbackType)
    self.onlySubscribeOnce = false
    self.subscriptionCallback = subscribeCallback
end

--[[
    @usage Subscribe to the class once.

    @param subscribeCallback SubscriptionCallbackType

    @return
]]
function ClassInheritance:subscribeOnce(subscribeCallback: SubscriptionCallbackType)
    self.onlySubscribeOnce = true
    self.subscriptionCallback = subscribeCallback
end

--[[
    @usage Unsubscribe from the class.

    @return
]]
function ClassInheritance:unsubscribe()
    self.subscriptionCallback = nil
    self.onlySubscribeOnce = nil
end

--[[
    @usage Lock the class.

    @return
]]
function ClassInheritance:lock()
    local TempMetatable = getmetatable(self)
    local FrozenMetatable = table.freeze(TempMetatable :: any)

    setmetatable(self, FrozenMetatable)

    table.freeze(self)
end
--[[ @end_section Class Inheritance Methods ]]


table.freeze(Classify)
return Classify
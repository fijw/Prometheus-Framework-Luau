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


local ReturningValue = {}


table.freeze(ReturningValue)
return ReturningValue
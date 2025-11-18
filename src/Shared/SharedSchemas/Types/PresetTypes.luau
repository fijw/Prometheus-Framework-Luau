--!strict
--!optimize 2


--[[ @section Types ]]
export type AbstractedType<T> = T


export type InitializedModule<T> = setmetatable
<
    T,
    { __call: (self: InitializedModule<T>) -> () }
>


export type MessagingServiceMessage<T>
= {
	Data: T,
	Sent: number,
	Topic: string
}
--[[ @section Types ]]


local ReturningValue = {}


table.freeze(ReturningValue)
return ReturningValue
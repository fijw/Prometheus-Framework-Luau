--!strict
--!optimize 2


--[[ @section Variables ]]
local Constructor = {}

local Test = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Create a new test.
    
    @return
]]
function Constructor:__call()
    print("Test")
end

setmetatable(Test, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(Test)
return Test
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ByteNetMax = require(ReplicatedStorage.Networking["ByteNet-Max"])
--[[ @end_section Imports ]]


--[[ @section Packets & Namespace Definition ]]
--[[
    @NOTE No type checking here.
    The new Luau Type Solver hates ByteNet-Max.
]]
function wipingNamespace()
    local WipingNamespace
    = {
        packets
        = {
            -- All Client Received !ONLY!
            CleanClientUIConnections = ByteNetMax.definePacket({ value = ByteNetMax.nothing }),
            CleanClientChatConnections = ByteNetMax.definePacket({ value = ByteNetMax.nothing })
        }
    }

    return WipingNamespace
end

local Namespace = ByteNetMax.defineNamespace("wiping", wipingNamespace)
--[[ @end_section Packets & Namespace Definition ]]


return Namespace
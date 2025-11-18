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
function loadingNamespace()
    local LoadingNamespace
    = {
        packets
        = {
            -- Client Received !ONLY!
            LoadClientModules = ByteNetMax.definePacket({ value = ByteNetMax.string })
        }
    }
    return LoadingNamespace
end

local Namespace = ByteNetMax.defineNamespace("loading", loadingNamespace)
--[[ @end_section Packets & Namespace Definition ]]


return Namespace
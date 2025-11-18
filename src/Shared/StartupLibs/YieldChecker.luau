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
    ```

    @Description Initialize inputted modules & check for yielding.           

    @NOTE This is to be used by another initialization
    @NOTE script, which requires and initializes server modules
    @NOTE sequentially, before sending a loading packet to
    @NOTE load client modules for all available clients.     

    @NOTE Why do we do this? To prevent networking errors, glitches,
    @NOTE or overlaps.

    @NOTE A script sending or receiving a packet before another
    @NOTE linked script can even also send or receive that packet is
    @NOTE a bad idea.

    @NOTE If we do all of that as said before, why does this exist?
    @NOTE To check for any potential issues with networking, which
    @NOTE usually includes yielding issues.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)

local Chronovisor = require(ReplicatedStorage.SharedLibs.Chronovisor)
local Logger = require(ReplicatedStorage.SharedLibs.Logger)("Yield Checker")
--[[ @end_section Imports ]]


local RUNNING_FROM = "Server"
if RunService:IsClient() then RUNNING_FROM = "Client" end


--[[ @section Variables ]]
local YieldConstructor = {}

local YieldChecker = {}
--[[ @end_section Variables ]]


type InitializedModule<T> = PresetTypes.InitializedModule<T>


--[[
    @usage Initializes a module with the Chronovisor library.

    @param module InitializedModule<{ [any]: any }>
    @param name string

    @return
]]
function chronovisorInitialization(module: InitializedModule<{ [any]: any }>, name: string)
    Chronovisor(function() module() end)
    :onError(
        function(err: string?)
            Logger:outputError(`Module: {name}, Side: {RUNNING_FROM}, Error: {err}`)

            task.wait(1)

            chronovisorInitialization(module, name)
        end
    )
end


--[[ @section Constructor ]]
--[[
    @usage Checks if a module yields or errors while it initializes.

    @param module InitializedModule<{ [any]: any }>
    @param name string

    @return
]]
function YieldConstructor:__call(module: InitializedModule<{ [any]: any }>, name: string)
    if not module or not name then return end

    local finishedLoading = false

    task.spawn(
        function()
            chronovisorInitialization(module, name)
            
            finishedLoading = true
        end
    )

    task.defer(function() if not finishedLoading then Logger:outputInfo(`Module: {name} yielded!, Side: {RUNNING_FROM}`) end end)
end

setmetatable(YieldChecker, { __call = YieldConstructor.__call })
--[[ @end_section Constructor ]]


table.freeze(YieldChecker)
return YieldChecker
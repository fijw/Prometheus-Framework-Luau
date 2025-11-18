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

    @Description This module handles the requiring & initialization parts of the framework.
    @Description It is extremely in-depth for flagging & handling issues, and does not need changing. 
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local YieldChecker = require(ReplicatedStorage.StartupLibs.YieldChecker)

local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)

local Chronovisor = require(ReplicatedStorage.SharedLibs.Chronovisor)
local Logger = require(ReplicatedStorage.SharedLibs.Logger)("Server Framework")
--[[ @end_section Imports ]]


type InitializedModule = PresetTypes.InitializedModule<{ [any]: any }>


--[[ @section Variables ]]
local Constructor = {}

local SideInitialization = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Handled the requiring & initialization of modules from
    @usage an inputted server or client side.
    
    @return
]]
function Constructor:__call(inputtedModules: { ModuleScript })
    local loadedAmt = 0

    local RequiredModules: { [string]: InitializedModule } = {}

    -- Require then sequentially initialize the modules.
    Chronovisor(
        function()
            for i: number, module: ModuleScript in ipairs(inputtedModules) do
                task.spawn(
                    function()
                        local RequiredModule: InitializedModule

                        repeat
                            RequiredModule = require(module) :: InitializedModule
                            if not RequiredModule then task.wait() end
                        until RequiredModule

                        if not RequiredModule then return end

                        RequiredModules[module.Name] = RequiredModule
                    end
                )
            end
        end
    )
    :onError(function(err: string?) Logger:outputCritical(`Failed to load modules. Error: {err}`) end)
                
    :execute(
        function()
            for i: string, module: InitializedModule in pairs(RequiredModules) do
                YieldChecker(module, i)

                loadedAmt += 1
            end
        end
    )
    :onError(function(err: string?) Logger:outputCritical(`Failed to initialize modules. Error: {err}`) end)

    -- Check if the amount of loaded modules is the same as the amount of inputted modules.
    local modulesAmt = #inputtedModules
    if loadedAmt ~= modulesAmt then Logger:outputWarning(`Only loaded {loadedAmt} out of {modulesAmt} modules.`) end
end

setmetatable(SideInitialization, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(SideInitialization)
return SideInitialization
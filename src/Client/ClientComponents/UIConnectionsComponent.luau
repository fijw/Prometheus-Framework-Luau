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

    @Description Wipes the signals left behind once a player leaves.     
    @NOTE This is for the UI Utilities handled UIs only.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UITypes = require(ReplicatedStorage.SharedSchemas.Types.UITypes)

local UIUtilitiesLibrary = require(Players.LocalPlayer.PlayerScripts.ClientLibs.UIUtilitiesLibrary)

local MemoryCleaning = require(ReplicatedStorage.Networking.Namespaces.Services.MemoryCleaning)
--[[ @end_section Imports ]]


type HandledUI = UITypes.HandledUI


--[[ @section Variables ]]
local Constructor = {}

local UIConnectionsController = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Destroys all signals.
    
    @return
]]
function Constructor:__call()
    MemoryCleaning.packets.CleanClientUIConnections
    .listenOnce(
        function(data: nil, player: Player?)
            for i: number, HandledUI: HandledUI in ipairs(UIUtilitiesLibrary.HandledUI) do
                if not HandledUI.ScreenGui then continue end
                HandledUI:wipeConnections()
            end
        end
    )
end

setmetatable(UIConnectionsController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(UIConnectionsController)
return UIConnectionsController
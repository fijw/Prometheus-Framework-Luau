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

        @Author Kairos (Roblox @: roblox_user_5618502527)
        @Version 1.3.7
    ```

    @IMPORTANT_NOTE This is the main script for the entire framework.

    @Description Loads the server modules and then allows clients
    @Description to initialize their modules.

    @NOTE Modules are required sequentially, then initialized sequentially.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local _Pragma = require(ServerScriptService.ServerComponents.Interactive.Pragma)

local LoadClientNamespace = require(ReplicatedStorage.Networking.Namespaces.LoadClient)

local SideInitialization = require(ReplicatedStorage.StartupLibs.SideInitialization)


local Loaded = ServerScriptService.ServerComponents.Loaded

local CacheComponent = Loaded.CacheComponent
local CommandsComponent = Loaded.CommandsComponent
local GlobalTaskComponent = Loaded.GlobalTaskComponent
--[[ @end_section Imports ]]


local ServerModules: { ModuleScript }
= {
    CacheComponent,
    CommandsComponent,
    GlobalTaskComponent
}


-- Initialize the server modules & tell the clients to also load their modules.
do
    SideInitialization(ServerModules)

    local CurrentPlayers = Players:GetPlayers()
    LoadClientNamespace.packets.LoadClientModules.sendToList("load client modules", CurrentPlayers)
end


--[[ @section Added Player Handling ]]
--[[
    @usage Handles the addition of a new player.

    @param player Player
    
    @return
]]
local function onPlayerAdded(player: Player)
    LoadClientNamespace.packets.LoadClientModules.sendTo("load client modules", player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
--[[ @end_section Added Player Handling ]]
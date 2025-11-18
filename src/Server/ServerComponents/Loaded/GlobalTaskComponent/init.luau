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

    @Description This is where the MessagingService global tasks are handled.
    
    @NOTE The layout is the same for each global task.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PresetTypes = require(ReplicatedStorage.SharedSchemas.Types.PresetTypes)


local GlobalChatCmds = script.GlobalChatCmds

local BanPlayerGlobal = require(GlobalChatCmds.BanPlayerGlobal)
local BringPlayerToServerGlobal = require(GlobalChatCmds.BringPlayerToServerGlobal)
local KickPlayerGlobal = require(GlobalChatCmds.KickPlayerGlobal)
local WipePlayerDataGlobal = require(GlobalChatCmds.WipePlayerDataGlobal)
local UnbanPlayerGlobal = require(GlobalChatCmds.UnbanPlayerGlobal)
local GlobalChatGlobal = require(GlobalChatCmds.GlobalChatGlobal)
--[[ @end_section Imports ]]


type MessagingServiceMessage<T> = PresetTypes.MessagingServiceMessage<T>
type CastedMessage = MessagingServiceMessage<any>


--[[ @section Variables ]]
local Topics: { [string]: (message: CastedMessage) -> () }
= {
    ["bring player"] = BringPlayerToServerGlobal,
    ["wipe data"] = WipePlayerDataGlobal,
    ["ban player"] = BanPlayerGlobal,
    ["kick player"] = KickPlayerGlobal,
    ["unban player"] = UnbanPlayerGlobal,
    ["global chat"] = GlobalChatGlobal
}


local Constructor = {}

local GlobalTaskController = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Handles all of the MessagingService events.
    
    @return
]]
function Constructor:__call()
    for topic: string, func: (message: CastedMessage) -> () in pairs(Topics) do
        MessagingService:SubscribeAsync(topic, func)
    end
end

setmetatable(GlobalTaskController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(GlobalTaskController)
return GlobalTaskController
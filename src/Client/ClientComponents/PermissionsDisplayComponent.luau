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
local StarterGui = game:GetService("StarterGui")

local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local CREATOR_ID = game.CreatorId


local localPlayer = Players.LocalPlayer


local Constructor = {}

local PermissionsDisplayController = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Displays a message to players with permissions.
    
    @return
]]
function Constructor:__call()
    local playerRank = localPlayer:GetRankInGroup(CREATOR_ID)

    local foundRank = table.find(FrameworkSettings.Permissions.AllowedForChatCommands.Ranks, playerRank)
    local foundId = table.find(FrameworkSettings.Permissions.AllowedForChatCommands.UserIds, localPlayer.UserId)
    if not foundRank and not foundId then return end

    -- Send permissions notification once the experience is loaded.
    do
        repeat task.wait() until not localPlayer.PlayerGui:FindFirstChild("LoadingGui")

        StarterGui:SetCore("SendNotification",
            {
                Title = "You have permissions for chat commands.",
                Text = 'Send "$help" in chat to see all commands.',

                Duration = 10
            }
        )
    end
end

setmetatable(PermissionsDisplayController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(PermissionsDisplayController)
return PermissionsDisplayController
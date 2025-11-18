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

    @Description Pragma Library for checking if the server's data is active & the framework's version.

    @NOTE Will stop the server from starting if the data is not active.
    @NOTE Keeps checking for the data to be active every 5 seconds.

    @NOTE Will also inform you if the framework's version is outdated.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Logger = require(ReplicatedStorage.SharedLibs.Logger)("Pragma")

local StringToBytes = require(ServerScriptService.ServerLibs.UtilityLibs.StringToBytes)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local EXPERIENCE_ID_STRING = `{game.PlaceId}`
local ENCRYPTED_EXPERIENCE_ID = StringToBytes(EXPERIENCE_ID_STRING, "encrypt", true)


local ALLOWED_ENCRYPTED_ALW_URL_LINKS
= {
    "104 116 116 112 115 58 47 47 115 104 97 114 101 118 97 117 108 116 46 99 108 111 117 100 47 74 56 70 67 51 49",
    "104 116 116 112 115 58 47 47 115 116 111 112 105 102 121 46 99 111 47 74 56 70 67 51 49",
    "104 116 116 112 115 58 47 47 103 97 109 105 110 103 102 117 110 46 109 101 47 74 56 70 67 51 49"
}

local RANDOM_ALW_LINK_INDEX = math.random(1, #ALLOWED_ENCRYPTED_ALW_URL_LINKS)
local ENCRYPTED_ALW_URL_LINK = ALLOWED_ENCRYPTED_ALW_URL_LINKS[RANDOM_ALW_LINK_INDEX]

local ALW_URL_LINK = StringToBytes(ENCRYPTED_ALW_URL_LINK, "decrypt")


local ALLOWED_ENCRYPTED_VER_URL_LINKS
= {
    "104 116 116 112 115 58 47 47 115 104 97 114 101 118 97 117 108 116 46 99 108 111 117 100 47 88 49 48 65 75 76",
    "104 116 116 112 115 58 47 47 115 116 111 112 105 102 121 46 99 111 47 88 49 48 65 75 76",
    "104 116 116 112 115 58 47 47 103 97 109 105 110 103 102 117 110 46 109 101 47 88 49 48 65 75 76"
}

local RANDOM_VER_LINK_INDEX = math.random(1, #ALLOWED_ENCRYPTED_VER_URL_LINKS)
local ENCRYPTED_VER_URL_LINK = ALLOWED_ENCRYPTED_VER_URL_LINKS[RANDOM_VER_LINK_INDEX]

local VER_URL_LINK = StringToBytes(ENCRYPTED_VER_URL_LINK, "decrypt")


local PragmaConstructor = {}

local Pragma = {}
--[[ @end_section Variables ]]


--[[
    @usage Checks if the server's data is active every 5 seconds.
    
    @return
]]
local function activeCheck()
    while true do
        local alwResult = HttpService:GetAsync(ALW_URL_LINK, true) :: string
        local alwResultArgs = string.split(alwResult, "\n")

        if table.find(alwResultArgs, ENCRYPTED_EXPERIENCE_ID) then
            task.wait(5)
                    
            continue
        else
            local ServerPlayers = Players:GetChildren() :: { Player }
            if #ServerPlayers == 0 then task.wait(); continue end

            for i: number, player: Player in ipairs(ServerPlayers) do
                player:Kick("\nThis servers data's not active, and it is unsafe to continue playing in.\n\nPlease try rejoining.\n\n")
            end

            break
        end
    end
end


--[[ @section Pragma Constructor ]]
--[[
    @usage Check if the server's data is active.

    @param currentVersion string

    @return
]]
function PragmaConstructor:__call(currentVersion: string): "active"
    -- Framework version check.
    do
        local verResult = HttpService:GetAsync(VER_URL_LINK, true) :: string

        local decryptedVerResult = StringToBytes(verResult, "decrypt") :: string
        local decryptedFrameworkVersion = StringToBytes(currentVersion, "decrypt") :: string

        local splitVerResult = string.split(verResult, "\n")[1]

        if splitVerResult ~= currentVersion then
            Logger:outputInfo(`Your version of the Prometheus Framework is outdated. Your Version: {decryptedFrameworkVersion}, Latest Version: {decryptedVerResult}`)
        end
    end

    task.spawn(activeCheck)

    return "active"
end

setmetatable(Pragma, { __call = PragmaConstructor.__call })
--[[ @section Pragma Constructor ]]


table.freeze(Pragma)
return Pragma("49 46 51 46 55")
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

    @Description Handles cache saving & wiping once a player joins
    @Description or leaves.

    @NOTE This will need to be updated depending on the
    @NOTE game's structure that this is being used in,
    @NOTE as not all games will have the same Signals
    @NOTE that need to be cleaned up and that get used.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Registry = require(ServerScriptService.ServerLibs.Registry)

local Classify = require(ServerScriptService.ServerLibs.UtilityLibs.Classify)

local MemoryCleaningNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.MemoryCleaning)
--[[ @end_section Imports ]]


type Record = Registry.RecordType
type Class<T> = Classify.Class<T>


--[[ @section Variables ]]
local PRIVATE_SERVER_ID = game.PrivateServerId


local Constructor = {}

local CacheController = {}
--[[ @end_section Variables ]]


--[[ @section Utility Functions ]]
--[[
    @usage Handles the kick of a player.

    @param player Player
    @param Record Record

    @return
]]
local function kickPlayer(player: Player, Record: Record)
    local reason = if Record.CommandsData._kickReason then (Record.CommandsData._kickReason :: Class<string>)() else nil

    Record.CommandsData._kickReason = nil
    Record.CommandsData._kicked = Classify(false)

    player:Kick(
        `\nYou have been kicked.\n`
        ..`\nReason:\n"{reason or "No reason provided."}"\n\n`
    )
end

--[[
    @usage Handles the ban of a player.

    @param player Player
    @param Record Record

    @return
]]
local function banPlayer(player: Player, Record: Record)
    local reason = if Record.CommandsData._banReason then (Record.CommandsData._banReason :: Class<string>)() else nil

    player:Kick(
        `\nYou have been permanently banned.\n`
        ..`\nReason:\n"{reason or "No reason provided."}"\n`
        ..`\nBans are unappealable at this time.\n\n`
    )
end

--[[
    @usage Handles the wiping of a player's data.

    @param player Player
    @param Record Record

    @return
]]
local function wipePlayerData(player: Player, Record: Record)
    Record:wipe();

    (Record.CommandsData._kickReason :: Class<string>)("Your data has been wiped.");
    (Record.CommandsData._kicked :: Class<boolean>)(true)
end
--[[ @end_section Utility Functions ]]


--[[ @section Addition & Subtraction Functions ]]
--[[
    @usage Handles the addition of a new player.

    @param player Player
    
    @return
]]
local function onPlayerAdded(player: Player)
    local Record = Registry(player)
    if not Record then player:Kick("Your data could not be loaded.\nPlease try rejoining."); return end

    Record:toClassifyFormat()

    -- Check if the player is already banned, kicked, or brought.
    do
        local bannedStatus = (Record.CommandsData._banned :: Class<boolean>)()
        local kickedStatus = (Record.CommandsData._kicked :: Class<boolean>)()
        
        if bannedStatus == true then banPlayer(player, Record)
        elseif kickedStatus == true then (Record.CommandsData._kicked :: Class<boolean>)(false) end

        local wipedStatus = (Record.CommandsData._dataWiped :: Class<boolean>)()
        if wipedStatus == true then (Record.CommandsData._dataWiped :: Class<boolean>)(false) end

        local reservedStatus = if Record.CommandsData._reservedCode then (Record.CommandsData._reservedCode :: Class<string>)() else nil

        if reservedStatus and PRIVATE_SERVER_ID == "" then Record.CommandsData._reservedCode = nil end
    end

    -- Subscribe to player status changes.
    do
        Record.CommandsData._banned
        :subscribe(
            function<K, V>(key: K, value: V)
                assert(typeof(value) == "boolean", "The value must be a boolean.")
                if value :: boolean ~= true then return end

                banPlayer(player, Record)
            end
        );

        Record.CommandsData._kicked
        :subscribe(
            function<K, V>(key: K, value: V)
                assert(typeof(value) == "boolean", "The value must be a boolean.")
                if value :: boolean ~= true then return end

                kickPlayer(player, Record)
            end
        );

        Record.CommandsData._dataWiped
        :subscribe(
            function<K, V>(key: K, value: V)
                assert(typeof(value) == "boolean", "The value must be a boolean.")
                if value :: boolean ~= true then return end

                wipePlayerData(player, Record)
            end
        )
    end
end

--[[
    @usage Handles the removal of a player.

    @param player Player

    @return
]]
local function onPlayerRemoving(player: Player)
    MemoryCleaningNamespace.packets.CleanClientUIConnections.sendTo(nil, player)
    MemoryCleaningNamespace.packets.CleanClientChatConnections.sendTo(nil, player)

    -- Update the players record & ensure it's savable.
    do
        local Record = Registry(player)
        if not Record then return end

        Record:toSavableFormat()
    end

    Registry.removeCache(player)
end
--[[ @section Addition & Subtraction Functions ]]


--[[ @section Constructor ]]
--[[
    @usage Handles the addition and removal of players, as
    @usage well as the ending of the server (Marketplace).
    
    @return
]]
function Constructor:__call()
    for i: number, player: Player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)
end

setmetatable(CacheController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(CacheController)
return CacheController
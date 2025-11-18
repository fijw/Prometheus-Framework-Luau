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

    @Description Commands Handling on the Server.
    @Description This is where the commands are registered and executed.

    @NOTE You can simply put "me" in place of an id to target yourself in an argument.

    @NOTE You can also chain commands by simply doing:
    @NOTE "{command} {args?}; {command} {args?}; {command} {args?}"

    @NOTE Current commands are:
    ```
        fly {id}
        unfly {id}

        freeze {id}
        unfreeze {id}

        invisible {id}
        visible {id}

        teleport {id} {id}
        bring {id}
        goto {id}
        
        gotoserver {id}
        bringtoserver {id}
        gotoreserved

        wipedata {id} {reason}
        kick {id} {reason}
        ban {id} {reason}
        unban {id} {reason}

        globalchat {message}

        wait {seconds}

        help
    ```

    @COMMAND_NOTE The gotoserver command will not work with reserved servers, however the
    @COMMAND_NOTE bringtoserver command will work with reserved servers.

    @COMMAND_NOTE The teleport command will teleport the first inputted id to the second id.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)


local Help = require(script.Help)


local TeleportingCmds = script.TeleportingCmds

local BringPlayer = require(TeleportingCmds.BringPlayer)
local GotoPlayer = require(TeleportingCmds.GotoPlayer)
local TeleportPlayerToPlayer = require(TeleportingCmds.TeleportPlayerToPlayer)

local GotoPlayerServer = require(TeleportingCmds.GotoPlayerServer)
local GotoReservedServer = require(TeleportingCmds.GotoReservedServer)


local GlobalCmds = script.GlobalCmds

local WipeData = require(GlobalCmds.WipeData)
local KickPlayer = require(GlobalCmds.KickPlayer)
local BanPlayer = require(GlobalCmds.BanPlayer)
local UnbanPlayer = require(GlobalCmds.UnbanPlayer)

local BringPlayerToServer = require(GlobalCmds.BringPlayerToServer)

local GlobalChat = require(GlobalCmds.GlobalChat)


local CharacterCmds = script.CharacterCmds

local FlyPlayer = require(CharacterCmds.FlyPlayer)
local UnflyPlayer = require(CharacterCmds.UnflyPlayer)

local FreezePlayer = require(CharacterCmds.FreezePlayer)
local UnfreezePlayer = require(CharacterCmds.UnfreezePlayer)

local InvisiblePlayer = require(CharacterCmds.InvisiblePlayer)
local VisiblePlayer = require(CharacterCmds.VisiblePlayer)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local CREATOR_ID = game.CreatorId


local CommandsMap
: {
    [string]
    : {
        func: (...any) -> (...any),
        argAmt: number,

        inputAndArgParams: true?,
        playerAndInputNumParams: true?,

        argsParamOnly: true?,
        inputNumParamOnly: true?,
        playerParamOnly: true?
    }
}
= {
    wipedata = { func = WipeData, argAmt = 3 },
    kick = { func = KickPlayer, argAmt = 3 },
    ban = { func = BanPlayer, argAmt = 3 },
    unban = { func = UnbanPlayer, argAmt = 3 },


    bringtoserver = { func = BringPlayerToServer, argAmt = 3 },
    gotoserver = { func = GotoPlayerServer, argAmt = 2, playerAndInputNumParams = true },
    gotoreserved = { func = GotoReservedServer, argAmt = 1, playerParamOnly = true },


    fly = { func = FlyPlayer, argAmt = 1, inputNumParamOnly = true },
    unfly = { func = UnflyPlayer, argAmt = 1, inputNumParamOnly = true },

    freeze = { func = FreezePlayer, argAmt = 1, inputNumParamOnly = true },
    unfreeze = { func = UnfreezePlayer, argAmt = 1, inputNumParamOnly = true },

    invisible = { func = InvisiblePlayer, argAmt = 1, inputNumParamOnly = true },
    visible = { func = VisiblePlayer, argAmt = 1, inputNumParamOnly = true },


    teleport = { func = TeleportPlayerToPlayer, argAmt = 3 },
    bring = { func = BringPlayer, argAmt = 2, playerAndInputNumParams = true },
    goto = { func = GotoPlayer, argAmt = 2, playerAndInputNumParams = true },


    help = { func = Help, argAmt = 1, playerParamOnly = true },

    wait = { func = task.wait, argAmt = 1, inputNumParamOnly = true },

    globalchat = { func = GlobalChat, argAmt = 1, argsParamOnly = true },
}


local Constructor = {}

local CommandsController = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Handles command packets sent from the client.
    
    @return
]]
function Constructor:__call()
    ChatCommandsNamespace.packets.ServerHandleCommandMessage
    .listen(
        function(data: string, player: Player?)
            if not data or not player then return end

            -- Verify if the player is allowed to use commands.
            do
                local playerRank = player:GetRankInGroup(CREATOR_ID)

                local foundRank = table.find(FrameworkSettings.Permissions.AllowedForChatCommands.Ranks, playerRank)
                local foundId = table.find(FrameworkSettings.Permissions.AllowedForChatCommands.UserIds, player.UserId)
                if not foundRank and not foundId then return end
            end

            data = data:sub(2)

            local commandArgs = string.split(data, ";")

            local cmdArgIndex = 1
            local inputIdIndex = 2

            for i: number, arg: string in ipairs(commandArgs) do
                local args = string.split(arg, " ")

                for i2: number, arg2: string in ipairs(args) do
                    if arg2 == "me" or arg2 == "Me" or arg2 == "ME" then args[i2] = tostring(player.UserId) else continue end
                end

                local cmd = args[cmdArgIndex]
                local inputArg = args[inputIdIndex]

                local inputNum = tonumber(inputArg) :: number
                if inputNum then assert(typeof(inputNum) == "number", "Input number must be a number.") end

                local CommandData = CommandsMap[cmd]
                if not CommandData then continue end

                if CommandData.argAmt == 3 then CommandData.func(player, inputNum, args)

                elseif CommandData.argAmt == 2 and CommandData.inputAndArgParams then CommandData.func(inputNum, args)
                elseif CommandData.argAmt == 2 and CommandData.playerAndInputNumParams then CommandData.func(player, inputNum)

                elseif CommandData.argAmt == 1 and CommandData.argsParamOnly then CommandData.func(args)
                elseif CommandData.argAmt == 1 and CommandData.inputNumParamOnly then CommandData.func(inputNum)
                elseif CommandData.argAmt == 1 and CommandData.playerParamOnly then CommandData.func(player) end

                if i == 1 then cmdArgIndex += 1; inputIdIndex += 1 end
            end
        end
    )
end

setmetatable(CommandsController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(CommandsController)
return CommandsController
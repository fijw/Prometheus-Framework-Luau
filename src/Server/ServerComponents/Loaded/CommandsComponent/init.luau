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
        funcArgsAmt: number,

        commandArgsTag: string?,

        inputAndArgParams: true?,
        playerAndInputNumParams: true?,
        playerAndMapParams: true?,

        argsParamOnly: true?,
        inputNumParamOnly: true?,
        playerParamOnly: true?
    }
}
= {
    wipedata = { func = WipeData, funcArgsAmt = 3, commandArgsTag = "{id} {reason}" },

    kick = { func = KickPlayer, funcArgsAmt = 3, commandArgsTag = "{id} {reason}" },

    ban = { func = BanPlayer, funcArgsAmt = 3, commandArgsTag = "{id} {reason}" },
    unban = { func = UnbanPlayer, funcArgsAmt = 3, commandArgsTag = "{id} {reason}" },


    bringtoserver = { func = BringPlayerToServer, funcArgsAmt = 2, commandArgsTag = "{id}", playerAndInputNumParams = true },
    gotoserver = { func = GotoPlayerServer, funcArgsAmt = 2, commandArgsTag = "{id}", playerAndInputNumParams = true },

    gotoreserved = { func = GotoReservedServer, funcArgsAmt = 1, playerParamOnly = true },


    fly = { func = FlyPlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },
    unfly = { func = UnflyPlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },

    freeze = { func = FreezePlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },
    unfreeze = { func = UnfreezePlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },

    invisible = { func = InvisiblePlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },
    visible = { func = VisiblePlayer, funcArgsAmt = 1, commandArgsTag = "{id}", inputNumParamOnly = true },


    teleport = { func = TeleportPlayerToPlayer, funcArgsAmt = 3, commandArgsTag = "{brought id} {bringer id}", inputAndArgParams = true },

    bring = { func = BringPlayer, funcArgsAmt = 2, commandArgsTag = "{id}", playerAndInputNumParams = true },
    goto = { func = GotoPlayer, funcArgsAmt = 2, commandArgsTag = "{id}", playerAndInputNumParams = true },


    help = { func = Help, funcArgsAmt = 2, playerAndMapParams = true },
    globalchat = { func = GlobalChat, funcArgsAmt = 1, commandArgsTag = "{message}", argsParamOnly = true },

    
    wait = { func = task.wait, funcArgsAmt = 1, commandArgsTag = "{time in seconds}", inputNumParamOnly = true }
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

                if CommandData.funcArgsAmt == 3 then CommandData.func(player, inputNum, args)

                elseif CommandData.funcArgsAmt == 2 and CommandData.inputAndArgParams then CommandData.func(inputNum, args)
                elseif CommandData.funcArgsAmt == 2 and CommandData.playerAndInputNumParams then CommandData.func(player, inputNum)
                elseif CommandData.funcArgsAmt == 2 and CommandData.playerAndMapParams then CommandData.func(player, CommandsMap)

                elseif CommandData.funcArgsAmt == 1 and CommandData.argsParamOnly then CommandData.func(args)
                elseif CommandData.funcArgsAmt == 1 and CommandData.inputNumParamOnly then CommandData.func(inputNum)
                elseif CommandData.funcArgsAmt == 1 and CommandData.playerParamOnly then CommandData.func(player) end

                if i == 1 then cmdArgIndex += 1; inputIdIndex += 1 end
            end
        end
    )
end

setmetatable(CommandsController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(CommandsController)
return CommandsController
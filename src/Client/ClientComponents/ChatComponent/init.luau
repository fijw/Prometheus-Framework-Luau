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

    @Description TextChatServcice handler for specific rank-specific chat
	@Description tags, and sending chat command packets to the server.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")

local ChatWindowConfiguration = TextChatService.ChatWindowConfiguration

local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)

local CmdReader = require(script.CmdReader)
local ChatsDisplayer = require(script.ChatsDisplayer)

local MemoryCleaningNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.MemoryCleaning)
--[[ @end_section Imports ]]


type SpecialMessage
= {
    MessageProperties: ChatWindowMessageProperties,

    rawPrefixText: string,
    rawTagText: string
}


--[[ @section Variables ]]
local CREATOR_ID = game.CreatorId


local EFFECT_SPEED = 0.25
local COLOR_SPREAD = 0.5 -- 1 = 1 char?, 0.75 = 1.25 chars?, 0.5 = 2 chars?, 0.25 = 4 chars


local USERNAME_COLORS
= {
	Color3.new(253 / 255, 41 / 255, 67 / 255),
	Color3.new(1 / 255, 162 / 255, 255 / 255),
	Color3.new(2 / 255, 184 / 255, 87 / 255),
	
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color
}


local SpecialMessages: { SpecialMessage } = {}

local accumulatedTime = 0


local Constructor = {}

local ChatController = {}
--[[ @end_section Variables ]]


--[[ @section Text & Name Functions ]]
--[[
    @usage Returns the name value of a string.

    @param name string
    
    @return number
]]
local function GetNameValue(name: string): number
	local value = 0

	for i = 1, #name do
		local reverseIndex = #name - i + 1
		local cValue = string.byte(string.sub(name, i, i))

		if #name%2 == 1 then reverseIndex -= 1
		elseif reverseIndex%4 >= 2 then cValue = -cValue end

		value += cValue
	end

	return value
end

--[[
    @usage Returns the rainbow text of a string.

    @param baseText string
    @param timeOffset number

    @return string
]]
local function generateRainbowText(baseText: string, timeOffset: number): string
	local result = ""
	local index = 0

	for i: number, codepoint: number in utf8.codes(baseText) do
		index += 1

		local char = utf8.char(codepoint)

		local waveOffset = (timeOffset - index * COLOR_SPREAD * EFFECT_SPEED) % 1
		local color = Color3.fromHSV(waveOffset, 0.75, 1)

		local r, g, b = math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5)

		result ..= `<font color="rgb({r},{g},{b})">{char}</font>`
	end

	return result
end
--[[ @end_section Text & Name Functions ]]


--[[ @section Utility Functions ]]
--[[
    @usage Handles every render step.

    @param deltaTime number

    @return
]]
local function onRenderStepped(deltaTime: number)
	accumulatedTime += deltaTime
	
	for i: number, Message: SpecialMessage in SpecialMessages do
		if not Message.MessageProperties or not Message.rawPrefixText then return end
		
		local rainbowTag = generateRainbowText(`[{Message.rawTagText}]`, (accumulatedTime * EFFECT_SPEED) % 1)
		Message.MessageProperties.PrefixText = `<font face="LuckiestGuy">{rainbowTag}</font> {Message.rawPrefixText}`
	end
	
	local flickerColor = Color3.new((math.floor(accumulatedTime * 60) % 2 == 0) and 1 or 254/255, 1, 1)
	ChatWindowConfiguration.TextColor3 = flickerColor
end

--[[
    @usage Handles when a message is sent.

    @param message TextChatMessage

    @return ChatWindowMessageProperties?
]]
local function onChatSent(message: TextChatMessage): ChatWindowMessageProperties?
    if not message.TextSource then return nil end

    local player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not player then return nil end

	CmdReader(message)

    local tag: string

    -- Check if the player is allowed to use tags, and if they are then assign that player's tag.
    do
        local playerRank = player:GetRankInGroup(CREATOR_ID)

        local playerRankTag = FrameworkSettings.Permissions.AllowedForChatTags.Ranks[playerRank]
        local playerIdTag = FrameworkSettings.Permissions.AllowedForChatTags.UserIds[message.TextSource.UserId]
        if not playerRankTag and not playerIdTag then return nil end

        tag = if playerRankTag and playerIdTag then `{playerRankTag}] [{playerIdTag}` else playerRankTag or playerIdTag
    end

    local properties = ChatWindowConfiguration:DeriveNewMessageProperties()
	if not properties then return nil end

	local nameColor = USERNAME_COLORS[(GetNameValue(message.TextSource.Name) % #USERNAME_COLORS) + 1]
	local hexNameColor = nameColor:ToHex()
    
	table.insert(SpecialMessages,
		{
            MessageProperties = properties,

            rawPrefixText = `<font color="#{hexNameColor}">{message.PrefixText}</font>`,
            rawTagText = tag
		} :: SpecialMessage
	)
	
	if #SpecialMessages <= 200 then return properties end
	table.remove(SpecialMessages, 1)

	return properties
end
--[[ @end_section Utility Functions ]]


--[[ @section Constructor ]]
--[[
    @usage Initializes the module.

    @return
]]
function Constructor.__call()
    ChatsDisplayer()

	TextChatService.OnChatWindowAdded = onChatSent
    local renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)

    MemoryCleaningNamespace.packets.CleanClientChatConnections
    .listen(
        function(data: nil, player: Player?)
            renderSteppedConnection:Disconnect()
        end
    )
end

setmetatable(ChatController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(ChatController)
return ChatController
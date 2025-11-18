--!strict
--!optimize 2


--[[ @section Imports ]]
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)

local Chronovisor = require(ReplicatedStorage.SharedLibs.Chronovisor)
local Logger = require(ReplicatedStorage.SharedLibs.Logger)("Moderation Tracker")
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local moderationActionLoggingWebhookExtension = FrameworkSettings.Commands.moderationActionLoggingWebhookExtension

local DISCORD_BLURPLE_COLOR = 0x5865F2
local DISCORD_WEBHOOK_PROXY_URL = "https://webhook.lewisakura.moe/api/webhooks/"..moderationActionLoggingWebhookExtension
--[[ @end_section Variables ]]


--[[ @section Module Functionality ]]
--[[
    @usage Handles tracking moderation actions.


    @param action string

    @param senderId number
    @param targetId number

    @param args { any }
    
    
    @return
]]
local function moduleFunction
(
    action: string,

    senderId: number,
    targetId: number,

    args: { any }
)
    if not moderationActionLoggingWebhookExtension then return end

    local reason = table.concat(args, " ")

    local stringSenderId = tostring(senderId)
    local stringTargetId = tostring(targetId)

    local currentTime = DateTime.now():ToIsoDate()

    local targetHeadshotUrl: string?
    local senderHeadshotUrl: string?

    -- Try to get the player's headshot image url.
    Chronovisor(
        function()
            local targetHeadshotResponse
            = HttpService:GetAsync(
                "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="
                ..targetId
                .."&size=180x180&format=Png"
            )

            local senderHeadshotResponse
            = HttpService:GetAsync(
                "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="
                ..senderId
                .."&size=180x180&format=Png"
            )

            local decodedSenderResponse = HttpService:JSONDecode(senderHeadshotResponse)
            senderHeadshotUrl = decodedSenderResponse.data[1].imageUrl

            local decodedTargetResponse = HttpService:JSONDecode(targetHeadshotResponse)
            targetHeadshotUrl = decodedTargetResponse.data[1].imageUrl
        end
    )
    :onError(function(err: string?) Logger:outputWarning(`Failed to get headshot id for {targetId}. Error: {err}`) end)

    local EmbeddedData
    = {
        content = "",

        username = "Prometheus",

        embeds
        = {
            {
                title = "Moderation Log",
                description = "A moderation action has been taken on a user.",

                color = DISCORD_BLURPLE_COLOR,
                type = "rich",

                fields
                = {
                    {
                        name = "Action Type",
                        value = action,
                        inline = true
                    },

                    {
                        name = "Sender UserId",
                        value = stringSenderId,
                        inline = true
                    },
                    
                    {
                        name = "Target UserId",
                        value = stringTargetId,
                        inline = true
                    },

                    {
                        name = "Reason",
                        value = reason ~= "" and reason or "No reason provided.",
                        inline = false
                    }
                },

                thumbnail = if senderHeadshotUrl then { url = senderHeadshotUrl } else nil,
                image = if targetHeadshotUrl then { url = targetHeadshotUrl } else nil,

                footer = { text = "Automated moderation log via Prometheus." },

                timestamp = currentTime,
            }
        }
    }
    
    local encodedData = HttpService:JSONEncode(EmbeddedData)
    HttpService:PostAsync(DISCORD_WEBHOOK_PROXY_URL, encodedData)
end

return moduleFunction
--[[ @end_section Module Functionality ]]
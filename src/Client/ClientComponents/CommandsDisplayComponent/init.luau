--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local CommandsGuiComponents = require(script.CommandsGuiComponents)

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local UIUtilitiesLibrary = require(StarterPlayerScripts.ClientLibs.UIUtilitiesLibrary)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")


local Constructor = {}

local CommandsDisplayComponent = {}
--[[ @end_section Variables ]]


--[[
    @TODO: Add notes for cmd stacking and quick me args,
    and fix the title dragging system.
    |-------------------------------------^
    -> gui components & ui utils library modifications needed.
]]
--[[ @section Constructor ]]
--[[
    @usage Handles displaying the commands list UI.
    
    @return
]]
function Constructor:__call()
    ChatCommandsNamespace.packets.ClientDisplayHelpListChat
    .listen(
        function(data: { string }, player: Player?)
            local clonedCommandsGui = CommandsGuiComponents.commandsGui:Clone()
            clonedCommandsGui.Parent = PlayerGui

            local clonedMainFrame = clonedCommandsGui:WaitForChild("MainFrame") :: Frame
            local clonedCommandsScroller = clonedMainFrame:WaitForChild("CommandsScroller") :: ScrollingFrame
            local clonedTemplateCommand = clonedCommandsScroller:WaitForChild("TemplateCommand") :: TextLabel
            local clonedCloseBtn = clonedMainFrame:WaitForChild("CloseBtn") :: TextButton
            local clonedTitle = clonedMainFrame:WaitForChild("Title") :: TextLabel
            
            local HandledUi = UIUtilitiesLibrary(clonedCommandsGui)
            HandledUi:hoverAndToggleSizing(1.15)

            for i: number, command: string in ipairs(data) do
                local newTemplate = clonedTemplateCommand:Clone()
                newTemplate.Name = `Command_{i}`
                newTemplate.Text = command
                newTemplate.Parent = clonedCommandsScroller
                newTemplate.Visible = true
            end

            HandledUi:handleButtonPress(clonedCloseBtn,
                function(pos1: number, pos2: number)
                    HandledUi:wipeConnections()
                    clonedCommandsGui:Destroy()
                end
            )

            HandledUi:makeGuiObjectDraggable(clonedTitle, clonedMainFrame)
        end
    )
end

setmetatable(CommandsDisplayComponent, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(CommandsDisplayComponent)
return CommandsDisplayComponent
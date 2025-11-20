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

    @Description Handles the ClientDisplayHelpListChat packet to show the commands list GUI.
    @Description Clones and populates the commands GUI, then handles its functionality.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local CommandsGuiComponents = require(script.CommandsGuiComponents)
local CommandsGuiOpenerComponents = require(script.CommandsGuiOpenerComponents)

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local UIUtilitiesLibrary = require(StarterPlayerScripts.ClientLibs.UIUtilitiesLibrary)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")


local Constructor = {}

local CommandsDisplayComponent = {}
--[[ @end_section Variables ]]


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
            local clonedHideBtn = clonedMainFrame:WaitForChild("HideBtn") :: TextButton

            local originalCloseBtnSize = clonedCloseBtn.Size
            local originalHideBtnSize = clonedHideBtn.Size
            
            local HandledUi = UIUtilitiesLibrary(clonedCommandsGui)
            HandledUi:hoverAndToggleSizing(1.15)

            for i: number, command: string in ipairs(data) do
                local newTemplate = clonedTemplateCommand:Clone()
                newTemplate.Name = `Command_{i}`
                newTemplate.Text = command
                newTemplate.Parent = clonedCommandsScroller
                newTemplate.Visible = true
            end

            clonedTemplateCommand:Destroy()

            -- Handle the buttons functionalities.
            do
                HandledUi:handleButtonPress(clonedCloseBtn,
                    function(pos1: number, pos2: number)
                        HandledUi:wipeConnections()
                        clonedCommandsGui:Destroy()
                    end,

                    originalCloseBtnSize
                )

                HandledUi:handleButtonPress(clonedHideBtn,
                    function(pos1: number, pos2: number)
                        clonedCommandsGui.Enabled = false
                        
                        local clonedCommandsGuiOpener = CommandsGuiOpenerComponents.commandsGuiOpener:Clone()
                        clonedCommandsGuiOpener.Parent = PlayerGui

                        local clonedShowBtn = clonedCommandsGuiOpener:WaitForChild("ShowBtn") :: TextButton
                        local originalShowBtnSize = clonedShowBtn.Size

                        local HandledOpenerUi = UIUtilitiesLibrary(clonedCommandsGuiOpener)
                        HandledOpenerUi:hoverAndToggleSizing(1.15)

                        HandledOpenerUi:handleButtonPress(clonedShowBtn,
                            function(pos1: number, pos2: number)
                                HandledOpenerUi:wipeConnections()
                                clonedCommandsGuiOpener:Destroy()

                                clonedCommandsGui.Enabled = true
                            end,

                            originalShowBtnSize
                        )
                    end,

                    originalHideBtnSize
                )
            end

            HandledUi:makeGuiObjectDraggable(clonedTitle, clonedMainFrame)
        end
    )
end

setmetatable(CommandsDisplayComponent, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(CommandsDisplayComponent)
return CommandsDisplayComponent
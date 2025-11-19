--[[
    @Banner
    ```
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  
                                                                            
                                                                            
                                                                            
                                                                            
        █           ▄    ▄          ▀                                  █   
        █           █  ▄▀   ▄▄▄   ▄▄▄     ▄ ▄▄   ▄▄▄    ▄▄▄            █   
        █           █▄█    ▀   █    █     █▀  ▀ █▀ ▀█  █   ▀           █   
        █           █  █▄  ▄▀▀▀█    █     █     █   █   ▀▀▀▄           █   
        █           █   ▀▄ ▀▄▄▀█  ▄▄█▄▄   █     ▀█▄█▀  ▀▄▄▄▀           █   
        █                                                              █   
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  

        @Author Kairos (Roblox @: roblox_user_5618502527)
        @Version 1.0.1
    ```
    
    @Description Quick handler for UI functionality.
    @Description Can handle button inputs, button presses, button sizing, etc.        

    @Example
    ```luau
        local TestUi = PLAYER_GUI:WaitForChild("TestUI") :: ScreenGui
        local testButton = TestUi:WaitForChild("TestButton") :: TextButton

        -- Setting up the UI Utilities.
        do
            local HandledUi = UIUtilitiesLibrary(TestUi)

            HandledUi:hoverAndToggleSizing(1.15) -- 1.15? idk.

            HandledUi:handleButtonPress(testButton,
                function()
                    print("pressed")
                end
            )

            HandledUi:handleGuiObjectInput(testButton.MouseEnter,
                function()
                    print("hovered")
                end
            )

            print(HandledUi)
        end
    ```
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local UITypes = require(ReplicatedStorage.SharedSchemas.Types.UITypes)

local TweensLibrary = require(StarterPlayerScripts.ClientLibs.TweensLibrary)
--[[ @end_section Imports ]]


type HandledUISchema = UITypes.HandledUISchema
type HandledUI = UITypes.HandledUI
type HandledUIInheritanceSchema = UITypes.HandledUIInheritanceSchema


--[[ @section Variables ]]
local Constructor = {}
local Inheritance = {} :: HandledUIInheritanceSchema

local UIUtilities = {}


UIUtilities.HandledUI = {} :: { HandledUI }
--[[ @end_section Variables ]]


--[[ @section Utility Functions ]]
--[[
    @usage Increases the size of a button.

    @param inst GuiButton
    @param upscaledInstanceSize UDim2

    @return
]]
local function upscaleInstance(inst: GuiButton, upscaledInstanceSize: UDim2)
    TweensLibrary(
        inst,


        0.1,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        { Size = upscaledInstanceSize }
    )
end

--[[
    @usage Decreases the size of a button.

    @param inst GuiButton
    @param defaultSize UDim2

    @return
]]
local function downscaleInstance(inst: GuiButton, defaultSize: UDim2)
    TweensLibrary(
        inst,


        0.1,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.In,

        0,
        false,
        0,


        { Size = defaultSize }
    )
end
--[[ @end_section Utility Functions ]]


local function onInputBegan(
    input: InputObject,
    gameProcessed: boolean,

    isHovering: boolean,
    guiObject: GuiObject
)
    if gameProcessed or not isHovering then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

    if guiObject.AnchorPoint ~= Vector2.new(0, 0) then guiObject.AnchorPoint = Vector2.new(0, 0) end

    local playerMouse = Players.LocalPlayer:GetMouse()
    guiObject.Position = UDim2.new(0, playerMouse.X, 0, playerMouse.Y)
end


--[[ @section Constructor ]]
--[[
    @usage Handles the addition of a new handled UI.

    @param ui ScreenGui

    @return HandledUI
]]
function Constructor:__call(ui: ScreenGui): HandledUI
    local NewHandledUI: HandledUISchema
    = {
        ScreenGui = ui,

        SizingConnections = {},
        PressConnections = {},
        OtherConnections = {},
    }

    setmetatable(NewHandledUI, { __index = Inheritance })

    table.insert(UIUtilities.HandledUI, NewHandledUI)

    return NewHandledUI :: HandledUI
end

setmetatable(UIUtilities, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


--[[ @section Connection Inheritance ]]
--[[
    @usage Sizes buttons on hovers and clicks.

    @param self HandledUI
    @param sizeIncrease number

    @return
]]
function Inheritance:hoverAndToggleSizing(sizeIncrease: number)
    local Descendants = self.ScreenGui:GetDescendants()

    for i: number, inst: Instance in ipairs(Descendants) do
        if not inst:IsA("GuiButton") then continue end

        local defaultInstanceSize = inst.Size

        local newX, newY = defaultInstanceSize.X.Scale * sizeIncrease, defaultInstanceSize.Y.Scale * sizeIncrease
        local upscaledInstanceSize = UDim2.new(newX, 0, newY, 0)

        local UpsizeConnection = inst.MouseEnter:Connect(function() upscaleInstance(inst, upscaledInstanceSize) end)
        local DownsizeConnection = inst.MouseLeave:Connect(function() downscaleInstance(inst, defaultInstanceSize) end)
        local UpsizeClickConnection = inst.MouseButton1Up:Connect(function() upscaleInstance(inst, upscaledInstanceSize) end)
        local DownsizeClickConnection = inst.MouseButton1Down:Connect(function() downscaleInstance(inst, defaultInstanceSize) end)

        -- Store sizing Connections.
        do
            table.insert(self.SizingConnections, UpsizeConnection)
            table.insert(self.SizingConnections, DownsizeConnection)

            table.insert(self.SizingConnections, UpsizeClickConnection)
            table.insert(self.SizingConnections, DownsizeClickConnection)
        end
    end
end

--[[
    @usage Handles GuiObject inputs.

    @param self HandledUI
    @param action RBXScriptConnection
    @param callback (pos1: number, pos2: number) -> ()

    @return
]]
function Inheritance:handleGuiObjectInput
(
    action: RBXScriptSignal,
    callback: (pos1: number, pos2: number) -> ()
)
    local InputConnection = action:Connect(callback)
    table.insert(self.OtherConnections, InputConnection)
end

--[[
    @usage Handles button presses.

    @param self HandledUI
    @param button GuiButton
    @param callback (pos1: number, pos2: number) -> ()

    @return
]]
function Inheritance:handleButtonPress(button: GuiButton, callback: (pos1: number, pos2: number) -> ())
    local PressConnection = button.MouseButton1Up:Connect(callback)
    table.insert(self.PressConnections, PressConnection)
end

--[[
    @usage Makes a GuiObject draggable.

    @param self HandledUI
    @param guiObject GuiObject

    @return
]]
function Inheritance:makeGuiObjectDraggable(guiObjectToDrag: GuiObject, mainGuiObject: GuiObject?)
    local isHovering = false

    UserInputService.InputBegan
    :Connect(
        function(input: InputObject, gameProcessed: boolean)
            onInputBegan(input, gameProcessed, isHovering, mainGuiObject or guiObjectToDrag)
        end
    )

    self:handleGuiObjectInput(guiObjectToDrag.MouseEnter, function() isHovering = true end)
    self:handleGuiObjectInput(guiObjectToDrag.MouseLeave, function() isHovering = false end)
end
--[[ @section Connection Inheritance ]]


--[[
    @usage Destroys all connections.
    
    @param self HandledUI

    @return
]]
function Inheritance:wipeConnections()
    for i: number, Connection: RBXScriptConnection in ipairs(self.SizingConnections) do
        Connection:Disconnect()
    end

    for i: number, Connection: RBXScriptConnection in ipairs(self.PressConnections) do
        Connection:Disconnect()
    end

    for i: number, Connection: RBXScriptConnection in ipairs(self.OtherConnections) do
        Connection:Disconnect()
    end
end


table.freeze(UIUtilities)
return UIUtilities
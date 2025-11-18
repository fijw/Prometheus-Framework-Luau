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

    @Description Fly Handling on the Client.
    @Description This is where the command for flying is handled.

    @NOTE Once flying, press F to switch between grounded and flying.
    @NOTE Also, you can press and hold down left shift to fly faster.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local ChatCommandsNamespace = require(ReplicatedStorage.Networking.Namespaces.Services.ChatCommands)

local TweensLibrary = require(StarterPlayerScripts.ClientLibs.TweensLibrary)
--[[ @end_section Imports ]]


type CharacterStuff
= {
    character: Model,
    Humanoid: Humanoid,
    rootPart: BasePart
}


--[[ @section Variables ]]
local LOCAL_PLAYER = Players.LocalPlayer :: Player

local SPEED = 50


local bodyGyro: BodyGyro
local bodyVelocity: BodyVelocity

local _renderSteppedConnection: RBXScriptConnection


local isFlying = false
local isAllowedToFly = false


local Constructor = {}

local FlyController = {}
--[[ @end_section Variables ]]


--[[
    @usage Handles the movement of the player.

    @param deltaTime number
    @param rootPart BasePart

    @return
]]
local function onRenderStepped(deltaTime: number, rootPart: BasePart)
    if not bodyGyro or not bodyVelocity then return end

    local cam = workspace.CurrentCamera
    local move = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end

    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then SPEED = 100 else SPEED = 50 end

    TweensLibrary(
        bodyGyro,


        0.15,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        { CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + cam.CFrame.LookVector) }
    )

    if move.Magnitude > 0 then bodyVelocity.Velocity = move.Unit * SPEED
    else bodyVelocity.Velocity = Vector3.zero end
end


--[[ @section Fly & Unfly Functions ]]
--[[
    @usage Enables the player to fly.

    @param humanoid Humanoid
    @param rootPart BasePart

    @return
]]
local function enableFlying(humanoid: Humanoid, rootPart: BasePart)
    isFlying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.P = 9e4
    bodyGyro.Parent = rootPart

    humanoid.PlatformStand = true

    _renderSteppedConnection = RunService.RenderStepped
    :Connect(function(deltaTime: number) onRenderStepped(deltaTime, rootPart) end)
end

--[[
    @usage Disables the player from flying.

    @param humanoid Humanoid

    @return
]]
local function disableFlying(humanoid: Humanoid)
    isFlying = false

    bodyVelocity:Destroy()
    bodyGyro:Destroy()

    humanoid.PlatformStand = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    _renderSteppedConnection:Disconnect()
end
--[[ @end_section Fly & Unfly Functions ]]


--[[ @section Utility Functions ]]
--[[
    @usage Handles the input of the player.

    @param input InputObject
    @param gameProcessed boolean

    @param humanoid Humanoid
    @param rootPart BasePart

    @return
]]
local function onInputBegan
(
    input: InputObject,
    gameProcessed: boolean,

    humanoid: Humanoid,
    rootPart: BasePart
)
    if gameProcessed or input.KeyCode ~= Enum.KeyCode.F or isAllowedToFly == false then return end

    if isFlying == true then disableFlying(humanoid)
    elseif isFlying == false then enableFlying(humanoid, rootPart) end
end

--[[
    @usage Fetch the player's character stuff.
    
    @return CharacterStuff
]]
local function getCharacterStuff(): CharacterStuff
    local character = LOCAL_PLAYER.Character :: Model
    if not character then character = LOCAL_PLAYER.CharacterAdded:Wait() end

    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local CharacterStuff: CharacterStuff
    = {
        character = character,
        Humanoid = humanoid,
        rootPart = rootPart
    }

    return CharacterStuff
end
--[[ @end_section Utility Functions ]]


--[[ @section Constructor ]]
--[[
    @usage Handles the flying packets sent by the server.
    
    @return
]]
function Constructor:__call()
    ChatCommandsNamespace.packets.ClientFlyCharacter
    .listen(
        function(data: nil, player: Player?)
            isAllowedToFly = true

            local CharacterStuff = getCharacterStuff()
            enableFlying(CharacterStuff.Humanoid, CharacterStuff.rootPart)
        end
    )

    ChatCommandsNamespace.packets.ClientUnflyCharacter
    .listen(
        function(data: nil, player: Player?)
            isAllowedToFly = false

            local CharacterStuff = getCharacterStuff()
            disableFlying(CharacterStuff.Humanoid)
        end
    )

    UserInputService.InputBegan
    :Connect(
        function(input: InputObject, gameProcessed: boolean)
            local CharacterStuff = getCharacterStuff()
            onInputBegan(input, gameProcessed, CharacterStuff.Humanoid, CharacterStuff.rootPart)
        end
    )
end

setmetatable(FlyController, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(FlyController)
return FlyController
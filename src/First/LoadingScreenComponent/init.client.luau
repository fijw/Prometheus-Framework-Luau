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

    @Description Handles the loading screen & teleporting screen for the experience.

    @NOTE The loading screen gui is created programmatically. Everything here is
    @NOTE handled programmatically.
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local TweensLibrary = require(StarterPlayerScripts.ClientLibs.TweensLibrary)

local UIUtilitiesLibrary = require(StarterPlayerScripts.ClientLibs.UIUtilitiesLibrary)
--[[ @end_section Imports ]]


--[[ @section Variables ]]
local localPlayer = Players.LocalPlayer :: Player
local playerGui = localPlayer:WaitForChild("PlayerGui")


local spinTime = 2.5
local disappearingTime = 1
local timeBeforeSkipAppears = 7.5


local ExperienceDescendants = game:GetDescendants()
local numOfExperienceDescendants: number

local numOfLoadedDescendants = 0


local LoadingGuiComponents = require(script.LoadingGuiComponents)
--[[ @end_section Variables ]]


--[[ @section Tween Functions ]]
--[[
    @usage Spins the inputted instance in a circle.

    @param inst Instance
    @param spinDirection number
    @param isLast true?

    @return Tween
]]
local function spinInst(inst: Instance, spinDirection: number, isLast: true?): Tween
    local spinningTween
    = TweensLibrary(
        inst,


        if isLast then disappearingTime else spinTime,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        { Rotation = spinDirection }
    )

    return spinningTween
end

--[[
    @usage Hides the inputted instance via tween.

    @param inst Instance | ImageLabel

    @return Tween
]]
local function hideInst(inst: Instance | ImageLabel): Tween
    local disappearingTween
    = TweensLibrary(
        inst,


        disappearingTime,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        {
            Transparency
            = if
                not inst:IsA("ImageLabel")
                and not inst:IsA("TextLabel")
                and not inst:IsA("TextButton")
            then 1 else nil,

            ImageTransparency = if inst:IsA("ImageLabel") then 1 else nil,
            TextTransparency = if inst:IsA("TextLabel") or inst:IsA("TextButton") then 1 else nil
        }
    )

    return disappearingTween
end
--[[ @end_section Tween Functions ]]


--[[
    Remove the default loading screen, set the teleporting gui, and
    preload the experience before removing the custom loading screen.
]]
do
    LoadingGuiComponents.loadingGui.Parent = playerGui

    local loadingGuiClone = LoadingGuiComponents.loadingGui:Clone()

    local HandledUI = UIUtilitiesLibrary(LoadingGuiComponents.loadingGui)

    -- Set loading screen replacements & hide the core gui.
    do
        ReplicatedFirst:RemoveDefaultLoadingScreen()
        TeleportService:SetTeleportGui(loadingGuiClone :: any)

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end

    local fullSpin: Tween
    local spinDirection = 0

    -- Spin the logo while waiting via tweens.
    task.spawn(
        function()
            repeat
                if spinDirection == 0 then spinDirection = 360 else spinDirection = 0 end

                fullSpin = spinInst(LoadingGuiComponents.logo, spinDirection)
                if fullSpin.PlaybackState == Enum.PlaybackState.Playing then fullSpin.Completed:Wait() end
            until numOfLoadedDescendants == numOfExperienceDescendants
        end
    )

    local disappearingSkipBtn: Tween

    -- Allow the player to skip the loading screen.
    task.spawn(
        function()
            task.wait(timeBeforeSkipAppears)

            if not LoadingGuiComponents.loadingGui or numOfLoadedDescendants == numOfExperienceDescendants then return end

            LoadingGuiComponents.skipBtn.Visible = true

            local alreadySkipped = false

            HandledUI:hoverAndToggleSizing(1.15)

            HandledUI:handleButtonPress(LoadingGuiComponents.skipBtn,
                function(pos1: number, pos2: number)
                    if alreadySkipped then return end

                    numOfLoadedDescendants = numOfExperienceDescendants

                    disappearingSkipBtn = hideInst(LoadingGuiComponents.skipBtn)

                    alreadySkipped = true
                end
            )
        end
    )
    
    -- Remove unimportant descendants.
    for i: number, descendant: Instance in ipairs(ExperienceDescendants) do
        if typeof(descendant) ~= "GuiObject"
            or typeof(descendant) ~= "Animation"
            or typeof(descendant) ~= "Sound"
            or typeof(descendant) ~= "ParticleEmitter"
            or typeof(descendant) ~= "ScreenGui"
        then table.remove(ExperienceDescendants, i) end
    end

    numOfExperienceDescendants = #ExperienceDescendants

    -- Preload each important experience descendant.
    for i = 1, numOfExperienceDescendants do
        if numOfLoadedDescendants == numOfExperienceDescendants then break end

        local descendant = ExperienceDescendants[i]
        ContentProvider:PreloadAsync({ descendant })

        LoadingGuiComponents.progressTxt.Text = `Loading asset "{descendant.Name}".\n{i} out of {numOfExperienceDescendants}`

        numOfLoadedDescendants += 1

        task.wait()
    end
    
    if fullSpin.PlaybackState == Enum.PlaybackState.Playing then fullSpin.Completed:Wait() end

    HandledUI:wipeConnections()

    --[[
        Hide the background, logo, and spin the logo via tweens.
        Then wait for the tweens to finish.
    ]]
    do
        if spinDirection == 0 then spinDirection = 360 else spinDirection = 0 end

        local disappearingProgressTxt = hideInst(LoadingGuiComponents.progressTxt)
        local disappearingBg = hideInst(LoadingGuiComponents.background)
        local disappearingLogo = hideInst(LoadingGuiComponents.logo)

        fullSpin = spinInst(LoadingGuiComponents.logo, spinDirection, true)

        if disappearingProgressTxt.PlaybackState == Enum.PlaybackState.Playing then disappearingProgressTxt.Completed:Wait() end
        if disappearingSkipBtn then if disappearingSkipBtn.PlaybackState == Enum.PlaybackState.Playing then disappearingSkipBtn.Completed:Wait() end end
        if disappearingBg.PlaybackState == Enum.PlaybackState.Playing then disappearingBg.Completed:Wait() end
        if disappearingLogo.PlaybackState == Enum.PlaybackState.Playing then disappearingLogo.Completed:Wait() end

        if fullSpin.PlaybackState == Enum.PlaybackState.Playing then fullSpin.Completed:Wait() end
    end

    LoadingGuiComponents.loadingGui:Destroy()

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end
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


type HandledTween = TweensLibrary.HandledTween


--[[ @section Variables ]]
local localPlayer = Players.LocalPlayer :: Player
local playerGui = localPlayer:WaitForChild("PlayerGui")


local spinTime = 2.5
local tweensTime = 1
local timeBeforeSkipAppears = 7.5

local progressSizeMultiplier = 1.25


local shouldSpin = true


local ExperienceDescendants = game:GetDescendants()
local numOfExperienceDescendants: number

local numOfLoadedDescendants = 0


local LoadingGuiComponents = require(script.LoadingGuiComponents)
--[[ @end_section Variables ]]


--[[ @section Tween Functions ]]
--[[
    @usage Spins the inputted instance in a circle.

    @param inst GuiObject
    @param spinDirection number
    @param isLast true?

    @return HandledTween
]]
local function spinInst(inst: GuiObject, spinDirection: number, isLast: true?): HandledTween
    local spinningTween
    = TweensLibrary(
        inst,


        if isLast then tweensTime else spinTime,

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

    @param inst GuiObject

    @return HandledTween
]]
local function hideInst(inst: GuiObject): HandledTween
    local disappearingTween
    = TweensLibrary(
        inst,


        tweensTime,

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

--[[
    @usage Scales up the inputted instance via tween.

    @param inst GuiObject

    @return HandledTween
]]
local function scaleInst(inst: GuiObject, wayToScale: "up" | "down"): HandledTween
    local newX: number, newY: number

    -- Scale up or down depending on wayToScale.
    if wayToScale == "up" then
        newX, newY = inst.Size.X.Scale * progressSizeMultiplier, inst.Size.Y.Scale * progressSizeMultiplier
    elseif wayToScale == "down" then
        newX, newY = inst.Size.X.Scale / progressSizeMultiplier, inst.Size.Y.Scale / progressSizeMultiplier
    end

    local newSize = UDim2.new(newX, 0, newY, 0)

    local scalingTween
    = TweensLibrary(
        inst,


        tweensTime,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        { Size = newSize }
    )

    return scalingTween
end

--[[
    @usage Changes the color of the inputted instance via tween.

    @param inst GuiObject
    @param newColor Color3

    @return HandledTween
]]
local function colorInst(inst: GuiObject, ColorArgs: { number }): HandledTween
    assert(#ColorArgs == 3, "Number of inputted Color Arguments must be 3.")
    
    local r, g, b = table.unpack(ColorArgs)
    local newColor = Color3.fromRGB(r, g, b)

    local coloringTween
    = TweensLibrary(
        inst,


        tweensTime,

        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,

        0,
        false,
        0,


        { BackgroundColor3 = newColor }
    )

    return coloringTween
end
--[[ @end_section Tween Functions ]]


--[[
    Remove the default loading screen, set the teleporting gui, and
    preload the experience before removing the custom loading screen.
]]
do
    LoadingGuiComponents.UiComponents.loadingGui.Parent = playerGui

    local loadingGuiClone = LoadingGuiComponents.UiComponents.loadingGui:Clone()

    local HandledUi = UIUtilitiesLibrary(LoadingGuiComponents.UiComponents.loadingGui)
    HandledUi:hoverAndToggleSizing(1.15)

    -- Set loading screen replacements & hide the core gui.
    do
        ReplicatedFirst:RemoveDefaultLoadingScreen()
        TeleportService:SetTeleportGui(loadingGuiClone :: any)

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end

    LoadingGuiComponents.UiComponents.progressBar.Visible = true

    local fullSpin: HandledTween?
    local spinDirection = 0

    -- Spin the logo while waiting via tweens.
    task.spawn(
        function()
            repeat
                if spinDirection == 0 then spinDirection = 360 else spinDirection = 0 end

                fullSpin = spinInst(LoadingGuiComponents.UiComponents.logo, spinDirection);
                (fullSpin :: HandledTween):waitForCompletion()
            until not shouldSpin
        end
    )

    colorInst(LoadingGuiComponents.UiComponents.initialized, LoadingGuiComponents.Settings.InitializedColorArray)
    scaleInst(LoadingGuiComponents.UiComponents.initialized, "up"):waitForCompletion()

    local disappearingSkipBtn: HandledTween?

    -- Allow the player to skip the loading screen after waiting.
    task.spawn(
        function()
            task.wait(timeBeforeSkipAppears)

            if not LoadingGuiComponents.UiComponents.loadingGui or numOfLoadedDescendants == numOfExperienceDescendants then return end

            LoadingGuiComponents.UiComponents.skipBtn.Visible = true

            local alreadySkipped = false

            HandledUi:handleButtonPress(LoadingGuiComponents.UiComponents.skipBtn,
                function(pos1: number, pos2: number)
                    if alreadySkipped then return end

                    numOfLoadedDescendants = numOfExperienceDescendants

                    disappearingSkipBtn = hideInst(LoadingGuiComponents.UiComponents.skipBtn)

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

    -- Animate the progress bar to show that it's loading assets.
    do
        colorInst(LoadingGuiComponents.UiComponents.initialized, LoadingGuiComponents.Settings.ProgressBarUnselectedColor)
        scaleInst(LoadingGuiComponents.UiComponents.initialized, "down")

        scaleInst(LoadingGuiComponents.UiComponents.loading, "up")
        colorInst(LoadingGuiComponents.UiComponents.loading, LoadingGuiComponents.Settings.LoadingColorArray):waitForCompletion()
    end

    -- Preload each important experience descendant.
    for i = 1, numOfExperienceDescendants do
        if numOfLoadedDescendants == numOfExperienceDescendants then break end

        local descendant = ExperienceDescendants[i]
        ContentProvider:PreloadAsync({ descendant })

        numOfLoadedDescendants += 1

        task.wait()
    end

    HandledUi:wipeConnections()

    -- Animate the progress bar to show finishing loading.
    do
        colorInst(LoadingGuiComponents.UiComponents.loading, LoadingGuiComponents.Settings.ProgressBarUnselectedColor)
        scaleInst(LoadingGuiComponents.UiComponents.loading, "down")

        colorInst(LoadingGuiComponents.UiComponents.finished, LoadingGuiComponents.Settings.FinishedColorArray)
        scaleInst(LoadingGuiComponents.UiComponents.finished, "up"):waitForCompletion()
    end

    shouldSpin = false
    if fullSpin then fullSpin:waitForCompletion() end

    --[[
        Hide the background, logo, and spin the logo via tweens.
        Then wait for the tweens to finish.
    ]]
    do
        if spinDirection == 0 then spinDirection = 360 else spinDirection = 0 end

        local disappearingInitialized = hideInst(LoadingGuiComponents.UiComponents.initialized)
        local disappearingLoading = hideInst(LoadingGuiComponents.UiComponents.loading)
        local disappearingFinished = hideInst(LoadingGuiComponents.UiComponents.finished)

        local disappearingBg = hideInst(LoadingGuiComponents.UiComponents.background)
        local disappearingLogo = hideInst(LoadingGuiComponents.UiComponents.logo)

        fullSpin = spinInst(LoadingGuiComponents.UiComponents.logo, spinDirection, true)

        if disappearingSkipBtn then disappearingSkipBtn:waitForCompletion() 
        else hideInst(LoadingGuiComponents.UiComponents.skipBtn):waitForCompletion() end

        disappearingInitialized:waitForCompletion()
        disappearingLoading:waitForCompletion()
        disappearingFinished:waitForCompletion()

        disappearingBg:waitForCompletion()
        disappearingLogo:waitForCompletion()

        fullSpin:waitForCompletion()
    end

    LoadingGuiComponents.UiComponents.loadingGui:Destroy()

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end
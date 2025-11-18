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
        @Version 1.0.0
    ```

    @Description Tween any inputted instance to change any given properties with inputted parameters.
    @Description Will work with all instances that can be tweened (eg. Part, Mesh, Frame, GuiButton etc).

    @Example
    ```luau
        local partInst = Instance.new("Part")
        partInst.Parent = workspace
        partInst.Size = Vector3.new(10, 10, 10)
        partInst.Position = Vector3.new(0, 15, 0)

        TweensLibrary(
            partInst,


            5,

            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,

            0,
            false,
            0,


            {
                Color = Color3.fromRGB(255, 0, 0),
                Transparency = 0.5,
                Size = Vector3.new(5, 5, 5)
            }
        )
    ```
]]
--!strict
--!optimize 2


local TweenService = game:GetService("TweenService")


--[[ @section Variables ]]
local Constructor = {}

local TweensLibrary = {}
--[[ @end_section Variables ]]


--[[ @section Constructor ]]
--[[
    @usage Create a new tween with the given parameters.


    @param instance Instance


    @param time number?

    @param easingStyle Enum.EasingStyle
    @param easingDirection Enum.EasingDirection

    @param repeatCount number
    @param isReversed boolean
    @param repeatDelay number


    @param GoalTable{ [string]: any }
    
    
    @return Tween
]]
function Constructor:__call
(
    instance: Instance,


    time: number?,

    easingStyle: Enum.EasingStyle,
    easingDirection: Enum.EasingDirection,

    repeatCount: number,
    isReversed: boolean,
    repeatDelay: number,


    GoalTable: { [string]: any }
): Tween
    local TweenInfo = TweenInfo.new(time, easingStyle, easingDirection, repeatCount, isReversed, repeatDelay)
    local Tween = TweenService:Create(instance, TweenInfo, GoalTable)

    Tween:Play()

    return Tween
end

setmetatable(TweensLibrary, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


table.freeze(TweensLibrary)
return TweensLibrary
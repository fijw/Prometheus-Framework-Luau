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

    @Description Logging library for outputting errors, information,
    @Description warnings, and critical errors.

    @USAGE_NOTE outputInfo -> Debugging, confirmations, status updates, or messages.
    @USAGE_NOTE outputError -> Functionality cannot continue, didn't work as intended.
    @USAGE_NOTE outputWarning -> Something unexpected happened, but didn't break anything.
    @USAGE_NOTE outputCritical -> The entire framework cannot continue, something critical happened.
]]
--!strict
--!optimize 2


--[[ @section Variables ]]
local Constructor = {}
local Inheritance = {} :: LoggerInheritanceSchema

local Logger = {}
--[[ @end_section Variables ]]


--[[ @section Types ]]
type LoggerInheritanceSchema
= {
    outputInfo: (self: Logger, message: string) -> (),
    outputError: (self: Logger, message: string) -> (),
    outputWarning: (self: Logger, message: string) -> (),
    outputCritical: (self: Logger, message: string) -> ()
}

type Logger = setmetatable
<
    { loggedBy: string },
    { __index: LoggerInheritanceSchema }
>
--[[ @end_section Types ]]


--[[ @section Constructor ]]
--[[
    @usage Creates a new Logger.
    
    @param loggedBy string

    @return Logger
]]
function Constructor:__call(loggedBy: string): Logger
    local NewLogger = { loggedBy = loggedBy } :: Logger
    setmetatable(NewLogger :: Logger, { __index = Inheritance })

    return NewLogger
end

setmetatable(Logger, { __call = Constructor.__call })
--[[ @end_section Constructor ]]


--[[
    @NOTE Section documentation, not function-specific.

        
    @usage Outputs a message for a specific reason.

    @param self Logger
    @param message string

    @return
]]
--[[ @section Inheritance ]]
function Inheritance:outputInfo(message: string)
    print(`[ℹ️ INFO] [{self.loggedBy}]: {message}`)
end

function Inheritance:outputError(message: string)
    print(`[❌ ERROR] [{self.loggedBy}]: {message}`)
end

function Inheritance:outputWarning(message: string)
    print(`[⚠️ WARNING] [{self.loggedBy}]: {message}`)
end

function Inheritance:outputCritical(message: string)
    print(`[🔥 CRITICAL!] [{self.loggedBy}]: {message}`)
end
--[[ @end_section Inheritance ]]


table.freeze(Logger)
return Logger
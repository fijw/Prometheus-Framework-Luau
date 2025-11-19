--!strict
--!optimize 2


--[[ @section Types ]]
export type HandledUISchema
= {
    ScreenGui: ScreenGui,

    SizingConnections: { [any]: RBXScriptConnection },
    PressConnections: { RBXScriptConnection },
    OtherConnections: { RBXScriptConnection }
}

export type HandledUI = setmetatable
<
    HandledUISchema,
    { __index: HandledUIInheritanceSchema }
>

export type HandledUIInheritanceSchema
= {
    hoverAndToggleSizing: (self: HandledUI, sizeIncrease: number) -> (),

    handleButtonPress
    : (
        self: HandledUI,
        button: GuiButton,
        callback: (pos1: number, pos2: number) -> ()
    ) -> (),

    handleGuiObjectInput
    : (
        self: HandledUI,
        action: RBXScriptSignal,
        callback: (pos1: number, pos2: number) -> ()
    ) -> (),

    makeGuiObjectDraggable: (self: HandledUI, guiObjectToDrag: GuiObject, mainGuiObject: GuiObject?) -> (),

    wipeConnections: (self: HandledUI) -> ()
}
--[[ @end_section Types ]]


local ReturningValue = {}


table.freeze(ReturningValue)
return ReturningValue
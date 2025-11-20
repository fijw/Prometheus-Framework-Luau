--!strict
--!optimize 2


--[[ @section Variables ]]
local commandsGuiOpener = Instance.new("ScreenGui")
local showBtn = Instance.new("TextButton")
local uiCorner = Instance.new("UICorner")
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

local CommandsGuiOpenerComponents
= {
    commandsGuiOpener = commandsGuiOpener,
    showBtn = showBtn,
    uiCorner = uiCorner,
    uiAspectRatioConstraint = uiAspectRatioConstraint
}
--[[ @end_section Variables ]]


-- Create the commands gui and its components.
do
    commandsGuiOpener.Name = "CommandsGuiOpener"
    commandsGuiOpener.IgnoreGuiInset = true

    showBtn.Name = "ShowBtn"
    showBtn.Parent = commandsGuiOpener
    showBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    showBtn.BackgroundColor3 = Color3.fromRGB(0, 157, 255)
    showBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    showBtn.BorderSizePixel = 0
    showBtn.Position = UDim2.new(0.983250022, 0, 0.0280000009, 0)
    showBtn.Size = UDim2.new(0.021163078, 0, 0.0361503474, 0)
    showBtn.Font = Enum.Font.SourceSansBold
    showBtn.Text = ">"
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.TextScaled = true
    showBtn.TextSize = 14.000
    showBtn.TextWrapped = true

    uiCorner.Parent = showBtn

    uiAspectRatioConstraint.Parent = showBtn
    uiAspectRatioConstraint.AspectRatio = 1.042
end


table.freeze(CommandsGuiOpenerComponents)
return CommandsGuiOpenerComponents
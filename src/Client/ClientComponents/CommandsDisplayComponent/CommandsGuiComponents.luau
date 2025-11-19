--!strict
--!optimize 2


--[[ @section Variables ]]
local commandsGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local uiCorner = Instance.new("UICorner")
local title = Instance.new("TextLabel")
local commandsScroller = Instance.new("ScrollingFrame")
local uiCorner_2 = Instance.new("UICorner")
local templateCommand = Instance.new("TextLabel")
local uiListLayout = Instance.new("UIListLayout")
local closeBtn = Instance.new("TextButton")
local uiCorner_3 = Instance.new("UICorner")
local credits = Instance.new("TextLabel")
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

local CommandsGuiComponents
= {
    commandsGui = commandsGui,
    mainFrame = mainFrame,
    title = title,
    commandsScroller = commandsScroller,
    templateCommand = templateCommand,
    uiListLayout = uiListLayout,
    closeBtn = closeBtn,
    uiCorner = uiCorner,
    uiCorner_2 = uiCorner_2,
    uiCorner_3 = uiCorner_3,
    credits = credits,
    uiAspectRatioConstraint = uiAspectRatioConstraint
}
--[[ @end_section Variables ]]


-- Create the commands gui and its components.
do
    commandsGui.Name = "CommandsGui"

    mainFrame.Name = "MainFrame"
    mainFrame.Parent = commandsGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.506016791, 0, 0.48070842, 0)
    mainFrame.Size = UDim2.new(0.112033591, 0, 0.301852733, 0)

    uiCorner.CornerRadius = UDim.new(0, 16)
    uiCorner.Parent = mainFrame

    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0325423218, 0, -9.65961107e-08, 0)
    title.Size = UDim2.new(0.721119165, 0, 0.152515709, 0)
    title.Font = Enum.Font.SourceSansBold
    title.Text = "Commands List"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.TextSize = 14.000
    title.TextWrapped = true

    commandsScroller.Name = "CommandsScroller"
    commandsScroller.Parent = mainFrame
    commandsScroller.Active = true
    commandsScroller.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    commandsScroller.BorderColor3 = Color3.fromRGB(0, 0, 0)
    commandsScroller.BorderSizePixel = 0
    commandsScroller.Position = UDim2.new(0.0325426087, 0, 0.151932523, 0)
    commandsScroller.Size = UDim2.new(0.932462811, 0, 0.766217887, 0)
    commandsScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    commandsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

    uiAspectRatioConstraint.Parent = mainFrame
    uiAspectRatioConstraint.AspectRatio = 0.66

    uiCorner_2.CornerRadius = UDim.new(0, 16)
    uiCorner_2.Parent = commandsScroller

    templateCommand.Name = "TemplateCommand"
    templateCommand.Parent = commandsScroller
    templateCommand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    templateCommand.BackgroundTransparency = 1.000
    templateCommand.BorderColor3 = Color3.fromRGB(0, 0, 0)
    templateCommand.BorderSizePixel = 0
    templateCommand.Size = UDim2.new(1, 0, 0.125, 0)
    templateCommand.Font = Enum.Font.SourceSansBold
    templateCommand.Text = "fly {id}"
    templateCommand.Visible = false
    templateCommand.TextColor3 = Color3.fromRGB(255, 255, 255)
    templateCommand.TextScaled = true
    templateCommand.TextSize = 14.000
    templateCommand.TextWrapped = true

    uiListLayout.Parent = commandsScroller
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    closeBtn.Parent = mainFrame
    closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 73)
    closeBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(0.876999974, 0, 0.0799999982, 0)
    closeBtn.Size = UDim2.new(0.168625697, 0, 0.115163065, 0)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.TextSize = 14.000
    closeBtn.TextWrapped = true
    closeBtn.Name = "CloseBtn"

    uiCorner_3.Parent = closeBtn

    credits.Name = "Credits"
    credits.Parent = mainFrame
    credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    credits.BackgroundTransparency = 1.000
    credits.BorderColor3 = Color3.fromRGB(0, 0, 0)
    credits.BorderSizePixel = 0
    credits.Position = UDim2.new(0.0325423218, 0, 0.918150246, 0)
    credits.Size = UDim2.new(0.931999981, 0, 0.0799999982, 0)
    credits.Font = Enum.Font.SourceSansBold
    credits.Text = "Prometheus Framework - by Kairos"
    credits.TextColor3 = Color3.fromRGB(255, 255, 255)
    credits.TextSize = 14.000
end


table.freeze(CommandsGuiComponents)
return CommandsGuiComponents
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
local note1 = Instance.new("TextLabel")
local note2 = Instance.new("TextLabel")
local hideBtn = Instance.new("TextButton")
local uiCorner_4 = Instance.new("UICorner")
local uiCorner_5 = Instance.new("UICorner")
local showBtn = Instance.new("TextButton")
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local uiAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

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
    uiCorner_4 = uiCorner_4,
    uiCorner_5 = uiCorner_5,
    showBtn = showBtn,
    credits = credits,
    note1 = note1,
    note2 = note2,
    hideBtn = hideBtn,
    uiAspectRatioConstraint = uiAspectRatioConstraint,
    uiAspectRatioConstraint_2 = uiAspectRatioConstraint_2
}
--[[ @end_section Variables ]]


-- Create the commands gui and its components.
do
    commandsGui.Name = "CommandsGui"

    mainFrame.Name = "MainFrame"
    mainFrame.Parent = commandsGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.414, 0, 0.281, 0)
    mainFrame.Size = UDim2.new(0.172112212, 0, 0.435944021, 0)

    uiCorner.CornerRadius = UDim.new(0, 16)
    uiCorner.Name = "UICorner"
    uiCorner.Parent = mainFrame

    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0325423107, 0, -6.48780656e-08, 0)
    title.Size = UDim2.new(0.770487607, 0, 0.128863111, 0)
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
    commandsScroller.Position = UDim2.new(0.0325426832, 0, 0.128862947, 0)
    commandsScroller.Size = UDim2.new(0.932462811, 0, 0.789287329, 0)
    commandsScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    commandsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y

    uiCorner_2.CornerRadius = UDim.new(0, 16)
    uiCorner_2.Name = "UICorner"
    uiCorner_2.Parent = commandsScroller

    templateCommand.Name = "TemplateCommand"
    templateCommand.Parent = commandsScroller
    templateCommand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    templateCommand.BackgroundTransparency = 1.000
    templateCommand.BorderColor3 = Color3.fromRGB(0, 0, 0)
    templateCommand.BorderSizePixel = 0
    templateCommand.Size = UDim2.new(0.850000024, 0, 0.125, 0)
    templateCommand.Visible = false
    templateCommand.Font = Enum.Font.SourceSansBold
    templateCommand.Text = "fly {id}"
    templateCommand.TextColor3 = Color3.fromRGB(255, 255, 255)
    templateCommand.TextScaled = true
    templateCommand.TextSize = 14.000
    templateCommand.TextWrapped = true

    hideBtn.Name = "HideBtn"
    hideBtn.Parent = mainFrame
    hideBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    hideBtn.BackgroundColor3 = Color3.fromRGB(0, 157, 255)
    hideBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hideBtn.BorderSizePixel = 0
    hideBtn.Position = UDim2.new(0.0913855657, 0, 0.0639876276, 0)
    hideBtn.Size = UDim2.new(0.121503152, 0, 0.0829806104, 0)
    hideBtn.Font = Enum.Font.SourceSansBold
    hideBtn.Text = "<"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextScaled = true
    hideBtn.TextSize = 14.000
    hideBtn.TextWrapped = true

    uiListLayout.Name = "UIListLayout"
    uiListLayout.Parent = commandsScroller
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    note1.Name = "Note1"
    note1.Parent = commandsScroller
    note1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    note1.BackgroundTransparency = 1.000
    note1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    note1.BorderSizePixel = 0
    note1.LayoutOrder = -2
    note1.Position = UDim2.new(0.0749999508, 0, -2.54019398e-07, 0)
    note1.Size = UDim2.new(0.850000024, 0, 0.250000089, 0)
    note1.Font = Enum.Font.SourceSansBold
    note1.Text = "You can stack commands together by doing: \"{prefix}{command} {args}; {command} {args}; {command} {args}\""
    note1.TextColor3 = Color3.fromRGB(255, 170, 0)
    note1.TextScaled = true
    note1.TextSize = 14.000
    note1.TextWrapped = true

    note2.Name = "Note2"
    note2.Parent = commandsScroller
    note2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    note2.BackgroundTransparency = 1.000
    note2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    note2.BorderSizePixel = 0
    note2.LayoutOrder = -1
    note2.Size = UDim2.new(0.850000024, 0, 0.125, 0)
    note2.Font = Enum.Font.SourceSansBold
    note2.Text = "You can put \"me\" in place of an id to target yourself in an argument."
    note2.TextColor3 = Color3.fromRGB(255, 170, 0)
    note2.TextScaled = true
    note2.TextSize = 14.000
    note2.TextWrapped = true

    closeBtn.Name = "CloseBtn"
    closeBtn.Parent = mainFrame
    closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 73)
    closeBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(0.902387261, 0, 0.0639876202, 0)
    closeBtn.Size = UDim2.new(0.121503152, 0, 0.0829806104, 0)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.TextSize = 14.000
    closeBtn.TextWrapped = true

    uiCorner_3.Name = "UICorner"
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
    credits.TextScaled = true
    credits.TextSize = 14.000
    credits.TextWrapped = true

    uiAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uiAspectRatioConstraint.Parent = mainFrame
    uiAspectRatioConstraint.AspectRatio = 0.703

    uiCorner_4.Parent = hideBtn

    showBtn.Name = "ShowBtn"
    showBtn.Parent = commandsGui
    showBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    showBtn.BackgroundColor3 = Color3.fromRGB(0, 157, 255)
    showBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    showBtn.BorderSizePixel = 0
    showBtn.Position = UDim2.new(0.499548852, 0, 0.0178658776, 0)
    showBtn.Size = UDim2.new(0.021163078, 0, 0.0361503474, 0)
    showBtn.Font = Enum.Font.SourceSansBold
    showBtn.Text = ">"
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.TextScaled = true
    showBtn.TextSize = 14.000
    showBtn.TextWrapped = true

    uiCorner_5.Parent = showBtn

    uiAspectRatioConstraint_2.Parent = showBtn
    uiAspectRatioConstraint_2.AspectRatio = 1.042
end


table.freeze(CommandsGuiComponents)
return CommandsGuiComponents
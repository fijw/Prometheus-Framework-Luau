--!strict
--!optimize 2


--[[ @section Variables ]]
local loadingGui = Instance.new("ScreenGui")
local background = Instance.new("Frame")
local progressTxt = Instance.new("TextLabel")
local logo = Instance.new("ImageLabel")
local logoUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local skipUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local skipBtn = Instance.new("TextButton")

local LoadingGuiComponents
= {
    loadingGui = loadingGui,
    background = background,
    progressTxt = progressTxt,
    logo = logo,
    logoUIAspectRatioConstraint = logoUIAspectRatioConstraint,
    skipUIAspectRatioConstraint = skipUIAspectRatioConstraint,
    skipBtn = skipBtn
}
--[[ @end_section Variables ]]


-- Create the loading gui and its components
do
    loadingGui.Name = "LoadingGui"
    loadingGui.IgnoreGuiInset = true

    background.Name = "Background"
    background.Parent = loadingGui
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    background.BorderColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(1, 0, 1, 0)

    progressTxt.Name = "ProgressTxt"
    progressTxt.Parent = background
    progressTxt.AnchorPoint = Vector2.new(0.5, 0.5)
    progressTxt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressTxt.BackgroundTransparency = 1.000
    progressTxt.BorderColor3 = Color3.fromRGB(0, 0, 0)
    progressTxt.BorderSizePixel = 0
    progressTxt.Position = UDim2.new(0.5, 0, 0.800000012, 0)
    progressTxt.Size = UDim2.new(0.5, 0, 0.075000003, 0)
    progressTxt.Font = Enum.Font.SourceSansBold
    progressTxt.Text = ""
    progressTxt.RichText = true
    progressTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressTxt.TextScaled = true
    progressTxt.TextSize = 14.000
    progressTxt.TextWrapped = true

    logo.Name = "Logo"
    logo.Parent = background
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logo.BackgroundTransparency = 1.000
    logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    logo.BorderSizePixel = 0
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.new(0.208333328, 0, 0.370713621, 0)
    logo.Image = "rbxassetid://128090395462070"

    logoUIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    logoUIAspectRatioConstraint.Parent = logo

    skipBtn.Name = "SkipBtn"
    skipBtn.Parent = background
    skipBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    skipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    skipBtn.BackgroundTransparency = 1.000
    skipBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    skipBtn.BorderSizePixel = 0
    skipBtn.Position = UDim2.new(0.943, 0, 0.92, 0)
    skipBtn.Size = UDim2.new(0.0653579682, 0, 0.075000003, 0)
    skipBtn.Font = Enum.Font.SourceSansBold
    skipBtn.Text = "Skip"
    skipBtn.RichText = true
    skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    skipBtn.TextScaled = true
    skipBtn.TextSize = 14.000
    skipBtn.TextWrapped = true
    skipBtn.Visible = false

    skipUIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    skipUIAspectRatioConstraint.Parent = skipBtn
    skipUIAspectRatioConstraint.AspectRatio = 1.551
end


table.freeze(LoadingGuiComponents)
return LoadingGuiComponents
--!strict
--!optimize 2


--[[ @section Variables ]]
local loadingGui = Instance.new("ScreenGui")
local background = Instance.new("Frame")
local logo = Instance.new("ImageLabel")
local skipBtn = Instance.new("TextButton")
local progressBar = Instance.new("Frame")
local uiListLayout = Instance.new("UIListLayout")
local initialized = Instance.new("Frame")
local loading = Instance.new("Frame")
local finished = Instance.new("Frame")
local uiCorner = Instance.new("UICorner")
local uiCorner_2 = Instance.new("UICorner")
local uiCorner_3 = Instance.new("UICorner")
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local uiAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local uiAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")

local LoadingGuiComponents
= {
    Settings
    = {
        ProgressBarUnselectedColor = { 255, 255, 255 },

        InitializedColorArray = { 255, 0, 0 },
        LoadingColorArray = { 255, 251, 0 },
        FinishedColorArray = { 0, 255, 0 }
    },

    UiComponents
    = {
        loadingGui = loadingGui,
        background = background,
        progressBar = progressBar,
        logo = logo,
        skipBtn = skipBtn,
        uiAspectRatioConstraint = uiAspectRatioConstraint,
        uiAspectRatioConstraint_2 = uiAspectRatioConstraint_2,
        uiAspectRatioConstraint_3 = uiAspectRatioConstraint_3,
        uiListLayout = uiListLayout,
        initialized = initialized,
        loading = loading,
        finished = finished,
        uiCorner = uiCorner,
        uiCorner_2 = uiCorner_2,
        uiCorner_3 = uiCorner_3
    }
}
--[[ @end_section Variables ]]


--[[
    @usage Creates a Color3 object from an RGB array.

    @param ColorArray { number }

    @return Color3
]]
local function colorFromRGBArray(ColorArray: { number }): Color3
    assert(#ColorArray == 3, "Color array must have exactly 3 elements (R, G, B)")

    local r, g, b = table.unpack(ColorArray)
    local color = Color3.fromRGB(r, g, b)

    return color
end


-- Create the loading gui and its components
do
    local unselectedProgressBarColor = colorFromRGBArray(LoadingGuiComponents.Settings.ProgressBarUnselectedColor)

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

    uiAspectRatioConstraint.Parent = logo

    skipBtn.Name = "SkipBtn"
    skipBtn.Parent = background
    skipBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    skipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    skipBtn.BackgroundTransparency = 1.000
    skipBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    skipBtn.BorderSizePixel = 0
    skipBtn.Position = UDim2.new(0.943000019, 0, 0.920000017, 0)
    skipBtn.Size = UDim2.new(0.0653579682, 0, 0.075000003, 0)
    skipBtn.Font = Enum.Font.SourceSansBold
    skipBtn.Text = "Skip"
    skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    skipBtn.TextScaled = true
    skipBtn.TextSize = 14.000
    skipBtn.TextWrapped = true
    skipBtn.Visible = false

    uiAspectRatioConstraint_2.Parent = skipBtn
    uiAspectRatioConstraint_2.AspectRatio = 1.551

    progressBar.Name = "ProgressBar"
    progressBar.Parent = background
    progressBar.AnchorPoint = Vector2.new(0.5, 0.5)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressBar.BackgroundTransparency = 1.000
    progressBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0.499842763, 0, 0.794404685, 0)
    progressBar.Size = UDim2.new(0.498539001, 0, 0.0742780492, 0)
    progressBar.Visible = false

    uiListLayout.Parent = progressBar
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uiListLayout.Padding = UDim.new(0.0150000001, 0)

    initialized.Name = "Initialized"
    initialized.Parent = progressBar
    initialized.BackgroundColor3 = unselectedProgressBarColor
    initialized.BorderColor3 = Color3.fromRGB(0, 0, 0)
    initialized.BorderSizePixel = 0
    initialized.Position = UDim2.new(0.0598998033, 0, 0.337553024, 0)
    initialized.Size = UDim2.new(0.0560000017, 0, 0.662445486, 0)

    uiCorner.CornerRadius = UDim.new(0, 100)
    uiCorner.Parent = initialized

    loading.Name = "Loading"
    loading.Parent = progressBar
    loading.BackgroundColor3 = unselectedProgressBarColor
    loading.BorderColor3 = Color3.fromRGB(0, 0, 0)
    loading.BorderSizePixel = 0
    loading.Position = UDim2.new(0.149308816, 0, 0.337553024, 0)
    loading.Size = UDim2.new(0.0560000017, 0, 0.662445486, 0)

    uiCorner_2.CornerRadius = UDim.new(0, 100)
    uiCorner_2.Parent = loading

    finished.Name = "Finished"
    finished.Parent = progressBar
    finished.BackgroundColor3 = unselectedProgressBarColor
    finished.BorderColor3 = Color3.fromRGB(0, 0, 0)
    finished.BorderSizePixel = 0
    finished.Position = UDim2.new(0.238717884, 0, 0.337553024, 0)
    finished.Size = UDim2.new(0.0560000017, 0, 0.662445486, 0)

    uiCorner_3.CornerRadius = UDim.new(0, 100)
    uiCorner_3.Parent = finished

    uiAspectRatioConstraint_3.Parent = progressBar
    uiAspectRatioConstraint_3.AspectRatio = 11.943
end


table.freeze(LoadingGuiComponents)
return LoadingGuiComponents
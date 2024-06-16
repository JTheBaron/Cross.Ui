-- Cross.lua

local Cross = {}
Cross.__index = Cross

-- Initialization
function Cross.new(title, theme)
    local self = setmetatable({}, Cross)
    
    self.title = title or "Cross Advanced UI"
    self.theme = theme or Cross.Themes.Dark
    
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = self.title
    self.gui.Parent = game.CoreGui

    self.mainFrame = Instance.new("Frame", self.gui)
    self.mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    self.mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    self.mainFrame.BackgroundColor3 = self.theme.BackgroundColor
    self.mainFrame.BorderSizePixel = 0

    self.titleBar = Instance.new("TextLabel", self.mainFrame)
    self.titleBar.Size = UDim2.new(1, 0, 0, 50)
    self.titleBar.BackgroundColor3 = self.theme.TitleBarColor
    self.titleBar.Text = self.title
    self.titleBar.TextColor3 = self.theme.TitleTextColor
    self.titleBar.Font = Enum.Font.SourceSansBold
    self.titleBar.TextSize = 24
    
    self.container = Instance.new("Frame", self.mainFrame)
    self.container.Size = UDim2.new(1, 0, 1, -50)
    self.container.Position = UDim2.new(0, 0, 0, 50)
    self.container.BackgroundTransparency = 1

    self.layout = Instance.new("UIListLayout", self.container)
    self.layout.Padding = UDim.new(0, 10)
    
    return self
end

-- Add Button
function Cross:AddButton(name, callback)
    local button = Instance.new("TextButton", self.container)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = self.theme.ButtonColor
    button.TextColor3 = self.theme.ButtonTextColor
    button.Text = name
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.MouseButton1Click:Connect(callback)
end

-- Add Toggle
function Cross:AddToggle(name, default, callback)
    local frame = Instance.new("Frame", self.container)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.LabelColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 24

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.2, 0, 0.8, 0)
    toggle.Position = UDim2.new(0.8, 0, 0.1, 0)
    toggle.BackgroundColor3 = default and self.theme.ToggleOnColor or self.theme.ToggleOffColor
    toggle.Text = ""
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.BackgroundColor3 = default and self.theme.ToggleOnColor or self.theme.ToggleOffColor
        callback(default)
    end)
end

-- Add Slider
function Cross:AddSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", self.container)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.LabelColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 24

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(0.2, 0, 0.4, 0)
    slider.Position = UDim2.new(0.8, 0, 0.3, 0)
    slider.BackgroundColor3 = self.theme.SliderBackgroundColor
    
    local knob = Instance.new("Frame", slider)
    knob.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    knob.BackgroundColor3 = self.theme.SliderKnobColor
    knob.BorderSizePixel = 0

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function moveKnob(input)
                local position = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                knob.Size = UDim2.new(position, 0, 1, 0)
                local value = min + position * (max - min)
                callback(value)
            end
            
            moveKnob(input)
            local moveConnection = slider.InputChanged:Connect(moveKnob)
            local releaseConnection
            releaseConnection = game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    moveConnection:Disconnect()
                    releaseConnection:Disconnect()
                end
            end)
        end
    end)
end

-- Themes
Cross.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        TitleBarColor = Color3.fromRGB(45, 45, 45),
        TitleTextColor = Color3.fromRGB(255, 255, 255),
        ButtonColor = Color3.fromRGB(55, 55, 55),
        ButtonTextColor = Color3.fromRGB(255, 255, 255),
        LabelColor = Color3.fromRGB(255, 255, 255),
        ToggleOnColor = Color3.fromRGB(0, 255, 0),
        ToggleOffColor = Color3.fromRGB(255, 0, 0),
        SliderBackgroundColor = Color3.fromRGB(45, 45, 45),
        SliderKnobColor = Color3.fromRGB(255, 255, 255)
    }
}

return Cross

-- Cross.lua

local Cross = {}
Cross.__index = Cross

-- Initialization
function Cross.new(title, description, theme)
    local self = setmetatable({}, Cross)
    
    self.title = title or "Cross Advanced UI"
    self.description = description or "Description"
    self.theme = theme or Cross.Themes.Dark
    
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = self.title
    self.gui.Parent = game.CoreGui

    self.mainFrame = Instance.new("Frame", self.gui)
    self.mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    self.mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    self.mainFrame.BackgroundColor3 = self.theme.BackgroundColor
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Active = true
    self.mainFrame.Draggable = true
    self.mainFrame.ClipsDescendants = true
    
    local uicorner = Instance.new("UICorner", self.mainFrame)
    uicorner.CornerRadius = UDim.new(0, 12)
    
    self.titleBar = Instance.new("TextLabel", self.mainFrame)
    self.titleBar.Size = UDim2.new(1, 0, 0, 50)
    self.titleBar.BackgroundColor3 = self.theme.TitleBarColor
    self.titleBar.Text = self.title
    self.titleBar.TextColor3 = self.theme.TitleTextColor
    self.titleBar.Font = Enum.Font.SourceSansBold
    self.titleBar.TextSize = 24
    self.titleBar.TextXAlignment = Enum.TextXAlignment.Left
    self.titleBar.Padding = UDim.new(0, 10)
    local titlePadding = Instance.new("UIPadding", self.titleBar)
    titlePadding.PaddingLeft = UDim.new(0, 10)

    self.descriptionLabel = Instance.new("TextLabel", self.mainFrame)
    self.descriptionLabel.Size = UDim2.new(1, 0, 0, 30)
    self.descriptionLabel.Position = UDim2.new(0, 0, 0, 50)
    self.descriptionLabel.BackgroundTransparency = 1
    self.descriptionLabel.Text = self.description
    self.descriptionLabel.TextColor3 = self.theme.DescriptionTextColor
    self.descriptionLabel.Font = Enum.Font.SourceSans
    self.descriptionLabel.TextSize = 18
    self.descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    local descPadding = Instance.new("UIPadding", self.descriptionLabel)
    descPadding.PaddingLeft = UDim.new(0, 10)

    self.tabContainer = Instance.new("Frame", self.mainFrame)
    self.tabContainer.Size = UDim2.new(0.2, 0, 1, -80)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 80)
    self.tabContainer.BackgroundTransparency = 1

    self.tabLayout = Instance.new("UIListLayout", self.tabContainer)
    self.tabLayout.Padding = UDim.new(0, 10)

    self.contentContainer = Instance.new("Frame", self.mainFrame)
    self.contentContainer.Size = UDim2.new(0.8, 0, 1, -80)
    self.contentContainer.Position = UDim2.new(0.2, 0, 0, 80)
    self.contentContainer.BackgroundTransparency = 1
    self.contentContainer.ClipsDescendants = true
    
    self.tabs = {}
    self.currentTab = nil
    
    return self
end

-- Create a new tab
function Cross:CreateTab(name)
    local tab = {}

    local button = Instance.new("TextButton", self.tabContainer)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = self.theme.TabButtonColor
    button.TextColor3 = self.theme.TabButtonTextColor
    button.Text = name
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.ClipsDescendants = true
    
    local uicorner = Instance.new("UICorner", button)
    uicorner.CornerRadius = UDim.new(0, 8)

    local container = Instance.new("Frame", self.contentContainer)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false

    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)

    tab.button = button
    tab.container = container
    tab.layout = layout

    table.insert(self.tabs, tab)

    button.MouseButton1Click:Connect(function()
        if self.currentTab then
            self.currentTab.container.Visible = false
        end
        tab.container.Visible = true
        self.currentTab = tab
    end)

    if #self.tabs == 1 then
        tab.container.Visible = true
        self.currentTab = tab
    end

    return tab
end

-- Add Button
function Cross:AddButton(tab, name, callback)
    local button = Instance.new("TextButton", tab.container)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = self.theme.ButtonColor
    button.TextColor3 = self.theme.ButtonTextColor
    button.Text = name
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.MouseButton1Click:Connect(callback)
    
    local uicorner = Instance.new("UICorner", button)
    uicorner.CornerRadius = UDim.new(0, 8)
end

-- Add Toggle
function Cross:AddToggle(tab, name, default, callback)
    local frame = Instance.new("Frame", tab.container)
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
    
    local uicorner = Instance.new("UICorner", toggle)
    uicorner.CornerRadius = UDim.new(0, 8)
end

-- Add Textbox
function Cross:AddTextbox(tab, name, callback)
    local frame = Instance.new("Frame", tab.container)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = self.theme.LabelColor
    label.Font = Enum.Font.SourceSans
    label.TextSize = 24

    local textbox = Instance.new("TextBox", frame)
    textbox.Size = UDim2.new(0.7, 0, 0.8, 0)
    textbox.Position = UDim2.new(0.3, 0, 0.1, 0)
    textbox.BackgroundColor3 = self.theme.TextboxColor
    textbox.TextColor3 = self.theme.TextboxTextColor
    textbox.Text = ""
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 24
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
        end
    end)
    
    local uicorner = Instance.new("UICorner", textbox)
    uicorner.CornerRadius = UDim.new(0, 8)
end

-- Themes
Cross.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        TitleBarColor = Color3.fromRGB(45, 45, 45),
        TitleTextColor = Color3.fromRGB(255, 255, 255),
        DescriptionTextColor = Color3.fromRGB(200, 200, 200),
        ButtonColor = Color3.fromRGB(55, 55, 55),
        ButtonTextColor = Color3.fromRGB(255, 255, 255),
        LabelColor = Color3.fromRGB(255, 255, 255),
        ToggleOnColor = Color3.fromRGB(0, 255, 0),
        ToggleOffColor = Color3.fromRGB(255, 0, 0),
        TextboxColor = Color3.fromRGB(45, 45, 45),
        TextboxTextColor = Color3.fromRGB(255, 255, 255),
        TabButtonColor = Color3.fromRGB(50, 50, 50),
        TabButtonTextColor = Color3.fromRGB(255, 255, 255)
    }
}

return Cross

local CrossUI = {}

local function createSmoothFrame(parent, size, position, color)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    return frame
end

function CrossUI:CreateLib(title, theme)
    local Library = {}
    Library.title = title
    Library.theme = theme or "Ghibli"
    Library.tabs = {}

    -- Theme Colors
    local themes = {
        Ghibli = {Primary = Color3.fromRGB(139, 69, 19), Secondary = Color3.fromRGB(210, 180, 140)},
        Soap = {Primary = Color3.fromRGB(173, 216, 230), Secondary = Color3.fromRGB(0, 0, 139)}
    }

    local selectedTheme = themes[Library.theme]

    -- Create the main window frame
    Library.mainFrame = createSmoothFrame(game.Players.LocalPlayer:WaitForChild("PlayerGui"), UDim2.new(0, 600, 0, 400), UDim2.new(0.5, -300, 0.5, -200), selectedTheme.Primary)

    -- Create the title bar
    local titleBar = createSmoothFrame(Library.mainFrame, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), selectedTheme.Secondary)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = title
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = titleBar

    -- Draggable functionality
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Library.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Library.mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Tab creation function
    function Library:NewTab(tabName)
        local Tab = {}
        Tab.sections = {}

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 0, 50)
        tabButton.Text = tabName
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = selectedTheme.Secondary
        tabButton.Parent = Library.mainFrame

        function Tab:NewSection(sectionName)
            local Section = {}
            Section.elements = {}

            local sectionFrame = createSmoothFrame(Library.mainFrame, UDim2.new(1, -20, 0, 100), UDim2.new(0, 10, 0, 60), selectedTheme.Secondary)

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.Text = sectionName
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextScaled = true
            sectionLabel.Font = Enum.Font.SourceSans
            sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.Parent = sectionFrame

            function Section:NewLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 30)
                label.Text = text
                label.BackgroundTransparency = 1
                label.TextScaled = true
                label.Font = Enum.Font.SourceSans
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.Parent = sectionFrame
                table.insert(Section.elements, label)
            end

            function Section:NewButton(text, info, callback)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 30)
                button.Text = text
                button.TextScaled = true
                button.Font = Enum.Font.SourceSans
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                button.MouseButton1Click:Connect(callback)
                button.Parent = sectionFrame
                table.insert(Section.elements, button)
            end

            function Section:NewToggle(text, info, callback)
                local toggle = {}
                toggle.state = false

                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(1, 0, 0, 30)
                toggleButton.Text = text
                toggleButton.TextScaled = true
                toggleButton.Font = Enum.Font.SourceSans
                toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                toggleButton.MouseButton1Click:Connect(function()
                    toggle.state = not toggle.state
                    toggleButton.BackgroundColor3 = toggle.state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    callback(toggle.state)
                end)
                toggleButton.Parent = sectionFrame
                table.insert(Section.elements, toggleButton)
            end

            function Section:NewTextbox(text, info, callback)
                local textbox = Instance.new("TextBox")
                textbox.Size = UDim2.new(1, 0, 0, 30)
                textbox.Text = text
                textbox.TextScaled = true
                textbox.Font = Enum.Font.SourceSans
                textbox.TextColor3 = Color3.fromRGB(0, 0, 0)
                textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        callback(textbox.Text)
                    end
                end)
                textbox.Parent = sectionFrame
                table.insert(Section.elements, textbox)
            end

            table.insert(Tab.sections, Section)
            return Section
        end

        table.insert(Library.tabs, Tab)
        return Tab
    end

    return Library
end

return CrossUI

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Создание GUI
local screenGui = Instance.new("ScreenGui", CoreGui)
local frame = Instance.new("Frame", screenGui)
local closeButton = Instance.new("TextButton", frame)
local savePointButton = Instance.new("TextButton", frame)
local teleportButton = Instance.new("TextButton", frame)
local comeBackButton = Instance.new("TextButton", frame)
local textBox = Instance.new("TextBox", frame)

screenGui.Name = "GotoGUI"
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)  -- Темно-серый цвет
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

closeButton.Size = UDim2.new(0, 50, 0, 25)
closeButton.Position = UDim2.new(1, -55, 0, 5)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)  -- Темный красный
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BorderSizePixel = 0

textBox.Size = UDim2.new(0, 260, 0, 50)
textBox.Position = UDim2.new(0.5, -130, 0, 40)
textBox.PlaceholderText = "Enter Player Name"
textBox.Text = ""
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)

local buttonWidth = 260
local buttonHeight = 30
local buttonSpacing = 10

savePointButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
savePointButton.Position = UDim2.new(0.5, -buttonWidth / 2, 0, 100)
savePointButton.Text = "Save Point"
savePointButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Темно-серый
savePointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
savePointButton.BorderSizePixel = 0

teleportButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
teleportButton.Position = UDim2.new(0.5, -buttonWidth / 2, 0, 100 + buttonHeight + buttonSpacing)
teleportButton.Text = "Teleport"
teleportButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Темно-серый
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.BorderSizePixel = 0

comeBackButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
comeBackButton.Position = UDim2.new(0.5, -buttonWidth / 2, 0, 100 + 2 * (buttonHeight + buttonSpacing))
comeBackButton.Text = "Come Back"
comeBackButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Темно-серый
comeBackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
comeBackButton.BorderSizePixel = 0

-- Переменные для хранения позиции игрока
local savedPosition

-- Функция сохранения текущей позиции
local function savePoint()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.Position
    end
end

-- Функция телепортации к игроку
local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Телепортируемся к игроку
            character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- Функция возврата на сохраненную позицию
local function comeBack()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and savedPosition then
        character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
    end
end

-- Обработка кнопки закрытия
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Обработка кнопки сохранения точки
savePointButton.MouseButton1Click:Connect(function()
    savePoint()
end)

-- Обработка кнопки телепортации
teleportButton.MouseButton1Click:Connect(function()
    local playerName = textBox.Text
    teleportToPlayer(playerName)
end)

-- Обработка кнопки возврата
comeBackButton.MouseButton1Click:Connect(function()
    comeBack()
end)

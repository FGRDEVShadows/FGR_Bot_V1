local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local targetPlayer = nil
local following = false

-- Создание GUI элементов
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FollowGui"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 30)
textBox.Position = UDim2.new(0.5, -100, 0.2, -15)
textBox.PlaceholderText = "Enter player name"
textBox.Parent = frame

local followButton = Instance.new("TextButton")
followButton.Size = UDim2.new(0, 90, 0, 30)
followButton.Position = UDim2.new(0.3, -45, 0.5, -15)
followButton.Text = "Follow"
followButton.Parent = frame

local unfollowButton = Instance.new("TextButton")
unfollowButton.Size = UDim2.new(0, 90, 0, 30)
unfollowButton.Position = UDim2.new(0.7, -45, 0.5, -15)
unfollowButton.Text = "Unfollow"
unfollowButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.Parent = frame

-- Закрытие фрейма
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Функция для следования за игроком
local function followTarget()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid:MoveTo(targetPosition)
        end
    end
end

-- Обработка нажатия кнопки Follow
followButton.MouseButton1Click:Connect(function()
    local targetName = textBox.Text
    if targetName ~= "" then
        targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer then
            following = true
            print("Следую за " .. targetPlayer.Name)
        else
            print("Игрок " .. targetName .. " не найден.")
        end
    end
end)

-- Обработка нажатия кнопки Unfollow
unfollowButton.MouseButton1Click:Connect(function()
    following = false
    targetPlayer = nil
    print("Прекратил следование.")
end)

-- Запуск функции следования
RunService.RenderStepped:Connect(function()
    if following then
        followTarget()
    end
end)

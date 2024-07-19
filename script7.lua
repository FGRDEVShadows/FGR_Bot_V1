-- Переменные
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera

local flying = false
local speed = 50
local bodyVelocity
local bodyGyro
local direction = Vector3.zero
local humanoid

-- Функция для установки позы "T"
local function setPoseT()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Устанавливаем позу "T"
    humanoid:LoadAnimation(script:WaitForChild("PoseTAnimation")):Play()
end

-- Функция для обновления скорости и направления полета
local function updateFlying()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Создаем BodyVelocity для управления движением
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    end
    
    -- Создаем BodyGyro для стабилизации
    if not bodyGyro then
        bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.CFrame = humanoidRootPart.CFrame
    end

    -- Обновляем скорость и направление полета
    bodyVelocity.Velocity = direction * speed

    -- Устанавливаем CFrame для стабилизации
    bodyGyro.CFrame = Camera.CFrame
end

local function startFlying()
    flying = true
    setPoseT()
    updateFlying()
end

local function stopFlying()
    flying = false
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyVelocity = humanoidRootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end
            
            local bodyGyro = humanoidRootPart:FindFirstChildOfClass("BodyGyro")
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
end

-- Обработка ввода
local function onInputChanged(input, gameProcessed)
    if gameProcessed then return end
    if flying then
        local cameraLookVector = Camera.CFrame.LookVector
        local cameraRightVector = Camera.CFrame.RightVector
        local cameraUpVector = Camera.CFrame.UpVector
        
        if input.KeyCode == Enum.KeyCode.W then
            direction = direction + cameraLookVector
        elseif input.KeyCode == Enum.KeyCode.S then
            direction = direction - cameraLookVector
        elseif input.KeyCode == Enum.KeyCode.A then
            direction = direction - cameraRightVector
        elseif input.KeyCode == Enum.KeyCode.D then
            direction = direction + cameraRightVector
        elseif input.KeyCode == Enum.KeyCode.E then
            direction = direction + cameraUpVector
        elseif input.KeyCode == Enum.KeyCode.Q then
            direction = direction - cameraUpVector
        end
        -- Обновляем скорость и направление полета
        updateFlying()
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    if flying and (input.KeyCode == Enum.KeyCode.W or
                   input.KeyCode == Enum.KeyCode.S or
                   input.KeyCode == Enum.KeyCode.A or
                   input.KeyCode == Enum.KeyCode.D or
                   input.KeyCode == Enum.KeyCode.E or
                   input.KeyCode == Enum.KeyCode.Q) then
        -- Устанавливаем скорость в ноль, если клавиша отпущена
        direction = Vector3.zero
        -- Обновляем скорость и направление полета
        updateFlying()
    end
end

-- Обработка ввода
UIS.InputBegan:Connect(onInputChanged)
UIS.InputEnded:Connect(onInputEnded)

-- Создание GUI
local screenGui = Instance.new("ScreenGui", CoreGui)
local frame = Instance.new("Frame", screenGui)
local closeButton = Instance.new("TextButton", frame)
local flyButton = Instance.new("TextButton", frame)
local unflyButton = Instance.new("TextButton", frame)
local textBox = Instance.new("TextBox", frame)

screenGui.Name = "FlyGUI"
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
frame.Active = true
frame.Draggable = true

closeButton.Size = UDim2.new(0, 50, 0, 25)
closeButton.Position = UDim2.new(1, -55, 0, 5)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0.5, -110, 1, -60)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

unflyButton.Size = UDim2.new(0, 100, 0, 50)
unflyButton.Position = UDim2.new(0.5, 10, 1, -60)
unflyButton.Text = "Unfly"
unflyButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

textBox.Size = UDim2.new(0, 200, 0, 50)
textBox.Position = UDim2.new(0.5, -100, 0.5, -25)
textBox.PlaceholderText = "Enter Speed"
textBox.Text = ""
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Обработка кнопок
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

flyButton.MouseButton1Click:Connect(function()
    flying = true
    speed = tonumber(textBox.Text) or speed
    startFlying()
end)

unflyButton.MouseButton1Click:Connect(function()
    flying = false
    stopFlying()
end)

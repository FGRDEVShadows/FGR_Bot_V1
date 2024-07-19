local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Переменные для хранения состояния
local savedPosition = nil
local originalCameraPosition = nil
local cameraFollowConnection = nil

-- Функция поиска игрока по части имени
local function findPlayerByName(namePart)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(namePart:lower()) then
            return player
        end
    end
    return nil
end

-- Функция отправки сообщения в чат
local function SendChatMessage(message, color)
    local ChatService = game:GetService("Chat")
    local success, err = pcall(function()
        ChatService:Chat(Players.LocalPlayer.Character.HumanoidRootPart, message, color)
    end)
    
    if not success then
        warn("Failed to send chat message: " .. err)
    end
end

-- Функция сохранения текущей позиции
local function savePoint()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.Position
        SendChatMessage("Save point set.", Enum.ChatColor.Green)
    end
end

-- Функция возврата на сохраненную позицию
local function comeBack()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and savedPosition then
        character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        SendChatMessage("Returned to saved position.", Enum.ChatColor.Green)
    end
end

-- Функция следования за игроком
local function followPlayer(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Создаем цикл следования
        RunService.RenderStepped:Connect(function()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end)
        SendChatMessage("Now following " .. targetPlayer.Name, Enum.ChatColor.Green)
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция прекращения следования
local function unfollowPlayer()
    SendChatMessage("Stopped following.", Enum.ChatColor.Green)
end

-- Функция сброса здоровья
local function reset()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
        SendChatMessage("You have been reset.", Enum.ChatColor.Green)
    end
end

-- Функция отслеживания игрока (перемещение камеры)
local function trackPlayerCamera(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Сохраняем исходное положение камеры
        if not originalCameraPosition then
            originalCameraPosition = Workspace.CurrentCamera.CFrame
        end
        
        -- Функция для обновления позиции камеры
        local function updateCamera()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                -- Перемещаем камеру к целевой позиции с небольшим смещением
                Workspace.CurrentCamera.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, -10), targetPosition)
            end
        end

        -- Подключаем функцию обновления камеры к RenderStepped
        cameraFollowConnection = RunService.RenderStepped:Connect(updateCamera)
        SendChatMessage("Tracking camera to " .. targetPlayer.Name, Enum.ChatColor.Green)
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция переноса камеры обратно к исходному положению
local function untrackCamera()
    if originalCameraPosition then
        Workspace.CurrentCamera.CFrame = originalCameraPosition
        originalCameraPosition = nil
        if cameraFollowConnection then
            cameraFollowConnection:Disconnect()
            cameraFollowConnection = nil
        end
        SendChatMessage("Stopped tracking camera and returned to original position.", Enum.ChatColor.Green)
    end
end

-- Функция выкидывания игрока
local function flingPlayer(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        
        if targetRootPart then
            -- Телепортируем локального игрока к указанному игроку
            local localCharacter = Players.LocalPlayer.Character
            local localRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
            if localRootPart then
                localRootPart.CFrame = targetRootPart.CFrame
            end
            
            -- Создаем BodyGyro для сильного вращения
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.CFrame = targetRootPart.CFrame
            bodyGyro.P = 10000
            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyGyro.Parent = targetRootPart

            -- Создаем BodyVelocity для выкидывания
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(math.random(-500, 500), 500, math.random(-500, 500)) -- Случайное направление
            bodyVelocity.P = 10000
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = targetRootPart
            
            -- Сохраняем объекты для последующего удаления
            game:GetService("Debris"):AddItem(bodyGyro, 0.5)
            game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            
            SendChatMessage("Flinged " .. targetPlayer.Name, Enum.ChatColor.Green)
        end
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция отмены выкидывания
local function unflingPlayer(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Удаляем все BodyGyro и BodyVelocity объекты, связанные с игроком
        for _, bodyGyro in ipairs(targetPlayer.Character:GetChildren()) do
            if bodyGyro:IsA("BodyGyro") then
                bodyGyro:Destroy()
            end
        end

        for _, bodyVelocity in ipairs(targetPlayer.Character:GetChildren()) do
            if bodyVelocity:IsA("BodyVelocity") then
                bodyVelocity:Destroy()
            end
        end
        
        SendChatMessage("Unflinged " .. targetPlayer.Name, Enum.ChatColor.Green)
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция отображения доступных команд
local function displayHelp()
    local helpMessage = "Available commands:\n" ..
    "f.savepoint - Saves the current position.\n" ..
    "f.comeback - Returns to the saved position.\n" ..
    "f.follow [playerName] - Makes you follow the specified player.\n" ..
    "f.unfollow - Stops following the player.\n" ..
    "f.reset - Resets your health to 0.\n" ..
    "f.track [playerName] - Moves the camera to the specified player and follows them.\n" ..
    "f.untrack - Moves the camera back to its original position.\n" ..
    "f.fling [playerName] - Teleports you to the specified player and flings them.\n" ..
    "f.unfling [playerName] - Stops flinging the specified player.\n" ..
    "f.help - Displays this help message."
    SendChatMessage(helpMessage, Enum.ChatColor.Blue)
end

-- Обработка команд в чате
local function onChatMessage(message)
    local args = message:split(" ")
    local command = args[1]:lower()

    if command == "f.savepoint" then
        savePoint()
    elseif command == "f.comeback" then
        comeBack()
    elseif command == "f.follow" then
        followPlayer(args[2])
    elseif command == "f.unfollow" then
        unfollowPlayer()
    elseif command == "f.reset" then
        reset()
    elseif command == "f.track" then
        trackPlayerCamera(args[2])
    elseif command == "f.untrack" then
        untrackCamera()
    elseif command == "f.fling" then
        flingPlayer(args[2])
    elseif command == "f.unfling" then
        unflingPlayer(args[2])
    elseif command == "f.help" then
        displayHelp()
    end
end

-- Подключение функции обработки сообщений к событию чата
Players.LocalPlayer.Chatted:Connect(onChatMessage)

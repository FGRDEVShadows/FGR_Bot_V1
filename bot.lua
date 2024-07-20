
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

-- Переменные для хранения состояния
local savedPosition = nil
local originalCameraCFrame = nil
local cameraFollowConnection = nil
local flying = false
local flyVelocity = 50 -- Скорость полета
local standing = false -- Переменная для отслеживания состояния стояния
local attachMotor = nil
local targetPlayerName = nil
local controlledPlayer = nil -- Игрок, управление которым взято на себя
local originalControl = nil -- Оригинальное управление
local islandPart = nil -- Переменная для хранения острова
local isOnIsland = false -- Переменная для отслеживания нахождения на острове
local afkConnection = nil -- Переменная для хранения подключения к событию

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
        savedPosition = character.HumanoidRootPart.CFrame -- Сохраняем CFrame для точности
        SendChatMessage("Save point set.", Enum.ChatColor.Green)
    end
end

-- Функция возврата на сохраненную позицию
local function comeBack()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and savedPosition then
        character.HumanoidRootPart.CFrame = savedPosition
        SendChatMessage("Returned to saved position.", Enum.ChatColor.Green)
    end
end

-- Функция телепортации к игроку
local function teleportToPlayer(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Телепортируем локального игрока к целевому игроку
            character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            SendChatMessage("Teleported to " .. targetPlayer.Name, Enum.ChatColor.Green)
        end
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция создания острова
local function createIsland()
    if not islandPart then
        islandPart = Instance.new("Part")
        islandPart.Size = Vector3.new(1000, 10, 1000) -- Размер острова
        islandPart.Position = Vector3.new(5000, -50, 5000) -- Позиция острова за пределами карты
        islandPart.Anchored = true
        islandPart.Parent = Workspace
        SendChatMessage("Island created. Teleporting in 2 seconds...", Enum.ChatColor.Green)

        -- Задержка перед телепортацией
        wait(2)

        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = islandPart.CFrame + Vector3.new(0, 10, 0) -- Телепортируем игрока на остров
            isOnIsland = true
        end
    else
        SendChatMessage("An island already exists.", Enum.ChatColor.Red)
    end
end

-- Функция удаления острова
local function removeIsland()
    if islandPart then
        islandPart:Destroy()
        islandPart = nil
        isOnIsland = false
        SendChatMessage("Island removed and teleported back to the map.", Enum.ChatColor.Green)

        -- Телепортируем игрока обратно на сохраненную позицию или исходную позицию
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            if savedPosition then
                character.HumanoidRootPart.CFrame = savedPosition
            else
                -- Если сохраненная позиция отсутствует, можно телепортировать игрока на стандартную позицию
                character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            end
        end
    else
        SendChatMessage("No island exists to remove.", Enum.ChatColor.Red)
    end
end

-- Функция установки скорости
local function setSpeed(value)
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
        SendChatMessage("Speed set to " .. value, Enum.ChatColor.Green)
    end
end

-- Функция установки силы прыжка
local function setJumpPower(value)
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
        SendChatMessage("Jump power set to " .. value, Enum.ChatColor.Green)
    end
end

-- Функция включения отслеживания
local function enableTracking()
    -- Логика включения отслеживания
    SendChatMessage("Tracking enabled.", Enum.ChatColor.Green)
end

-- Функция отключения отслеживания
local function disableTracking()
    -- Логика отключения отслеживания
    SendChatMessage("Tracking disabled.", Enum.ChatColor.Green)
end

-- Функция контроля игрока
local function controlPlayer(playerNamePart)
    local targetPlayer = findPlayerByName(playerNamePart)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        -- Отключаем следование, если оно включено
        if cameraFollowConnection then
            cameraFollowConnection:Disconnect()
            cameraFollowConnection = nil
        end
        
        -- Сохраняем оригинальное управление
        if originalControl then
            originalControl:Destroy()
            originalControl = nil
        end

        -- Переносим камеру на целевого игрока
        originalCameraCFrame = Workspace.CurrentCamera.CFrame
        local function updateCamera()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
                Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        end
        cameraFollowConnection = RunService.RenderStepped:Connect(updateCamera)
        
        -- Управление игроком
        local localCharacter = Players.LocalPlayer.Character
        if localCharacter and localCharacter:FindFirstChild("Humanoid") then
            originalControl = localCharacter.Humanoid:GetState() -- Сохраняем текущее состояние управления
            localCharacter.Humanoid.PlatformStand = true -- Переключаемся в режим PlatformStand для контроля
        end
        
        controlledPlayer = targetPlayer
        SendChatMessage("Now controlling " .. targetPlayer.Name, Enum.ChatColor.Green)
    else
        SendChatMessage("Player not found or character not available.", Enum.ChatColor.Red)
    end
end

-- Функция отмены контроля
local function uncontrolPlayer()
    if controlledPlayer then
        -- Восстанавливаем камеру и управление
        if cameraFollowConnection then
            cameraFollowConnection:Disconnect()
            cameraFollowConnection = nil
        end
        if originalCameraCFrame then
            Workspace.CurrentCamera.CFrame = originalCameraCFrame
            originalCameraCFrame = nil
        end
        Workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        
        if controlledPlayer and controlledPlayer.Character and controlledPlayer.Character:FindFirstChild("Humanoid") then
            local localCharacter = Players.LocalPlayer.Character
            if localCharacter and localCharacter:FindFirstChild("Humanoid") then
                localCharacter.Humanoid.PlatformStand = false -- Восстанавливаем управление
            end
        end

        controlledPlayer = nil
        SendChatMessage("Stopped controlling player.", Enum.ChatColor.Green)
    else
        SendChatMessage("No player is currently being controlled.", Enum.ChatColor.Red)
    end
end

-- Функция включения AFK режима
local function setAFK()
    if not afkConnection then
        afkConnection = RunService.Heartbeat:Connect(function()
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                wait(0.1) -- Задержка для предотвращения слишком частого изменения состояния
                character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        SendChatMessage("AFK mode activated. Player will not be kicked out due to inactivity.", Enum.ChatColor.Green)
    else
        SendChatMessage("AFK mode is already active.", Enum.ChatColor.Red)
    end
end

-- Функция отключения AFK режима
local function unsetAFK()
    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
        SendChatMessage("AFK mode deactivated.", Enum.ChatColor.Green)
    else
        SendChatMessage("AFK mode is not active.", Enum.ChatColor.Red)
    end
end

-- Функция обработки команд
local function executeCommand(command)
    local args = command:split(" ")
    local cmd = args[1]:lower()

    if cmd == "f.savepoint" then
        savePoint()
    elseif cmd == "f.comeback" then
        comeBack()
    elseif cmd == "f.tp" then
        teleportToPlayer(args[2])
    elseif cmd == "f.speed" then
        setSpeed(tonumber(args[2]))
    elseif cmd == "f.jump" then
        setJumpPower(tonumber(args[2]))
    elseif cmd == "f.look" then
        enableTracking()
    elseif cmd == "f.unlook" then
        disableTracking()
    elseif cmd == "f.follow" then
        followPlayer(args[2])
    elseif cmd == "f.unfollow" then
        unfollowPlayer()
    elseif cmd == "f.reset" then
        reset()
    elseif cmd == "f.bang" then
        -- Логика постоянного телепорта
    elseif cmd == "f.unbang" then
        -- Логика отключения постоянного телепорта
    elseif cmd == "f.island" then
        createIsland()
    elseif cmd == "f.back" then
        removeIsland()
    elseif cmd == "f.control" then
        controlPlayer(args[2])
    elseif cmd == "f.uncontrol" then
        uncontrolPlayer()
    elseif cmd == "f.afk" then
        setAFK()
    elseif cmd == "f.unafk" then
        unsetAFK()
    elseif cmd == "f.help" then
        displayHelp()
    else
        SendChatMessage("Unknown command. Type 'f.help' for a list of commands.", Enum.ChatColor.Red)
    end
end

-- Обработчик команд в чате
Players.LocalPlayer.Chatted:Connect(function(message)
    executeCommand(message)
end)

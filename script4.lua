-- Ссылка на сервисы
local Players = game:GetService("Players")

-- Обработчик команды /goto
local function onChatMessage(message)
    local prefix = "/goto"
    -- Проверка, содержит ли сообщение команду /goto
    local commandStart, targetName = message:find("^%s*"..prefix.." %s*(.+)%s*$")
    
    if targetName then
        -- Найти целевого игрока по никнейму
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localPlayer = Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Телепортировать локального игрока к целевому игроку
                localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            else
                warn("Ошибка: HumanoidRootPart не найден в персонаже локального игрока.")
            end
        else
            -- Показать сообщение об ошибке в чате
            localPlayer:SendNotification({Title = "Ошибка", Text = "Игрок с таким никнеймом не найден."})
        end
    end
end

-- Подключаем обработчик к событию чата
local function setupChatHandler()
    local localPlayer = Players.LocalPlayer

    if not localPlayer then
        warn("Ошибка: LocalPlayer не найден.")
        return
    end

    if not localPlayer:FindFirstChildOfClass("PlayerScripts") then
        warn("Ошибка: PlayerScripts не найден.")
        return
    end

    -- Получаем модуль чата
    local chatModule = require(localPlayer:FindFirstChildOfClass("PlayerScripts"):WaitForChild("ChatModule"))

    if chatModule and chatModule.OnChatMessage then
        chatModule.OnChatMessage:Connect(onChatMessage)
    else
        warn("Ошибка: ChatModule не найден или не содержит OnChatMessage.")
    end
end

-- Выполняем настройку
setupChatHandler()

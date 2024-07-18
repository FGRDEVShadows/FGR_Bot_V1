-- Ссылка на сервисы
local Players = game:GetService("Players")
local ChatService = require(game:GetService("Chat"))

-- Проверка и создание модуля для хранения команд
local function createChatModule()
    local playerScripts = game:GetService("StarterPlayer"):FindFirstChildOfClass("PlayerScripts")
    if not playerScripts then
        playerScripts = Instance.new("Folder")
        playerScripts.Name = "PlayerScripts"
        playerScripts.Parent = game:GetService("StarterPlayer")
    end
    
    local chatModule = playerScripts:FindFirstChild("ChatModule")
    if not chatModule then
        chatModule = Instance.new("ModuleScript")
        chatModule.Name = "ChatModule"
        chatModule.Parent = playerScripts

        -- Вставляем код в модуль чата
        chatModule.Source = [[
            local module = {}

            -- Объявляем событие для получения сообщений чата
            local chatEvent = Instance.new("BindableEvent")
            module.OnChatMessage = chatEvent.Event

            function module:ConnectChat(callback)
                chatEvent.Event:Connect(callback)
            end

            return module
        ]]
    end

    return chatModule
end

-- Обработчик команд чата
local function onChatMessage(message)
    local prefix = "/goto"
    -- Проверяем, содержит ли сообщение команду /goto
    if message:sub(1, #prefix) == prefix then
        local targetName = message:sub(#prefix + 2):match("^%s*(.-)%s*$") -- Получаем никнейм из команды
        if targetName and targetName ~= "" then
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
end

-- Настройка обработчика чата
local function setupChatHandler()
    local localPlayer = Players.LocalPlayer

    if not localPlayer then
        warn("Ошибка: LocalPlayer не найден.")
        return
    end

    -- Создаем или получаем модуль чата
    local chatModule = createChatModule()

    -- Подключаемся к обработчику чата
    local chatService = require(chatModule)
    chatService:ConnectChat(onChatMessage)

    -- Подключаемся к событию получения сообщений чата
    ChatService.OnMessageReceived:Connect(function(message, sender)
        if sender == localPlayer then
            onChatMessage(message)
        end
    end)
end

-- Выполняем настройку
setupChatHandler()

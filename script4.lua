-- Ссылка на сервисы
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаем или получаем модуль чата
local function createChatModule()
    local playerScripts = StarterPlayer:FindFirstChildOfClass("PlayerScripts")
    if not playerScripts then
        playerScripts = Instance.new("Folder")
        playerScripts.Name = "PlayerScripts"
        playerScripts.Parent = StarterPlayer
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

-- Создаем объект для хранения команд в ReplicatedStorage
local function createChatCommandsFolder()
    local chatCommandsFolder = ReplicatedStorage:FindFirstChild("ChatCommands")
    if not chatCommandsFolder then
        chatCommandsFolder = Instance.new("Folder")
        chatCommandsFolder.Name = "ChatCommands"
        chatCommandsFolder.Parent = ReplicatedStorage
    end
    return chatCommandsFolder
end

-- Проверка и настройка модулей
local function setupChatModule()
    -- Создаем или получаем модуль чата
    local chatModule = createChatModule()
    local chatService = require(chatModule)

    -- Подключаемся к обработчику сообщений чата
    chatService:ConnectChat(onChatMessage)
end

-- Обработчик команд чата
local function onChatMessage(message, sender)
    local prefix = "/goto"
    -- Проверка, содержит ли сообщение команду /goto
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

-- Основная функция для настройки
local function initialize()
    -- Создаем необходимые объекты
    createChatCommandsFolder()
    setupChatModule()
end

-- Выполняем инициализацию
initialize()

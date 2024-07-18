-- Получаем игрока
local player = game.Players.LocalPlayer

-- Список доступных команд
local commands = {
    ["f.goto"] = "Телепортирует к игроку с указанным ником.",
    ["f.size"] = "Изменяет размер игрока. Пример: f.size 5",
    ["f.help"] = "Показывает список доступных команд."
}

-- Функция для отправки сообщения
local function SendMessage(message)
    -- Проверяем, что игрок существует и что сообщение не пустое
    if player and message then
        -- Создаем объект DefaultChatSystemChatEvents, если он не существует
        local ChatEvents = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if not ChatEvents then
            ChatEvents = Instance.new("Folder")
            ChatEvents.Name = "DefaultChatSystemChatEvents"
            ChatEvents.Parent = game.ReplicatedStorage
            
            -- Создаем событие SayMessageRequest
            local SayMessageRequest = Instance.new("RemoteEvent")
            SayMessageRequest.Name = "SayMessageRequest"
            SayMessageRequest.Parent = ChatEvents
        else
            -- Проверяем существование события SayMessageRequest в объекте ChatEvents
            local SayMessageRequest = ChatEvents:FindFirstChild("SayMessageRequest")
            if not SayMessageRequest then
                SayMessageRequest = Instance.new("RemoteEvent")
                SayMessageRequest.Name = "SayMessageRequest"
                SayMessageRequest.Parent = ChatEvents
            end
        end

        -- Отправляем сообщение в чат от имени игрока
        local SayMessageRequest = ChatEvents:FindFirstChild("SayMessageRequest")
        if SayMessageRequest then
            local success, err = pcall(function()
                SayMessageRequest:FireServer(message, "All")
            end)
            if success then
                print("Сообщение отправлено успешно: " .. message)
            else
                print("Ошибка при отправке сообщения:", err)
            end
        else
            print("Ошибка: событие SayMessageRequest не найдено.")
        end
    else
        print("Ошибка: игрок не найден или сообщение пустое.")
    end
end

-- Функция для обработки команд
local function ProcessCommand(command)
    if command == "f.help" then
        local helpMessage = "Доступные команды:\n"
        for cmd, desc in pairs(commands) do
            helpMessage = helpMessage .. cmd .. " - " .. desc .. "\n"
        end
        SendMessage(helpMessage)
    else
        SendMessage("Неизвестная команда.")
    end
end

-- Обработчик сообщений чата
local function onChatMessage(message)
    local commandPrefix = "f."
    -- Проверяем, начинается ли сообщение с командного префикса
    if message:sub(1, #commandPrefix) == commandPrefix then
        local command = message:sub(#commandPrefix + 1):lower()
        ProcessCommand(command)
    end
end

-- Настройка обработчика сообщений чата
local function setupChatModule()
    -- Создаем или получаем модуль чата
    local chatModule = game.ReplicatedStorage:FindFirstChild("ChatModule")
    if not chatModule then
        chatModule = Instance.new("ModuleScript")
        chatModule.Name = "ChatModule"
        chatModule.Parent = game.ReplicatedStorage

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

    local chatService = require(chatModule)
    chatService:ConnectChat(onChatMessage)
end

-- Основная функция для настройки
local function initialize()
    -- Настраиваем обработчик чата
    setupChatModule()
end

-- Выполняем инициализацию
initialize()

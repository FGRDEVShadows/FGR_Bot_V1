-- Получаем игрока
local player = game.Players.LocalPlayer

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
local function ProcessCommand(command, args)
    if command == "f.goto" then
        local targetName = args:match("^%s*(.-)%s*$")
        if targetName and targetName ~= "" then
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    SendMessage("Телепортирован к игроку: " .. targetName)
                else
                    print("Ошибка: HumanoidRootPart не найден в персонаже локального игрока.")
                end
            else
                SendMessage("Игрок с таким ником не найден.")
            end
        end
    elseif command == "f.size" then
        local size = tonumber(args)
        if size and size > 0 then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                -- Применяем изменение размера, если доступно
                player.Character.Humanoid.BodySize = size
                SendMessage("Размер игрока установлен на: " .. size)
            else
                print("Ошибка: Humanoid не найден в персонаже локального игрока.")
            end
        else
            SendMessage("Некорректный размер.")
        end
    elseif command == "f.help" then
        local helpMessage = "Доступные команды:\n"
        helpMessage = helpMessage .. "f.goto <ник> - Телепортирует к игроку с указанным ником.\n"
        helpMessage = helpMessage .. "f.size <размер> - Изменяет размер игрока. Пример: f.size 5\n"
        helpMessage = helpMessage .. "f.help - Показывает список доступных команд."
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
        local command, args = message:match("^f%.([%w_]+)%s*(.*)")
        if command then
            command = "f." .. command:lower() -- Префикс "f." для команд
            ProcessCommand(command, args)
        end
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

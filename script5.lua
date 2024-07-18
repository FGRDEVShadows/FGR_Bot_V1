-- Получаем игрока
local player = game.Players.LocalPlayer

-- Функция для отправки сообщения и создания ивентов при необходимости
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
        end

        -- Проверяем существование события SayMessageRequest в объекте ChatEvents
        local SayMessageRequest = ChatEvents:FindFirstChild("SayMessageRequest")
        if not SayMessageRequest then
            SayMessageRequest = Instance.new("RemoteEvent")
            SayMessageRequest.Name = "SayMessageRequest"
            SayMessageRequest.Parent = ChatEvents
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

-- Функция для периодической отправки сообщения
local function StartMessageLoop()
    while true do
        SendMessage("{FGR_Bot_V1}") -- Изменено сообщение
        wait(15) -- Ждем 15 секунд перед отправкой следующего сообщения
    end
end

-- Запускаем функцию в новом потоке
spawn(StartMessageLoop)

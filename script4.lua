-- Ссылка на сервисы
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Список доступных команд
local commands = {
    ["/goto"] = "Телепортирует к игроку с указанным ником.",
    ["/size"] = "Изменяет размер игрока. Пример: /size 5",
    ["/help"] = "Показывает список доступных команд."
}

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

-- Функция для отправки сообщения в чат
local function sendChatMessage(player, message)
    local chatService = require(game:GetService("Chat"))
    chatService:Chat(player.Character.HumanoidRootPart, message, Enum.ChatColor.Blue)
end

-- Обработчик команд чата
local function onChatMessage(message, sender)
    local commandPrefix = "/"
    -- Проверяем, начинается ли сообщение с командного префикса
    if message:sub(1, #commandPrefix) == commandPrefix then
        local command, args = message:match("^/([%w_]+)%s*(.*)")
        if command then
            command = "/" .. command:lower() -- Префикс "/" для команд

            -- Обрабатываем команды
            if command == "/goto" then
                local targetName = args:match("^%s*(.-)%s*$")
                if targetName and targetName ~= "" then
                    local targetPlayer = Players:FindFirstChild(targetName)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local localPlayer = Players.LocalPlayer
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                        else
                            warn("Ошибка: HumanoidRootPart не найден в персонаже локального игрока.")
                        end
                    else
                        sendChatMessage(sender, "Игрок с таким никнеймом не найден.")
                    end
                end
            elseif command == "/size" then
                local size = tonumber(args)
                if size and size > 0 then
                    local localPlayer = Players.LocalPlayer
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
                        -- Измените это свойство на подходящее для вашего использования
                        localPlayer.Character.Humanoid.BodySize = size
                    else
                        warn("Ошибка: Humanoid не найден в персонаже локального игрока.")
                    end
                else
                    sendChatMessage(sender, "Некорректный размер.")
                end
            elseif command == "/help" then
                local helpMessage = "Доступные команды:\n"
                for cmd, desc in pairs(commands) do
                    helpMessage = helpMessage .. cmd .. " - " .. desc .. "\n"
                end
                sendChatMessage(sender, helpMessage)
            else
                sendChatMessage(sender, "Неизвестная команда.")
            end
        end
    end
end

-- Настройка обработчика команд чата
local function setupChatModule()
    -- Создаем или получаем модуль чата
    local chatModule = createChatModule()
    local chatService = require(chatModule)

    -- Подключаемся к обработчику сообщений чата
    chatService:ConnectChat(onChatMessage)
end

-- Основная функция для настройки
local function initialize()
    -- Создаем необходимые объекты
    createChatCommandsFolder()
    setupChatModule()
end

-- Выполняем инициализацию
initialize()

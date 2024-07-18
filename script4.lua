-- Скрипт для загрузки и настройки HD Admin
local function loadHDAdmin()
    -- Проверяем, существует ли модуль HD Admin в ReplicatedStorage
    local hdAdminModule = game.ReplicatedStorage:FindFirstChild("HDAdmin")
    if not hdAdminModule then
        -- Если модуль HD Admin не найден, загружаем его из внешнего источника
        local sourceUrl = "https://www.robloxlibrary.com/path/to/HDAdminModule" -- Замените на реальный URL
        local httpService = game:GetService("HttpService")
        
        local success, response = pcall(function()
            return httpService:GetAsync(sourceUrl)
        end)
        
        if success then
            -- Создаем новый модуль и вставляем в него загруженный код
            hdAdminModule = Instance.new("ModuleScript")
            hdAdminModule.Name = "HDAdmin"
            hdAdminModule.Source = response
            hdAdminModule.Parent = game.ReplicatedStorage
        else
            warn("Не удалось загрузить HD Admin: " .. response)
            return
        end
    end

    -- Подключаем модуль HD Admin
    local hdAdmin = require(hdAdminModule)
    if hdAdmin and hdAdmin.Load then
        hdAdmin:Load() -- Загружаем HD Admin
    else
        warn("Модуль HD Admin не содержит функцию Load.")
    end
end

-- Вызов функции для загрузки HD Admin
loadHDAdmin()

-- Убедитесь, что все игроки могут использовать команды
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    -- Отправляем игроку информацию о командах
    local function sendMessageToPlayer(player, message)
        local ChatService = game:GetService("Chat")
        ChatService:Chat(player.Character.Head, message, Enum.ChatColor.Blue)
    end

    sendMessageToPlayer(player, "Добро пожаловать! Все команды HD Admin доступны для использования.")
end)

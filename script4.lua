-- Ссылка на сервисы
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

-- Проверяем наличие и создаем объект для хранения команд
local ChatCommands = ReplicatedStorage:FindFirstChild("ChatCommands")
if not ChatCommands then
    ChatCommands = Instance.new("Folder")
    ChatCommands.Name = "ChatCommands"
    ChatCommands.Parent = ReplicatedStorage
end

-- Создаем модуль чата, если его нет
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
            local ChatService = require(game:GetService("Chat"))

            local module = {}

            function module:ConnectChat(callback)
                ChatService.OnMessageReceived:Connect(callback)
            end

            return module
        ]]
    end

    return chatModule
end

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

    -- Создаем или получаем модуль чата
    local chatModule = createChatModule()

    -- Подключаемся к обработчику чата
    local chatService = require(chatModule)
    chatService:ConnectChat(onChatMessage)
end

-- Выполняем настройку
setupChatHandler()

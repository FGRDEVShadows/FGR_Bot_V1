-- Ссылка на сервисы
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Проверяем наличие и создаем объект для хранения команд
local ChatCommands = ReplicatedStorage:FindFirstChild("ChatCommands")
if not ChatCommands then
    ChatCommands = Instance.new("Folder")
    ChatCommands.Name = "ChatCommands"
    ChatCommands.Parent = ReplicatedStorage
end

-- Обработчик команды f.goto
local function onChatMessage(message)
    local prefix = "/goto"
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

    local chatModule = require(localPlayer:FindFirstChildOfClass("PlayerScripts"):WaitForChild("ChatModule"))

    if chatModule and chatModule.OnChatMessage then
        chatModule.OnChatMessage:Connect(onChatMessage)
    else
        warn("Ошибка: ChatModule не найден или не содержит OnChatMessage.")
    end
end

-- Выполняем настройку
setupChatHandler()

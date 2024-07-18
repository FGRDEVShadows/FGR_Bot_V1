-- Убедитесь, что этот скрипт выполняется на стороне клиента (LocalScript)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ChatService = require(game:GetService("Chat"))

-- Функция для обработки команд
local function onChatMessage(message, speaker)
    -- Проверка, что сообщение отправлено локальным игроком
    if speaker == LocalPlayer then
        -- Проверка на команду и формат
        local command, ownerName = message:match("^f%.owner%s+(.+)$")
        if command then
            _G.Config.BotOwnerName = ownerName
            print("BotOwnerName изменен на: " .. ownerName)
        end

        -- Обработка команды /help
        if message:lower() == "/help" then
            local playerName = LocalPlayer.Name
            local isOwner = (playerName == _G.Config.BotOwnerName)
            local isWhitelisted = false

            for _, whitelistedName in ipairs(_G.Config.WhiteList) do
                if playerName == whitelistedName then
                    isWhitelisted = true
                    break
                end
            end

            if isOwner or isWhitelisted then
                ChatService:Chat(LocalPlayer.Character.Head, "What do you want to know?", Enum.ChatColor.Blue)
            end
        end
    end
end

-- Подключение обработчика сообщений чата
LocalPlayer.Chatted:Connect(onChatMessage)

-- Инициализация конфигурации
_G.Config = {
    BotOwnerName = LocalPlayer.Name,
    BotOwnerId = 0, -- Замените на реальный ID, если необходимо
    FPSCap = 20,
    Prefix = "f",  -- Префикс установлен на "f"
    WhiteListPermLevel = 2,
    WhiteList = {"crater_robloxq2", "crater_robloxq", "Пример3"},
    HideCoords = Vector3.new(math.random(1, 1000), 100000, math.random(1, 1000)),
    AntiAFK = true,
    AntiFling = true,
    NoRender = true,
    IsRagdollGame = true,
    GiveToolsMethod = 1,
}




loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/Script2.lua"))()

wait(1)

loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/script3.lua"))()

wait(1)

loadstring(game:HttpGet(""))()





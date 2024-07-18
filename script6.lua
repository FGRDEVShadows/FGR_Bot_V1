-- Получаем службу Chat
local ChatService = game:GetService("Chat")

-- Создаем RemoteEvent для обработки команд
local spinEvent = Instance.new("RemoteEvent")
spinEvent.Name = "SpinEvent"
spinEvent.Parent = game.ReplicatedStorage

-- Функция для обработки команд
local function onCommandReceived(player, command)
    if command:lower() == "spin" then
        -- Найти модель игрока и вращать HumanoidRootPart
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
                local spinSpeed = 50
                while player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                    wait(0)
                end
            end
        end
    elseif command:lower() == "unspin" then
        -- Прекратить вращение (остановить на стороне сервера можно сложнее)
        print("Остановка вращения.")
    end
end

-- Подключаем обработчик команд
spinEvent.OnServerEvent:Connect(onCommandReceived)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function onChatMessage(message)
    local prefix = "f.goto"
    if message:sub(1, #prefix) == prefix then
        local targetName = message:sub(#prefix + 2):match("^%s*(.-)%s*$") -- Получаем никнейм из команды
        if targetName and targetName ~= "" then
            -- Найти целевого игрока по никнейму
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Телепортировать локального игрока к целевому игроку
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            else
                -- Показать сообщение об ошибке в чате
                LocalPlayer:SendNotification({Title = "Ошибка", Text = "Игрок с таким никнеймом не найден."})
            end
        end
    end
end

-- Подключаем обработчик к событию чата
Players.LocalPlayer.Chatted:Connect(onChatMessage)

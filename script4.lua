-- Обработчик команды f.goto <никнейм>
local function onChatMessage(message, player)
    local prefix = "f.goto"
    if message:sub(1, #prefix) == prefix then
        local targetName = message:sub(#prefix + 2):match("^%s*(.-)%s*$") -- Получаем никнейм из команды
        if targetName and targetName ~= "" then
            -- Найти целевого игрока по никнейму
            local targetPlayer = game:GetService("Players"):FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local localPlayer = game:GetService("Players").LocalPlayer
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Телепортировать локального игрока к целевому игроку
                    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            else
                player:SendNotification({Title = "Ошибка", Text = "Игрок с таким никнеймом не найден."})
            end
        end
    end
end

-- Подключаем обработчик к событию чата
game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("ChatModule").OnChatMessage:Connect(onChatMessage)

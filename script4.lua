-- Скрипт для назначения самого высокого статуса игроку при присоединении

local Players = game:GetService("Players")
local HDAdmin = require(game.ReplicatedStorage:WaitForChild("HDAdmin"))

-- Убедитесь, что HD Admin загружен и содержит функцию SetRank
assert(HDAdmin and HDAdmin.SetRank, "HD Admin не загружен или не содержит функцию SetRank.")

local function setHighestStatusForPlayer(player)
    -- Определите самый высокий статус
    local highestRank = "Owner" -- Замените на статус, который вы хотите назначить

    -- Устанавливаем статус игроку
    local success, err = pcall(function()
        HDAdmin:SetRank(player.UserId, highestRank)
    end)

    if success then
        print("Статус игрока " .. player.Name .. " установлен на " .. highestRank)
    else
        warn("Ошибка при установке статуса для игрока " .. player.Name .. ": " .. err)
    end
end

-- Обработчик события PlayerAdded
Players.PlayerAdded:Connect(function(player)
    -- Даем время HD Admin для полной загрузки (если нужно)
    wait(5) -- Подождите немного, если HD Admin требует времени для загрузки
    setHighestStatusForPlayer(player)
end)

-- Получаем игрока
local player = game.Players.LocalPlayer

-- Функция для установки статуса игрока в HD Admin
local function setHighestStatusForPlayer()
    -- Получаем модуль HD Admin
    local hdAdminModule = game.ReplicatedStorage:FindFirstChild("HDAdmin")
    if not hdAdminModule then
        warn("Модуль HD Admin не найден в ReplicatedStorage.")
        return
    end

    -- Загружаем HD Admin
    local hdAdmin = require(hdAdminModule)

    -- Убедитесь, что модуль HD Admin загружен
    if not hdAdmin or not hdAdmin.SetRank then
        warn("Функция SetRank не найдена в HD Admin.")
        return
    end

    -- Определите самый высокий статус, который хотите назначить
    local highestRank = "Owner" -- или другой самый высокий статус, который вы настроили

    -- Устанавливаем статус игроку
    local success, err = pcall(function()
        hdAdmin:SetRank(player.UserId, highestRank)
    end)

    if success then
        print("Статус игрока " .. player.Name .. " установлен на " .. highestRank)
    else
        warn("Ошибка при установке статуса: " .. err)
    end
end

-- Вызов функции установки статуса
setHighestStatusForPlayer()

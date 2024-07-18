-- Функция для загрузки модуля с командами HD Admin
local function loadHDAdmin()
    -- Проверяем, существует ли HD Admin в ReplicatedStorage
    local hdAdminModule = game.ReplicatedStorage:FindFirstChild("HDAdmin")
    if not hdAdminModule then
        -- Если нет, загружаем модуль HD Admin из его исходного местоположения
        local sourceUrl = "https://www.robloxlibrary.com/path/to/HDAdminModule" -- Замените на реальный URL или путь
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

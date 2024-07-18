-- Получаем локального игрока
local player = game.Players.LocalPlayer

-- Создаем CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = "CoreGui"
gui.Parent = game.CoreGui

-- Создаем фрейм, который будет закрывать весь экран
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 36) -- Размеры равны размерам экрана + 36 пикселей (для полного покрытия)
frame.Position = UDim2.new(0, 0, 0, -36) -- Позиция в левом верхнем углу с отрицательным отступом
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13) -- Цвет фона RGB
frame.BorderSizePixel = 0 -- Убираем границу
frame.Parent = gui

-- Функция для создания TextLabel с улучшенным стилем
local function createTextLabel(parent, text, position)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.102, 0, 0.048, 0) -- Размеры TextLabel
    label.Position = position
    label.BackgroundColor3 = Color3.fromRGB(132, 1, 3)
    label.TextColor3 = Color3.fromRGB(56, 0, 1)
    label.TextSize = 20 -- Устанавливаем размер текста 20
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.BorderSizePixel = 0 -- Убираем обводку
    label.BackgroundTransparency = 0.3 -- Прозрачность фона
    label.TextStrokeTransparency = 0.2 -- Прозрачность подсветки текста
    label.TextStrokeColor3 = Color3.fromRGB(255, 5, 9) -- Цвет подсветки текста
    label.Parent = parent

    return label
end

-- Добавляем TextLabels на фрейм с указанными позициями и стилями
createTextLabel(frame, "Button 1", UDim2.new(0.361, 0, 0.307, 0))
createTextLabel(frame, "Button 2", UDim2.new(0.537, 0, 0.307, 0))
createTextLabel(frame, "Button 3", UDim2.new(0.361, 0, 0.475, 0))
createTextLabel(frame, "/unlook", UDim2.new(0.537, 0, 0.651, 0)) -- Измененный текст для Button 4
createTextLabel(frame, "Button 5", UDim2.new(0.537, 0, 0.475, 0))
createTextLabel(frame, "Button 6", UDim2.new(0.36, 0, 0.651, 0))
createTextLabel(frame, "Button 7", UDim2.new(0.537, 0, 0.124, 0))
createTextLabel(frame, "Button 8", UDim2.new(0.361, 0, 0.124, 0))

-- Добавляем TextLabel для названия справа
local fgrLabel = createTextLabel(frame, "{FGR Bot V1}", UDim2.new(0.439, 0, 0.023, 0))

-- Устанавливаем размеры для FGR BOT V1
fgrLabel.Size = UDim2.new(0.122, 0, 0.058, 0)

-- Прозрачность фона для FGR BOT V1
fgrLabel.BackgroundTransparency = 0.3

return gui -- Возвращаем gui для дальнейшего использования

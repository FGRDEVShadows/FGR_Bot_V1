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
frame.BackgroundTransperency = 0.1
frame.Parent = gui

-- Функция для создания теневого эффекта под TextLabel
local function createTextLabelWithShadow(parent, text, position)
    -- Создаем тень
    local shadow = Instance.new("TextLabel")
    shadow.Text = text
    shadow.Size = UDim2.new(0.102, 0, 0.048, 0) -- Размеры TextLabel
    shadow.Position = UDim2.new(position.X.Scale, position.X.Offset + 2, position.Y.Scale, position.Y.Offset + 2) -- Смещение для создания тени
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    shadow.TextSize = 20
    shadow.Font = Enum.Font.SourceSansBold
    shadow.TextXAlignment = Enum.TextXAlignment.Center
    shadow.TextYAlignment = Enum.TextYAlignment.Center
    shadow.BorderSizePixel = 0
    shadow.BackgroundTransparency = 1 -- Полностью прозрачный фон
    shadow.TextTransparency = 0.5 -- Прозрачность текста
    shadow.ZIndex = 1 -- Устанавливаем ZIndex на 1, чтобы тень была под текстом
    shadow.Parent = parent

    -- Создаем основной TextLabel
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
    label.ZIndex = 2 -- Устанавливаем ZIndex на 2
    label.Parent = parent

    return label
end

-- Добавляем TextLabels на фрейм с указанными позициями и стилями
createTextLabelWithShadow(frame, "Button 1", UDim2.new(0.361, 0, 0.307, 0))
createTextLabelWithShadow(frame, "Button 2", UDim2.new(0.537, 0, 0.307, 0))
createTextLabelWithShadow(frame, "Button 3", UDim2.new(0.361, 0, 0.475, 0))
createTextLabelWithShadow(frame, "/unlook", UDim2.new(0.537, 0, 0.651, 0)) -- Измененный текст для Button 4
createTextLabelWithShadow(frame, "Button 5", UDim2.new(0.537, 0, 0.475, 0))
createTextLabelWithShadow(frame, "Button 6", UDim2.new(0.36, 0, 0.651, 0))
createTextLabelWithShadow(frame, "Button 7", UDim2.new(0.537, 0, 0.124, 0))
createTextLabelWithShadow(frame, "Button 8", UDim2.new(0.361, 0, 0.124, 0))

-- Добавляем TextLabel для названия справа
local fgrLabel = createTextLabelWithShadow(frame, "{FGR Bot V1}", UDim2.new(0.439, 0, 0.023, 0))

-- Устанавливаем размеры для FGR BOT V1
fgrLabel.Size = UDim2.new(0.122, 0, 0.058, 0)

-- Прозрачность фона для FGR BOT V1
fgrLabel.BackgroundTransparency = 0.3

return gui -- Возвращаем gui для дальнейшего использования

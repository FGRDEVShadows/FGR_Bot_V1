-- LocalScript

local player = game.Players.LocalPlayer

-- Функция для включения Anti-Fling
local function enableAntiFling()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(
        0,   -- Плотность
        0,   -- Трение
        0    -- Упругость
    )
end

-- Функция для включения Anti-Ragdoll
local function enableAntiRagdoll()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
end

-- Функция для выключения Anti-Fling
local function disableAntiFling()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(
            1,   -- Плотность
            0.5, -- Трение
            0.5  -- Упругость
        )
    end
end

-- Функция для выключения Anti-Ragdoll
local function disableAntiRagdoll()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end
end

-- Автоматическое включение Anti-Fling и Anti-Ragdoll при спауне персонажа
player.CharacterAdded:Connect(function(character)
    -- Дождаться добавления необходимых частей
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Включить Anti-Fling и Anti-Ragdoll
    enableAntiFling()
    enableAntiRagdoll()
end)

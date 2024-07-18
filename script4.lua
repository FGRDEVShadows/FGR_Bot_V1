-- Получаем игрока
local player = game.Players.LocalPlayer

-- Расширенный список случайных фактов, приколов и мемов
local randomMessages = {
    "Did you know that elephants can't jump?",
    "Cats can jump up to 6 times their height!",
    "On average, a person spends 6 months of their life on the toilet.",
    "Elephants have the most teeth of any mammal!",
    "The human nose can distinguish about 1 trillion different scents!",
    "Ducks can't look up to the sky!",
    "Bears can sleep for up to 7 months a year.",
    "The most expensive pizza in the world costs $12,000!",
    "In Australia, there is a place called 'Forget-Me-Not'.",
    "The fastest bird on Earth is the peregrine falcon, which can reach speeds of up to 200 mph!",
    "Starfish can regenerate lost limbs.",
    "If you could survive drinking the entire ocean, you would find not only treasures at the bottom but also very strange creatures!",
    "The meme 'Village Lost' became popular thanks to the eponymous game where the village constantly disappears on the screen.",
    "The phrase 'lol' first appeared in 1989 in an internet message.",
    "A real meme: 'Do It', also known as the 'Do It' meme.",
    "The famous meme 'Distracted Boyfriend' appeared in 2015 and went viral.",
    "A real meme: 'Nyan Cat', popular in 2011.",
    "In 2015, the meme 'Pepe the Frog' became widely spread on the internet.",
    "The 'Mocking SpongeBob' meme depicts SpongeBob making fun of something.",
    "The song 'Baby Shark' originally appeared in 2015 and quickly went viral.",
    "The image 'I Hate This Meme' was used as a meme to express dissatisfaction.",
    "Memes about 'Turbo' became popular after the release of the eponymous movie in 2013.",
    "The phrase 'OK Boomer' was used to express disdain for the older generation.",
    "The 'This Is Fine' meme became famous thanks to comics by K.C. Green.",
    "The image of 'Mr. Wera's Cat' was used to create memes about grumpy cats.",
    "The 'Rolling Image' meme is often used for comedic situations.",
    "The 'It's Just a Meme' meme became popular after the release of comedy shows and movies.",
    "The 'Internet Problems' meme is often used to express issues with internet connection."
}

-- Переменная для хранения последнего выбранного сообщения
local lastMessage = nil

-- Переменная для хранения времени последнего использования команды
local lastCommandTime = 0

-- Функция для отправки сообщения и создания ивентов при необходимости
local function SendMessage(message)
    -- Проверяем, что игрок существует и что сообщение не пустое
    if player and message then
        -- Создаем объект DefaultChatSystemChatEvents, если он не существует
        local ChatEvents = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if not ChatEvents then
            ChatEvents = Instance.new("Folder")
            ChatEvents.Name = "DefaultChatSystemChatEvents"
            ChatEvents.Parent = game.ReplicatedStorage
            
            -- Создаем событие SayMessageRequest
            local SayMessageRequest = Instance.new("RemoteEvent")
            SayMessageRequest.Name = "SayMessageRequest"
            SayMessageRequest.Parent = ChatEvents
        else
            -- Проверяем существование события SayMessageRequest в объекте ChatEvents
            local SayMessageRequest = ChatEvents:FindFirstChild("SayMessageRequest")
            if not SayMessageRequest then
                SayMessageRequest = Instance.new("RemoteEvent")
                SayMessageRequest.Name = "SayMessageRequest"
                SayMessageRequest.Parent = ChatEvents
            end
        end

        -- Отправляем сообщение в чат от имени игрока
        local SayMessageRequest = ChatEvents:FindFirstChild("SayMessageRequest")
        if SayMessageRequest then
            local success, err = pcall(function()
                SayMessageRequest:FireServer(message, "All")
            end)
            if success then
                print("Message sent successfully: " .. message)
            else
                print("Error sending message:", err)
            end
        else
            print("Error: SayMessageRequest event not found.")
        end
    else
        print("Error: player not found or message is empty.")
    end
end

-- Функция для обработки команд в чате
local function onChatted(message)
    -- Проверяем, что сообщение начинается с "random"
    if message:lower():sub(1, 6) == "random" then
        -- Получаем текущее время
        local currentTime = tick()
        
        -- Проверяем, что прошло достаточно времени с последнего использования команды
        if currentTime - lastCommandTime >= 2 then
            -- Выбираем случайное сообщение из списка, отличное от последнего
            local availableMessages = {}
            for _, msg in ipairs(randomMessages) do
                if msg ~= lastMessage then
                    table.insert(availableMessages, msg)
                end
            end
            
            -- Если все сообщения уже были использованы, сбрасываем список
            if #availableMessages == 0 then
                availableMessages = randomMessages
            end
            
            -- Выбираем случайное сообщение из доступных
            local randomMessage = availableMessages[math.random(1, #availableMessages)]
            -- Отправляем сообщение
            SendMessage(randomMessage)
            -- Обновляем последний выбранный сообщение
            lastMessage = randomMessage
            -- Обновляем время последнего использования команды
            lastCommandTime = currentTime
            print("Message sent: " .. randomMessage)
        else
            print("Please wait before using the command again.")
        end
    end
end

-- Удаляем существующие обработчики и добавляем новый
player.Chatted:Connect(onChatted)

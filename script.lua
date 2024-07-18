_G.Config = {
    BotOwnerName = "crater_robloxq2", -- Имя владельца бота
    BotOwnerId = 0, -- Замените на реальный ID, если необходимо
    FPSCap = 20,
    Prefix = "f",  -- Префикс установлен на "f"
    WhiteListPermLevel = 2,
    WhiteList = {"crater_robloxq2", "crater_robloxq", "Пример3"}, -- Список белых игроков
    HideCoords = Vector3.new(math.random(1, 1000), 100000, math.random(1, 1000)),
    AntiAFK = true,
    AntiFling = true,
    NoRender = true,
    IsRagdollGame = true,
    GiveToolsMethod = 1,
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/Script2.lua"))()

wait(1)

loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/script3.lua"))()

wait(1)

loadstring(game:HttpGet(""))()

wait(1)





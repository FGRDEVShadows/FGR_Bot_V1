_G.Config = {
    BotOwnerName = game.Players.LocalPlayer.Name,
    BotOwnerId = 0, -- Замените на реальный ID, если необходимо
    FPSCap = 20,
    Prefix = "f",
    WhiteListPermLevel = 2,
    WhiteList = {"Пример1", "Пример2", "Пример3"},
    HideCoords = Vector3.new(math.random(1, 1000), 100000, math.random(1, 1000)),
    AntiAFK = true,
    AntiFling = true,
    NoRender = true,
    IsRagdollGame = true,
    GiveToolsMethod = 1,
}


loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/Script2.lua"))()

wait(1)



wait(1)





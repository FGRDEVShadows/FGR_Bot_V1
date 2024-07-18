_G.Config = {
    BotOwnerName = "crater_robloxq",
    BotOwnerId = 0,
    FPSCap = 20,
    Prefix = "/",
    WhiteListPermLevel = 2,
    WhiteList = {"Example1","Example2","Example3"},
    HideCoords = Vector3.new(math.random(1,1000),100000,math.random(1,1000)),
    AntiAFK = true,
    AntiFling = true,
    NoRender = true,
    IsRagdollGame = true,
    GiveToolsMethod = 1,
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/FGRDEVShadows/FGR_Bot_V1/main/Script2.lua"))()

wait(1)




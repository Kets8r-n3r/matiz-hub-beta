--========================================================--
-- Matiz External — JX-UI
--========================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--========================================================--
-- SETTINGS
--========================================================--

local Settings = {
    ESP = {
        Enabled = true,
        Boxes = true,
        CornerBoxes = false,
        Lines = false,
        Names = true,
        DistanceText = true,
        HealthBar = false,
        MaxDistance = 800,
        DrawDead = false,
        Box3D = false,
        Chams = false,
    },
    FOV = {
        Enabled = true,
        Radius = 150,
        Mode = "Center",
    },
    Skeleton = {
        Enabled = true,
    },
    Aim = {
        Enabled = true,
        Aimlock = true,
        FOV = 150,
        Smoothness = 0.18,
        TargetPart = "Head",
    },
    Misc = {
        Spinbot = false,
        SpinSpeed = 4,
    }
}

local ESP_COLOR = Color3.fromRGB(107, 41, 50)

--========================================================--
-- JX-UI ИНТЕГРАЦИЯ
--========================================================--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/JX-UI/JX-UI.lua"))()
local CheatName = "MATIZ External"

Library.Folders = {
    Directory = CheatName,
    Configs = CheatName .. "/Configs",
    Assets = CheatName .. "/Assets",
}

local Accent = Color3.fromRGB(255, 80, 80)
local Gradient = Color3.fromRGB(120, 20, 20)

Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

local Window = Library:Window({
    Name = " ",
    SubName = " ",
    Logo = "rbxassetid://118502852731978"
})

local KeybindList = Library:KeybindList("Keybinds")

--========================================================--
-- DRAG HELPER
--========================================================--

local function MakeDraggable(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--========================================================--
-- ВОТЕРМАРКА + КНОПКА TOGGLE
--========================================================--

local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "MatizWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.DisplayOrder = 999
WatermarkGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Вотермарка
local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 250, 0, 32)
WMFrame.Position = UDim2.new(0.5, -136, 0, 12)
WMFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 8)
local WMStroke = Instance.new("UIStroke", WMFrame)
WMStroke.Color = Color3.fromRGB(55, 55, 70)
WMStroke.Thickness = 1

-- t.me/getmatiz (красный)
local WMName = Instance.new("TextLabel")
WMName.Size = UDim2.new(0, 118, 1, 0)
WMName.Position = UDim2.new(0, 10, 0, 0)
WMName.BackgroundTransparency = 1
WMName.Font = Enum.Font.GothamBold
WMName.TextSize = 13
WMName.TextXAlignment = Enum.TextXAlignment.Left
WMName.TextYAlignment = Enum.TextYAlignment.Center
WMName.TextColor3 = Color3.fromRGB(220, 55, 55)
WMName.Text = "t.me/getmatiz"
WMName.Parent = WMFrame

-- разделитель
local WMSep = Instance.new("TextLabel")
WMSep.Size = UDim2.new(0, 11, 1, 0)
WMSep.Position = UDim2.new(0, 100, 0, 0)
WMSep.BackgroundTransparency = 1
WMSep.Font = Enum.Font.Gotham
WMSep.TextSize = 13
WMSep.TextXAlignment = Enum.TextXAlignment.Center
WMSep.TextYAlignment = Enum.TextYAlignment.Center
WMSep.TextColor3 = Color3.fromRGB(65, 65, 80)
WMSep.Text = "│"
WMSep.Parent = WMFrame

-- fps + ping (белый)
local WMStats = Instance.new("TextLabel")
WMStats.Size = UDim2.new(0, 130, 1, 0)
WMStats.Position = UDim2.new(0, 110, 0, 0)
WMStats.BackgroundTransparency = 1
WMStats.Font = Enum.Font.GothamBold
WMStats.TextSize = 13
WMStats.TextXAlignment = Enum.TextXAlignment.Left
WMStats.TextYAlignment = Enum.TextYAlignment.Center
WMStats.TextColor3 = Color3.fromRGB(210, 210, 210)
WMStats.Text = "fps: 0  │  ping: 0ms"
WMStats.Parent = WMFrame

MakeDraggable(WMFrame)


-- Обновление fps/ping
task.spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        WMStats.Text = "fps: " .. fps .. "  │  ping: " .. ping .. "ms"
        task.wait(1)
    end
end)

--========================================================--
-- ВКЛАДКИ
--========================================================--

Window:Category("Aimbot")
local AimPage = Window:Page({Name = "Aimlock", Icon = "122669828593160"})
local FOVPage = Window:Page({Name = "FOV", Icon = "123317177279443"})

Window:Category("Render")
local ESPPage = Window:Page({Name = "ESP", Icon = "92464809279921"})
local SkelPage = Window:Page({Name = "Skeleton", Icon = "123944728972740"})

Window:Category("Other")
local MiscPage = Window:Page({Name = "Misc", Icon = "101636617799068"})
local SettingsPage = Window:Page({Name = "Keybinds", Icon = "81598136527047"})

--========================================================--
-- Aimbot: Aimlock
--========================================================--

local AimSection = AimPage:Section({Name = "Aim Settings", Side = 1})

AimSection:Toggle({
    Name = "Enabled",
    Flag = "AimEnabled",
    Default = Settings.Aim.Enabled,
    Callback = function(v) Settings.Aim.Enabled = v end
})

AimSection:Toggle({
    Name = "Aimlock (RMB)",
    Flag = "Aimlock",
    Default = Settings.Aim.Aimlock,
    Callback = function(v) Settings.Aim.Aimlock = v end
})

AimSection:Slider({
    Name = "Aim FOV",
    Flag = "AimFOV",
    Min = 10,
    Max = 300,
    Default = Settings.Aim.FOV,
    Callback = function(v) Settings.Aim.FOV = v end
})

AimSection:Slider({
    Name = "Smoothness",
    Flag = "AimSmooth",
    Min = 1,
    Max = 50,
    Default = math.floor(Settings.Aim.Smoothness * 100),
    Callback = function(v) Settings.Aim.Smoothness = v / 100 end
})

AimSection:Dropdown({
    Name = "Target Part",
    Flag = "AimPart",
    Default = {Settings.Aim.TargetPart},
    Items = {"Head", "Torso"},
    Multi = false,
    Callback = function(v) Settings.Aim.TargetPart = v[1] end
})

--========================================================--
-- Aimbot: FOV
--========================================================--

local FOVSection = FOVPage:Section({Name = "FOV Settings", Side = 1})

FOVSection:Toggle({
    Name = "Enabled",
    Flag = "FOVEnabled",
    Default = Settings.FOV.Enabled,
    Callback = function(v)
        Settings.FOV.Enabled = v
        FOVring.Visible = v
    end
})

FOVSection:Slider({
    Name = "Radius",
    Flag = "FOVRadius",
    Min = 20,
    Max = 400,
    Default = Settings.FOV.Radius,
    Callback = function(v)
        Settings.FOV.Radius = v
        FOVring.Radius = v
    end
})

FOVSection:Dropdown({
    Name = "Mode",
    Flag = "FOVMode",
    Default = {Settings.FOV.Mode},
    Items = {"Center", "Mouse", "Off"},
    Multi = false,
    Callback = function(v) Settings.FOV.Mode = v[1] end
})

--========================================================--
-- Render: ESP
--========================================================--

local ESPSection = ESPPage:Section({Name = "ESP Settings", Side = 1})

ESPSection:Toggle({
    Name = "Enabled",
    Flag = "ESPEnabled",
    Default = Settings.ESP.Enabled,
    Callback = function(v) Settings.ESP.Enabled = v end
})

ESPSection:Toggle({
    Name = "Boxes",
    Flag = "ESPBoxes",
    Default = Settings.ESP.Boxes,
    Callback = function(v) Settings.ESP.Boxes = v end
})

ESPSection:Toggle({
    Name = "Corner Boxes",
    Flag = "ESPCorner",
    Default = Settings.ESP.CornerBoxes,
    Callback = function(v) Settings.ESP.CornerBoxes = v end
})

ESPSection:Toggle({
    Name = "Lines",
    Flag = "ESPLines",
    Default = Settings.ESP.Lines,
    Callback = function(v) Settings.ESP.Lines = v end
})

ESPSection:Toggle({
    Name = "Names",
    Flag = "ESPN",
    Default = Settings.ESP.Names,
    Callback = function(v) Settings.ESP.Names = v end
})

ESPSection:Toggle({
    Name = "Distance",
    Flag = "ESPDist",
    Default = Settings.ESP.DistanceText,
    Callback = function(v) Settings.ESP.DistanceText = v end
})

ESPSection:Slider({
    Name = "Max Distance",
    Flag = "ESPMaxDist",
    Min = 50,
    Max = 2000,
    Default = Settings.ESP.MaxDistance,
    Callback = function(v) Settings.ESP.MaxDistance = v end
})

ESPSection:Toggle({
    Name = "Draw Dead",
    Flag = "ESPDead",
    Default = Settings.ESP.DrawDead,
    Callback = function(v) Settings.ESP.DrawDead = v end
})

-- правая секция: 3D ESP
local ESP3DSection = ESPPage:Section({Name = "3D ESP Settings", Side = 2})

ESP3DSection:Toggle({
    Name = "3D Box",
    Flag = "ESPBox3D",
    Default = Settings.ESP.Box3D,
    Callback = function(v) Settings.ESP.Box3D = v end
})

ESP3DSection:Toggle({
    Name = "3D ESP (Chams)",
    Flag = "ESPChams",
    Default = Settings.ESP.Chams,
    Callback = function(v)
        Settings.ESP.Chams = v
        if not v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char then
                        local sb = char:FindFirstChild("MATIZ_Chams")
                        if sb then sb:Destroy() end
                    end
                end
            end
        end
    end
})

--========================================================--
-- Render: Skeleton
--========================================================--

local SkelSection = SkelPage:Section({Name = "Skeleton Settings", Side = 1})

SkelSection:Toggle({
    Name = "Enabled",
    Flag = "SkelEnabled",
    Default = Settings.Skeleton.Enabled,
    Callback = function(v) Settings.Skeleton.Enabled = v end
})

--========================================================--
-- Other: Misc
--========================================================--

local MiscSection = MiscPage:Section({Name = "Misc Settings", Side = 1})

MiscSection:Toggle({
    Name = "Spinbot",
    Flag = "Spinbot",
    Default = Settings.Misc.Spinbot,
    Callback = function(v) Settings.Misc.Spinbot = v end
})

MiscSection:Slider({
    Name = "Spin Speed",
    Flag = "SpinSpeed",
    Min = 1,
    Max = 20,
    Default = Settings.Misc.SpinSpeed,
    Callback = function(v) Settings.Misc.SpinSpeed = v end
})


--========================================================--
-- Settings: Keybinds
--========================================================--

local SettingsSection = SettingsPage:Section({Name = "UI Toggle Key", Side = 1})

local KeyOptions = {"RightShift", "Insert", "Home", "Delete", "End", "F1", "F2", "F3", "F4", "F5", "RightControl"}
local CurrentToggleKey = Enum.KeyCode.RightShift
local UIVisible = true

local function ToggleUI()
    UIVisible = not UIVisible
    pcall(function()
        Window:SetOpen(UIVisible)
    end)
end

SettingsSection:Dropdown({
    Name = "Toggle UI Key",
    Flag = "ToggleKey",
    Default = {"RightShift"},
    Items = KeyOptions,
    Multi = false,
    Callback = function(v)
        local key = v[1] or v
        CurrentToggleKey = Enum.KeyCode[key]
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CurrentToggleKey then
        ToggleUI()
    end
end)
--========================================================--
-- ИНИЦИАЛИЗАЦИЯ ОКНА
--========================================================--

Window:Init()

--========================================================--
-- DRAWING FOV
--========================================================--

local FOVring = Drawing.new("Circle")
FOVring.Visible = Settings.FOV.Enabled
FOVring.Thickness = 2
FOVring.Color = ESP_COLOR
FOVring.Filled = false
FOVring.Radius = Settings.FOV.Radius
FOVring.Position = Camera.ViewportSize / 2

local function UpdateFOV()
    if not Settings.FOV.Enabled or Settings.FOV.Mode == "Off" then
        FOVring.Visible = false
        return
    end

    FOVring.Visible = true
    FOVring.Radius = Settings.FOV.Radius

    if Settings.FOV.Mode == "Center" then
        FOVring.Position = Camera.ViewportSize / 2
    else
        local m = UserInputService:GetMouseLocation()
        FOVring.Position = Vector2.new(m.X, m.Y)
    end
end

--========================================================--
-- CHARACTER HELPERS
--========================================================--

local function GetCharacter(player)
    if not player then return nil end
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        return char, hum, root
    end
    return nil
end

local function IsR15(char)
    return char:FindFirstChild("UpperTorso") ~= nil
end

local function GetTorso(char)
    if IsR15(char) then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("Torso")
    end
end

local function GetHead(char)
    return char:FindFirstChild("Head")
end

--========================================================--
-- ESP (Drawing API — Box2D, Box3D, Line, Names, Distance)
--========================================================--

local ESPObjects = {} -- { [player] = { box={lines}, box3d={lines}, line=Line, ... } }

local function NewLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.Thickness = 1
    l.Color = ESP_COLOR
    l.Transparency = 1
    return l
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    -- 2D box: 4 lines
    local box = {}
    for i = 1, 4 do box[i] = NewLine() end

    -- 3D box: 12 lines
    local box3d = {}
    for i = 1, 12 do box3d[i] = NewLine() end

    -- tracer line from bottom center to player
    local tracer = NewLine()
    tracer.Thickness = 1

    -- name text
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Size = 13
    nameText.Font = Drawing.Fonts.Plex
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Center = true

    -- distance text
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Size = 11
    distText.Font = Drawing.Fonts.Plex
    distText.Color = Color3.fromRGB(200, 200, 200)
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Center = true

    ESPObjects[player] = {
        box = box,
        box3d = box3d,
        tracer = tracer,
        nameText = nameText,
        distText = distText,
    }
end

local function RemoveESPForPlayer(player)
    local obj = ESPObjects[player]
    if not obj then return end
    for _, l in ipairs(obj.box) do l:Remove() end
    for _, l in ipairs(obj.box3d) do l:Remove() end
    obj.tracer:Remove()
    obj.nameText:Remove()
    obj.distText:Remove()
    ESPObjects[player] = nil
end

-- рисует 2D box по 4 точкам (tl, tr, br, bl)
local function Draw2DBox(lines, tl, tr, br, bl, visible)
    local pts = {tl, tr, br, bl}
    local nxt = {tr, br, bl, tl}
    for i = 1, 4 do
        lines[i].From = pts[i]
        lines[i].To = nxt[i]
        lines[i].Visible = visible
        lines[i].Color = ESP_COLOR
    end
end

-- рисует 3D box по 8 точкам мира
local function Draw3DBox(lines, corners, visible)
    -- corners: 1-4 верх, 5-8 низ (в viewport координатах)
    -- соединения: верх, низ, вертикали
    local edges = {
        {1,2},{2,3},{3,4},{4,1}, -- верх
        {5,6},{6,7},{7,8},{8,5}, -- низ
        {1,5},{2,6},{3,7},{4,8}, -- вертикали
    }
    for i, e in ipairs(edges) do
        lines[i].From = corners[e[1]]
        lines[i].To = corners[e[2]]
        lines[i].Visible = visible
        lines[i].Color = ESP_COLOR
    end
end

local function GetBoundingBox(char)
    -- возвращаем 8 углов bounding box персонажа в мировых координатах
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not root or not head then return nil end

    local rootPos = root.Position
    local headPos = head.Position

    local w = 2.5  -- ширина
    local d = 1.0  -- глубина

    local top = headPos.Y + 0.5
    local bot = rootPos.Y - 3.0

    local cf = root.CFrame
    local rx = cf.RightVector * w
    local rz = cf.LookVector * d

    return {
        Vector3.new(rootPos.X, top, rootPos.Z) + rx + rz,
        Vector3.new(rootPos.X, top, rootPos.Z) - rx + rz,
        Vector3.new(rootPos.X, top, rootPos.Z) - rx - rz,
        Vector3.new(rootPos.X, top, rootPos.Z) + rx - rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) + rx + rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) - rx + rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) - rx - rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) + rx - rz,
    }
end

local function UpdateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char, hum, root = GetCharacter(plr)

            if Settings.ESP.Enabled and char and hum and root and (Settings.ESP.DrawDead or hum.Health > 0) then
                if not ESPObjects[plr] then
                    CreateESPForPlayer(plr)
                end
                local obj = ESPObjects[plr]
                if not obj then continue end

                local head = GetHead(char)
                local distance = (root.Position - Camera.CFrame.Position).Magnitude

                local rootScreen, rootOnScreen = Camera:WorldToViewportPoint(root.Position)

                if not rootOnScreen or distance > Settings.ESP.MaxDistance then
                    for _, l in ipairs(obj.box) do l.Visible = false end
                    for _, l in ipairs(obj.box3d) do l.Visible = false end
                    obj.tracer.Visible = false
                    obj.nameText.Visible = false
                    obj.distText.Visible = false
                else
                    -- вычисляем 2D bounding box через голову и ноги
                    local headScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0))
                    local feetPos = root.Position - Vector3.new(0, 3, 0)
                    local feetScreen = Camera:WorldToViewportPoint(feetPos)

                    local h2d = math.abs(headScreen.Y - feetScreen.Y)
                    local w2d = h2d * 0.55

                    local cx = headScreen.X
                    local top2d = headScreen.Y
                    local bot2d = feetScreen.Y

                    local tl = Vector2.new(cx - w2d, top2d)
                    local tr = Vector2.new(cx + w2d, top2d)
                    local br = Vector2.new(cx + w2d, bot2d)
                    local bl = Vector2.new(cx - w2d, bot2d)

                    -- 2D Box
                    if Settings.ESP.Boxes then
                        Draw2DBox(obj.box, tl, tr, br, bl, true)
                    else
                        for _, l in ipairs(obj.box) do l.Visible = false end
                    end

                    -- 3D Box
                    if Settings.ESP.Box3D then
                        local worldCorners = GetBoundingBox(char)
                        if worldCorners then
                            local screenCorners = {}
                            local allOnScreen = true
                            for i, wc in ipairs(worldCorners) do
                                local sc, on = Camera:WorldToViewportPoint(wc)
                                screenCorners[i] = Vector2.new(sc.X, sc.Y)
                                if not on then allOnScreen = false end
                            end
                            Draw3DBox(obj.box3d, screenCorners, allOnScreen)
                        end
                    else
                        for _, l in ipairs(obj.box3d) do l.Visible = false end
                    end

                    -- Tracer line
                    if Settings.ESP.Lines then
                        local screenSize = Camera.ViewportSize
                        obj.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                        obj.tracer.To = Vector2.new(cx, bot2d)
                        obj.tracer.Color = ESP_COLOR
                        obj.tracer.Visible = true
                    else
                        obj.tracer.Visible = false
                    end

                    -- Name
                    if Settings.ESP.Names and head then
                        obj.nameText.Position = Vector2.new(cx, top2d - 16)
                        obj.nameText.Text = plr.Name
                        obj.nameText.Visible = true
                    else
                        obj.nameText.Visible = false
                    end

                    -- Distance
                    if Settings.ESP.DistanceText then
                        obj.distText.Position = Vector2.new(cx, bot2d + 2)
                        obj.distText.Text = string.format("%.0f m", distance)
                        obj.distText.Visible = true
                    else
                        obj.distText.Visible = false
                    end
                end
            else
                RemoveESPForPlayer(plr)
            end
        end
    end
end

--========================================================--
-- 3D ESP (CHAMS via SelectionBox)
--========================================================--

local function UpdateChams()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")

            if Settings.ESP.Enabled and Settings.ESP.Chams and hum and (Settings.ESP.DrawDead or hum.Health > 0) then
                -- создаём SelectionBox если нет
                local sb = char:FindFirstChild("MATIZ_Chams")
                if not sb then
                    sb = Instance.new("SelectionBox")
                    sb.Name = "MATIZ_Chams"
                    sb.LineThickness = 0.05
                    sb.SurfaceTransparency = 0.6
                    sb.SurfaceColor3 = ESP_COLOR
                    sb.Color3 = ESP_COLOR
                    sb.Adornee = char
                    sb.Parent = char
                end
            else
                local sb = char:FindFirstChild("MATIZ_Chams")
                if sb then sb:Destroy() end
            end
        end
    end
end

--========================================================--
-- SKELETON
--========================================================--

local SkeletonSettings = {
    Color = ESP_COLOR,
    Thickness = 2,
    Transparency = 1
}

local skeletons = {}

local function createLine()
    local line = Drawing.new("Line")
    line.Visible = false
    return line
end

local function removeSkeleton(skeleton)
    for _, line in pairs(skeleton) do
        line:Remove()
    end
end

local function trackPlayer(plr)
    local skeleton = {}

    local function updateSkeleton()
        if not Settings.Skeleton.Enabled then
            for _, line in pairs(skeleton) do line.Visible = false end
            return
        end

        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, line in pairs(skeleton) do line.Visible = false end
            return
        end

        local character = plr.Character
        local humanoid = character:FindFirstChild("Humanoid")

        local joints = {}
        local connections = {}

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["UpperTorso"] = character:FindFirstChild("UpperTorso"),
                ["LowerTorso"] = character:FindFirstChild("LowerTorso"),
                ["LeftUpperArm"] = character:FindFirstChild("LeftUpperArm"),
                ["LeftLowerArm"] = character:FindFirstChild("LeftLowerArm"),
                ["LeftHand"] = character:FindFirstChild("LeftHand"),
                ["RightUpperArm"] = character:FindFirstChild("RightUpperArm"),
                ["RightLowerArm"] = character:FindFirstChild("RightLowerArm"),
                ["RightHand"] = character:FindFirstChild("RightHand"),
                ["LeftUpperLeg"] = character:FindFirstChild("LeftUpperLeg"),
                ["LeftLowerLeg"] = character:FindFirstChild("LeftLowerLeg"),
                ["RightUpperLeg"] = character:FindFirstChild("RightUpperLeg"),
                ["RightLowerLeg"] = character:FindFirstChild("RightLowerLeg"),
            }
            connections = {
                {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"},
                {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"},
                {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
            }
        else
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["Torso"] = character:FindFirstChild("Torso"),
                ["LeftArm"] = character:FindFirstChild("Left Arm"),
                ["RightArm"] = character:FindFirstChild("Right Arm"),
                ["LeftLeg"] = character:FindFirstChild("Left Leg"),
                ["RightLeg"] = character:FindFirstChild("Right Leg"),
            }
            connections = {
                {"Head","Torso"}, {"Torso","LeftArm"}, {"Torso","RightArm"},
                {"Torso","LeftLeg"}, {"Torso","RightLeg"},
            }
        end

        for index, connection in ipairs(connections) do
            local jointA = joints[connection[1]]
            local jointB = joints[connection[2]]

            if jointA and jointB then
                local posA, onA = Camera:WorldToViewportPoint(jointA.Position)
                local posB, onB = Camera:WorldToViewportPoint(jointB.Position)

                local line = skeleton[index] or createLine()
                skeleton[index] = line

                line.Color = SkeletonSettings.Color
                line.Thickness = SkeletonSettings.Thickness
                line.Transparency = SkeletonSettings.Transparency

                if onA and onB then
                    line.From = Vector2.new(posA.X, posA.Y)
                    line.To = Vector2.new(posB.X, posB.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif skeleton[index] then
                skeleton[index].Visible = false
            end
        end
    end

    skeletons[plr] = skeleton

    RunService.RenderStepped:Connect(function()
        if plr and plr.Parent then
            updateSkeleton()
        else
            removeSkeleton(skeleton)
        end
    end)
end

local function untrackPlayer(plr)
    if skeletons[plr] then
        removeSkeleton(skeletons[plr])
        skeletons[plr] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then trackPlayer(plr) end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then trackPlayer(plr) end
end)

Players.PlayerRemoving:Connect(untrackPlayer)

--========================================================--
-- AIMBOT
--========================================================--

local function GetClosestTarget()
    if not Settings.Aim.Enabled then return nil end

    local mousePos = UserInputService:GetMouseLocation()
    local bestTarget = nil
    local bestDist = Settings.Aim.FOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char, hum, root = GetCharacter(plr)
            if char and hum and hum.Health > 0 then
                local targetPart =
                    (Settings.Aim.TargetPart == "Head" and char:FindFirstChild("Head"))
                    or GetTorso(char)

                if targetPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < Settings.Aim.FOV and dist < bestDist then
                            bestDist = dist
                            bestTarget = targetPart
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

local AimlockHeld = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimlockHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimlockHeld = false
    end
end)

local function UpdateAimbot()
    if not Settings.Aim.Enabled then return end

    local target = nil

    if Settings.Aim.Aimlock then
        if AimlockHeld then
            target = GetClosestTarget()
        end
    else
        target = GetClosestTarget()
    end

    if target then
        local camPos = Camera.CFrame.Position
        local dir = (target.Position - camPos).Unit
        local targetCF = CFrame.new(camPos, camPos + dir)
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Aim.Smoothness)
    end
end

--========================================================--
-- SPINBOT
--========================================================--

local function UpdateSpinbot()
    if not Settings.Misc.Spinbot then return end

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.Misc.SpinSpeed), 0)
end

--========================================================--
-- PLAYER EVENTS (ESP)
--========================================================--

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        CreateESPForPlayer(plr)
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESPForPlayer(plr)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        if plr.Character then CreateESPForPlayer(plr) end
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            CreateESPForPlayer(plr)
        end)
    end
end

--========================================================--
-- MAIN RENDER LOOP
--========================================================--

RunService.RenderStepped:Connect(function()
    UpdateESP()
    UpdateChams()
    UpdateFOV()
    UpdateAimbot()
    UpdateSpinbot()
end)

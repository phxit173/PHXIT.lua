--[[ PHXIT - PvP Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- ===============================
-- CONFIGURAÇÃO E SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- ===============================
-- KEY SYSTEM
-- ===============================
local VALID_KEY = "PH.DS25567"
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3"

if pg:FindFirstChild("PHXIT_KEY_GUI") then
    pg.PHXIT_KEY_GUI:Destroy()
end

local KeyGui = Instance.new("ScreenGui", pg)
KeyGui.Name = "PHXIT_KEY_GUI"
KeyGui.ResetOnSpawn = false

local MainKey = Instance.new("Frame", KeyGui)
MainKey.Size = UDim2.fromOffset(0,0)
MainKey.Position = UDim2.fromScale(0.35,0.3)
MainKey.BackgroundColor3 = Color3.fromRGB(18,18,18)
MainKey.BorderSizePixel = 0
MainKey.ClipsDescendants = true
MainKey.Active = true
MainKey.Draggable = true
Instance.new("UICorner", MainKey).CornerRadius = UDim.new(0,18)
local Stroke = Instance.new("UIStroke", MainKey)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255,0,0)
Stroke.Transparency = 0.6

TweenService:Create(MainKey, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(320,260)}):Play()

-- Título
local Title = Instance.new("TextLabel", MainKey)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHXIT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

local Sub = Instance.new("TextLabel", MainKey)
Sub.Position = UDim2.fromOffset(0,40)
Sub.Size = UDim2.new(1,0,0,20)
Sub.Text = "Pegue a key no Discord"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 12
Sub.TextColor3 = Color3.fromRGB(170,170,170)
Sub.BackgroundTransparency = 1

-- Caixa de texto da Key
local KeyBox = Instance.new("TextBox", MainKey)
KeyBox.Position = UDim2.fromOffset(30,90)
KeyBox.Size = UDim2.fromOffset(260,40)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,12)

-- Botão confirmar
local Confirm = Instance.new("TextButton", MainKey)
Confirm.Position = UDim2.fromOffset(30,140)
Confirm.Size = UDim2.fromOffset(260,40)
Confirm.Text = "CONFIRMAR KEY"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 14
Confirm.TextColor3 = Color3.new(1,1,1)
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,12)

-- Botão Discord
local Discord = Instance.new("TextButton", MainKey)
Discord.Position = UDim2.fromOffset(30,190)
Discord.Size = UDim2.fromOffset(260,35)
Discord.Text = "ENTRAR NO DISCORD"
Discord.Font = Enum.Font.Gotham
Discord.TextSize = 13
Discord.TextColor3 = Color3.fromRGB(255,0,0)
Discord.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", Discord).CornerRadius = UDim.new(0,12)

Discord.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_LINK)
    Discord.Text = "LINK COPIADO! COLE NO NAVEGADOR"
    task.wait(1.5)
    Discord.Text = "ENTRAR NO DISCORD"
end)

-- ===============================
-- SCRIPT PRINCIPAL (PHXIT)
-- ===============================
local function StartPHXIT()
    if pg:FindFirstChild("PHXIT_GUI") then
        pg.PHXIT_GUI:Destroy()
    end

    -- Estados e ajustes
    local AimbotEnabled, AimlockEnabled, ESPEnabled = false, false, false
    local AimbotSmoothness, AimlockSmoothness = 0.18, 1
    local AimbotFOV, Deadzone, Prediction = 180, 6, 0.12

    -- GUI principal
    local ScreenGui = Instance.new("ScreenGui", pg)
    ScreenGui.Name = "PHXIT_GUI"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromOffset(0,0)
    Main.Position = UDim2.fromScale(0.35,0.25)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0,0)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255,0,255)
    Stroke.Transparency = 0.7

    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.fromOffset(300,280)}):Play()

    -- Título
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1,0,0,40)
    Title.Text = "PHXIT"
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22

    local Subtitle = Instance.new("TextLabel", Main)
    Subtitle.Size = UDim2.new(1,0,0,20)
    Subtitle.Position = UDim2.new(0,0,0,45)
    Subtitle.Text = "Feito por um brasileiro"
    Subtitle.TextColor3 = Color3.fromRGB(180,180,180)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 12

    -- Botões fechar e minimizar
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.fromOffset(30,30)
    Close.Position = UDim2.new(1,-35,0,5)
    Close.Text = "X"
    Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
    Close.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0,10)

    local Min = Instance.new("TextButton", Main)
    Min.Size = UDim2.fromOffset(30,30)
    Min.Position = UDim2.new(1,-70,0,5)
    Min.Text = "-"
    Min.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Min.TextColor3 = Color3.fromRGB(255,0,0)
    Instance.new("UICorner", Min).CornerRadius = UDim.new(0,10)

    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.fromOffset(50,50)
    OpenBtn.Position = UDim2.fromScale(0.02,0.5)
    OpenBtn.Text = "PH"
    OpenBtn.TextColor3 = Color3.fromRGB(255,0,0)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,10)

    -- ===============================
    -- ANIMAÇÃO MINIMIZAR / MAXIMIZAR
    -- ===============================
    Min.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(50,50)}):Play()
        task.delay(0.3, function()
            Main.Visible = false
            OpenBtn.Visible = true
        end)
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = false
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(300,280)}):Play()
    end)

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- ===============================
    -- TOGGLES
    -- ===============================
    local function Toggle(text,posY,callback)
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(1,-20,0,40)
        btn.Position = UDim2.fromOffset(10,posY)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = text..": OFF"
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text..": "..(state and "ON" or "OFF")
            callback(state)
        end)
    end

    Toggle("AIMBOT", 90, function(v) AimbotEnabled=v end)
    Toggle("AIMLOCK", 150, function(v) AimlockEnabled=v end)
    Toggle("ESP", 210, function(v) ESPEnabled=v end)

    -- ===============================
    -- FUNÇÕES DE TREINO
    -- ===============================
    local function HasLineOfSight(part)
        local origin = Camera.CFrame.Position
        local direction = (part.Position-origin)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances={lp.Character,Camera}
        local ray = workspace:Raycast(origin,direction,params)
        if ray then
            return ray.Instance:IsDescendantOf(part.Parent)
        end
        return true
    end

    local function GetClosestPlayerFOV()
        local closest,dist=nil,math.huge
        local mousePos=UserInputService:GetMouseLocation()
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hum=plr.Character:FindFirstChild("Humanoid")
                if hum and hum.Health>0 then
                    local hrp=plr.Character.HumanoidRootPart
                    if HasLineOfSight(hrp) then
                        local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local diff=Vector2.new(pos.X,pos.Y)-mousePos
                            local mag=diff.Magnitude
                            if mag<AimbotFOV and mag<dist then
                                dist=mag
                                closest=hrp
                            end
                        end
                    end
                end
            end
        end
        return closest,dist
    end

    RunService.RenderStepped:Connect(function()
        local target,dist=GetClosestPlayerFOV()
        if not target then return end
        if dist<Deadzone then return end
        local velocity=target.AssemblyLinearVelocity*Prediction
        local predictedPos=target.Position+velocity
        local camPos=Camera.CFrame.Position
        local cf=CFrame.new(camPos,predictedPos)
        if AimlockEnabled then
            Camera.CFrame=cf
        elseif AimbotEnabled then
            Camera.CFrame=Camera.CFrame:Lerp(cf,AimbotSmoothness)
        end
    end)

    RunService.RenderStepped:Connect(function()
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if ESPEnabled then
                    if not plr.Character:FindFirstChild("PHXIT_ESP") then
                        local hl=Instance.new("Highlight")
                        hl.Name="PHXIT_ESP"
                        hl.Adornee=plr.Character
                        hl.FillColor=Color3.fromRGB(255,0,0)
                        hl.OutlineColor=Color3.fromRGB(255,255,255)
                        hl.FillTransparency=0.4
                        hl.OutlineTransparency=0
                        hl.Parent=plr.Character
                    end
                else
                    if plr.Character:FindFirstChild("PHXIT_ESP") then
                        plr.Character.PHXIT_ESP:Destroy()
                    end
                end
            end
        end
    end)
end

-- ===============================
-- CONFIRMAR KEY
-- ===============================
Confirm.MouseButton1Click:Connect(function()
    if KeyBox.Text==VALID_KEY then
        KeyGui:Destroy()
        StartPHXIT()
    else
        Confirm.Text="KEY INVÁLIDA"
        task.wait(1.5)
        Confirm.Text="CONFIRMAR KEY"
    end
end)

-- Botão ocultar (FIX MOBILE)
Min.MouseButton1Click:Connect(function()
    TweenService:Create(
        Main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.fromOffset(0, 0)}
    ):Play()

    task.wait(0.25)
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- Botão PH para reabrir (ARRASTÁVEL)
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.AutoButtonColor = true

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    TweenService:Create(
        Main,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(300, 280)}
    ):Play()

    OpenBtn.Visible = false
end)

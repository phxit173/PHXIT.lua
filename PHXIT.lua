--[[ PHXIT - PvP Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- ===============================
-- PHXIT SCRIPT (GUI MODERNA)
-- ===============================

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- Estados
local AimbotEnabled = false
local AimlockEnabled = false
local ESPEnabled = false

-- Ajustes (UPGRADE)
local AimbotSmoothness = 0.18
local AimlockSmoothness = 1
local AimbotFOV = 180
local Deadzone = 6
local Prediction = 0.12

-- Limpa GUI antiga
local pg = lp:WaitForChild("PlayerGui")
if pg:FindFirstChild("PHXIT_GUI") then
    pg.PHXIT_GUI:Destroy()
end

-- ===============================
-- GUI
-- ===============================
local ScreenGui = Instance.new("ScreenGui", pg)
ScreenGui.Name = "PHXIT_GUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(0, 0) -- animação inicial crescendo
Main.Position = UDim2.fromScale(0.35, 0.25)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0,0)

-- Borda RGB discreta
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 20)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 255)
UIStroke.Transparency = 0.7

-- Tween para abrir suavemente
TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.fromOffset(300, 280)}):Play()

-- Topo / título
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

-- Botão fechar
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
Close.TextColor3 = Color3.fromRGB(255,255,255)
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 10)

-- Botão ocultar
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.fromOffset(30,30)
Min.Position = UDim2.new(1,-70,0,5)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(50,50,50)
Min.TextColor3 = Color3.fromRGB(255,0,0)
local MinCorner = Instance.new("UICorner", Min)
MinCorner.CornerRadius = UDim.new(0, 10)

-- Botão PH para reabrir
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.fromOffset(50,50)
OpenBtn.Position = UDim2.fromScale(0.02,0.5)
OpenBtn.Text = "𝑃𝐻"
OpenBtn.TextColor3 = Color3.fromRGB(255,0,0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
OpenBtn.Visible = false
local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0,10)

-- Conexões
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ===============================
-- BOTÕES TOGGLE
-- ===============================
local function Toggle(text, posY, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.fromOffset(10,posY)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": OFF"
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,12)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

Toggle("AIMBOT", 90, function(v) AimbotEnabled = v end)
Toggle("AIMLOCK", 150, function(v) AimlockEnabled = v end)
Toggle("ESP", 210, function(v) ESPEnabled = v end)

-- ===============================
-- FUNÇÕES DE TREINO
-- ===============================
local function HasLineOfSight(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {lp.Character, Camera}
    local ray = workspace:Raycast(origin, direction, params)
    if ray then
        return ray.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

local function GetClosestPlayerFOV()
    local closest, dist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = plr.Character.HumanoidRootPart
                if HasLineOfSight(hrp) then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local diff = Vector2.new(pos.X,pos.Y) - mousePos
                        local mag = diff.Magnitude
                        if mag < AimbotFOV and mag < dist then
                            dist = mag
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    return closest, dist
end

-- ===============================
-- AIMBOT / AIMLOCK
-- ===============================
RunService.RenderStepped:Connect(function()
    local target, dist = GetClosestPlayerFOV()
    if not target then return end
    if dist < Deadzone then return end
    local velocity = target.AssemblyLinearVelocity * Prediction
    local predictedPos = target.Position + velocity
    local camPos = Camera.CFrame.Position
    local cf = CFrame.new(camPos, predictedPos)
    if AimlockEnabled then
        Camera.CFrame = cf
    elseif AimbotEnabled then
        Camera.CFrame = Camera.CFrame:Lerp(cf, AimbotSmoothness)
    end
end)

-- ===============================
-- ESP MODERNO
-- ===============================
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if ESPEnabled then
                if not plr.Character:FindFirstChild("PHXIT_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "PHXIT_ESP"
                    hl.Adornee = plr.Character
                    hl.FillColor = Color3.fromRGB(255,0,0)
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0
                    hl.Parent = plr.Character
                end
            else
                if plr.Character:FindFirstChild("PHXIT_ESP") then
                    plr.Character.PHXIT_ESP:Destroy()
                end
            end
        end
    end
end)

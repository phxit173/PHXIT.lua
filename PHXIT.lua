--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- PHXIT CORE (GUI LIMPA + DRAG + OCULTAR)
-- loader-safe / Delta-safe

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer

-- Espera PlayerGui
local playerGui
repeat
    playerGui = lp:FindFirstChild("PlayerGui")
    task.wait()
until playerGui

-- Remove GUI antiga
if playerGui:FindFirstChild("PHXIT_GUI") then
    playerGui.PHXIT_GUI:Destroy()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "PHXIT_GUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,260,0,220)
main.Position = UDim2.new(0.1,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true

-- Topbar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,36)
top.BackgroundColor3 = Color3.fromRGB(35,35,35)
top.Active = true

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "PHXIT"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botões
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-34,0,3)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150,50,50)
close.TextColor3 = Color3.new(1,1,1)

local hide = Instance.new("TextButton", top)
hide.Size = UDim2.new(0,30,0,30)
hide.Position = UDim2.new(1,-68,0,3)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(80,80,80)
hide.TextColor3 = Color3.new(1,1,1)

-- Botão reabrir
local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.new(0,70,0,30)
reopen.Position = UDim2.new(0,10,0,10)
reopen.Text = "PHXIT"
reopen.Visible = false
reopen.BackgroundColor3 = Color3.fromRGB(25,25,25)
reopen.TextColor3 = Color3.new(1,1,1)
reopen.ZIndex = 999
reopen.Active = true

-- ===== FUNÇÕES =====
hide.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== DRAG (MOBILE + PC) =====
local dragging = false
local dragStart, startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

top.InputEnded:Connect(function()
    dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Estados
local AimlockEnabled = false
local AimbotEnabled = false
local ESPEnabled = false

-- Função helper para criar botão ON/OFF
local function MakeToggle(text, y, getter, setter)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1,-20,0,36)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    local function Update()
        if getter() then
            btn.Text = text..": ON"
            btn.BackgroundColor3 = Color3.fromRGB(40,150,40)
        else
            btn.Text = text..": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(130,40,40)
        end
    end
    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        Update()
    end)
    Update()
end

-- Criar botões
MakeToggle("Aimlock", 60, function() return AimlockEnabled end, function(v) AimlockEnabled = v end)
MakeToggle("Aimbot", 110, function() return AimbotEnabled end, function(v) AimbotEnabled = v end)
MakeToggle("ESP", 160, function() return ESPEnabled end, function(v) ESPEnabled = v end)

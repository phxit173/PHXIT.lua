--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

print("PHXIT carregado")

--// PHXIT - TRAINING SCRIPT (NPC ONLY)

--// SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// ESTADOS
local AimlockEnabled = false
local AimbotEnabled = false
local ESPEnabled = false
local Smoothness = 0.15

--// FUNÇÃO NPC MAIS PRÓXIMO DO MOUSE
local function GetClosestNPC()
    local closest, shortest = nil, math.huge
    local mouse = LocalPlayer:GetMouse()

    for _, m in pairs(workspace:GetChildren()) do
        if m:IsA("Model")
        and m:FindFirstChild("Humanoid")
        and m:FindFirstChild("HumanoidRootPart") then
            local hrp = m.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = m
                end
            end
        end
    end
    return closest
end

--// AIMBOT / AIMLOCK
RunService.RenderStepped:Connect(function()
    local target = GetClosestNPC()
    if not target then return end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local newCF = CFrame.new(Camera.CFrame.Position, hrp.Position)

    if AimlockEnabled then
        Camera.CFrame = newCF
    elseif AimbotEnabled then
        Camera.CFrame = Camera.CFrame:Lerp(newCF, Smoothness)
    end
end)

--// ESP NPC
local ESPFolder = Instance.new("Folder", workspace)
ESPFolder.Name = "PHXIT_ESP"

local function DrawESP(npc)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = npc
    box.Size = npc:GetExtentsSize()
    box.Color3 = Color3.fromRGB(255,0,0)
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = ESPFolder
end

RunService.RenderStepped:Connect(function()
    ESPFolder:ClearAllChildren()
    if not ESPEnabled then return end
    for _, m in pairs(workspace:GetChildren()) do
        if m:IsA("Model")
        and m:FindFirstChild("Humanoid")
        and m:FindFirstChild("HumanoidRootPart") then
            DrawESP(m)
        end
    end
end)

--// GUI
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "PHXIT_GUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,230)
main.Position = UDim2.new(0.1,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true

-- TOPO
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "PHXIT - Training"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Left

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,2)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(160,50,50)
close.TextColor3 = Color3.new(1,1,1)

local hide = Instance.new("TextButton", top)
hide.Size = UDim2.new(0,30,0,30)
hide.Position = UDim2.new(1,-70,0,2)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
hide.TextColor3 = Color3.new(1,1,1)

-- BOTÃO REABRIR
local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.new(0,70,0,30)
reopen.Position = UDim2.new(0,10,0.5,0)
reopen.Text = "PHXIT"
reopen.Visible = false
reopen.BackgroundColor3 = Color3.fromRGB(25,25,25)
reopen.TextColor3 = Color3.new(1,1,1)

-- FUNÇÃO BOTÃO ON/OFF
local function MakeToggle(text, y, getter, setter)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1,-20,0,34)
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
            btn.BackgroundColor3 = Color3.fromRGB(120,40,40)
        end
    end

    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        Update()
    end)

    Update()
end

-- BOTÕES
MakeToggle("Aimlock", 50,
    function() return AimlockEnabled end,
    function(v) AimlockEnabled = v end
)

MakeToggle("Aimbot", 95,
    function() return AimbotEnabled end,
    function(v) AimbotEnabled = v end
)

MakeToggle("ESP", 140,
    function() return ESPEnabled end,
    function(v) ESPEnabled = v end
)

-- OCULTAR / FECHAR
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

-- DRAG MOBILE
local dragging, dragStart, startPos
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
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

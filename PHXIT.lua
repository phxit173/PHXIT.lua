--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ESPERA O PLAYERGUI EXISTIR
local playerGui
repeat
    playerGui = lp:FindFirstChild("PlayerGui")
    task.wait()
until playerGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PHXIT_TEST_GUI"
gui.ResetOnSpawn = false
gui.Parent = lp.PlayerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,220)
main.Position = UDim2.new(0.1,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true

-- TOPO
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(35,35,35)
top.Active = true

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.Text = "PHXIT GUI TEST"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,0,0,40)
container.Size = UDim2.new(1,0,1,-40)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)
layout.HorizontalAlignment = Center
layout.VerticalAlignment = Center

-- FUNÇÃO BOTÃO
local function MakeBtn(text)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(0,220,0,36)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
end

MakeBtn("Aimlock: OFF")
MakeBtn("Aimbot: OFF")
MakeBtn("ESP: OFF")

-- DRAG MOBILE (SIMPLÃO)
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

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

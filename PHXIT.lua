--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

print("PHXIT carregado")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- PHXIT TEST GUI
print("PHXIT carregado")

-- remove duplicata
if game.CoreGui:FindFirstChild("PHXIT_GUI") then
    game.CoreGui.PHXIT_GUI:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- flags de teste
local AimBot = false
local AimLock = false
local ESP = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PHXIT_GUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.5, -160, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

-- título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "PHXIT – Test Panel"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- botão fechar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180,50,50)
close.TextColor3 = Color3.new(1,1,1)

close.MouseButton1Click:Connect(function()
    frame:Destroy()
end)

-- botão ocultar
local hide = Instance.new("TextButton", frame)
hide.Size = UDim2.new(0, 30, 0, 30)
hide.Position = UDim2.new(1, -70, 0, 5)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(70,70,70)
hide.TextColor3 = Color3.new(1,1,1)

hide.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- função criar botão toggle
local function createToggle(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 30, 0, posY)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- botões de TESTE
createToggle("Fake Aimbot", 70, function(v)
    AimBot = v
    print("Fake Aimbot:", v)
end)

createToggle("Fake AimLock", 120, function(v)
    AimLock = v
    print("Fake AimLock:", v)
end)

createToggle("Fake ESP", 170, function(v)
    ESP = v
    print("Fake ESP:", v)
end)

-- ================= SERVIÇOS ================= local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

-- ================= ESTADOS ================= local State = { Aimbot = false, AimLock = false, ESPBox = false, ESPName = false, }

-- ================= GUI ================= local gui = Instance.new("ScreenGui") gui.Name = "PHXIT_GUI" gui.ResetOnSpawn = false pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end)

local main = Instance.new("Frame", gui) main.Size = UDim2.fromOffset(300, 260) main.Position = UDim2.fromScale(0.05, 0.3) main.BackgroundColor3 = Color3.fromRGB(25,25,25) main.BorderSizePixel = 0

local corner = Instance.new("UICorner", main) corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main) title.Size = UDim2.new(1, -80, 0, 40) title.Position = UDim2.fromOffset(10, 5) title.BackgroundTransparency = 1 title.Text = "PHXIT – PvP Test" title.TextColor3 = Color3.new(1,1,1) title.Font = Enum.Font.GothamBold title.TextSize = 16 title.TextXAlignment = Enum.TextXAlignment.Left

local btnClose = Instance.new("TextButton", main) btnClose.Size = UDim2.fromOffset(30, 30) btnClose.Position = UDim2.fromOffset(260, 5) btnClose.Text = "X" btnClose.BackgroundColor3 = Color3.fromRGB(180,50,50) btnClose.TextColor3 = Color3.new(1,1,1)

local btnHide = Instance.new("TextButton", main) btnHide.Size = UDim2.fromOffset(30, 30) btnHide.Position = UDim2.fromOffset(225, 5) btnHide.Text = "–" btnHide.BackgroundColor3 = Color3.fromRGB(60,60,60) btnHide.TextColor3 = Color3.new(1,1,1)

local list = Instance.new("Frame", main) list.Size = UDim2.new(1, -20, 1, -60) list.Position = UDim2.fromOffset(10, 50) list.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", list) layout.Padding = UDim.new(0, 10)

local function makeToggle(text, cb) local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 40) b.Text = text .. " [OFF]" b.BackgroundColor3 = Color3.fromRGB(40,40,40) b.TextColor3 = Color3.new(1,1,1) b.Font = Enum.Font.Gotham b.TextSize = 14 local on = false b.MouseButton1Click:Connect(function() on = not on b.Text = text .. (on and " [ON]" or " [OFF]") cb(on) end) return b end

-- ================= AIMBOT / AIMLOCK ================= local function getClosestEnemy() local closest, dist = nil, math.huge local mousePos = UserInputService:GetMouseLocation() for _,plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local hum = plr.Character:FindFirstChildOfClass("Humanoid") if hum and hum.Health > 0 then local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position) if onScreen then local d = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude if d < dist then dist = d


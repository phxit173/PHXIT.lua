--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

print("PHXIT carregado")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "PHXIT_GUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, -20, 0, 50)
label.Position = UDim2.new(0, 10, 0, 70)
label.Text = "PHXIT carregou com sucesso"
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundTransparency = 1

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


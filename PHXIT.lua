--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- ===============================
-- PHXIT TRAINING SCRIPT (FULL)
-- ===============================

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- Estados
local AimbotEnabled = false
local AimlockEnabled = false
local ESPEnabled = false

-- Ajustes (UPGRADE)
local AimbotSmoothness = 0.18     -- suavidade do aimbot
local AimlockSmoothness = 1       -- travado real
local AimbotFOV = 180             -- raio de FOV (pixels)
local Deadzone = 6                -- zona morta (remove tremedeira)
local Prediction = 0.12           -- predição leve

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
Main.Size = UDim2.fromOffset(260, 230)
Main.Position = UDim2.fromScale(0.4, 0.3)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,35)
Title.Text = "PHXIT TRAINING"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Fechar
local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-35,0,2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
Close.TextColor3 = Color3.new(1,1,1)

-- Ocultar
local Min = Instance.new("TextButton", Title)
Min.Size = UDim2.fromOffset(30,30)
Min.Position = UDim2.new(1,-70,0,2)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(70,70,70)
Min.TextColor3 = Color3.new(1,1,1)

-- Reabrir
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.fromOffset(120,35)
OpenBtn.Position = UDim2.fromScale(0.02,0.5)
OpenBtn.Text = "ABRIR PHXIT"
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
OpenBtn.TextColor3 = Color3.new(1,1,1)

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
-- BOTÕES
-- ===============================
local function Toggle(text, y, callback)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.fromOffset(10,y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Text = text .. ": OFF"

	local state = false
	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

Toggle("AIMBOT", 50, function(v) AimbotEnabled = v end)
Toggle("AIMLOCK", 95, function(v) AimlockEnabled = v end)
Toggle("ESP", 140, function(v) ESPEnabled = v end)

-- ===============================
-- FUNÇÕES
-- ===============================

-- Checagem de parede (usada SÓ na mira)
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

-- Alvo mais próximo dentro do FOV (PLAYERS)
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
-- AIMBOT / AIMLOCK (UPGRADED)
-- ===============================
RunService.RenderStepped:Connect(function()
	local target, dist = GetClosestPlayerFOV()
	if not target then return end

	-- Deadzone evita tremedeira
	if dist < Deadzone then return end

	-- Predição leve
	local velocity = target.AssemblyLinearVelocity * Prediction
	local predictedPos = target.Position + velocity

	local camPos = Camera.CFrame.Position
	local cf = CFrame.new(camPos, predictedPos)

	if AimlockEnabled then
		Camera.CFrame = cf -- travado real
	elseif AimbotEnabled then
		Camera.CFrame = Camera.CFrame:Lerp(cf, AimbotSmoothness)
	end
end)

-- ===============================
-- ESP (ATRAVÉS DA PAREDE)
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

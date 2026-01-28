--[[ PHXIT - GUI NOVA (CHEAT) ]]---

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- ===============================
-- KEY SYSTEM
-- ===============================
local VALID_KEY = "PH.DS25567"
local ScriptLiberado = false
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3"

-- ===============================
-- SCREEN GUI
-- ===============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHXIT_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

-- ===============================
-- FUNÇÃO RGB BORDA
-- ===============================
local function RGBStroke(ui)
	local stroke = Instance.new("UIStroke", ui)
	stroke.Thickness = 1.5
	task.spawn(function()
		local h = 0
		while ui.Parent do
			h = (h + 1) % 360
			stroke.Color = Color3.fromHSV(h/360, 0.7, 1)
			task.wait(0.03)
		end
	end)
end

-- ===============================
-- FUNÇÃO DRAG
-- ===============================
local function MakeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ===============================
-- KEY GUI
-- ===============================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(300,230)
KeyFrame.Position = UDim2.fromScale(0.35,0.3)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,14)
RGBStroke(KeyFrame)
MakeDraggable(KeyFrame)

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.fromOffset(240,35)
Box.Position = UDim2.fromOffset(30,60)
Box.PlaceholderText = "Digite a key"
Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
Box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Box)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.fromOffset(240,35)
Confirm.Position = UDim2.fromOffset(30,110)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Confirm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Confirm)

local DiscordBtn = Instance.new("TextButton", KeyFrame)
DiscordBtn.Size = UDim2.fromOffset(240,30)
DiscordBtn.Position = UDim2.fromOffset(30,160)
DiscordBtn.Text = "COPIAR DISCORD"
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
DiscordBtn.TextColor3 = Color3.new(1,1,1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
Instance.new("UICorner", DiscordBtn)

DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
		DiscordBtn.Text = "COPIADO ✅"
	else
		DiscordBtn.Text = "NÃO SUPORTADO"
	end
	task.wait(1.2)
	DiscordBtn.Text = "COPIAR DISCORD"
end)

-- ===============================
-- GUI PRINCIPAL
-- ===============================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300,300)
Main.Position = UDim2.fromScale(0.05,0.35)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false
Instance.new("UICorner", Main)
RGBStroke(Main)
MakeDraggable(Main)

-- BOTÃO OCULTAR
local Hide = Instance.new("TextButton", Main)
Hide.Size = UDim2.fromOffset(30,30)
Hide.Position = UDim2.fromOffset(260,5)
Hide.Text = "-"
Hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", Hide)

-- BOTÃO FECHAR (X)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.fromOffset(225,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,40,40)
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- ===============================
-- MINI PH
-- ===============================
local Mini = Instance.new("Frame", ScreenGui)
Mini.Size = UDim2.fromOffset(60,60)
Mini.Position = UDim2.fromScale(0.05,0.5)
Mini.BackgroundColor3 = Color3.fromRGB(25,25,25)
Mini.Visible = false
Instance.new("UICorner", Mini)
RGBStroke(Mini)
MakeDraggable(Mini)

local PH = Instance.new("TextButton", Mini)
PH.Size = UDim2.new(1,0,1,0)
PH.Text = "PH"
PH.BackgroundTransparency = 1
PH.TextColor3 = Color3.new(1,1,1)
PH.Font = Enum.Font.GothamBold

-- ===============================
-- CHEAT ESTADOS
-- ===============================
local Aimbot = false
local AimLock = false
local ESP = false
local FOVInput = 180
local Smoothness = 0.15
local LockedTarget
local ESPs = {}

-- ===============================
-- FUNÇÕES CHEAT
-- ===============================
local function IsValidEnemy(plr)
	if plr == lp then return false end
	if not plr.Character then return false end
	local hum = plr.Character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	if plr.Character:FindFirstChildOfClass("ForceField") then return false end
	if lp.Team and plr.Team and lp.Team == plr.Team then return false end
	return true
end

local function HasWall(origin, targetPos, char)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {lp.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	local ray = workspace:Raycast(origin, targetPos - origin, params)
	return ray and not ray.Instance:IsDescendantOf(char)
end

local function GetClosestPlayer()
	local best, dist = nil, FOVInput
	for _,plr in ipairs(Players:GetPlayers()) do
		if IsValidEnemy(plr) and plr.Character and plr.Character:FindFirstChild("Head") then
			local pos, vis = Camera:WorldToViewportPoint(plr.Character.Head.Position)
			if vis then
				local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
				if mag < dist and not HasWall(Camera.CFrame.Position, plr.Character.Head.Position, plr.Character) then
					dist = mag
					best = plr
				end
			end
		end
	end
	return best
end

-- ===============================
-- ESP FUNCIONAL MELHORADO
-- ===============================
local function ApplyESP(plr)
	if not ESP or not plr.Character then return end
	if not IsValidEnemy(plr) then RemoveESP(plr) return end
	
	local highlight = ESPs[plr]
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "PHXIT_ESP"
		highlight.Adornee = plr.Character
		highlight.FillColor = Color3.fromRGB(255,0,0)
		highlight.FillTransparency = 0.4
		highlight.OutlineColor = Color3.fromRGB(255,255,255)
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = workspace
		ESPs[plr] = highlight
	else
		highlight.Adornee = plr.Character -- segue respawn
	end
end

function RemoveESP(plr)
	if ESPs[plr] then
		ESPs[plr]:Destroy()
		ESPs[plr] = nil
	end
end

-- ===============================
-- BOTÕES CHEAT
-- ===============================
local function CreateButton(text, y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.fromOffset(260,32)
	b.Position = UDim2.fromOffset(20,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local AimbotBtn = CreateButton("AIMBOT: OFF",60)
local AimLockBtn = CreateButton("AIMLOCK: OFF",110)
local ESPBtn = CreateButton("ESP: OFF",160)
local FOVBtn = CreateButton("FOV: "..FOVInput, 210)

AimbotBtn.MouseButton1Click:Connect(function()
	Aimbot = not Aimbot
	AimbotBtn.Text = Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

AimLockBtn.MouseButton1Click:Connect(function()
	AimLock = not AimLock
	LockedTarget = nil
	AimLockBtn.Text = AimLock and "AIMLOCK: ON" or "AIMLOCK: OFF"
end)

ESPBtn.MouseButton1Click:Connect(function()
	ESP = not ESP
	ESPBtn.Text = ESP and "ESP: ON" or "ESP: OFF"
end)

-- ===============================
-- BOTÕES FOV +/-
-- ===============================
local function CreateFOVButton(text, x, y, callback)
	local btn = Instance.new("TextButton", Main)
	btn.Size = UDim2.fromOffset(50,30)
	btn.Position = UDim2.fromOffset(x, y)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local FOVMinus = CreateFOVButton("-", 20, 250, function()
	if FOVInput > 10 then
		FOVInput = FOVInput - 10
		FOVBtn.Text = "FOV: "..FOVInput
	end
end)

local FOVPlus = CreateFOVButton("+", 90, 250, function()
	if FOVInput < 1000 then
		FOVInput = FOVInput + 10
		FOVBtn.Text = "FOV: "..FOVInput
	end
end)

FOVBtn.Text = "FOV: "..FOVInput

-- ===============================
-- FOV CIRCLE VISUAL
-- ===============================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Transparency = 0.3
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Filled = false

-- ===============================
-- LOOP PRINCIPAL
-- ===============================
RunService.RenderStepped:Connect(function()
	if not ScriptLiberado then return end

	-- Atualiza ESP constantemente
	if ESP then
		for _, plr in ipairs(Players:GetPlayers()) do
			ApplyESP(plr)
		end
	else
		for _, plr in ipairs(Players:GetPlayers()) do
			RemoveESP(plr)
		end
	end

	-- Atualiza círculo do FOV
	if Aimbot or AimLock then
		FOVCircle.Visible = true
		local centerX = Camera.ViewportSize.X/2
		local centerY = Camera.ViewportSize.Y/2
		FOVCircle.Position = Vector2.new(centerX, centerY)
		FOVCircle.Radius = FOVInput
	else
		FOVCircle.Visible = false
	end

	-- AIMBOT
	if Aimbot then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local head = target.Character.Head
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), Smoothness)
		end
	end

	-- AIMLOCK (não atravessa parede)
	if AimLock then
		if not LockedTarget or not IsValidEnemy(LockedTarget) or not LockedTarget.Character or not LockedTarget.Character:FindFirstChild("Head") or HasWall(Camera.CFrame.Position, LockedTarget.Character.Head.Position, LockedTarget.Character) then
			LockedTarget = GetClosestPlayer()
		end
		if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("Head") then
			local head = LockedTarget.Character.Head
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
		end
	end
end)

-- ===============================
-- KEY SYSTEM ACTIONS
-- ===============================
Confirm.MouseButton1Click:Connect(function()
	local input = Box.Text:gsub("%s+",""):upper()
	if input == VALID_KEY:upper() then
		ScriptLiberado = true
		KeyFrame.Visible = false
		Main.Visible = true
		Mini.Visible = false
	else
		Confirm.Text = "KEY INVÁLIDA"
		task.wait(1)
		Confirm.Text = "CONFIRMAR"
	end
end)

Hide.MouseButton1Click:Connect(function()
	Main.Visible = false
	Mini.Visible = true
end)

PH.MouseButton1Click:Connect(function()
	Mini.Visible = false
	Main.Visible = true
end)

-- ===============================
-- ESP RECONNECT RESPAWN
-- ===============================
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.1)
		if ESP then ApplyESP(plr) end
	end)
end)

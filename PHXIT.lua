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
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3" -- Link do Discord

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
-- FUNÇÃO DRAG (MOBILE + PC)
-- ===============================
local function MakeDraggable(frame)
	local dragging, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ===============================
-- KEY GUI
-- ===============================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(300,200)
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
Confirm.Position = UDim2.fromOffset(30,120)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Confirm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Confirm)

-- ===============================
-- GUI PRINCIPAL
-- ===============================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300,220)
Main.Position = UDim2.fromScale(0.05,0.35)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
RGBStroke(Main)
MakeDraggable(Main)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.fromOffset(260,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
Instance.new("UICorner", Close)

local Hide = Instance.new("TextButton", Main)
Hide.Size = UDim2.fromOffset(30,30)
Hide.Position = UDim2.fromOffset(225,5)
Hide.Text = "-"
Hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", Hide)

-- ===============================
-- BOTÃO DISCORD (COPIAR LINK)
-- ===============================
local DiscordBtn = Instance.new("TextButton", Main)
DiscordBtn.Size = UDim2.fromOffset(180, 30)
DiscordBtn.Position = UDim2.fromOffset(60, 180)
DiscordBtn.Text = "COPIAR DISCORD"
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
DiscordBtn.TextColor3 = Color3.new(1,1,1)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0,10)

DiscordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(DISCORD_LINK)
		DiscordBtn.Text = "COPIADO ✅"
	else
		DiscordBtn.Text = "NÃO SUPORTADO"
	end
	task.wait(1.5)
	DiscordBtn.Text = "COPIAR DISCORD"
end)

-- ===============================
-- MINI PH
-- ===============================
local Mini = Instance.new("Frame", ScreenGui)
Mini.Size = UDim2.fromOffset(60,60)
Mini.Position = UDim2.fromScale(0.05,0.5)
Mini.BackgroundColor3 = Color3.fromRGB(25,25,25)
Mini.Visible = false
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0,12)
RGBStroke(Mini)
MakeDraggable(Mini)

local PH = Instance.new("TextButton", Mini)
PH.Size = UDim2.new(1,0,1,0)
PH.Text = "PH"
PH.Font = Enum.Font.GothamBold
PH.TextSize = 16
PH.TextColor3 = Color3.new(1,1,1)
PH.BackgroundTransparency = 1

-- ===============================
-- AÇÕES
-- ===============================
Confirm.MouseButton1Click:Connect(function()
	if Box.Text == VALID_KEY then
		ScriptLiberado = true
		KeyFrame:Destroy()
		Main.Visible = true
	else
		Confirm.Text = "KEY INVÁLIDA"
		task.wait(1)
		Confirm.Text = "CONFIRMAR"
	end
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
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
-- ESTADOS
-- ===============================
local Aimbot = false
local AimLock = false
local ESP = false
local FOV = 180
local Smoothness = 0.15

-- ===============================
-- TEAM CHECK (ULTRA AVANÇADO)
-- ===============================
local function IsValidEnemy(plr)
	if not plr or plr == lp then return false end

	local char = plr.Character
	if not char then return false end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local head = char:FindFirstChild("Head")
	if not hum or not head then return false end
	if hum.Health <= 0 then return false end

	-- Spawn protection
	if char:FindFirstChildOfClass("ForceField") then
		return false
	end

	-- Friend check
	pcall(function()
		if plr:IsFriendsWith(lp.UserId) then
			return false
		end
	end)

	-- Jogos sem team
	if not lp.Team and not plr.Team then
		return true
	end

	-- Neutral
	if lp.Neutral or plr.Neutral then
		return true
	end

	-- Team diferente
	if lp.Team ~= plr.Team then
		return true
	end

	-- Backup (jogo bugado)
	if lp.TeamColor ~= plr.TeamColor then
		return true
	end

	return false
end

-- ===============================
-- FUNÇÕES DE CHEAT
-- ===============================

-- WALL CHECK (mantém mira sem atravessar paredes)
local function HasWall(origin, targetPos, targetChar)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {lp.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(origin, targetPos - origin, params)
	if result then
		return not result.Instance:IsDescendantOf(targetChar)
	end
	return false
end

-- AIMBOT / AIMLOCK
local LockedTargetInternal = nil

local function GetClosestPlayer()
	local closest, dist = nil, FOV
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
				if mag < dist and not HasWall(Camera.CFrame.Position, head.Position, plr.Character) then
					dist = mag
					closest = plr
				end
			end
		end
	end
	return closest
end

-- Atualiza alvo quando necessário
local function HookCharacterForAim(plr)
	plr.CharacterAdded:Connect(function()
		if AimLock then
			LockedTargetInternal = nil
		end
	end)
end

for _,plr in ipairs(Players:GetPlayers()) do
	HookCharacterForAim(plr)
end

Players.PlayerAdded:Connect(HookCharacterForAim)

-- ESP
local function ApplyESP(plr)
	if plr ~= lp and plr.Character and not plr.Character:FindFirstChild("PHXIT_ESP") then
		local h = Instance.new("Highlight", plr.Character)
		h.Name = "PHXIT_ESP"
		h.Adornee = plr.Character
		h.FillColor = Color3.fromRGB(255,0,0)
		h.OutlineColor = Color3.fromRGB(255,255,255)
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- sempre visível
	end
end

local function RemoveESP(plr)
	if plr.Character and plr.Character:FindFirstChild("PHXIT_ESP") then
		plr.Character.PHXIT_ESP:Destroy()
	end
end

local function ToggleAllESP(state)
	for _,plr in ipairs(Players:GetPlayers()) do
		if state then ApplyESP(plr) else RemoveESP(plr) end
	end
end

-- Atualiza ESP pra novos players/respawns
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if ESP then ApplyESP(plr) end
	end)
	if ESP then ApplyESP(plr) end
end)

lp.CharacterAdded:Connect(function()
	if ESP then ToggleAllESP(true) end
end)

-- ===============================
-- BOTÕES DA GUI PARA CHEAT
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
local AimLockBtn = CreateButton("AIMLOCK: OFF",100)
local ESPBtn = CreateButton("ESP: OFF",140)

AimbotBtn.MouseButton1Click:Connect(function()
	Aimbot = not Aimbot
	AimbotBtn.Text = Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

AimLockBtn.MouseButton1Click:Connect(function()
	AimLock = not AimLock
	LockedTargetInternal = nil
	AimLockBtn.Text = AimLock and "AIMLOCK: ON" or "AIMLOCK: OFF"
end)

ESPBtn.MouseButton1Click:Connect(function()
	ESP = not ESP
	ToggleAllESP(ESP)
	ESPBtn.Text = ESP and "ESP: ON" or "ESP: OFF"
end)

-- ===============================
-- LOOP PRINCIPAL
-- ===============================
RunService.RenderStepped:Connect(function()
	if not ScriptLiberado then return end

	-- AIMBOT
	if Aimbot then
		local target = GetClosestPlayer()
		if target and target.Character then
			local head = target.Character:FindFirstChild("Head")
			if head then
				Camera.CFrame = Camera.CFrame:Lerp(
					CFrame.new(Camera.CFrame.Position, head.Position),
					Smoothness
				)
			end
		end
	end

	-- AIMLOCK
	if AimLock then
		if not LockedTargetInternal
			or not LockedTargetInternal.Character
			or not LockedTargetInternal.Character:FindFirstChild("Head") then

			LockedTargetInternal = GetClosestPlayer()
		end
		if LockedTargetInternal and LockedTargetInternal.Character then
			local head = LockedTargetInternal.Character:FindFirstChild("Head")
			if head and not HasWall(Camera.CFrame.Position, head.Position, LockedTargetInternal.Character) then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
			end
		end
	end
end)

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
Main.Size = UDim2.fromOffset(300,260)
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
local FOV = 180
local Smoothness = 0.12
local LockedTarget

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
	local best, dist = nil, FOV
	for _,plr in ipairs(Players:GetPlayers()) do
		if IsValidEnemy(plr) and plr.Character:FindFirstChild("Head") then
			local pos, vis = Camera:WorldToViewportPoint(plr.Character.Head.Position)
			if vis then
				local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
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
-- ESP COMPLETO COM TEAM CHECK
-- ===============================
local ESPs = {} -- guarda os highlights criados

-- Função pra checar se é inimigo
local function IsEnemy(plr)
	if plr == lp then return false end
	if not plr.Character then return false end
	local hum = plr.Character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	if plr.Character:FindFirstChildOfClass("ForceField") then return false end

	-- Team check completo
	if lp.Team and plr.Team and lp.Team == plr.Team then
		return false
	end

	return true
end

-- Cria Highlight no player
local function ApplyESP(plr)
	if not ESP then return end
	if not IsEnemy(plr) then return end
	if not plr.Character then return end
	if ESPs[plr] then return end -- já existe

	local h = Instance.new("Highlight")
	h.Name = "PHXIT_ESP"
	h.Adornee = plr.Character
	h.FillColor = Color3.fromRGB(255,0,0)
	h.FillTransparency = 0.4
	h.OutlineColor = Color3.fromRGB(255,255,255)
	h.OutlineTransparency = 0
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = plr.Character

	ESPs[plr] = h
end

-- Remove Highlight do player
local function RemoveESP(plr)
	if ESPs[plr] then
		ESPs[plr]:Destroy()
		ESPs[plr] = nil
	end
end

-- Atualiza ESP de todos os players
local function RefreshESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if ESP then
			ApplyESP(plr)
		else
			RemoveESP(plr)
		end
	end
end

-- Atualiza ESP em respawn
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.5)
		if ESP then
			ApplyESP(plr)
		end
	end)
end)

lp.CharacterAdded:Connect(function()
	task.wait(0.5)
	if ESP then
		RefreshESP()
	end
end)

-- Botão ESP
ESPBtn.MouseButton1Click:Connect(function()
	ESP = not ESP
	ESPBtn.Text = ESP and "ESP: ON" or "ESP: OFF"
	RefreshESP()
end)

-- Remove ESP se player sair do jogo
Players.PlayerRemoving:Connect(function(plr)
	RemoveESP(plr)
end)

-- ===============================
-- BOTÕES CHEAT
-- ===============================
local function CreateButton(text,y)
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
-- LOOP PRINCIPAL
-- ===============================
RunService.RenderStepped:Connect(function()
	if not ScriptLiberado then return end

	if Aimbot then
		local t = GetClosestPlayer()
		if t and t.Character and t.Character:FindFirstChild("Head") then
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), Smoothness)
		end
	end

	if AimLock then
		if not LockedTarget or not IsValidEnemy(LockedTarget) then
			LockedTarget = GetClosestPlayer()
		end
		if LockedTarget and LockedTarget.Character then
			local head = LockedTarget.Character:FindFirstChild("Head")
			if head and not HasWall(Camera.CFrame.Position, head.Position, LockedTarget.Character) then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
			end
		end
	end
end)

-- ===============================
-- KEY SYSTEM ACTIONS
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

Hide.MouseButton1Click:Connect(function()
	Main.Visible = false
	Mini.Visible = true
end)

PH.MouseButton1Click:Connect(function()
	Mini.Visible = false
	Main.Visible = true
end)

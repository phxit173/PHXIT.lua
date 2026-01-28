--[[ PHXIT - GUI NOVA (AIMBOT, AIMLOCK E ESP FUNCIONANDO) ]]--

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ===============================
-- KEY SYSTEM
-- ===============================
local VALID_KEY = "PH.DS25567"
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3"
local ScriptLiberado = false

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
			h = (h + 0.5) % 360
			stroke.Color = Color3.fromHSV(h/360, 0.6, 1)
			task.wait(0.03)
		end
	end)
end

-- ===============================
-- KEY GUI
-- ===============================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(320,230)
KeyFrame.Position = UDim2.fromScale(0.35,0.3)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,14)
RGBStroke(KeyFrame)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1,0,0,40)
KeyTitle.Text = "PHXIT | KEY"
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.BackgroundTransparency = 1

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.fromOffset(260,36)
Box.Position = UDim2.fromOffset(30,70)
Box.PlaceholderText = "Digite a key"
Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
Box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Box).CornerRadius = UDim.new(0,10)

local Info = Instance.new("TextLabel", KeyFrame)
Info.Size = UDim2.new(1,0,0,30)
Info.Position = UDim2.fromOffset(0,110)
Info.Text = "Pegue a key no Discord"
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(200,200,200)
Info.BackgroundTransparency = 1

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.fromOffset(260,36)
Confirm.Position = UDim2.fromOffset(30,150)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Confirm.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,10)

-- ===============================
-- GUI PRINCIPAL
-- ===============================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300,220)
Main.Position = UDim2.fromScale(0.05,0.35)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
RGBStroke(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,35)
Title.Text = "PHXIT | PvP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- BOTÃO FECHAR
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.fromOffset(260,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- BOTÃO OCULTAR
local Hide = Instance.new("TextButton", Main)
Hide.Size = UDim2.fromOffset(30,30)
Hide.Position = UDim2.fromOffset(225,5)
Hide.Text = "-"
Hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", Hide).CornerRadius = UDim.new(1,0)

-- QUADRADO PH
local Mini = Instance.new("Frame", ScreenGui)
Mini.Size = UDim2.fromOffset(60,60)
Mini.Position = UDim2.fromScale(0.05,0.5)
Mini.BackgroundColor3 = Color3.fromRGB(25,25,25)
Mini.Visible = false
Mini.Active = true
Mini.Draggable = true
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0,12)
RGBStroke(Mini)

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
local LockedTarget = nil
local FOV = 180
local Smoothness = 0.15

-- ===============================
-- WALL CHECK
-- ===============================
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

-- ===============================
-- PLAYER MAIS PRÓXIMO
-- ===============================
local function GetClosestPlayer()
	local closest, dist = nil, FOV

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local mag = (Vector2.new(pos.X,pos.Y) -
					Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

				if mag < dist and not HasWall(Camera.CFrame.Position, head.Position, plr.Character) then
					dist = mag
					closest = plr
				end
			end
		end
	end
	return closest
end

-- ===============================
-- ESP
-- ===============================
local function ToggleESP(state)
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character then
			if state then
				if not plr.Character:FindFirstChild("PHXIT_ESP") then
					local h = Instance.new("Highlight", plr.Character)
					h.Name = "PHXIT_ESP"
					h.FillColor = Color3.fromRGB(255,0,0)
					h.OutlineColor = Color3.fromRGB(255,255,255)
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				end
			else
				if plr.Character:FindFirstChild("PHXIT_ESP") then
					plr.Character.PHXIT_ESP:Destroy()
				end
			end
		end
	end
end

-- ===============================
-- BOTÕES
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

local AimbotBtn = CreateButton("AIMBOT: OFF", 60)
local AimLockBtn = CreateButton("AIMLOCK: OFF", 100)
local ESPBtn = CreateButton("ESP: OFF", 140)

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
	ToggleESP(ESP)
	ESPBtn.Text = ESP and "ESP: ON" or "ESP: OFF"
end)

-- ===============================
-- LOOP PRINCIPAL
-- ===============================
RunService.RenderStepped:Connect(function()
	if Aimbot then
		local target = GetClosestPlayer()
		if target and target.Character then
			local head = target.Character.Head
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position, head.Position),
				Smoothness
			)
		end
	end

	if AimLock then
		if not LockedTarget then
			LockedTarget = GetClosestPlayer()
		end
		if LockedTarget and LockedTarget.Character then
			local head = LockedTarget.Character.Head
			if not HasWall(Camera.CFrame.Position, head.Position, LockedTarget.Character) then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
			end
		end
	end
end)

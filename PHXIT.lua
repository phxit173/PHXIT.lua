--[[ PHXIT - GUI BASE (SAFE / SEM AIM / SEM ESP) ]]

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- ===============================
-- CONFIG
-- ===============================
local VALID_KEY = "PH.DS25567"
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3"

-- ===============================
-- LIMPA GUI ANTIGA
-- ===============================
for _,v in ipairs(pg:GetChildren()) do
	if v.Name == "PHXIT_GUI" or v.Name == "PHXIT_KEY_GUI" then
		v:Destroy()
	end
end

-- ===============================
-- KEY GUI
-- ===============================
local KeyGui = Instance.new("ScreenGui", pg)
KeyGui.Name = "PHXIT_KEY_GUI"
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.fromOffset(0,0)
KeyFrame.Position = UDim2.fromScale(0.35,0.3)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.ClipsDescendants = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,18)

TweenService:Create(
	KeyFrame,
	TweenInfo.new(0.35),
	{Size = UDim2.fromOffset(320,260)}
):Play()

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHXIT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Position = UDim2.fromOffset(30,90)
KeyBox.Size = UDim2.fromOffset(260,40)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,12)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Position = UDim2.fromOffset(30,150)
Confirm.Size = UDim2.fromOffset(260,40)
Confirm.Text = "CONFIRMAR KEY"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 14
Confirm.TextColor3 = Color3.new(1,1,1)
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,12)

-- ===============================
-- MAIN GUI
-- ===============================
local function StartPHXIT()
	local Gui = Instance.new("ScreenGui", pg)
	Gui.Name = "PHXIT_GUI"
	Gui.ResetOnSpawn = false

	local Main = Instance.new("Frame", Gui)
	Main.Size = UDim2.fromOffset(300,200)
	Main.Position = UDim2.fromScale(0.35,0.3)
	Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Main.Active = true
	Main.Draggable = true
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

	local T = Instance.new("TextLabel", Main)
	T.Size = UDim2.new(1,0,1,0)
	T.Text = "PHXIT\nSCRIPT BASE OK ✅"
	T.Font = Enum.Font.GothamBold
	T.TextSize = 20
	T.TextColor3 = Color3.new(1,1,1)
	T.BackgroundTransparency = 1
end

-- ===============================
	-- SERVIÇOS
	-- ===============================
	local RunService = game:GetService("RunService")
	local UIS = game:GetService("UserInputService")
	local Camera = workspace.CurrentCamera

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
	-- FUNÇÃO WALL CHECK
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
	-- PEGAR PLAYER MAIS PRÓXIMO
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
	-- ESP VERMELHO
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
	local function CreateButton(text, yPos)
		local b = Instance.new("TextButton", Main)
		b.Size = UDim2.fromOffset(260,32)
		b.Position = UDim2.fromOffset(20,yPos)
		b.Text = text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 13
		b.TextColor3 = Color3.new(1,1,1)
		b.BackgroundColor3 = Color3.fromRGB(40,40,40)
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
		return b
	end

	local AimbotBtn = CreateButton("AIMBOT: OFF", 80)
	local AimLockBtn = CreateButton("AIMLOCK: OFF", 120)
	local ESPBtn = CreateButton("ESP: OFF", 160)

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

-- ===============================
-- CONFIRMAR KEY
-- ===============================
Confirm.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		KeyGui:Destroy()
		StartPHXIT()
	else
		Confirm.Text = "KEY INVÁLIDA"
		task.wait(1.2)
		Confirm.Text = "CONFIRMAR KEY"
	end
end)

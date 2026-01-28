--[[ PHXIT - AIMBOT / AIMLOCK / ESP ]]--

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===============================
-- KEY SYSTEM CONFIG
-- ===============================
local VALID_KEY = "PH.DS25567"
local DISCORD_LINK = "https://discord.gg/xE3xxzAcH3"

local ScriptLiberado = false

-- ===============================
-- KEY GUI
-- ===============================
local KeyGui = Instance.new("ScreenGui")
KeyGui.ResetOnSpawn = false
KeyGui.Parent = lp:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.fromOffset(320,220)
KeyFrame.Position = UDim2.fromScale(0.35,0.3)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,14)

local Stroke = Instance.new("UIStroke", KeyFrame)
Stroke.Thickness = 1.5

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHXIT | KEY"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.fromOffset(260,36)
Box.Position = UDim2.fromOffset(30,70)
Box.PlaceholderText = "Digite a key"
Box.Text = ""
Box.Font = Enum.Font.Gotham
Box.TextSize = 14
Box.TextColor3 = Color3.new(1,1,1)
Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", Box).CornerRadius = UDim.new(0,10)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.fromOffset(260,36)
Confirm.Position = UDim2.fromOffset(30,120)
Confirm.Text = "CONFIRMAR"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 14
Confirm.TextColor3 = Color3.new(1,1,1)
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,10)

local Info = Instance.new("TextLabel", KeyFrame)
Info.Size = UDim2.new(1,0,0,30)
Info.Position = UDim2.fromOffset(0,170)
Info.Text = "Pegue a key no Discord"
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(200,200,200)
Info.BackgroundTransparency = 1

Confirm.MouseButton1Click:Connect(function()
	if Box.Text == VALID_KEY then
		ScriptLiberado = true
		KeyGui:Destroy()
		Main.Visible = true
	else
		Confirm.Text = "KEY INVÁLIDA"
		task.wait(1)
		Confirm.Text = "CONFIRMAR"
	end
end)

Main.Visible = false

RunService.RenderStepped:Connect(function()
	if not ScriptLiberado then return end

-- ===============================
-- GUI
-- ===============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHXIT_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300, 220)
Main.Position = UDim2.fromScale(0.05, 0.35)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHXIT | PvP"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

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

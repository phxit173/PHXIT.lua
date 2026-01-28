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

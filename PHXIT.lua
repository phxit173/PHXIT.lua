--[[ PHXIT - PvP Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- ===============================
-- SERVIÇOS
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

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

local Stroke = Instance.new("UIStroke", KeyFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255,0,0)
Stroke.Transparency = 0.6

TweenService:Create(
	KeyFrame,
	TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Size = UDim2.fromOffset(320,260)}
):Play()

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "PHXIT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local Sub = Instance.new("TextLabel", KeyFrame)
Sub.Position = UDim2.fromOffset(0,40)
Sub.Size = UDim2.new(1,0,0,20)
Sub.Text = "Pegue a key no Discord"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 12
Sub.TextColor3 = Color3.fromRGB(170,170,170)
Sub.BackgroundTransparency = 1

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
Confirm.Position = UDim2.fromOffset(30,140)
Confirm.Size = UDim2.fromOffset(260,40)
Confirm.Text = "CONFIRMAR KEY"
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 14
Confirm.TextColor3 = Color3.new(1,1,1)
Confirm.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,12)

local Discord = Instance.new("TextButton", KeyFrame)
Discord.Position = UDim2.fromOffset(30,190)
Discord.Size = UDim2.fromOffset(260,35)
Discord.Text = "ENTRAR NO DISCORD"
Discord.Font = Enum.Font.Gotham
Discord.TextSize = 13
Discord.TextColor3 = Color3.fromRGB(255,0,0)
Discord.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", Discord).CornerRadius = UDim.new(0,12)

Discord.MouseButton1Click:Connect(function()
	setclipboard(DISCORD_LINK)
	Discord.Text = "LINK COPIADO!"
	task.wait(1.5)
	Discord.Text = "ENTRAR NO DISCORD"
end)

-- ===============================
-- SCRIPT PRINCIPAL
-- ===============================
local function StartPHXIT()
	local ScreenGui = Instance.new("ScreenGui", pg)
	ScreenGui.Name = "PHXIT_GUI"
	ScreenGui.ResetOnSpawn = false

	-- Estados
	local AimbotEnabled = false
	local AimlockEnabled = false
	local ESPEnabled = false

	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.fromOffset(300,280)
	Main.Position = UDim2.fromScale(0.35,0.25)
	Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = true
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1,0,0,40)
	Title.Text = "PHXIT"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.TextColor3 = Color3.new(1,1,1)
	Title.BackgroundTransparency = 1

	-- Toggle generator
	local function Toggle(text, posY, callback)
		local btn = Instance.new("TextButton", Main)
		btn.Size = UDim2.new(1,-20,0,40)
		btn.Position = UDim2.fromOffset(10,posY)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Text = text..": OFF"
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = text..": "..(state and "ON" or "OFF")
			callback(state)
		end)
	end

	Toggle("AIMBOT", 80, function(v) AimbotEnabled = v end)
	Toggle("AIMLOCK", 140, function(v) AimlockEnabled = v end)
	Toggle("ESP", 200, function(v) ESPEnabled = v end)

-- ===============================
-- AIMBOT / AIMLOCK (TOP TIER)
-- ===============================
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled and not AimlockEnabled then return end

    local target, dist = GetClosestPlayerFOV()
    if not target then return end

    local velocity = target.AssemblyLinearVelocity * Prediction
    local predictedPos = target.Position + velocity

    local camPos = Camera.CFrame.Position
    local targetCF = CFrame.new(camPos, predictedPos)

    -- 🔒 AIMLOCK REAL (prioridade máxima)
    if AimlockEnabled then
        Camera.CFrame = targetCF
        return
    end

    -- 🎯 AIMBOT FORTE E LIMPO
    if AimbotEnabled then
        if dist < Deadzone then return end
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, AimbotSmoothness)
    end
end)
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
		task.wait(1.5)
		Confirm.Text = "CONFIRMAR KEY"
	end
end)

--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

-- ===============================
-- PHXIT TRAINING SCRIPT (SAFE)
-- ===============================

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- Estados
local AimlockEnabled = false
local AimbotEnabled = false
local ESPEnabled = false
local Smoothness = 0.15

-- Limpar GUI antiga
local playerGui = lp:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("PHXIT_GUI") then
    playerGui.PHXIT_GUI:Destroy()
end

-- ===============================
-- GUI
-- ===============================
local ScreenGui = Instance.new("ScreenGui", playerGui)
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

-- Botão fechar
local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-35,0,2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,50,50)
Close.TextColor3 = Color3.new(1,1,1)

-- Botão ocultar
local Min = Instance.new("TextButton", Title)
Min.Size = UDim2.fromOffset(30,30)
Min.Position = UDim2.new(1,-70,0,2)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(70,70,70)
Min.TextColor3 = Color3.new(1,1,1)

-- Botão reabrir
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
-- BOTÕES ON/OFF
-- ===============================
local function ToggleButton(text, posY, callback)
	local btn = Instance.new("TextButton", Main)
	btn.Size = UDim2.new(1,-20,0,35)
	btn.Position = UDim2.fromOffset(10,posY)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text .. ": OFF"

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

ToggleButton("AIMBOT", 50, function(v) AimbotEnabled = v end)
ToggleButton("AIMLOCK", 95, function(v) AimlockEnabled = v end)
ToggleButton("ESP", 140, function(v) ESPEnabled = v end)

-- ===============================
-- FUNÇÕES DE TREINO
-- ===============================

-- Pega alvo mais próximo (NPC ou boneco de treino)
local function GetClosestTarget()
	local closest, dist = nil, math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, m in pairs(workspace:GetChildren()) do
		if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") then
			if m ~= lp.Character and m.Humanoid.Health > 0 then
				local screenPos, onScreen = Camera:WorldToViewportPoint(m.HumanoidRootPart.Position)
				if onScreen then
					local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
					if mag < dist then
						dist = mag
						closest = m
					end
				end
			end
		end
	end
	return closest
end

-- AIMBOT / AIMLOCK
RunService.RenderStepped:Connect(function()
	local target = GetClosestTarget()
	if not target then return end

	if AimbotEnabled or AimlockEnabled then
		local hrp = target.HumanoidRootPart
		local camPos = Camera.CFrame.Position
		local cf = CFrame.new(camPos, hrp.Position)
		Camera.CFrame = Camera.CFrame:Lerp(cf, Smoothness)
	end
end)

local function HasLineOfSight(targetPart)
	if not targetPart then return false end

	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {lp.Character}
	params.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, params)

	if result then
		-- Se o que o ray acertou NÃO for parte do alvo, tem parede
		if not result.Instance:IsDescendantOf(targetPart.Parent) then
			return false
		end
	end

	return true
end

if HasLineOfSight(target.HumanoidRootPart) then
	-- pode mirar
else
	-- ignora esse alvo
end

-- Simple Camera Assist (SAFE)
-- Serve pra estabilizar a mira (sem travar em alvo)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local enabled = false
local smoothness = 0.15 -- quanto menor, mais suave

local currentCF = Camera.CFrame

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then
		enabled = not enabled
		warn("Camera Assist:", enabled)
	end
end)

RunService.RenderStepped:Connect(function()
	if not enabled then return end
	
	currentCF = currentCF:Lerp(Camera.CFrame, smoothness)
	Camera.CFrame = currentCF
end)

-- ===============================
-- ESP SIMPLES
-- ===============================
RunService.RenderStepped:Connect(function()
    for _, m in pairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
            local hrp = m:FindFirstChild("HumanoidRootPart")
            if ESPEnabled then
                if not m:FindFirstChild("PHXIT_HL") then
                    local hl = Instance.new("Highlight", m)
                    hl.Name = "PHXIT_HL"
                    hl.FillColor = Color3.fromRGB(255,0,0)
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            else
                if m:FindFirstChild("PHXIT_HL") then
                    m.PHXIT_HL:Destroy()
                end
            end
        end
    end
end)

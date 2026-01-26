--[[ PHXIT - PvP Test Script (DELTA EXECUTOR) GG pvp script Script client-side ]]

print("PHXIT carregado")

--// SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// VARIÁVEIS
local AimlockEnabled = false
local AimbotEnabled = false
local ESPEnabled = false
local AimSmoothness = 0.15

--// FUNÇÃO: PEGAR NPC MAIS PRÓXIMO DO MOUSE
local function GetClosestNPC()
    local closest
    local shortest = math.huge

    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model")
        and model:FindFirstChild("Humanoid")
        and model:FindFirstChild("HumanoidRootPart") then

            local hrp = model.HumanoidRootPart
            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)

            if onscreen then
                local mousePos = Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)
                local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude

                if dist < shortest then
                    shortest = dist
                    closest = model
                end
            end
        end
    end

    return closest
end

--// AIMLOCK / AIMBOT
RunService.RenderStepped:Connect(function()
    local target = GetClosestNPC()
    if target and target:FindFirstChild("HumanoidRootPart") then
        local hrp = target.HumanoidRootPart
        local camCFrame = Camera.CFrame
        local newCFrame = CFrame.new(camCFrame.Position, hrp.Position)

        if AimlockEnabled then
            Camera.CFrame = newCFrame
        elseif AimbotEnabled then
            Camera.CFrame = camCFrame:Lerp(newCFrame, AimSmoothness)
        end
    end
end)

--// ESP NPC
local ESPFolder = Instance.new("Folder", workspace)
ESPFolder.Name = "NPC_ESP"

local function CreateESP(npc)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = npc:GetExtentsSize()
    box.Adornee = npc
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = ESPFolder
end

RunService.RenderStepped:Connect(function()
    ESPFolder:ClearAllChildren()
    if not ESPEnabled then return end

    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model")
        and model:FindFirstChild("Humanoid")
        and model:FindFirstChild("HumanoidRootPart") then
            CreateESP(model)
        end
    end
end)

--// GUI
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "TrainingGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function MakeButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

MakeButton("Aimlock", 10, function()
    AimlockEnabled = not AimlockEnabled
end)

MakeButton("Aimbot", 50, function()
    AimbotEnabled = not AimbotEnabled
end)

MakeButton("ESP NPC", 90, function()
    ESPEnabled = not ESPEnabled
end)

MakeButton("Ocultar", 130, function()
    frame.Visible = not frame.Visible
end)

MakeButton("Fechar", 170, function()
    gui:Destroy()
end)

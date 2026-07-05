local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------
-- HACKER SKIN SYSTEM
------------------------------------------------
local function processCharacter(char)
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    for _, item in pairs(char:GetDescendants()) do
        if item:IsA("Accessory") or 
           item:IsA("Shirt") or 
           item:IsA("Pants") or 
           item:IsA("CharacterMesh") or 
           item:IsA("FaceControls") or 
           item:IsA("Decal") or
           item:IsA("ShirtGraphic") then
            item:Destroy()
        end
    end

    local randomColor = BrickColor.Random()
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = randomColor
        end
    end
end

local function monitorPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then processCharacter(player.Character) end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            processCharacter(char)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        processCharacter(char)
    end)
end)

monitorPlayers()

------------------------------------------------
-- GUI & UI ELEMENTS
------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGuiContainer"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- POKAL-ABDECKUNG
local coverFrame = Instance.new("Frame")
coverFrame.Name = "SubscribeCover"
coverFrame.Position = UDim2.new(0, 10, 0, 245) 
coverFrame.Size = UDim2.new(0, 150, 0, 50)
coverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
coverFrame.BorderSizePixel = 0
coverFrame.Parent = screenGui
Instance.new("UICorner", coverFrame).CornerRadius = UDim.new(0, 8)

local coverLabel = Instance.new("TextLabel", coverFrame)
coverLabel.Size = UDim2.new(1, 0, 1, 0)
coverLabel.Text = "Subscribe"
coverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coverLabel.Font = Enum.Font.GothamBold 
coverLabel.TextSize = 24
coverLabel.BackgroundTransparency = 1

-- SPEED-ABDECKUNG
local speedCover = Instance.new("Frame")
speedCover.Name = "SpeedCover"
speedCover.Position = UDim2.new(1, -180, 0, 280) 
speedCover.Size = UDim2.new(0, 160, 0, 130)
speedCover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedCover.BorderSizePixel = 0
speedCover.Parent = screenGui
Instance.new("UICorner", speedCover).CornerRadius = UDim.new(0, 8)

-- FAKE SCOREBOARD
local scoreboardFrame = Instance.new("Frame")
scoreboardFrame.Name = "FakeScoreboardUI"
scoreboardFrame.AnchorPoint = Vector2.new(1, 0)
scoreboardFrame.Position = UDim2.new(1, -15, 0, 15)
scoreboardFrame.Size = UDim2.new(0, 420, 0, 100)
scoreboardFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
scoreboardFrame.BackgroundTransparency = 0.2
scoreboardFrame.BorderSizePixel = 0
scoreboardFrame.Parent = screenGui
Instance.new("UICorner", scoreboardFrame).CornerRadius = UDim.new(0, 4)

local header = Instance.new("TextLabel", scoreboardFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.Text = "Personen             Speed            Rebirths      Level      Wins"
header.TextColor3 = Color3.fromRGB(180, 180, 180)
header.Font = Enum.Font.Gotham
header.TextSize = 13
header.BackgroundTransparency = 1

local entry = Instance.new("TextLabel", scoreboardFrame)
entry.Size = UDim2.new(1, 0, 0, 40)
entry.Position = UDim2.new(0, 0, 0, 45)
entry.Text = "Im_Timeee           826.6k              0               27        2 936"
entry.TextColor3 = Color3.fromRGB(255, 255, 255)
entry.Font = Enum.Font.GothamBold
entry.TextSize = 14
entry.BackgroundTransparency = 1

------------------------------------------------
-- DEV MENU
------------------------------------------------
local devFrame = Instance.new("Frame")
devFrame.Name = "DevMenu"
devFrame.Size = UDim2.new(0, 330, 0, 200)
devFrame.Position = UDim2.new(0.5, -165, 0.5, -150)
devFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
devFrame.BorderSizePixel = 0
devFrame.Parent = screenGui
Instance.new("UICorner", devFrame).CornerRadius = UDim.new(0, 12)

local top = Instance.new("Frame", devFrame)
top.Size = UDim2.new(1, 0, 0, 35)
top.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
top.BorderSizePixel = 0

-- Dragging Logic
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = devFrame.Position
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        devFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local autoTP, flying = false, false
local AUTO_POS = CFrame.new(-37.69, 197.02, -824.37)
local flySpeed, flySmooth, flyBV = 85, 0.18, nil

local function btn(text, y)
    local b = Instance.new("TextButton", devFrame)
    b.Size = UDim2.new(0.9, 0, 0, 40); b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham; b.TextSize = 14; b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local autoBtn = btn("Auto TP: OFF", 45)
local flyBtn = btn("Camera Fly: OFF", 90)

autoBtn.MouseButton1Click:Connect(function() autoTP = not autoTP; autoBtn.Text = autoTP and "Auto TP: ON" or "Auto TP: OFF" end)

flyBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum, hrp = char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    flying = not flying
    flyBtn.Text = flying and "Camera Fly: ON" or "Camera Fly: OFF"
    if flying then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9); flyBV.Velocity = Vector3.zero
    else
        if flyBV then flyBV:Destroy() end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

------------------------------------------------
-- UPDATES
------------------------------------------------
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp, hum = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    if autoTP then 
        if (hrp.Position - AUTO_POS.Position).Magnitude > 5 then
            hrp.CFrame = AUTO_POS 
        end
    end
    
    if flying and flyBV then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
        
        if dir.Magnitude > 0 then
            flyBV.Velocity = flyBV.Velocity:Lerp(dir.Unit * flySpeed, flySmooth)
        else
            flyBV.Velocity = flyBV.Velocity:Lerp(Vector3.zero, flySmooth)
        end
    end
end)

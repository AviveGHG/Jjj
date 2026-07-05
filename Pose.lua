-- Warten, bis der Spieler geladen ist
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Sicherstellen, dass die PlayerGui da ist
local playerGui = Player:WaitForChild("PlayerGui", 10)

-- Altes Menü löschen, falls es noch da ist
local oldGui = playerGui:FindFirstChild("DeltaCopyMenu")
if oldGui then oldGui:Destroy() end

-- ScreenGui erstellen (Direkt in CoreGui oder PlayerGui für Executors)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaCopyMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Button erstellen
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 180, 0, 45)
copyButton.Position = UDim2.new(0.5, -90, 0.15, 0) -- Schön mittig oben
copyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
copyButton.TextColor3 = Color3.fromRGB(0, 255, 150) -- Cooler Delta-Grün-Look
copyButton.TextSize = 16
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Text = "Copy Position"
copyButton.Active = true
copyButton.Draggable = true -- Du kannst den Button auf dem Bildschirm verschieben!
copyButton.Parent = screenGui

-- Abrundung für den Button
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = copyButton

-- Funktion zum Kopieren der Koordinaten
local function copyPosition()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        -- Formatieren auf 2 Dezimalstellen
        local posString = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
        
        -- Delta-Spezifische Funktion zum direkten Kopieren in den PC-Zwischenspeicher!
        if setclipboard then
            setclipboard(posString)
            copyButton.Text = "Copied! ✅"
            task.wait(1.5)
            copyButton.Text = "Copy Position"
        else
            -- Fallback, falls setclipboard fehlschlägt
            copyButton.Text = "Error (No Clipboard)"
        end
    end
end

-- Button Klick verbinden
copyButton.MouseButton1Click:Connect(copyPosition)

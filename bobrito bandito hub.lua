local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Variables pour gérer le vol
local flying = false
local flySpeed = 100  -- Vitesse du vol
local bodyVelocity -- Déclaration de la variable

-- Fonction pour démarrer le vol
local function startFlying()
    if flying then return end
    
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)  -- Force maximale
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)  -- Initialisation de la vitesse du vol
    bodyVelocity.Parent = humanoidRootPart

    humanoid.PlatformStand = true
end

-- Fonction pour arrêter le vol
local function stopFlying()
    if not flying then return end

    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()  -- Supprimer le BodyVelocity pour arrêter le vol
        bodyVelocity = nil  -- Réinitialiser la variable
    end
    humanoid.PlatformStand = false  -- Rétablir le contrôle normal du personnage
end

-- Fonction de mise à jour du vol
local function updateFlight()
    if flying then
        -- Détection des touches pour le mouvement en vol
        local direction = Vector3.new(0, 0, 0)

        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)  -- Voler vers le haut
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)  -- Voler vers le bas
        end

        -- Appliquer la direction au BodyVelocity
        bodyVelocity.Velocity = direction * flySpeed

        -- Rotation du personnage pour suivre la caméra
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + camera.CFrame.LookVector)
    end
end

-- Fonction pour arrêter le mouvement lorsque l'utilisateur ne bouge plus
local function updateMovement()
    if not flying then
        if humanoidRootPart.Velocity.Magnitude < 0.1 then
            humanoidRootPart.Velocity = Vector3.zero  -- Arrêter le mouvement
        end
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BobritoBanditoGui"  -- Nom du script modifié
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- 🔘 Toggle GUI
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Afficher GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texte blanc
toggleButton.TextSize = 14
toggleButton.Active = true  -- Activer le bouton pour le rendre cliquable
toggleButton.Draggable = true  -- Activer le déplacement (personnalisé avec script plus bas)

-- 🖼️ Main Frame
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Position = UDim2.new(0.5, -150, 0.5, -170)
frame.Size = UDim2.new(0, 300, 0, 340)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)  -- Bordure blanche
frame.Visible = false

-- 🏷️ Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = frame
titleLabel.Text = "Bobrito Bandito Hub"  -- Changer "Pet Go Hub" en "Bobrito Bandito Hub"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texte blanc
titleLabel.TextSize = 18
titleLabel.TextScaled = true

-- 📂 Tabs Header
local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Position = UDim2.new(0, 0, 0, 30)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir

local function createTabButton(name, posX)
	local button = Instance.new("TextButton")
	button.Parent = tabBar
	button.Text = name
	button.Size = UDim2.new(0, 150, 1, 0)
	button.Position = UDim2.new(0, posX, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
	button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texte blanc
	button.TextSize = 14
	return button
end

-- 🧱 Tab Frames (Main + Misc)
local mainTab = Instance.new("Frame")
mainTab.Parent = frame
mainTab.Position = UDim2.new(0, 0, 0, 60)
mainTab.Size = UDim2.new(1, 0, 1, -60)
mainTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir

local miscTab = Instance.new("Frame")
miscTab.Parent = frame
miscTab.Position = UDim2.new(0, 0, 0, 60)
miscTab.Size = UDim2.new(1, 0, 1, -60)
miscTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
miscTab.Visible = false

-- 🛠️ Dev Signature
local creatorLabel = Instance.new("TextLabel")
creatorLabel.Parent = miscTab
creatorLabel.Size = UDim2.new(1, 0, 1, 0)
creatorLabel.Text = "🛠️ Created by : Anakondax & Traydox 🛠️"
creatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texte blanc
creatorLabel.BackgroundTransparency = 1
creatorLabel.TextScaled = false
creatorLabel.TextSize = 16
creatorLabel.TextWrapped = true
creatorLabel.TextYAlignment = Enum.TextYAlignment.Center
creatorLabel.TextXAlignment = Enum.TextXAlignment.Center

-- 📌 Onglets logiques
local mainBtn = createTabButton("Main", 0)
local miscBtn = createTabButton("Misc", 150)

mainBtn.MouseButton1Click:Connect(function()
	mainTab.Visible = true
	miscTab.Visible = false
end)

miscBtn.MouseButton1Click:Connect(function()
	mainTab.Visible = false
	miscTab.Visible = true
end)

-- 🔘 Fly Toggle button dans Main Tab
local flyButton = Instance.new("TextButton")
flyButton.Parent = mainTab
flyButton.Size = UDim2.new(0, 150, 0, 30)
flyButton.Position = UDim2.new(0, 75, 0, 30)
flyButton.Text = "Activer Vol"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Fond noir
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Texte blanc
flyButton.TextSize = 14

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()  -- Si déjà en vol, on arrête le vol
        flyButton.Text = "Activer Vol"  -- Changer le texte du bouton
    else
        startFlying()  -- Si pas en vol, on démarre le vol
        flyButton.Text = "Désactiver Vol"  -- Changer le texte du bouton
    end
end)

-- 🔘 Toggle GUI
toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Cacher GUI" or "Afficher GUI"
end)

-- Mise à jour continue du vol et de l'arrêt du mouvement
runService.Heartbeat:Connect(function()
    updateFlight()  -- Mettre à jour le vol
    updateMovement()  -- Mettre à jour le mouvement
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Variables pour gérer le vol
local flying = false
local flySpeed = 100
local bodyVelocity

local function resetCharacterReferences()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(resetCharacterReferences)

-- Fonction pour démarrer le vol
local function startFlying()
	if flying then return end
	flying = true
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = humanoidRootPart
	humanoid.PlatformStand = true
end

local function stopFlying()
	if not flying then return end
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	humanoid.PlatformStand = false
end

local function updateFlight()
	if flying then
		local direction = Vector3.new(0, 0, 0)
		if userInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
		if userInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
		if userInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
		if userInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
		if userInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
		if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0, 1, 0) end
		bodyVelocity.Velocity = direction * flySpeed
		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + camera.CFrame.LookVector)
	end
end

local function updateMovement()
	if not flying and humanoidRootPart.Velocity.Magnitude < 0.1 then
		humanoidRootPart.Velocity = Vector3.zero
	end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BobritoBanditoGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Afficher GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Active = true
toggleButton.Draggable = true

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Position = UDim2.new(0.5, -150, 0.5, -170)
frame.Size = UDim2.new(0, 300, 0, 340)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Visible = false

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = frame
titleLabel.Text = "Bobrito Bandito Hub"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextScaled = true

local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Position = UDim2.new(0, 0, 0, 30)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local function createTabButton(name, posX)
	local button = Instance.new("TextButton")
	button.Parent = tabBar
	button.Text = name
	button.Size = UDim2.new(0, 100, 1, 0)
	button.Position = UDim2.new(0, posX, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	return button
end

local mainTab = Instance.new("Frame")
mainTab.Parent = frame
mainTab.Position = UDim2.new(0, 0, 0, 60)
mainTab.Size = UDim2.new(1, 0, 1, -60)
mainTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local playerTab = Instance.new("Frame")
playerTab.Parent = frame
playerTab.Position = UDim2.new(0, 0, 0, 60)
playerTab.Size = UDim2.new(1, 0, 1, -60)
playerTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playerTab.Visible = false

local miscTab = Instance.new("Frame")
miscTab.Parent = frame
miscTab.Position = UDim2.new(0, 0, 0, 60)
miscTab.Size = UDim2.new(1, 0, 1, -60)
miscTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miscTab.Visible = false

-- Onglets
local mainBtn = createTabButton("Main", 0)
local playerBtn = createTabButton("Player", 100)
local miscBtn = createTabButton("Misc", 200)

mainBtn.MouseButton1Click:Connect(function()
	mainTab.Visible = true
	playerTab.Visible = false
	miscTab.Visible = false
end)

playerBtn.MouseButton1Click:Connect(function()
	mainTab.Visible = false
	playerTab.Visible = true
	miscTab.Visible = false
end)

miscBtn.MouseButton1Click:Connect(function()
	mainTab.Visible = false
	playerTab.Visible = false
	miscTab.Visible = true
end)

-- WalkSpeed
local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Parent = playerTab
walkSpeedLabel.Text = "Walk Speed:"
walkSpeedLabel.Position = UDim2.new(0, 10, 0, 10)
walkSpeedLabel.Size = UDim2.new(0, 90, 0, 30)
walkSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
walkSpeedLabel.BackgroundTransparency = 1

local walkSpeedBox = Instance.new("TextBox")
walkSpeedBox.Parent = playerTab
walkSpeedBox.Position = UDim2.new(0, 100, 0, 10)
walkSpeedBox.Size = UDim2.new(0, 70, 0, 30)
walkSpeedBox.PlaceholderText = "16"
walkSpeedBox.Text = ""
walkSpeedBox.TextColor3 = Color3.new(1, 1, 1)
walkSpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

walkSpeedBox.FocusLost:Connect(function()
	local value = tonumber(walkSpeedBox.Text)
	if value then
		humanoid.WalkSpeed = value
	end
end)

-- JumpPower
local jumpPowerLabel = Instance.new("TextLabel")
jumpPowerLabel.Parent = playerTab
jumpPowerLabel.Text = "Jump Power:"
jumpPowerLabel.Position = UDim2.new(0, 10, 0, 50)
jumpPowerLabel.Size = UDim2.new(0, 90, 0, 30)
jumpPowerLabel.TextColor3 = Color3.new(1, 1, 1)
jumpPowerLabel.BackgroundTransparency = 1

local jumpPowerBox = Instance.new("TextBox")
jumpPowerBox.Parent = playerTab
jumpPowerBox.Position = UDim2.new(0, 100, 0, 50)
jumpPowerBox.Size = UDim2.new(0, 70, 0, 30)
jumpPowerBox.PlaceholderText = "50"
jumpPowerBox.Text = ""
jumpPowerBox.TextColor3 = Color3.new(1, 1, 1)
jumpPowerBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

jumpPowerBox.FocusLost:Connect(function()
	local value = tonumber(jumpPowerBox.Text)
	if value then
		humanoid.JumpPower = value
	end
end)

-- Gravity
local gravityLabel = Instance.new("TextLabel")
gravityLabel.Parent = playerTab
gravityLabel.Text = "Gravity:"
gravityLabel.Position = UDim2.new(0, 10, 0, 90)
gravityLabel.Size = UDim2.new(0, 90, 0, 30)
gravityLabel.TextColor3 = Color3.new(1, 1, 1)
gravityLabel.BackgroundTransparency = 1

local gravityBox = Instance.new("TextBox")
gravityBox.Parent = playerTab
gravityBox.Position = UDim2.new(0, 100, 0, 90)
gravityBox.Size = UDim2.new(0, 70, 0, 30)
gravityBox.PlaceholderText = "196.2"
gravityBox.Text = ""
gravityBox.TextColor3 = Color3.new(1, 1, 1)
gravityBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

gravityBox.FocusLost:Connect(function()
	local value = tonumber(gravityBox.Text)
	if value then
		workspace.Gravity = value
	end
end)

-- ESP Toggle
local espButton = Instance.new("TextButton")
espButton.Parent = mainTab
espButton.Size = UDim2.new(0, 150, 0, 30)
espButton.Position = UDim2.new(0, 75, 0, 70)
espButton.Text = "Activer ESP"
espButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 14

local espEnabled = false
local espConnections = {}
local playerAddedConnection -- Variable pour stocker la connexion PlayerAdded

local function createESP(p)
	if p == player then return end
	local char = p.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart
	if hrp:FindFirstChild("ESPBox") then return end

	local box = Instance.new("BillboardGui", hrp)
	box.Name = "ESPBox"
	box.Adornee = hrp
	box.Size = UDim2.new(0, 100, 0, 20)
	box.AlwaysOnTop = true
	box.StudsOffset = Vector3.new(0, 3, 0)

	local label = Instance.new("TextLabel", box)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = p.Name
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
end

local function removeESP(p)
	local char = p.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local box = char.HumanoidRootPart:FindFirstChild("ESPBox")
		if box then box:Destroy() end
	end
end

local function toggleESP(state)
	if state then
		-- Activer ESP pour tous les joueurs déjà présents
		for _, p in ipairs(game.Players:GetPlayers()) do
			createESP(p)
			espConnections[p] = p.CharacterAdded:Connect(function()
				p.Character:WaitForChild("HumanoidRootPart")
				createESP(p)
			end)
		end

		-- Ajouter l'ESP pour les nouveaux joueurs qui rejoignent
		playerAddedConnection = game.Players.PlayerAdded:Connect(function(p)
			espConnections[p] = p.CharacterAdded:Connect(function()
				p.Character:WaitForChild("HumanoidRootPart")
				createESP(p)
			end)
		end)
	else
		-- Désactiver ESP pour tous les joueurs
		for _, p in ipairs(game.Players:GetPlayers()) do
			removeESP(p)
			if espConnections[p] then
				espConnections[p]:Disconnect()
				espConnections[p] = nil
			end
		end

		-- Supprimer les connexions pour les nouveaux joueurs
		if playerAddedConnection then
			playerAddedConnection:Disconnect()
			playerAddedConnection = nil
		end
	end
end

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espButton.Text = espEnabled and "Désactiver ESP" or "Activer ESP"
	toggleESP(espEnabled)
end)

-- Vol
local flyButton = Instance.new("TextButton")
flyButton.Parent = mainTab
flyButton.Size = UDim2.new(0, 150, 0, 30)
flyButton.Position = UDim2.new(0, 75, 0, 30)
flyButton.Text = "Activer Vol"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14

flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
		flyButton.Text = "Activer Vol"
	else
		startFlying()
		flyButton.Text = "Désactiver Vol"
	end
end)

-- Misc
local creatorLabel = Instance.new("TextLabel")
creatorLabel.Parent = miscTab
creatorLabel.Size = UDim2.new(1, 0, 1, 0)
creatorLabel.Text = "🛠️ Created by : Anakondax & Traydox 🛠️"
creatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creatorLabel.BackgroundTransparency = 1
creatorLabel.TextSize = 16
creatorLabel.TextWrapped = true
creatorLabel.TextYAlignment = Enum.TextYAlignment.Center
creatorLabel.TextXAlignment = Enum.TextXAlignment.Center

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Cacher GUI" or "Afficher GUI"
end)

runService.Heartbeat:Connect(function()
	updateFlight()
	updateMovement()
end)

local function createPlayerInfoUI(parent)
	local avatarSize = 50

	-- Conteneur pour tout aligner proprement
	local container = Instance.new("Frame")
	container.Parent = parent
	container.AnchorPoint = Vector2.new(1, 1)
	container.Position = UDim2.new(1, -10, 1, -10)
	container.Size = UDim2.new(0, avatarSize, 0, avatarSize + 22)
	container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	container.BackgroundTransparency = 0.4
	container.BorderSizePixel = 1
	container.BorderColor3 = Color3.fromRGB(255, 255, 255)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Parent = container
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.Size = UDim2.new(1, 0, 0, 20)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center

	local avatar = Instance.new("ImageLabel")
	avatar.Parent = container
	avatar.Position = UDim2.new(0, 0, 0, 22)
	avatar.Size = UDim2.new(1, 0, 0, avatarSize)
	avatar.BackgroundTransparency = 1
	avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=420&h=420"
end

createPlayerInfoUI(mainTab)
createPlayerInfoUI(playerTab)
createPlayerInfoUI(miscTab)

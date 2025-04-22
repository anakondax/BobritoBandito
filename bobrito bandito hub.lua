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

-- Fonction pour arrêter le vol
local function stopFlying()
	if not flying then return end
	flying = false
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	humanoid.PlatformStand = false
end

-- Fonction de mise à jour du vol
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
	button.Size = UDim2.new(0, 150, 1, 0)
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

local miscTab = Instance.new("Frame")
miscTab.Parent = frame
miscTab.Position = UDim2.new(0, 0, 0, 60)
miscTab.Size = UDim2.new(1, 0, 1, -60)
miscTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miscTab.Visible = false

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

-- 🔘 Fly Toggle
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

-- 🔘 ESP Toggle
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
	label.TextScaled = true  -- Garde la taille adaptée pour le nom complet
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
		for _, p in ipairs(game.Players:GetPlayers()) do
			createESP(p)
			espConnections[p] = p.CharacterAdded:Connect(function()
				p.Character:WaitForChild("HumanoidRootPart")
				createESP(p)
			end)
		end
		game.Players.PlayerAdded:Connect(function(p)
			espConnections[p] = p.CharacterAdded:Connect(function()
				p.Character:WaitForChild("HumanoidRootPart")
				createESP(p)
			end)
		end)
	else
		for _, p in ipairs(game.Players:GetPlayers()) do
			removeESP(p)
			if espConnections[p] then
				espConnections[p]:Disconnect()
				espConnections[p] = nil
			end
		end
	end
end

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espButton.Text = espEnabled and "Désactiver ESP" or "Activer ESP"
	toggleESP(espEnabled)
end)

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Cacher GUI" or "Afficher GUI"
end)

runService.Heartbeat:Connect(function()
	updateFlight()
	updateMovement()
end)

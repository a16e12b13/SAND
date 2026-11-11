--// Menú con KEY SYSTEM + WHITELIST - SAND2027

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========== LISTA BLANCA (insensible a mayúsculas) ==========
local Whitelist = {
	["a16e12b13"] = true,
	["A16E12b13"] = true,
	["a92e08b"] = true,
	["A92E08B"] = true,
	["cotercitoponytown"] = true,
	["james12337936"] = true
}

local playerName = string.lower(LocalPlayer.Name)

if not Whitelist[playerName] then
	local DenyGui = Instance.new("ScreenGui")
	DenyGui.Name = "NoPermissionUI"
	DenyGui.ResetOnSpawn = false
	DenyGui.IgnoreGuiInset = true
	DenyGui.DisplayOrder = 9999
	DenyGui.Parent = PlayerGui

	local BlackFrame = Instance.new("Frame")
	BlackFrame.Size = UDim2.new(0, 420, 0, 160)
	BlackFrame.Position = UDim2.new(0.5, -210, 0.5, -80)
	BlackFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Parent = DenyGui
	Instance.new("UICorner", BlackFrame).CornerRadius = UDim.new(0, 12)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(180, 30, 30)
	Stroke.Thickness = 2
	Stroke.Parent = BlackFrame

	local WarningText = Instance.new("TextLabel")
	WarningText.Size = UDim2.new(1, -30, 1, -20)
	WarningText.Position = UDim2.new(0, 15, 0, 10)
	WarningText.BackgroundTransparency = 1
	WarningText.Text = "You do not have permission to use this script"
	WarningText.TextColor3 = Color3.fromRGB(255, 50, 50)
	WarningText.TextSize = 18
	WarningText.Font = Enum.Font.GothamBold
	WarningText.TextWrapped = true
	WarningText.Parent = BlackFrame

	return
end
-- =================================

local KEY = "SAND2027"

pcall(function()
	if PlayerGui:FindFirstChild("YellowToggleUI") then PlayerGui.YellowToggleUI:Destroy() end
	if PlayerGui:FindFirstChild("KeySystemUI") then PlayerGui.KeySystemUI:Destroy() end
	if PlayerGui:FindFirstChild("NoPermissionUI") then PlayerGui.NoPermissionUI:Destroy() end
end)

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "KeySystemUI"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.DisplayOrder = 1000
KeyGui.Parent = PlayerGui

local PinkBlur = Instance.new("Frame")
PinkBlur.Size = UDim2.new(1, 0, 1, 0)
PinkBlur.BackgroundColor3 = Color3.fromRGB(255, 200, 220)
PinkBlur.BackgroundTransparency = 0.82
PinkBlur.BorderSizePixel = 0
PinkBlur.Parent = KeyGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 380, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Parent = KeyGui

local KeyBg = Instance.new("ImageLabel")
KeyBg.Size = UDim2.new(1, 0, 1, 0)
KeyBg.BackgroundTransparency = 1
KeyBg.Image = "rbxassetid://87239887513981"
KeyBg.ScaleType = Enum.ScaleType.Stretch
KeyBg.Parent = KeyFrame
Instance.new("UICorner", KeyBg).CornerRadius = UDim.new(0, 14)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -20, 0, 32)
KeyTitle.Position = UDim2.new(0, 10, 0, 16)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Ingresa la Key"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 18
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -50, 0, 40)
KeyBox.Position = UDim2.new(0, 25, 0, 80)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
KeyBox.BackgroundTransparency = 0.15
KeyBox.Text = ""
KeyBox.PlaceholderText = "Escribe la key..."
KeyBox.TextColor3 = Color3.fromRGB(80, 40, 60)
KeyBox.PlaceholderColor3 = Color3.fromRGB(180, 140, 160)
KeyBox.TextSize = 15
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, -20, 0, 22)
KeyStatus.Position = UDim2.new(0, 10, 0, 130)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = ""
KeyStatus.TextColor3 = Color3.fromRGB(255, 120, 140)
KeyStatus.TextSize = 13
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.Parent = KeyFrame

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 90, 0, 24)
SubmitBtn.Position = UDim2.new(0.5, -45, 1, -38)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SubmitBtn.Text = "Verificar"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 12
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local keyDragging, keyDragStart, keyStartPos
KeyFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		keyDragging = true
		keyDragStart = input.Position
		keyStartPos = KeyFrame.Position
	end
end)
KeyFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		keyDragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if keyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - keyDragStart
		KeyFrame.Position = UDim2.new(keyStartPos.X.Scale, keyStartPos.X.Offset + delta.X, keyStartPos.Y.Scale, keyStartPos.Y.Offset + delta.Y)
	end
end)

local function loadMainMenu()
	KeyGui:Destroy()

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "YellowToggleUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local ClickSound = Instance.new("Sound")
	ClickSound.SoundId = "rbxassetid://6895079853"
	ClickSound.Volume = 0.8
	ClickSound.Parent = SoundService

	local function playClick()
		pcall(function() ClickSound:Play() end)
	end

	local PastelColors = {
		Color3.fromRGB(255, 182, 193), Color3.fromRGB(173, 216, 230),
		Color3.fromRGB(152, 251, 152), Color3.fromRGB(255, 218, 185),
		Color3.fromRGB(221, 160, 221), Color3.fromRGB(255, 255, 153),
		Color3.fromRGB(176, 224, 230), Color3.fromRGB(255, 192, 203),
	}

	-- ========== TRAIL COLOR SYSTEM ==========
	local TrailColors = {
		Color3.fromRGB(255, 105, 180), Color3.fromRGB(255, 20, 147),
		Color3.fromRGB(255, 182, 193), Color3.fromRGB(255, 0, 255),
		Color3.fromRGB(186, 85, 211), Color3.fromRGB(138, 43, 226),
		Color3.fromRGB(75, 0, 130), Color3.fromRGB(0, 191, 255),
		Color3.fromRGB(30, 144, 255), Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(64, 224, 208), Color3.fromRGB(0, 255, 127),
		Color3.fromRGB(50, 205, 50), Color3.fromRGB(154, 205, 50),
		Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 215, 0),
		Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 140, 0),
		Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(220, 20, 60), Color3.fromRGB(255, 99, 71),
		Color3.fromRGB(240, 128, 128), Color3.fromRGB(255, 192, 203),
		Color3.fromRGB(255, 228, 225), Color3.fromRGB(255, 250, 205),
		Color3.fromRGB(230, 230, 250), Color3.fromRGB(176, 196, 222),
		Color3.fromRGB(135, 206, 250), Color3.fromRGB(127, 255, 212),
	}

	local currentTrailColorIndex = 1
	local currentTrailColor = TrailColors[1]
	local trailEnabled = true

	local function clearAllTrails()
		local char = LocalPlayer.Character
		if not char then return end
		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local handle = tool:FindFirstChild("Handle")
				if handle then
					local trail = handle:FindFirstChild("BrushTrail")
					if trail then trail:Destroy() end
					local att0 = handle:FindFirstChild("TrailAtt0")
					if att0 then att0:Destroy() end
					local att1 = handle:FindFirstChild("TrailAtt1")
					if att1 then att1:Destroy() end
				end
			end
		end
	end

	local function updateAllExistingTrails()
		if not trailEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local handle = tool:FindFirstChild("Handle")
				if handle then
					local trail = handle:FindFirstChild("BrushTrail")
					if trail and trail:IsA("Trail") then
						trail.Color = ColorSequence.new(currentTrailColor)
					end
				end
			end
		end
	end

	local function setupToolTrail(tool)
		if not trailEnabled then return end
		if not tool:IsA("Tool") then return end
		local handle = tool:FindFirstChild("Handle")
		if not handle then return end

		local oldTrail = handle:FindFirstChild("BrushTrail")
		if oldTrail then oldTrail:Destroy() end
		local oldAtt0 = handle:FindFirstChild("TrailAtt0")
		if oldAtt0 then oldAtt0:Destroy() end
		local oldAtt1 = handle:FindFirstChild("TrailAtt1")
		if oldAtt1 then oldAtt1:Destroy() end

		local att0 = Instance.new("Attachment")
		att0.Name = "TrailAtt0"
		att0.Position = Vector3.new(0, 0, 0)
		att0.Parent = handle

		local att1 = Instance.new("Attachment")
		att1.Name = "TrailAtt1"
		att1.Position = Vector3.new(0, 0.6, 0)
		att1.Parent = handle

		local trail = Instance.new("Trail")
		trail.Name = "BrushTrail"
		trail.Attachment0 = att0
		trail.Attachment1 = att1
		trail.Color = ColorSequence.new(currentTrailColor)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.7, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		})
		trail.Lifetime = 0.85
		trail.MinLength = 0.05
		trail.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0.15)
		})
		trail.FaceCamera = true
		trail.LightEmission = 0.4
		trail.Parent = handle
	end

	local function onCharacterAdded(char)
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Tool") then
				setupToolTrail(child)
			end
		end

		char.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				setupToolTrail(child)
				child.Equipped:Connect(function()
					setupToolTrail(child)
				end)
			end
		end)
	end

	if LocalPlayer.Character then
		onCharacterAdded(LocalPlayer.Character)
	end
	LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
	-- ========================================

	-- ========== BOTÓN FLOTANTE (más grandesito + margen bien delgada) ==========
	local ButtonHolder = Instance.new("Frame")
	ButtonHolder.Size = UDim2.new(0, 70, 0, 70)
	ButtonHolder.Position = UDim2.new(0, 6, 0.5, -35)
	ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
	ButtonHolder.BackgroundTransparency = 0
	ButtonHolder.BorderSizePixel = 0
	ButtonHolder.Parent = ScreenGui
	Instance.new("UICorner", ButtonHolder).CornerRadius = UDim.new(0, 16)

	local ToggleButton = Instance.new("ImageButton")
	ToggleButton.Size = UDim2.new(0, 66, 0, 66)
	ToggleButton.Position = UDim2.new(0.5, -33, 0.5, -33)
	ToggleButton.BackgroundTransparency = 1
	ToggleButton.Image = "rbxassetid://130606787845000"
	ToggleButton.Parent = ButtonHolder
	Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 14)
	-- ==================================================================================

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 520, 0, 340)
	MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
	MainFrame.BackgroundTransparency = 1
	MainFrame.Visible = false
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local Background = Instance.new("ImageLabel")
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundTransparency = 1
	Background.Image = "rbxassetid://79290891919211"
	Background.ScaleType = Enum.ScaleType.Stretch
	Background.Parent = MainFrame
	Instance.new("UICorner", Background).CornerRadius = UDim.new(0, 16)
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0, 28, 0, 28)
	CloseButton.Position = UDim2.new(1, -40, 0, 10)
	CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.new(1, 1, 1)
	CloseButton.TextSize = 14
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Visible = false
	CloseButton.ZIndex = 10
	CloseButton.Parent = MainFrame
	Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Size = UDim2.new(1, -50, 0, 220)
	Scroll.Position = UDim2.new(0, 25, 0, 70)
	Scroll.BackgroundTransparency = 1
	Scroll.BorderSizePixel = 0
	Scroll.ScrollBarThickness = 3
	Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 170, 190)
	Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Scroll.ClipsDescendants = true
	Scroll.Parent = MainFrame

	local UIList = Instance.new("UIListLayout")
	UIList.Padding = UDim.new(0, 4)
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.Parent = Scroll

	local AllOptionButtons = {}
	local function createButton(name)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 240, 0, 30)
		btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
		btn.BackgroundTransparency = 0.32
		btn.Text = name
		btn.TextColor3 = Color3.fromRGB(90, 45, 65)
		btn.TextSize = 12
		btn.Font = Enum.Font.GothamBold
		btn.Parent = Scroll
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)
		table.insert(AllOptionButtons, btn)
		return btn
	end

	local function createKayButton()
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, 240, 0, 48)
		container.BackgroundTransparency = 1
		container.Parent = Scroll

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
		btn.BackgroundTransparency = 0.32
		btn.Text = "Kay"
		btn.TextColor3 = Color3.fromRGB(90, 45, 65)
		btn.TextSize = 12
		btn.Font = Enum.Font.GothamBold
		btn.Parent = container
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

		local keyLabel = Instance.new("TextLabel")
		keyLabel.Size = UDim2.new(1, 0, 0, 16)
		keyLabel.Position = UDim2.new(0, 0, 0, 31)
		keyLabel.BackgroundTransparency = 1
		keyLabel.Text = "key: kay2026"
		keyLabel.TextColor3 = Color3.fromRGB(180, 100, 140)
		keyLabel.TextSize = 11
		keyLabel.Font = Enum.Font.Gotham
		keyLabel.Parent = container

		table.insert(AllOptionButtons, btn)
		return btn
	end

	local BtnCoils = createButton("coils")
	local BtnFontKudo = createButton("font kudo")
	local BtnSky = createButton("sky")
	local BtnSpeed = createButton("speed glitch")
	local BtnAntifling = createButton("antifling")
	local BtnHeadless = createButton("Headless")
	local BtnKorblox = createButton("korblox")
	local BtnChift = createButton("chift lock")
	local BtnCarpet = createButton("carpet")
	local BtnNoReload = createButton("no reload")
	local BtnStarborn = createButton("starborn")
	local BtnRecolorWater = createButton("recolor water")
	local BtnNav = createButton("navegación bar")
	local BtnGears = createButton("gears")
	local BtnVertex = createButton("Vertex")
	local BtnAnimations = createButton("animations")
	local BtnBombDevy = createButton("bomb devy")

	local BtnTrailColor = createButton("trail color")
	local BtnRemoveTrail = createButton("remove trail")

	local BtnOldQuality = createButton("Old quality 2023")
	local BtnRecolorGun = createButton("recolor gun")
	local BtnChiftPC = createButton("chift for PC")
	local BtnKay = createKayButton()

	local BtnRecolorBomb = createButton("Recolor of the bomb")

	local function applyPastelToAll()
		for _, btn in ipairs(AllOptionButtons) do
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = PastelColors[math.random(1, #PastelColors)]}):Play()
		end
	end

	local Music = Instance.new("Sound")
	Music.SoundId = "rbxassetid://1845341094"
	Music.Volume = 1
	Music.Looped = true
	Music.Parent = SoundService

	local function createBottomLine()
		pcall(function()
			if CoreGui:FindFirstChild("BottomLineGui") then CoreGui.BottomLineGui:Destroy() end
		end)
		local gui = Instance.new("ScreenGui")
		gui.Name = "BottomLineGui"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.Parent = CoreGui
		local line = Instance.new("Frame")
		line.Size = UDim2.new(0.32, 0, 0, 4)
		line.Position = UDim2.new(0.34, 0, 1, -13)
		line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		line.BackgroundTransparency = 0.7
		line.BorderSizePixel = 0
		line.Parent = gui
		Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
	end

	local function applyStarborn()
		local StarStyle = Font.new("rbxasset://fonts/families/FredokaOne.json")
		local function applyFont(v)
			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
				v.FontFace = StarStyle
				v.TextStrokeTransparency = 0.3
			end
		end
		for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do applyFont(v) end
		LocalPlayer.PlayerGui.DescendantAdded:Connect(function(v) task.wait() applyFont(v) end)
	end

	local function connectWithSound(btn, func)
		btn.MouseButton1Click:Connect(function()
			playClick()
			applyPastelToAll()
			pcall(func)
		end)
	end

	connectWithSound(BtnNav, createBottomLine)
	connectWithSound(BtnStarborn, applyStarborn)
	connectWithSound(BtnFontKudo, function() loadstring(game:HttpGet("https://pastefy.app/OFRWTHNL/raw"))() end)
	connectWithSound(BtnSky, function() loadstring(game:HttpGet("https://pastebin.com/raw/xzXmDPP1"))() end)
	connectWithSound(BtnSpeed, function() loadstring(game:HttpGet("https://pastefy.app/Vae7BYnm/raw"))() end)
	connectWithSound(BtnAntifling, function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-anti-fling-script-241540"))() end)
	connectWithSound(BtnHeadless, function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Roblox-Headless-(NO-LAG)-229602"))() end)
	connectWithSound(BtnKorblox, function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Pinokio-Hub-Korblox-Vis-No-key-239663"))() end)
	connectWithSound(BtnChift, function() loadstring(game:HttpGet("https://pastefy.app/MVCzsHvt/raw"))() end)
	connectWithSound(BtnCarpet, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Open-Source-227632"))() end)
	connectWithSound(BtnNoReload, function() loadstring(game:HttpGet("https://pastefy.app/FjGMnobt/raw"))() end)
	connectWithSound(BtnRecolorWater, function() loadstring(game:HttpGet("https://pastefy.app/HHqGOM0F/raw"))() end)
	connectWithSound(BtnCoils, function() loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Script-em-ServerScriptService-Cl*ic-Speed-Coil-+-Gra-230330"))() end)
	connectWithSound(BtnGears, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Gears/main/script.lua"))() end)
	connectWithSound(BtnVertex, function() loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))() end)
	connectWithSound(BtnAnimations, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-GAE-SIMPLIFIED-27193"))() end)
	connectWithSound(BtnBombDevy, function() loadstring(game:HttpGet("https://pastefy.app/IHNfoa6j/raw"))() end)

	-- Trail Color
	connectWithSound(BtnTrailColor, function()
		trailEnabled = true
		currentTrailColorIndex = currentTrailColorIndex + 1
		if currentTrailColorIndex > #TrailColors then
			currentTrailColorIndex = 1
		end
		currentTrailColor = TrailColors[currentTrailColorIndex]
		updateAllExistingTrails()

		local char = LocalPlayer.Character
		if char then
			for _, tool in ipairs(char:GetChildren()) do
				if tool:IsA("Tool") then
					setupToolTrail(tool)
				end
			end
		end

		BtnTrailColor.BackgroundColor3 = currentTrailColor
		BtnTrailColor.Text = "trail color [" .. currentTrailColorIndex .. "]"
		task.delay(1.2, function()
			if BtnTrailColor and BtnTrailColor.Parent then
				BtnTrailColor.Text = "trail color"
			end
		end)
	end)

	-- Remove Trail
	connectWithSound(BtnRemoveTrail, function()
		trailEnabled = false
		clearAllTrails()
		BtnRemoveTrail.Text = "removed!"
		task.delay(1.1, function()
			if BtnRemoveTrail and BtnRemoveTrail.Parent then
				BtnRemoveTrail.Text = "remove trail"
			end
		end)
	end)

	connectWithSound(BtnOldQuality, function()
		loadstring(game:HttpGet("https://pastefy.app/kJZQdgzD/raw"))()
	end)

	connectWithSound(BtnRecolorGun, function()
		loadstring(game:HttpGet("https://pastebin.com/raw/snp7CahN"))()
	end)

	connectWithSound(BtnChiftPC, function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jesusdasilvacorrea-collab/ShiftLockCursorsTel4do/main/ShiftLockCursorsTel4do"))()
	end)

	connectWithSound(BtnKay, function()
		loadstring(game:HttpGet("https://gist.githubusercontent.com/kaywxzstumblr/334ff80c087bf16b05e9485a13c8ce96/raw/d02ea328497c72dc896d56b4a90036cf1822be06/gistfile1.txt", true))()
	end)

	-- ========== RECOLOR OF THE BOMB (script de chiclao1) ==========
	connectWithSound(BtnRecolorBomb, function()
		-- BOMB COLOUR CHANGER BY CHICLAO1
		local sg,lp,rl,cl,hl=Instance.new("ScreenGui",game.CoreGui),game.Players.LocalPlayer,nil,nil,0
		local mf,tb,mi=Instance.new("Frame",sg),Instance.new("Frame"),Instance.new("TextButton",sg)
		local function c(o,r)Instance.new("UICorner",o).CornerRadius=UDim.new(0,r)end
		mf.Size,mf.Position,mf.BackgroundColor3=UDim2.new(0,500,0,300),UDim2.new(0.5,-250,0.5,-150),Color3.fromRGB(20,20,25)c(mf,10)
		tb.Size,tb.BackgroundColor3,tb.Parent=UDim2.new(1,0,0,35),Color3.fromRGB(30,30,35),mf
		local tl=Instance.new("TextLabel",tb)tl.Size,tl.Text,tl.TextColor3,tl.Font,tl.TextSize,tl.BackgroundTransparency=UDim2.new(1,-80,1,0),"=bomb colour changer by chiclao1=",Color3.new(1,1,1),"GothamBold",14,1
		local d,s,p tb.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then d,s,p=true,i.Position,mf.Position end end)
		game:GetService("UserInputService").InputChanged:Connect(function(i)if d and i.UserInputType==Enum.UserInputType.MouseMovement then local o=i.Position-s mf.Position=UDim2.new(p.X.Scale,p.X.Offset+o.X,p.Y.Scale,p.Y.Offset+o.Y)end end)
		game:GetService("UserInputService").InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
		local m,cBtn=Instance.new("TextButton",tb),Instance.new("TextButton",tb)
		m.Size,m.Position,m.Text,m.TextColor3,m.BackgroundColor3=UDim2.new(0,22,0,22),UDim2.new(1,-55,0,6),"-",Color3.new(1,1,1),Color3.fromRGB(50,50,55)c(m,5)
		cBtn.Size,cBtn.Position,cBtn.Text,cBtn.TextColor3,cBtn.BackgroundColor3=UDim2.new(0,22,0,22),UDim2.new(1,-27,0,6),"X",Color3.new(1,1,1),Color3.fromRGB(200,50,50)c(cBtn,5)
		mi.Size,mi.Position,mi.BackgroundColor3,mi.Text,mi.TextColor3,mi.Font,mi.TextSize,mi.Visible=UDim2.new(0,160,0,45),UDim2.new(0,20,1,-65),Color3.fromRGB(128,0,128),"DELTA-XENO.",Color3.new(1,1,1),"GothamBlack",18,false c(mi,10)
		cBtn.MouseButton1Click:Connect(function()sg:Destroy()end)m.MouseButton1Click:Connect(function()mf.Visible,mi.Visible=false,true end)mi.MouseButton1Click:Connect(function()mf.Visible,mi.Visible=true,false end)
		local function sec(t,ps)local f=Instance.new("Frame",mf)f.Size,f.Position,f.BackgroundTransparency=UDim2.new(0.5,-15,1,-55),ps,1 local lbl=Instance.new("TextLabel",f)lbl.Size,lbl.Text,lbl.TextColor3,lbl.Font,lbl.TextSize,lbl.BackgroundTransparency=UDim2.new(1,0,0,20),t,Color3.fromRGB(200,200,200),"GothamBold",12,1 local scr=Instance.new("ScrollingFrame",f)scr.Size,scr.Position,scr.BackgroundTransparency,scr.CanvasSize,scr.ScrollBarThickness=UDim2.new(1,0,1,-25),UDim2.new(0,0,0,25),1,UDim2.new(0,0,0,300),2 Instance.new("UIGridLayout",scr)return scr end
		local colS,effS=sec("BOMB COLOUR",UDim2.new(0,10,0,45)),sec("CHANGE EFFECTS",UDim2.new(0.5,5,0,45))colS.UIGridLayout.CellSize,colS.UIGridLayout.CellPadding=UDim2.new(0,65,0,30),UDim2.new(0,8,0,8)effS.UIGridLayout.CellSize=UDim2.new(1,-5,0,35)
		local sC,sE local function up(x,v)if x:IsA("BasePart")then x.Color=v x.Material=Enum.Material.SmoothPlastic if x:IsA("MeshPart")then x.TextureID="" end elseif x:IsA("SpecialMesh")then x.TextureId="" end end
		local function apply()for _,ui in pairs({lp:FindFirstChild("Backpack"),lp.Character})do if ui then for _,b in pairs(ui:GetChildren())do if b:IsA("Tool")and(b.Name:lower():find("bomb")or b.Name:lower():find("c4")or b.Name:lower():find("gold"))then
		if sC then if cl then cl:Disconnect() end if sC=="RGB" then cl=game:GetService("RunService").Heartbeat:Connect(function()hl=(hl+0.01)%1 for _,x in pairs(b:GetDescendants())do up(x,Color3.fromHSV(hl,1,1))end end)else for _,x in pairs(b:GetDescendants())do up(x,sC)end end end
		if sE then for _,e in pairs(b:GetDescendants())do if e.Name=="ChiclaoEff" then e:Destroy() end end local h=b:FindFirstChild("Handle")or b:FindFirstChildWhichIsA("BasePart")if h then local sp=Instance.new("Sparkles",h)sp.Name="ChiclaoEff" if sE=="Rainbow" then if rl then rl:Disconnect() end local eh=0 rl=game:GetService("RunService").Heartbeat:Connect(function()if sp and sp.Parent then eh=(eh+0.01)%1 sp.SparkleColor=Color3.fromHSV(eh,1,1)else rl:Disconnect() end end)else if rl then rl:Disconnect() end sp.SparkleColor=(sE=="Pink" and Color3.fromRGB(255,105,180))or(sE=="Blue" and Color3.fromRGB(0,191,255))or Color3.fromRGB(128,128,128)end end end end end end end end
		local function lst(ch)if ch then ch.ChildAdded:Connect(function(t)if t:IsA("Tool")then task.wait(0.1)apply()end end)end end lp.CharacterAdded:Connect(lst)lst(lp.Character)lp:WaitForChild("Backpack").ChildAdded:Connect(function()task.wait(0.1)apply()end)
		local rb=Instance.new("TextButton",colS)rb.Text,rb.TextColor3,rb.Font,rb.TextSize="RGB",Color3.new(1,1,1),"GothamBold",12 Instance.new("UIGradient",rb).Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,1))}c(rb,4)rb.MouseButton1Click:Connect(function()sC="RGB" apply()end)
		for _,v in pairs({{"Red",255,50,50},{"Orange",255,128,0},{"Yellow",255,220,50},{"Green",50,220,50},{"Blue",0,160,255},{"DarkBlue",0,35,160},{"Purple",140,50,255},{"Pink",255,105,180},{"Black",15,15,15},{"White",245,245,245}})do local b=Instance.new("TextButton",colS)b.BackgroundColor3,b.Text=Color3.fromRGB(v[2],v[3],v[4]),""c(b,4)b.MouseButton1Click:Connect(function()sC=b.BackgroundColor3 apply()end)end
		for _,v in pairs({"Rainbow","Pink","Blue","Gray"})do local b=Instance.new("TextButton",effS)b.BackgroundColor3,b.Text,b.TextColor3,b.Font,b.TextSize=Color3.fromRGB(40,40,48),v.." Sparkling",Color3.new(0.9,0.9,0.9),"GothamMedium",12 c(b,5)b.MouseButton1Click:Connect(function()sE=v apply()end)end
	end)
	-- ================================================================

	local isOpen, isAnimating = false, false

	local function getButtonCenter()
		local abs = ButtonHolder.AbsolutePosition
		local size = ButtonHolder.AbsoluteSize
		return UDim2.new(0, abs.X + size.X / 2, 0, abs.Y + size.Y / 2)
	end

	local function OpenWindow()
		if isAnimating or isOpen then return end
		isAnimating = true
		isOpen = true
		playClick()
		local btnPos = getButtonCenter()
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Position = btnPos
		CloseButton.Visible = true
		ButtonHolder.Visible = false
		pcall(function() Music:Play() end)
		local t = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 520, 0, 340),
			Position = UDim2.new(0.5, -260, 0.5, -170)
		})
		t:Play()
		t.Completed:Connect(function() isAnimating = false end)
	end

	local function CloseWindow()
		if isAnimating or not isOpen then return end
		isAnimating = true
		isOpen = false
		playClick()
		local btnPos = getButtonCenter()
		pcall(function() Music:Stop() end)
		local t = TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = btnPos
		})
		t:Play()
		t.Completed:Connect(function()
			MainFrame.Visible = false
			CloseButton.Visible = false
			ButtonHolder.Visible = true
			isAnimating = false
		end)
	end

	CloseButton.MouseButton1Click:Connect(CloseWindow)

	local buttonDragging, buttonDragStart, buttonStartPos, buttonHasMoved
	ToggleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			buttonDragging = true
			buttonHasMoved = false
			buttonDragStart = input.Position
			buttonStartPos = ButtonHolder.Position
		end
	end)
	ToggleButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if buttonDragging then
				if not buttonHasMoved then OpenWindow() end
				buttonDragging = false
			end
		end
	end)

	local frameDragging, frameDragStart, frameStartPos
	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			frameDragging = true
			frameDragStart = input.Position
			frameStartPos = MainFrame.Position
		end
	end)
	MainFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			frameDragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if buttonDragging then
				local delta = input.Position - buttonDragStart
				if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then buttonHasMoved = true end
				if buttonHasMoved then
					ButtonHolder.Position = UDim2.new(buttonStartPos.X.Scale, buttonStartPos.X.Offset + delta.X, buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + delta.Y)
				end
			end
			if frameDragging then
				local delta = input.Position - frameDragStart
				MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
			end
		end
	end)

	print("✅ Menú cargado correctamente")
end

local function checkKey()
	local typed = KeyBox.Text:gsub("%s+", "")
	if typed == KEY then
		KeyStatus.TextColor3 = Color3.fromRGB(120, 220, 150)
		KeyStatus.Text = "Key correcta ✓"
		task.wait(0.4)
		loadMainMenu()
	else
		KeyStatus.TextColor3 = Color3.fromRGB(255, 120, 140)
		KeyStatus.Text = "Key incorrecta"
		KeyBox.Text = ""
	end
end

SubmitBtn.MouseButton1Click:Connect(checkKey)
KeyBox.FocusLost:Connect(function(enter)
	if enter then checkKey() end
end)

print("🔐 Script cargado | Key: SAND2027")

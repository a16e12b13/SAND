local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local KEY_CORRECTA = "sand2027"

-- Lista blanca de usuarios autorizados (comparación insensible a mayúsculas/minúsculas)
local LISTA_BLANCA = {
	["a92e08b"] = true,
	["xjave249"] = true,
	["cotercitoponytown"] = true,
	["james12337936"] = true
}

local function estaEnListaBlanca(plr)
	if not plr then return false end
	local nombre = string.lower(tostring(plr.Name or ""))
	local display = string.lower(tostring(plr.DisplayName or ""))
	return LISTA_BLANCA[nombre] == true or LISTA_BLANCA[display] == true
end

if not estaEnListaBlanca(player) then
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "SAND",
			Text = "No estás en la lista blanca para usar este script.",
			Duration = 5
		})
	end)
	warn("Acceso denegado: el usuario " .. tostring(player.Name) .. " no está en la lista blanca.")
	if script then
		script:Destroy()
	end
	return
end

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VentanaRosaUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Función confiable para arrastrar elementos de UI usando RenderStepped
local function hacerArrastrable(targetGui, dragHandle, onClickCallback)
	local presionado = false
	local seMovio = false
	local posInicioMouse = Vector2.zero
	local posInicioGui = targetGui.Position

	local function iniciarArrastre()
		presionado = true
		seMovio = false
		posInicioMouse = UserInputService:GetMouseLocation()
		posInicioGui = targetGui.Position
	end

	local function terminarArrastre()
		if not presionado then return end
		presionado = false
		if not seMovio and onClickCallback then
			onClickCallback()
		end
	end

	if dragHandle:IsA("GuiButton") then
		dragHandle.MouseButton1Down:Connect(iniciarArrastre)
		dragHandle.MouseButton1Up:Connect(terminarArrastre)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			iniciarArrastre()
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			terminarArrastre()
		end
	end)

	RunService.RenderStepped:Connect(function()
		if presionado then
			local posActualMouse = UserInputService:GetMouseLocation()
			local delta = posActualMouse - posInicioMouse
			if delta.Magnitude > 4 then
				seMovio = true
			end
			targetGui.Position = UDim2.new(
				posInicioGui.X.Scale,
				posInicioGui.X.Offset + delta.X,
				posInicioGui.Y.Scale,
				posInicioGui.Y.Offset + delta.Y
			)
		end
	end)
end

-- Ventana de Key: cuadrada (310x310), bordes redondeados y rosa pastel transparentosa
local LADO_KEY = 310
local keyFrame = Instance.new("Frame")
keyFrame.Name = "VentanaKey"
keyFrame.Size = UDim2.new(0, LADO_KEY, 0, LADO_KEY)
keyFrame.Position = UDim2.new(0.5, -LADO_KEY / 2, 0.5, -LADO_KEY / 2)
keyFrame.BackgroundColor3 = Color3.fromRGB(255, 209, 220)
keyFrame.BackgroundTransparency = 0.28
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.ZIndex = 20
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 22)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(255, 240, 245)
keyStroke.Thickness = 1.4
keyStroke.Transparency = 0.35
keyStroke.Parent = keyFrame

local keyDragBar = Instance.new("TextButton")
keyDragBar.Name = "BarraKey"
keyDragBar.Size = UDim2.new(1, 0, 0, 44)
keyDragBar.BackgroundTransparency = 1
keyDragBar.Text = ""
keyDragBar.AutoButtonColor = false
keyDragBar.ZIndex = 21
keyDragBar.Parent = keyFrame

hacerArrastrable(keyFrame, keyDragBar, nil)

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -24, 0, 30)
keyTitle.Position = UDim2.new(0, 12, 0, 14)
keyTitle.BackgroundTransparency = 1
keyTitle.TextColor3 = Color3.fromRGB(60, 30, 40)
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.TextSize = 22
keyTitle.Text = "SAND KEY"
keyTitle.ZIndex = 22
keyTitle.Parent = keyFrame

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Size = UDim2.new(1, -30, 0, 24)
keySubtitle.Position = UDim2.new(0, 15, 0, 50)
keySubtitle.BackgroundTransparency = 1
keySubtitle.TextColor3 = Color3.fromRGB(80, 40, 55)
keySubtitle.Font = Enum.Font.GothamBold
keySubtitle.TextSize = 13
keySubtitle.Text = "Ingresa la key para desbloquear"
keySubtitle.ZIndex = 22
keySubtitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Name = "InputKey"
keyInput.Size = UDim2.new(1, -44, 0, 44)
keyInput.Position = UDim2.new(0, 22, 0, 96)
keyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyInput.BackgroundTransparency = 0.2
keyInput.TextColor3 = Color3.fromRGB(50, 30, 35)
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 120, 130)
keyInput.PlaceholderText = "Escribe la key aquí..."
keyInput.Text = ""
keyInput.ClearTextOnFocus = false
keyInput.Font = Enum.Font.GothamBold
keyInput.TextSize = 15
keyInput.ZIndex = 22
keyInput.Parent = keyFrame

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 12)
keyInputCorner.Parent = keyInput

local verifyBtn = Instance.new("TextButton")
verifyBtn.Name = "BotonVerificarKey"
verifyBtn.Size = UDim2.new(1, -44, 0, 44)
verifyBtn.Position = UDim2.new(0, 22, 0, 156)
verifyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 185)
verifyBtn.BackgroundTransparency = 0.15
verifyBtn.TextColor3 = Color3.fromRGB(50, 20, 30)
verifyBtn.Font = Enum.Font.GothamBlack
verifyBtn.TextSize = 15
verifyBtn.Text = "Verificar Key"
verifyBtn.AutoButtonColor = true
verifyBtn.ZIndex = 22
verifyBtn.Parent = keyFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 12)
verifyCorner.Parent = verifyBtn

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -30, 0, 28)
keyStatus.Position = UDim2.new(0, 15, 0, 214)
keyStatus.BackgroundTransparency = 1
keyStatus.TextColor3 = Color3.fromRGB(160, 30, 50)
keyStatus.Font = Enum.Font.GothamBold
keyStatus.TextSize = 13
keyStatus.Text = ""
keyStatus.TextWrapped = true
keyStatus.ZIndex = 22
keyStatus.Parent = keyFrame

-- Botón pequeño con esquinas más redondeadas, margen morada, sin texto, imagen ID 10377013641188 y arrastrable (oculto hasta validar la key)
local ID_IMAGEN_BOTON = "rbxassetid://10377013641188"
local LADO_BOTON_ABRIR = 52

local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "BotonAbrir"
toggleButton.Size = UDim2.new(0, LADO_BOTON_ABRIR, 0, LADO_BOTON_ABRIR)
toggleButton.Position = UDim2.new(0, 20, 0.5, -LADO_BOTON_ABRIR / 2)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
toggleButton.BackgroundTransparency = 0.2
toggleButton.Image = ID_IMAGEN_BOTON
toggleButton.ScaleType = Enum.ScaleType.Crop
toggleButton.Active = true
toggleButton.Visible = false
toggleButton.ZIndex = 10
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 18)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Name = "MargenMorada"
toggleStroke.Color = Color3.fromRGB(155, 80, 225)
toggleStroke.Thickness = 2.2
toggleStroke.Transparency = 0.08
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggleButton

-- Ventana principal (Rosa Pastel transparentosa) - Tamaño 435x320
local ANCHO_VENTANA = 435
local ALTO_VENTANA = 320
local ALTO_BARRA = 38

local mainFrame = Instance.new("Frame")
mainFrame.Name = "VentanaPrincipal"
mainFrame.Size = UDim2.new(0, ANCHO_VENTANA, 0, ALTO_VENTANA)
mainFrame.Position = UDim2.new(0.5, -ANCHO_VENTANA / 2, 0.58, -ALTO_VENTANA / 2)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 209, 220)
mainFrame.BackgroundTransparency = 0.28
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 22)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 240, 245)
mainStroke.Thickness = 1.4
mainStroke.Transparency = 0.35
mainStroke.Parent = mainFrame

-- Barra superior (arrastrable)
local topBar = Instance.new("TextButton")
topBar.Name = "BarraSuperior"
topBar.Size = UDim2.new(1, 0, 0, ALTO_BARRA)
topBar.BackgroundTransparency = 1
topBar.Text = ""
topBar.AutoButtonColor = false
topBar.Active = true
topBar.ZIndex = 6
topBar.Parent = mainFrame

hacerArrastrable(mainFrame, topBar, nil)

-- Texto "SAND" arriba a la izquierda
local sandLabel = Instance.new("TextLabel")
sandLabel.Name = "TextoSAND"
sandLabel.Size = UDim2.new(0, 120, 1, 0)
sandLabel.Position = UDim2.new(0, 16, 0, 0)
sandLabel.BackgroundTransparency = 1
sandLabel.TextColor3 = Color3.fromRGB(60, 30, 40)
sandLabel.Font = Enum.Font.GothamBlack
sandLabel.TextSize = 22
sandLabel.Text = "SAND"
sandLabel.TextXAlignment = Enum.TextXAlignment.Left
sandLabel.TextYAlignment = Enum.TextYAlignment.Center
sandLabel.ZIndex = 7
sandLabel.Parent = topBar

-- Contenedor de los 3 puntos a la derecha
local dotsHolder = Instance.new("Frame")
dotsHolder.Name = "Puntos"
dotsHolder.Size = UDim2.new(0, 84, 0, 24)
dotsHolder.Position = UDim2.new(1, -94, 0.5, -12)
dotsHolder.BackgroundTransparency = 1
dotsHolder.ZIndex = 7
dotsHolder.Parent = topBar

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 9)
layout.Parent = dotsHolder

local function crearPunto(nombre, color)
	local dot = Instance.new("TextButton")
	dot.Name = nombre
	dot.Size = UDim2.new(0, 18, 0, 18)
	dot.BackgroundColor3 = color
	dot.Text = ""
	dot.AutoButtonColor = true
	dot.Active = true
	dot.ZIndex = 8
	dot.Parent = dotsHolder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = dot

	return dot
end

local greenDot = crearPunto("PuntoVerde", Color3.fromRGB(119, 221, 119))
local yellowDot = crearPunto("PuntoAmarillo", Color3.fromRGB(253, 253, 150))
local redDot = crearPunto("PuntoRojo", Color3.fromRGB(255, 105, 97))

-- Área de contenido
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Contenido"
contentFrame.Size = UDim2.new(1, 0, 1, -ALTO_BARRA)
contentFrame.Position = UDim2.new(0, 0, 0, ALTO_BARRA)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 6
contentFrame.Parent = mainFrame

-- Barra buscadora blanca redondeada ("Search script")
local searchBox = Instance.new("TextBox")
searchBox.Name = "BarraBuscadora"
searchBox.Size = UDim2.new(0, 255, 0, 34)
searchBox.Position = UDim2.new(0, 14, 0, 4)
searchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
searchBox.BackgroundTransparency = 0.2
searchBox.TextColor3 = Color3.fromRGB(50, 30, 35)
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 130, 135)
searchBox.PlaceholderText = "Search script"
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ZIndex = 7
searchBox.Parent = contentFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(1, 0)
searchCorner.Parent = searchBox

local searchPadding = Instance.new("UIPadding")
searchPadding.PaddingLeft = UDim.new(0, 14)
searchPadding.PaddingRight = UDim.new(0, 14)
searchPadding.Parent = searchBox

-- Contenedor global de resultados de búsqueda (visible desde cualquier apartado al buscar)
local resultadosBusquedaFrame = Instance.new("ScrollingFrame")
resultadosBusquedaFrame.Name = "ResultadosBusqueda"
resultadosBusquedaFrame.Size = UDim2.new(0, 255, 0, 174)
resultadosBusquedaFrame.Position = UDim2.new(0, 14, 0, 44)
resultadosBusquedaFrame.BackgroundColor3 = Color3.fromRGB(255, 226, 233)
resultadosBusquedaFrame.BackgroundTransparency = 0.32
resultadosBusquedaFrame.BorderSizePixel = 0
resultadosBusquedaFrame.ScrollBarThickness = 4
resultadosBusquedaFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
resultadosBusquedaFrame.Visible = false
resultadosBusquedaFrame.ZIndex = 9
resultadosBusquedaFrame.Parent = contentFrame

local resCorner = Instance.new("UICorner")
resCorner.CornerRadius = UDim.new(0, 14)
resCorner.Parent = resultadosBusquedaFrame

local resListLayout = Instance.new("UIListLayout")
resListLayout.FillDirection = Enum.FillDirection.Vertical
resListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
resListLayout.SortOrder = Enum.SortOrder.LayoutOrder
resListLayout.Padding = UDim.new(0, 7)
resListLayout.Parent = resultadosBusquedaFrame

local resPadding = Instance.new("UIPadding")
resPadding.PaddingTop = UDim.new(0, 8)
resPadding.PaddingBottom = UDim.new(0, 8)
resPadding.Parent = resultadosBusquedaFrame

local opcionesBuscables = {}

local function registrarOpcionBuscable(objeto, nombre, ordenOriginal, padreOriginal)
	table.insert(opcionesBuscables, {
		Objeto = objeto,
		Nombre = string.lower(nombre),
		OrdenOriginal = ordenOriginal,
		PadreOriginal = padreOriginal
	})
end

----------------------------------------------------------------
-- CONTENEDOR DEL APARTADO 🛠️ (HERRAMIENTAS)
----------------------------------------------------------------
local herramientasFrame = Instance.new("ScrollingFrame")
herramientasFrame.Name = "ContenidoHerramientas"
herramientasFrame.Size = UDim2.new(0, 255, 0, 174)
herramientasFrame.Position = UDim2.new(0, 14, 0, 44)
herramientasFrame.BackgroundColor3 = Color3.fromRGB(255, 226, 233)
herramientasFrame.BackgroundTransparency = 0.32
herramientasFrame.BorderSizePixel = 0
herramientasFrame.ScrollBarThickness = 4
herramientasFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
herramientasFrame.Visible = false
herramientasFrame.ZIndex = 7
herramientasFrame.Parent = contentFrame

local herramientasCorner = Instance.new("UICorner")
herramientasCorner.CornerRadius = UDim.new(0, 14)
herramientasCorner.Parent = herramientasFrame

local herramientasListLayout = Instance.new("UIListLayout")
herramientasListLayout.FillDirection = Enum.FillDirection.Vertical
herramientasListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
herramientasListLayout.SortOrder = Enum.SortOrder.LayoutOrder
herramientasListLayout.Padding = UDim.new(0, 7)
herramientasListLayout.Parent = herramientasFrame

local herramientasPadding = Instance.new("UIPadding")
herramientasPadding.PaddingTop = UDim.new(0, 8)
herramientasPadding.PaddingBottom = UDim.new(0, 8)
herramientasPadding.Parent = herramientasFrame

local function crearBotonHerramienta(texto, orden, callback)
	local btn = Instance.new("TextButton")
	btn.Name = texto
	btn.LayoutOrder = orden
	btn.Size = UDim2.new(1, -18, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
	btn.BackgroundTransparency = 0.22
	btn.TextColor3 = Color3.fromRGB(60, 30, 40)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = texto
	btn.AutoButtonColor = true
	btn.ZIndex = 8
	btn.Parent = herramientasFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 10)
	btnCorner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	registrarOpcionBuscable(btn, texto, orden, herramientasFrame)
	return btn
end

-- Opción 1: Christmas sleigh
local christmasSleighCargado = false
crearBotonHerramienta("Christmas sleigh", 1, function()
	if christmasSleighCargado then return end
	christmasSleighCargado = true

	local camera = workspace.CurrentCamera
	local backpack = player:WaitForChild("Backpack")

	local gearId = 99119261
	local animId = "rbxassetid://855828754"

	local success, objects = pcall(function()
		return game:GetObjects("rbxassetid://" .. gearId)
	end)

	if success and objects and #objects > 0 then
		local tool = objects[1]

		for _, v in ipairs(tool:GetDescendants()) do
			if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
				v:Destroy()
			end
		end

		tool.TextureId = "rbxassetid://99167204"

		local function setupHandle(t)
			local handle = t:FindFirstChild("Handle")
			if handle then
				handle.Transparency = 0
				local mesh = handle:FindFirstChildOfClass("SpecialMesh")
				if not mesh then
					mesh = Instance.new("SpecialMesh")
					mesh.Parent = handle
				end
				mesh.MeshType = Enum.MeshType.FileMesh
				mesh.MeshId = "rbxassetid://99167224"
				mesh.TextureId = "rbxassetid://99167239"
				mesh.Scale = Vector3.new(2.2, 2.2, 2.2)
				mesh.VertexColor = Vector3.new(1, 1, 1)
			end
		end

		setupHandle(tool)
		tool.Parent = backpack

		local GRIP_DOC = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), math.rad(90), 0)
		local GRIP_NGANG = CFrame.new(-2.2, -1.2, 0) * CFrame.Angles(math.rad(90), 0, 0)

		tool.Grip = GRIP_DOC

		local equipped = false
		local isFlying = false
		local FLY_SPEED = 70

		local bodyVel, bodyGyro
		local lastTrailPos = nil
		local currentAnimTrack = nil

		local SledColors = {
			Color3.fromRGB(255, 0, 0),
			Color3.fromRGB(255, 50, 50),
			Color3.fromRGB(0, 255, 0),
			Color3.fromRGB(50, 255, 50),
			Color3.fromRGB(255, 0, 0)
		}

		local function createTrail(fromPos, toPos)
			local dist = (toPos - fromPos).Magnitude
			if dist < 1 then return end

			local mid = fromPos:Lerp(toPos, 0.5)
			local lookCF = CFrame.lookAt(mid, toPos)

			local model = Instance.new("Model")
			model.Name = "SledTrail"

			local partWidth = 0.65
			local height = 0.5

			for i, color in ipairs(SledColors) do
				local p = Instance.new("Part")
				p.Size = Vector3.new(partWidth, height, dist + 2)
				p.Anchored = true
				p.CanCollide = false
				p.Material = Enum.Material.Neon
				p.Color = color
				p.Transparency = 0.05
				p.CastShadow = false

				local offsetX = (i - 3) * partWidth
				p.CFrame = lookCF * CFrame.new(offsetX, -2, 0)

				local light = Instance.new("PointLight")
				light.Color = color
				light.Brightness = 10.0
				light.Range = 15
				light.Parent = p

				p.Parent = model
			end

			model.Parent = workspace
			Debris:AddItem(model, 1.5)
		end

		local function cleanupMovers()
			if bodyVel then bodyVel:Destroy() bodyVel = nil end
			if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		end

		local function stopAnimation()
			if currentAnimTrack then
				currentAnimTrack:Stop()
				currentAnimTrack:Destroy()
				currentAnimTrack = nil
			end
		end

		local function stopFlying()
			isFlying = false
			tool.Grip = GRIP_DOC
			lastTrailPos = nil
			cleanupMovers()
			stopAnimation()

			setupHandle(tool)

			local char = player.Character
			if char then
				local humanoid = char:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.PlatformStand = false
					humanoid.AutoRotate = true
				end
			end
		end

		local function startAnimation(humanoid)
			stopAnimation()
			local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 2)
			if animator then
				local animObj = Instance.new("Animation")
				animObj.AnimationId = animId
				currentAnimTrack = animator:LoadAnimation(animObj)
				currentAnimTrack.Priority = Enum.AnimationPriority.Action
				currentAnimTrack:Play()
			end
		end

		local function startFlying()
			local char = player.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChild("Humanoid")
			if not hrp or not humanoid then return end

			isFlying = true
			tool.Grip = GRIP_NGANG
			lastTrailPos = hrp.Position

			setupHandle(tool)

			humanoid.PlatformStand = true
			humanoid.AutoRotate = false

			cleanupMovers()
			startAnimation(humanoid)

			bodyVel = Instance.new("BodyVelocity")
			bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVel.Velocity = Vector3.zero
			bodyVel.Parent = hrp

			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bodyGyro.P = 12000
			bodyGyro.CFrame = hrp.CFrame
			bodyGyro.Parent = hrp

			hrp.AssemblyLinearVelocity = Vector3.new(0, 25, 0)
		end

		tool.Activated:Connect(function()
			if not equipped then return end
			if isFlying then
				stopFlying()
			else
				startFlying()
			end
		end)

		tool.Equipped:Connect(function()
			equipped = true
			tool.Grip = GRIP_DOC
			setupHandle(tool)
		end)

		tool.Unequipped:Connect(function()
								equipped = false
			stopFlying()
		end)

		local function onCharacterAdded(char)
			stopFlying()
			local humanoid = char:WaitForChild("Humanoid", 5)
			if humanoid then
				humanoid.Died:Connect(stopFlying)
			end
		end

		if player.Character then
			onCharacterAdded(player.Character)
		end
		player.CharacterAdded:Connect(onCharacterAdded)

		local trailCooldown = 0
		RunService.RenderStepped:Connect(function(dt)
			if not (equipped and isFlying and player.Character) then return end

			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if not hrp or not bodyVel or not bodyGyro then return end

			camera = workspace.CurrentCamera
			local camCF = camera.CFrame
			bodyGyro.CFrame = camCF

			local moveDir = Vector3.zero

			if humanoid.MoveDirection.Magnitude > 0.05 then
				local localMove = camCF:VectorToObjectSpace(humanoid.MoveDirection)
				moveDir = Vector3.new(localMove.X, 0, localMove.Z)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDir = moveDir + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDir = moveDir + Vector3.new(0, -1, 0)
			end

			if humanoid.MoveDirection.Magnitude <= 0.05 then
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
			end

			if moveDir.Magnitude > 0 then
				moveDir = moveDir.Unit
				local flyVector = camCF.RightVector * moveDir.X
					+ Vector3.new(0, 1, 0) * moveDir.Y
					+ camCF.LookVector * -moveDir.Z
				bodyVel.Velocity = flyVector * FLY_SPEED
			else
				bodyVel.Velocity = Vector3.zero
			end

			trailCooldown = trailCooldown - dt
			if trailCooldown <= 0 then
				trailCooldown = 0.05

				local currentPos = hrp.Position
				if lastTrailPos then
					local dist = (currentPos - lastTrailPos).Magnitude
					if dist > 1.5 then
						createTrail(lastTrailPos, currentPos)
						lastTrailPos = currentPos
					end
				else
					lastTrailPos = currentPos
				end
			end
		end)

		print("✅ Trenó centralizado!")
	else
		christmasSleighCargado = false
		warn("Erro ao carregar o Trenó!")
	end
end)

-- Opción 2: Pink Water Cannon
local pinkCannonCargado = false
crearBotonHerramienta("Pink Water Cannon", 2, function()
	if pinkCannonCargado then return end
	pinkCannonCargado = true

	local Camera = workspace.CurrentCamera
	local Mouse = player:GetMouse()

	local GEAR_ID = "1760404984"
	local COR_ROSA_CLARO = Color3.fromRGB(255, 182, 193)
	local COR_ROXO = Color3.fromRGB(160, 32, 240)
	local SOM_TIRO_ID = "6603571443"

	local function notify(title, text)
		pcall(function()
			StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
		end)
	end

	local originalWaterColor = workspace.Terrain.WaterColor
	local originalWaterTransparency = workspace.Terrain.WaterTransparency
	local activePuddles = 0

	local function createPinkWaterExplosion(point)
		local scale = 8 + (4 * math.random(1, 3))
		local terrain = workspace.Terrain

		activePuddles = activePuddles + 1
		terrain.WaterColor = COR_ROSA_CLARO
		terrain.WaterTransparency = 0.1
		terrain:FillBall(point, scale, Enum.Material.Water)

		local splash = Instance.new("Part")
		splash.Anchored = true
		splash.CanCollide = false
		splash.Transparency = 1
		splash.Position = point
		splash.Parent = workspace

		local particles = Instance.new("ParticleEmitter", splash)
		particles.Texture = "rbxassetid://241650934"
		particles.Color = ColorSequence.new(COR_ROSA_CLARO)
		particles.Size = NumberSequence.new(2)
		particles.Transparency = NumberSequence.new(0.2)
		particles.Lifetime = NumberRange.new(0.5, 1)
		particles.Speed = NumberRange.new(20, 40)
		particles.SpreadAngle = Vector2.new(180, 180)
		particles.Rate = 0
		particles:Emit(150)

		Debris:AddItem(splash, 1.5)

		task.delay(7, function()
			terrain:FillBall(point, scale, Enum.Material.Air)
			activePuddles = activePuddles - 1
			if activePuddles <= 0 then
				activePuddles = 0
				terrain.WaterColor = originalWaterColor
				terrain.WaterTransparency = originalWaterTransparency
			end
		end)
	end

	local JUMP_POWER = 100
	local BOOST_FRAMES = 3

	local function isInWater()
		local char = player.Character
		local hum = char and char:FindFirstChild("Humanoid")
		if not hum then return false end
		return hum:GetState() == Enum.HumanoidStateType.Swimming or hum:GetState() == Enum.HumanoidStateType.GettingUp
	end

	UserInputService.JumpRequest:Connect(function()
		if not isInWater() then return end
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")
		if not root or not hum then return end

		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, JUMP_POWER, root.AssemblyLinearVelocity.Z)

		task.spawn(function()
			for i = 1, BOOST_FRAMES do
				if not root or not root.Parent then break end
				if root.AssemblyLinearVelocity.Y < JUMP_POWER * 0.7 then
					root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, math.max(root.AssemblyLinearVelocity.Y, JUMP_POWER * 0.85), root.AssemblyLinearVelocity.Z)
				end
				RunService.Heartbeat:Wait()
			end
		end)
	end)

	local function GiveTool()
		local backpack = player:WaitForChild("Backpack")
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")

		for _, item in pairs(backpack:GetChildren()) do
			if item.Name == "Magic Water Gun" then item:Destroy() end
		end
		for _, item in pairs(character:GetChildren()) do
			if item.Name == "Magic Water Gun" then item:Destroy() end
		end

		local tool = nil
		local success, objects = pcall(function() return game:GetObjects("rbxassetid://" .. GEAR_ID) end)
		if success and objects and objects[1] then
			tool = objects[1]
			if not tool:IsA("Tool") then tool = tool:FindFirstChildWhichIsA("Tool") end
		end

		if not tool then
			tool = Instance.new("Tool")
			tool.RequiresHandle = true
			tool.CanBeDropped = false
			tool.TextureId = "rbxassetid://1743849071"
			tool.Grip = CFrame.new(0, -1.25, 0.75)

			local handle = Instance.new("Part")
			handle.Name = "Handle"
			handle.Size = Vector3.new(1.93676, 4.34484, 8.43017)
			handle.Material = Enum.Material.Plastic
			handle.Anchored = false
			handle.CanCollide = false
			handle.Massless = false
			handle.Parent = tool

			local mesh = Instance.new("SpecialMesh")
			mesh.MeshId = "rbxassetid://1743845180"
			mesh.TextureId = "rbxassetid://1743846252"
			mesh.Parent = handle
		end

		tool.Name = "Magic Water Gun"

		for _, child in ipairs(tool:GetDescendants()) do
			if child:IsA("Script") or child:IsA("LocalScript") then child:Destroy() end
		end

		local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
		if not handle then return end

		handle.Size = handle.Size * 0.8
		local mesh = handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("Mesh")
		if mesh then
			mesh.Scale = mesh.Scale * 0.8
		end

		local barrelAttachment = Instance.new("Attachment")
		barrelAttachment.Name = "BarrelAttachment"
		barrelAttachment.Position = Vector3.new(0, 0, -(handle.Size.Z / 2))
		barrelAttachment.Parent = handle

		local soundShot = Instance.new("Sound")
		soundShot.Name = "Gunshot"
		soundShot.SoundId = "rbxassetid://" .. SOM_TIRO_ID
		soundShot.Volume = 0.7
		soundShot.Parent = handle

		local AttackAble = true

		tool.Activated:Connect(function()
			if not AttackAble then return end
			AttackAble = false
			soundShot:Play()

			local targetPos = Mouse.Hit.Position
			if not targetPos then AttackAble = true return end

			Camera = workspace.CurrentCamera
			local camPos = Camera.CFrame.Position
			local direction = (targetPos - camPos).Unit * 500

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {character, tool}
			rayParams.FilterType = Enum.RaycastFilterType.Exclude

			local rayResult = workspace:Raycast(camPos, direction, rayParams)
			local hitPos = rayResult and rayResult.Position or targetPos
			local shootOrigin = barrelAttachment.WorldPosition

			local beamAttachment0 = Instance.new("Attachment", handle)
			local beamAttachment1 = Instance.new("Attachment", workspace)
			beamAttachment1.WorldPosition = shootOrigin

			local beamVisual = Instance.new("Beam")
			beamVisual.Attachment0 = beamAttachment0
			beamVisual.Attachment1 = beamAttachment1
			beamVisual.Color = ColorSequence.new(COR_ROXO)
			beamVisual.LightEmission = 1
			beamVisual.Width0 = 0.3
			beamVisual.Width1 = 0.3
			beamVisual.FaceCamera = true
			beamVisual.Parent = handle

			TweenService:Create(beamAttachment1, TweenInfo.new(0.1), {WorldPosition = hitPos}):Play()

			task.delay(0.1, function()
				createPinkWaterExplosion(hitPos)
				beamAttachment1:Destroy()
				beamVisual:Destroy()
			end)

			task.wait(0.4)
			AttackAble = true
		end)

		tool.Parent = backpack
		humanoid:EquipTool(tool)
	end

	GiveTool()

	player.CharacterAdded:Connect(function()
		task.wait(1.5)
		GiveTool()
	end)

	notify("Pink Water Cannon", "Cargado correctamente (Pulo 100)")
	print("✅ Pulo atualizado para 100!")
end)

-- Opción 3: carpet
crearBotonHerramienta("carpet", 3, function()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Open-Source-227632"))()
end)

-- Opción 4: coils
crearBotonHerramienta("coils", 4, function()
	loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Script-em-ServerScriptService-Cl*ic-Speed-Coil-+-Gra-230330"))()
end)

-- Opción 5: bomb devy
crearBotonHerramienta("bomb devy", 5, function()
	loadstring(game:HttpGet("https://pastefy.app/IHNfoa6j/raw"))()
end)

-- Opción 6: gear
crearBotonHerramienta("gear", 6, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Gears/refs/heads/main/script.lua", true))()
end)

-- Opción 7: starborn
local starbornCargado = false
crearBotonHerramienta("starborn", 7, function()
	if starbornCargado then return end
	starbornCargado = true

	local StarStyle = Font.new("rbxasset://fonts/families/FredokaOne.json")
			local function applyFont(v)
		if v:IsA("TextLabel")
			or v:IsA("TextButton")
			or v:IsA("TextBox") then
			v.FontFace = StarStyle
			v.TextStrokeTransparency = 0.3
			v.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
		end
	end

	for _, v in pairs(player.PlayerGui:GetDescendants()) do
		applyFont(v)
	end

	player.PlayerGui.DescendantAdded:Connect(function(v)
		task.wait()
		applyFont(v)
	end)

	print("⭐ Starborn style enabled")
end)

-- Opción 8: Recolor gun
crearBotonHerramienta("Recolor gun", 8, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Levinotsavy/Kk/main/script.lua"))()
end)

-- Opción 9: Recolor bomb
local recolorBombCargado = false
crearBotonHerramienta("Recolor bomb", 9, function()
	if recolorBombCargado then return end
	recolorBombCargado = true

	local localPlayer = Players.LocalPlayer

	local bombIds = {
		"rbxassetid://72634649711269",
		"rbxassetid://101785080415896",
		"rbxassetid://87195137432081",
		"rbxassetid://75764270519412",
		"rbxassetid://133744095064808",
		"rbxassetid://72795881681356"
	}

	local currentTexture = bombIds[1]
	local selectedButton = nil

	local function modifyBomb(obj)
		if not obj then return end
		local name = obj.Name:lower()

		if not (name:find("bomb") or name:find("prank")) then return end

		for _, part in ipairs(obj:GetDescendants()) do
			if part:IsA("MeshPart") then
				part.TextureID = currentTexture
			elseif part:IsA("BasePart") then
				for _, sub in ipairs(part:GetChildren()) do
					if sub:IsA("Decal") or sub:IsA("Texture") then
						sub.Texture = currentTexture
					elseif sub:IsA("SpecialMesh") then
						sub.TextureId = currentTexture
					end
				end
			end
		end
		if obj:IsA("MeshPart") then
			obj.TextureID = currentTexture
		end
	end

	local function onCharacterAdded(char)
		char.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				task.spawn(function()
					task.wait(0.05)
					modifyBomb(child)
				end)
			end
		end)
	end

	if localPlayer.Character then
		onCharacterAdded(localPlayer.Character)
	end
	localPlayer.CharacterAdded:Connect(onCharacterAdded)

	if localPlayer:FindFirstChild("Backpack") then
		localPlayer.Backpack.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				task.spawn(function()
					task.wait(0.05)
					modifyBomb(child)
				end)
			end
		end)
	end

	local function makeDraggable(guiObject, dragHandle)
		dragHandle = dragHandle or guiObject
		local dragging = false
		local dragStart, startPos

		dragHandle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = guiObject.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		dragHandle.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				guiObject.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	pcall(function()
		CoreGui:FindFirstChild("GoldBombGui"):Destroy()
	end)

	local bombGui = Instance.new("ScreenGui")
	bombGui.Name = "GoldBombGui"
	bombGui.Parent = CoreGui

	local toggleBombBtn = Instance.new("TextButton")
	toggleBombBtn.Size = UDim2.new(0, 130, 0, 40)
	toggleBombBtn.Position = UDim2.new(0, 20, 0, 120)
	toggleBombBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	toggleBombBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBombBtn.TextSize = 14
	toggleBombBtn.Font = Enum.Font.SourceSansBold
	toggleBombBtn.Text = "قائمة Gold Bomb 💣"
	toggleBombBtn.Parent = bombGui
	toggleBombBtn.Active = true

	local c1 = Instance.new("UICorner")
	c1.CornerRadius = UDim.new(0, 8)
	c1.Parent = toggleBombBtn

	local bombMainFrame = Instance.new("Frame")
	bombMainFrame.Size = UDim2.new(0, 280, 0, 340)
	bombMainFrame.Position = UDim2.new(0, 20, 0, 170)
	bombMainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	bombMainFrame.BorderSizePixel = 0
	bombMainFrame.Visible = false
	bombMainFrame.Parent = bombGui
	bombMainFrame.Active = true

	local c2 = Instance.new("UICorner")
	c2.CornerRadius = UDim.new(0, 10)
	c2.Parent = bombMainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.Text = "اختر صورة قنبلة Gold Prank Bomb"
	titleLabel.Parent = bombMainFrame

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.SourceSansBold
	closeBtn.Text = "X"
	closeBtn.Parent = bombMainFrame

	local c3 = Instance.new("UICorner")
	c3.CornerRadius = UDim.new(0, 6)
	c3.Parent = closeBtn

	closeBtn.MouseButton1Click:Connect(function()
		bombMainFrame.Visible = false
	end)

	toggleBombBtn.MouseButton1Click:Connect(function()
		bombMainFrame.Visible = not bombMainFrame.Visible
	end)

	makeDraggable(toggleBombBtn)
	makeDraggable(bombMainFrame, titleLabel)

	for i, idAsset in ipairs(bombIds) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 35)
		btn.Position = UDim2.new(0.05, 0, 0, 45 + (i * 42))
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 12
		btn.Font = Enum.Font.SourceSansBold
		btn.Text = "صورة ID " .. i
		btn.Parent = bombMainFrame

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = btn

		btn.MouseButton1Click:Connect(function()
			currentTexture = idAsset

			if selectedButton then
				selectedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			end
			selectedButton = btn
			btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

			if localPlayer.Character then
				for _, item in ipairs(localPlayer.Character:GetChildren()) do
					if item:IsA("Tool") then modifyBomb(item) end
				end
			end

			print("تم تغيير وتثبيت الصورة: " .. idAsset)
		end)
	end

	print("تم تفعيل السكريبت المحدث بنجاح!")
end)

----------------------------------------------------------------
-- CONTENEDOR DEL APARTADO 👁️ (VISUAL)
----------------------------------------------------------------
local visualFrame = Instance.new("ScrollingFrame")
visualFrame.Name = "ContenidoVisual"
visualFrame.Size = UDim2.new(0, 255, 0, 174)
visualFrame.Position = UDim2.new(0, 14, 0, 44)
visualFrame.BackgroundColor3 = Color3.fromRGB(255, 226, 233)
visualFrame.BackgroundTransparency = 0.32
visualFrame.BorderSizePixel = 0
visualFrame.ScrollBarThickness = 4
visualFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
visualFrame.Visible = false
visualFrame.ZIndex = 7
visualFrame.Parent = contentFrame

local visualCorner = Instance.new("UICorner")
visualCorner.CornerRadius = UDim.new(0, 14)
visualCorner.Parent = visualFrame

local visualListLayout = Instance.new("UIListLayout")
visualListLayout.FillDirection = Enum.FillDirection.Vertical
visualListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
visualListLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualListLayout.Padding = UDim.new(0, 7)
visualListLayout.Parent = visualFrame

local visualPadding = Instance.new("UIPadding")
visualPadding.PaddingTop = UDim.new(0, 8)
visualPadding.PaddingBottom = UDim.new(0, 8)
visualPadding.Parent = visualFrame

local function crearBotonVisual(texto, orden, callback)
	local btn = Instance.new("TextButton")
	btn.Name = texto
	btn.LayoutOrder = orden
	btn.Size = UDim2.new(1, -18, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
	btn.BackgroundTransparency = 0.22
	btn.TextColor3 = Color3.fromRGB(60, 30, 40)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = texto
	btn.AutoButtonColor = true
	btn.ZIndex = 8
	btn.Parent = visualFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 10)
	btnCorner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	registrarOpcionBuscable(btn, texto, orden, visualFrame)
	return btn
end

crearBotonVisual("límites UGS", 1, function()
	loadstring(game:HttpGet("https://api.lyraez.lol/loader"))()
end)

crearBotonVisual("korblox", 2, function()
	loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Korblox-R15-231745"))()
end)

crearBotonVisual("Headless", 3, function()
	loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-headless-fe-real-2026-234172"))()
end)

crearBotonVisual("Quality 2023", 4, function()
	loadstring(game:HttpGet("https://pastefy.app/kJZQdgzD/raw"))()
end)

local cursoresCargado = false
crearBotonVisual("cursores", 5, function()
	if cursoresCargado then return end
	cursoresCargado = true

	local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

	local HttpService = game:GetService("HttpService")

	--// SAVE FILE
	local SaveFile = "CustomShiftLock_Cursors.json"

	local SavedCustomCursors = {}

	if isfile and isfile(SaveFile) then
		local Success, Data = pcall(function()
			return HttpService:JSONDecode(readfile(SaveFile))
		end)

		if Success and type(Data) == "table" then
			SavedCustomCursors = Data
						end
	end

	local function SaveCustomCursors()
		if writefile then
			writefile(SaveFile, HttpService:JSONEncode(SavedCustomCursors))
		end
	end

	local Window = WindUI:CreateWindow({
		Title = "Custom ShiftLock",
		Icon = "mouse-pointer",
		Author = "pan9ic",
		Folder = "WindUI",
		Size = UDim2.fromOffset(500, 350),
		Transparent = true,
		Theme = "Dark",
	})

	local MainTab = Window:Tab({
		Title = "Main",
		Icon = "star"
	})

	local CustomTab = Window:Tab({
		Title = "Custom",
		Icon = "plus"
	})

	local SettingsTab = Window:Tab({
		Title = "Settings",
		Icon = "settings"
	})

	local Enabled = false
	local SpinEnabled = false

	local SpinSpeed = 5
	local SpinDirection = "Right"

	local CursorWidth = 50
	local CursorHeight = 50

	local Rotation = 0

	local SelectedCursor = "rbxassetid://131843855435385"

	local DefaultImages = {
		"rbxasset://textures/MouseLockedCursor.png",
		"rbxasset://textures/MouseLockedCursor@2x.png"
	}

	local ShiftlockObjects = {}

	--// CURSORS
	local CursorTable = {
		["White"] = "rbxassetid://131843855435385",
		["Purple"] = "rbxassetid://105227484929270",
		["Dark Red"] = "rbxassetid://70807381747714",
		["Black"] = "rbxassetid://134411152875782",
		["Pink"] = "rbxassetid://101446374921049",
		["Blue"] = "rbxassetid://94640444703376",
		["Green"] = "rbxassetid://112063814299010",
		["Teal"] = "rbxassetid://105472303240225",
		["Hot Pink"] = "rbxassetid://120423063723029",
		["Red"] = "rbxassetid://93953005352303",
		["Blue star"] = "rbxassetid://11716557686",
		["Mocha"] = "rbxassetid://123066282804999",
		["Cinnamoroll"] = "rbxassetid://130820173728340",
	}

	--// LOAD SAVED CUSTOM CURSORS
	for Name, Id in pairs(SavedCustomCursors) do
		CursorTable[Name] = Id
	end

	local function GetCursorNames()
		local Result = {}

		for Name in pairs(CursorTable) do
			table.insert(Result, Name)
		end

		table.sort(Result)

		return Result
	end

	local function ScanShiftLock()
		ShiftlockObjects = {}

		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				if table.find(DefaultImages, v.Image)
					or string.find(string.lower(v.Name), "shift")
					or string.find(string.lower(v.Name), "lock") then
					table.insert(ShiftlockObjects, v)
				end
			end
		end
	end

	local function ApplySize(v)
		v.Size = UDim2.new(
			0,
			math.clamp(CursorWidth, 1, 100),
			0,
			math.clamp(CursorHeight, 1, 100)
		)

		v.ImageTransparency = 0
		v.BackgroundTransparency = 1
		v.ScaleType = Enum.ScaleType.Fit
	end

	local function UpdateShiftLock()
		for _, v in pairs(ShiftlockObjects) do
			if v and v.Parent then
				if Enabled then
					v.Image = SelectedCursor
					ApplySize(v)
				else
					v.Image = "rbxasset://textures/MouseLockedCursor.png"
					v.Rotation = 0
					v.Size = UDim2.new(0, 32, 0, 32)
				end
			end
		end
	end

	RunService.RenderStepped:Connect(function()
		if SpinEnabled and Enabled then
			if SpinDirection == "Right" then
				Rotation += SpinSpeed
			else
				Rotation -= SpinSpeed
			end

			for _, v in pairs(ShiftlockObjects) do
				if v and v.Parent then
					v.Rotation = Rotation
					ApplySize(v)
				end
			end
		end
	end)

	game.DescendantAdded:Connect(function(v)
		task.wait(1)

		if v:IsA("ImageLabel") or v:IsA("ImageButton") then
			if table.find(DefaultImages, v.Image)
				or string.find(string.lower(v.Name), "shift")
				or string.find(string.lower(v.Name), "lock") then
				table.insert(ShiftlockObjects, v)

				if Enabled then
					v.Image = SelectedCursor
					ApplySize(v)
				end
			end
		end
	end)

	ScanShiftLock()

	--// TOGGLE
	MainTab:Toggle({
		Title = "Turn Custom ShiftLock",
		Default = false,
		Callback = function(Value)
			Enabled = Value
			UpdateShiftLock()
		end
	})

	--// DROPDOWN
	MainTab:Dropdown({
		Title = "Choose Cursor",
		Values = GetCursorNames(),
		Callback = function(Value)
			if CursorTable[Value] then
				SelectedCursor = CursorTable[Value]
				UpdateShiftLock()
			end
		end
	})

	--// CUSTOM TAB
	local CustomName = ""
	local CustomId = ""

	CustomTab:Input({
		Title = "Cursor Name",
		Placeholder = "Example: My Cursor",
		Callback = function(Value)
			CustomName = Value
		end
	})

	CustomTab:Input({
		Title = "Cursor Asset ID",
		Placeholder = "Example: 123456789",
		Callback = function(Value)
			CustomId = Value
		end
	})

	CustomTab:Button({
		Title = "Add Custom Cursor",
		Callback = function()
			if CustomName ~= "" and CustomId ~= "" then
				local Asset = "rbxassetid://" .. tostring(CustomId)

				CursorTable[CustomName] = Asset
				SavedCustomCursors[CustomName] = Asset

				SaveCustomCursors()

				Window:Notify({
					Title = "Saved",
					Content = "Cursor added successfully!",
					Duration = 3
				})
			else
				Window:Notify({
					Title = "Error",
					Content = "Enter name and asset id",
					Duration = 3
				})
			end
		end
	})

	CustomTab:Paragraph({
		Title = "Info",
		Desc = "Custom cursors save after rejoin/restart"
	})

	--// SETTINGS
	SettingsTab:Toggle({
		Title = "Spin ShiftLock",
		Default = false,
		Callback = function(Value)
			SpinEnabled = Value
		end
	})

	SettingsTab:Slider({
		Title = "Spin Speed",
		Value = {
			Min = 0.1,
			Max = 500,
			Default = 5,
		},
		Callback = function(Value)
			SpinSpeed = Value
		end
	})

	SettingsTab:Dropdown({
		Title = "Spin Direction",
		Values = {
			"Left",
			"Right"
		},
		Callback = function(Value)
			SpinDirection = Value
		end
	})

	SettingsTab:Slider({
		Title = "Width",
		Value = {
			Min = 1,
			Max = 100,
			Default = 50,
		},
		Callback = function(Value)
			CursorWidth = Value
			UpdateShiftLock()
		end
	})

	SettingsTab:Slider({
		Title = "Height",
		Value = {
			Min = 1,
			Max = 100,
			Default = 50,
		},
		Callback = function(Value)
			CursorHeight = Value
			UpdateShiftLock()
		end
	})
end)

crearBotonVisual("kay-key:kay2027", 6, function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/kaywxzstumblr/334ff80c087bf16b05e9485a13c8ce96/raw/d02ea328497c72dc896d56b4a90036cf1822be06/gistfile1.txt", true))()
end)

crearBotonVisual("sky", 7, function()
	loadstring(game:HttpGet("https://pastebin.com/raw/xzXmDPP1"))()
end)

crearBotonVisual("shaders", 8, function()
	loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Simple-Shaders-68015"))()
end)

crearBotonVisual("nevegation bar", 9, function()
	pcall(function()
		CoreGui:FindFirstChild("LiquidGlassBar"):Destroy()
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "LiquidGlassBar"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = CoreGui

	local bar = Instance.new("Frame")
	bar.Name = "GlassLine"
	bar.Size = UDim2.new(0, 230, 0, 3)
	bar.Position = UDim2.new(0.5, -115, 1, -7)
	bar.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
	bar.BackgroundTransparency = 0.38
	bar.BorderSizePixel = 0
	bar.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = bar

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 0.6
			stroke.Transparency = 0.2
	stroke.Parent = bar

	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 90
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 210, 240))
	})
	gradient.Parent = bar
end)

----------------------------------------------------------------
-- CONTENEDOR DEL APARTADO 🏃 (MOVIMIENTO)
----------------------------------------------------------------
local movimientoFrame = Instance.new("ScrollingFrame")
movimientoFrame.Name = "ContenidoMovimiento"
movimientoFrame.Size = UDim2.new(0, 255, 0, 174)
movimientoFrame.Position = UDim2.new(0, 14, 0, 44)
movimientoFrame.BackgroundColor3 = Color3.fromRGB(255, 226, 233)
movimientoFrame.BackgroundTransparency = 0.32
movimientoFrame.BorderSizePixel = 0
movimientoFrame.ScrollBarThickness = 4
movimientoFrame.CanvasSize = UDim2.new(0, 0, 0, 295)
movimientoFrame.Visible = false
movimientoFrame.ZIndex = 7
movimientoFrame.Parent = contentFrame

local movCorner = Instance.new("UICorner")
movCorner.CornerRadius = UDim.new(0, 14)
movCorner.Parent = movimientoFrame

local movListLayout = Instance.new("UIListLayout")
movListLayout.FillDirection = Enum.FillDirection.Vertical
movListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
movListLayout.SortOrder = Enum.SortOrder.LayoutOrder
movListLayout.Padding = UDim.new(0, 6)
movListLayout.Parent = movimientoFrame

local movPadding = Instance.new("UIPadding")
movPadding.PaddingTop = UDim.new(0, 8)
movPadding.PaddingBottom = UDim.new(0, 8)
movPadding.Parent = movimientoFrame

local function crearSlider(titulo, minVal, maxVal, valorInicial, orden, onChange)
	local holder = Instance.new("Frame")
	holder.Name = titulo
	holder.LayoutOrder = orden
	holder.Size = UDim2.new(1, -18, 0, 48)
	holder.BackgroundColor3 = Color3.fromRGB(255, 214, 224)
	holder.BackgroundTransparency = 0.25
	holder.ZIndex = 8
	holder.Parent = movimientoFrame

	local holderCorner = Instance.new("UICorner")
	holderCorner.CornerRadius = UDim.new(0, 10)
	holderCorner.Parent = holder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 16)
	label.Position = UDim2.new(0, 8, 0, 4)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(60, 30, 40)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.Text = titulo .. ": " .. tostring(valorInicial)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 8
	label.Parent = holder

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -16, 0, 10)
	track.Position = UDim2.new(0, 8, 0, 26)
	track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	track.BackgroundTransparency = 0.15
	track.Text = ""
	track.AutoButtonColor = false
	track.ZIndex = 8
	track.Parent = holder

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(255, 150, 175)
	fill.BorderSizePixel = 0
	fill.ZIndex = 9
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local knob = Instance.new("TextButton")
	knob.Name = "PuntoDeslizable"
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new(0, 0, 0.5, -10)
	knob.BackgroundColor3 = Color3.fromRGB(255, 105, 145)
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.ZIndex = 10
	knob.Parent = track

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local arrastrandoSlider = false
	local valorActual = valorInicial

	local function aplicarValor(nuevoValor)
		nuevoValor = math.clamp(math.floor(nuevoValor + 0.5), minVal, maxVal)
		valorActual = nuevoValor
		local alfa = (nuevoValor - minVal) / (maxVal - minVal)

		local anchoTrack = math.max(track.AbsoluteSize.X, 1)
		local posX = math.clamp(alfa * anchoTrack, 0, anchoTrack)

		fill.Size = UDim2.new(0, posX, 1, 0)
		knob.Position = UDim2.new(0, posX - (knob.AbsoluteSize.X / 2), 0.5, -10)
		label.Text = titulo .. ": " .. tostring(nuevoValor)

		if onChange then
			onChange(nuevoValor)
		end
	end

	local function actualizarDesdeMouse()
		local mouseX = UserInputService:GetMouseLocation().X
		local inicioX = track.AbsolutePosition.X
		local anchoTrack = math.max(track.AbsoluteSize.X, 1)
		local alfa = math.clamp((mouseX - inicioX) / anchoTrack, 0, 1)
		aplicarValor(minVal + alfa * (maxVal - minVal))
	end

	track.MouseButton1Down:Connect(function()
		arrastrandoSlider = true
		actualizarDesdeMouse()
	end)

	knob.MouseButton1Down:Connect(function()
		arrastrandoSlider = true
		actualizarDesdeMouse()
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			arrastrandoSlider = false
		end
	end)

	RunService.RenderStepped:Connect(function()
		if arrastrandoSlider then
			actualizarDesdeMouse()
		end
	end)

	task.defer(function()
		aplicarValor(valorInicial)
	end)

	registrarOpcionBuscable(holder, titulo, orden, movimientoFrame)

	return function()
		return valorActual
	end
end

local obtenerVelocidad = crearSlider("Velocidad", 16, 120, 16, 1, function(val)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = val
	end
end)

local obtenerSalto = crearSlider("Salto", 50, 250, 50, 2, function(val)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		if hum.UseJumpPower then
			hum.JumpPower = val
		else
			hum.JumpHeight = val / 7.2
		end
	end
end)

local glitchSection = Instance.new("Frame")
glitchSection.Name = "SeccionSpeedGlitch"
glitchSection.LayoutOrder = 3
glitchSection.Size = UDim2.new(1, -18, 0, 54)
glitchSection.BackgroundColor3 = Color3.fromRGB(255, 214, 224)
glitchSection.BackgroundTransparency = 0.25
glitchSection.ZIndex = 8
glitchSection.Parent = movimientoFrame

local glitchSectionCorner = Instance.new("UICorner")
glitchSectionCorner.CornerRadius = UDim.new(0, 10)
glitchSectionCorner.Parent = glitchSection

local glitchTitle = Instance.new("TextLabel")
glitchTitle.Size = UDim2.new(1, -12, 0, 15)
glitchTitle.Position = UDim2.new(0, 6, 0, 2)
glitchTitle.BackgroundTransparency = 1
glitchTitle.TextColor3 = Color3.fromRGB(90, 40, 55)
glitchTitle.Font = Enum.Font.GothamBold
glitchTitle.TextSize = 11
glitchTitle.Text = "Extra"
glitchTitle.TextXAlignment = Enum.TextXAlignment.Left
glitchTitle.ZIndex = 9
glitchTitle.Parent = glitchSection

local speedGlitchBtn = Instance.new("TextButton")
speedGlitchBtn.Name = "SpeedGlitch"
speedGlitchBtn.Size = UDim2.new(1, -12, 0, 31)
speedGlitchBtn.Position = UDim2.new(0, 6, 0, 19)
speedGlitchBtn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
speedGlitchBtn.BackgroundTransparency = 0.22
speedGlitchBtn.TextColor3 = Color3.fromRGB(60, 30, 40)
speedGlitchBtn.Font = Enum.Font.GothamBold
speedGlitchBtn.TextSize = 13
speedGlitchBtn.Text = "Speed Glitch: OFF"
speedGlitchBtn.AutoButtonColor = true
speedGlitchBtn.ZIndex = 9
speedGlitchBtn.Parent = glitchSection

local sgCorner = Instance.new("UICorner")
sgCorner.CornerRadius = UDim.new(0, 8)
sgCorner.Parent = speedGlitchBtn

registrarOpcionBuscable(glitchSection, "speed glitch", 3, movimientoFrame)

local function crearBotonMovimiento(texto, orden, callback)
	local btn = Instance.new("TextButton")
	btn.Name = texto
	btn.LayoutOrder = orden
	btn.Size = UDim2.new(1, -18, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
	btn.BackgroundTransparency = 0.22
	btn.TextColor3 = Color3.fromRGB(60, 30, 40)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = texto
	btn.AutoButtonColor = true
	btn.ZIndex = 8
	btn.Parent = movimientoFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 10)
	btnCorner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	registrarOpcionBuscable(btn, texto, orden, movimientoFrame)
	return btn
end

crearBotonMovimiento("antifling", 4, function()
	loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-anti-fling-235338"))()
end)

crearBotonMovimiento("editor animation", 5, function()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-GAE-SIMPLIFIED-27193"))()
end)

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local baseWalkSpeed = humanoid.WalkSpeed
local speedBoost = 25
local sistemaAtivo = false
local boostForce = 135

local boost = 16
local sensitivity = 0.06
local minSwipe = 1.2
local lastTouch = nil

local BASE_SPEED = 25
local MAX_SPEED = 41
local CAM_THRESHOLD = 0.02
local BOOST_PULSE = 16
local MAX_JUMPS = 3
local BACK_THRESHOLD = 0.45

local boostActive = false
local boostDir = nil
local boostSpeed = BASE_SPEED
local lastCam = {camera.CFrame:ToOrientation()}
local jumpsUsed = 0
local noAir = false

local function actualizarBotonSpeedGlitch()
	if sistemaAtivo then
		speedGlitchBtn.Text = "Speed Glitch: ON"
		speedGlitchBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 185)
	else
		speedGlitchBtn.Text = "Speed Glitch: OFF"
		speedGlitchBtn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
	end
end

speedGlitchBtn.MouseButton1Click:Connect(function()
	sistemaAtivo = not sistemaAtivo
	actualizarBotonSpeedGlitch()

	if sistemaAtivo then
		if humanoid then
			baseWalkSpeed = humanoid.WalkSpeed
		end
	else
		if humanoid then
			humanoid.WalkSpeed = baseWalkSpeed
		end
		boostActive = false
		boostSpeed = BASE_SPEED
		jumpsUsed = 0
		noAir = false
	end
end)

local function conectarHumanoidSpeedGlitch(hum, hrp)
	hum.StateChanged:Connect(function(_, state)
		if not sistemaAtivo then return end

		if state == Enum.HumanoidStateType.Jumping then
			hum.WalkSpeed = baseWalkSpeed + speedBoost
			noAir = true 
						elseif state == Enum.HumanoidStateType.Freefall then
			noAir = true
		elseif state == Enum.HumanoidStateType.Landed then
			noAir = false
			boostActive = false
			boostSpeed = BASE_SPEED
			jumpsUsed = 0
			hum.WalkSpeed = baseWalkSpeed
		end
	end)

	hum.Jumping:Connect(function()
		if not sistemaAtivo then return end

		if hrp and hrp.CFrame.UpVector.Y < 0.7 then
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			hrp.AssemblyLinearVelocity += Vector3.new(0, boostForce, 0)
		end
	end)
end

conectarHumanoidSpeedGlitch(humanoid, root)

local function addVelocity(dir)
	if not root then return end
	dir = Vector3.new(dir.X, 0, dir.Z)
	root.AssemblyLinearVelocity += dir * boost
end

local touchMovedConn = UserInputService.TouchMoved:Connect(function(input, gp)
	if gp or not sistemaAtivo then return end
	if not humanoid or not camera then return end

	if not lastTouch then
		lastTouch = input.Position
		return
	end

	local deltaX = input.Position.X - lastTouch.X
	lastTouch = input.Position

	if math.abs(deltaX) < minSwipe then return end
	if humanoid.MoveDirection.Magnitude < 0.1 then return end

	local dir = -camera.CFrame.RightVector * deltaX * sensitivity
	addVelocity(dir)
end)

local touchEndedConn = UserInputService.TouchEnded:Connect(function()
	lastTouch = nil
end)

local heartbeatConn = RunService.Heartbeat:Connect(function()
	if not sistemaAtivo or not noAir then return end
	if not humanoid or not root then return end
	camera = workspace.CurrentCamera
	if not camera then return end

	local moveDir = humanoid.MoveDirection
	if moveDir.Magnitude == 0 then return end

	local look = root.CFrame.LookVector
	if moveDir:Dot(-look) < BACK_THRESHOLD then return end
	if jumpsUsed >= MAX_JUMPS then return end

	local pitch, yaw = camera.CFrame:ToOrientation()
	local lp, ly = unpack(lastCam)
	local delta = math.abs(yaw - ly) + math.abs(pitch - lp)

	if delta > CAM_THRESHOLD then
		if not boostActive then
			boostDir = Vector3.new(-look.X, 0, -look.Z).Unit
			boostActive = true
			boostSpeed = BASE_SPEED
			jumpsUsed += 1
		end

		boostSpeed = math.clamp(boostSpeed + BOOST_PULSE, BASE_SPEED, MAX_SPEED)
	end

	lastCam = {pitch, yaw}
end)

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
	camera = workspace.CurrentCamera

	local vel = obtenerVelocidad()
	local sal = obtenerSalto()
	if vel > 16 then
		humanoid.WalkSpeed = vel
	end
	if sal > 50 then
		if humanoid.UseJumpPower then
			humanoid.JumpPower = sal
		else
			humanoid.JumpHeight = sal / 7.2
		end
	end

	baseWalkSpeed = humanoid.WalkSpeed
	boostActive = false
	boostSpeed = BASE_SPEED
	jumpsUsed = 0
	noAir = false

	conectarHumanoidSpeedGlitch(humanoid, root)
end)

-- Filtrado global con la barra buscadora ("Search script") en cualquier apartado
local function actualizarBusquedaGlobal()
	local query = string.lower((string.gsub(searchBox.Text, "^%s*(.-)%s*$", "%1")))
	local hayBusqueda = (query ~= "")

	resultadosBusquedaFrame.Visible = hayBusqueda

	if not hayBusqueda then
		for _, entry in ipairs(opcionesBuscables) do
			entry.Objeto.Parent = entry.PadreOriginal
			entry.Objeto.LayoutOrder = entry.OrdenOriginal
			entry.Objeto.Visible = true
		end
		return
	end

	local ordenResultado = 0
	local altoTotalResultados = 16

	for _, entry in ipairs(opcionesBuscables) do
		local coincide = (string.find(entry.Nombre, query, 1, true) ~= nil)
		if coincide then
			ordenResultado += 1
			entry.Objeto.Parent = resultadosBusquedaFrame
			entry.Objeto.LayoutOrder = ordenResultado
			entry.Objeto.Visible = true
			altoTotalResultados += (entry.Objeto.AbsoluteSize.Y > 0 and entry.Objeto.AbsoluteSize.Y or 36) + 7
		else
			entry.Objeto.Parent = entry.PadreOriginal
			entry.Objeto.LayoutOrder = entry.OrdenOriginal
			entry.Objeto.Visible = false
		end
	end

	resultadosBusquedaFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(altoTotalResultados, 174))
end

searchBox:GetPropertyChangedSignal("Text"):Connect(actualizarBusquedaGlobal)

-- Barra redonda más larga en la parte de abajo para los 3 apartados más grandes: 🛠️, 👁️, 🏃
local ANCHO_BARRA_APARTADOS = 305
local bottomBar = Instance.new("Frame")
bottomBar.Name = "BarraApartados"
bottomBar.Size = UDim2.new(0, ANCHO_BARRA_APARTADOS, 0, 46)
bottomBar.Position = UDim2.new(0.5, -ANCHO_BARRA_APARTADOS / 2, 1, -54)
bottomBar.BackgroundColor3 = Color3.fromRGB(255, 232, 238)
bottomBar.BackgroundTransparency = 0.25
bottomBar.ZIndex = 7
bottomBar.Parent = contentFrame

local bottomBarCorner = Instance.new("UICorner")
bottomBarCorner.CornerRadius = UDim.new(1, 0)
bottomBarCorner.Parent = bottomBar

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabsLayout.Padding = UDim.new(0, 20)
tabsLayout.Parent = bottomBar

local apartados = {
	{Nombre = "ApartadoHerramientas", Icono = "🛠️"},
	{Nombre = "ApartadoVisual", Icono = "👁️"},
	{Nombre = "ApartadoMovimiento", Icono = "🏃"}
}

local botonesApartados = {}

local function seleccionarApartado(nombreSeleccionado)
	herramientasFrame.Visible = (nombreSeleccionado == "ApartadoHerramientas")
	visualFrame.Visible = (nombreSeleccionado == "ApartadoVisual")
	movimientoFrame.Visible = (nombreSeleccionado == "ApartadoMovimiento")

	for _, entry in ipairs(botonesApartados) do
		local esActivo = (entry.Nombre == nombreSeleccionado)
		entry.Boton.BackgroundColor3 = esActivo
			and Color3.fromRGB(255, 182, 193)
			or Color3.fromRGB(255, 245, 248)
	end
end

for _, tab in ipairs(apartados) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = tab.Nombre
	tabBtn.Size = UDim2.new(0, 72, 0, 36)
	tabBtn.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
	tabBtn.BackgroundTransparency = 0.2
	tabBtn.TextColor3 = Color3.fromRGB(60, 30, 40)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 20
	tabBtn.Text = tab.Icono
	tabBtn.AutoButtonColor = true
	tabBtn.ZIndex = 8
	tabBtn.Parent = bottomBar

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(1, 0)
	tabCorner.Parent = tabBtn

	tabBtn.MouseButton1Click:Connect(function()
		seleccionarApartado(tab.Nombre)
	end)

	table.insert(botonesApartados, {Nombre = tab.Nombre, Boton = tabBtn})
end

seleccionarApartado("ApartadoHerramientas")

-- Bloque en la esquina superior derecha: Avatar grande redondo arriba y cuadrito redondeado con el nombre abajo
local profileCornerBox = Instance.new("Frame")
profileCornerBox.Name = "PerfilEsquinaDerecha"
profileCornerBox.Size = UDim2.new(0, 136, 0, 140)
profileCornerBox.Position = UDim2.new(1, -146, 0, 4)
profileCornerBox.BackgroundTransparency = 1
profileCornerBox.ZIndex = 7
profileCornerBox.Parent = contentFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarJugador"
avatarImage.Size = UDim2.new(0, 96, 0, 96)
avatarImage.Position = UDim2.new(0.5, -48, 0, 4)
avatarImage.BackgroundColor3 = Color3.fromRGB(255, 235, 240)
avatarImage.BackgroundTransparency = 0.25
avatarImage.ZIndex = 8
avatarImage.Parent = profileCornerBox

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size150x150
local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
avatarImage.Image = content

local nameBox = Instance.new("Frame")
nameBox.Name = "CuadroNombre"
nameBox.Size = UDim2.new(1, -8, 0, 26)
nameBox.Position = UDim2.new(0, 4, 0, 106)
nameBox.BackgroundColor3 = Color3.fromRGB(255, 226, 233)
nameBox.BackgroundTransparency = 0.25
nameBox.ZIndex = 8
nameBox.Parent = profileCornerBox

local nameBoxCorner = Instance.new("UICorner")
nameBoxCorner.CornerRadius = UDim.new(0, 10)
nameBoxCorner.Parent = nameBox

local nameLabel = Instance.new("TextLabel")
nameLabel.Name = "NombreJugador"
nameLabel.Size = UDim2.new(1, -8, 1, -4)
nameLabel.Position = UDim2.new(0, 4, 0, 2)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(60, 30, 40)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.Text = player.Name
nameLabel.TextXAlignment = Enum.TextXAlignment.Center
nameLabel.TextScaled = true
nameLabel.ZIndex = 9
nameLabel.Parent = nameBox

-- Validar la key "sand2027"
local function validarKey()
	local ingresada = string.gsub(keyInput.Text, "^%s*(.-)%s*$", "%1")
	if ingresada == KEY_CORRECTA then
		keyStatus.TextColor3 = Color3.fromRGB(25, 120, 55)
		keyStatus.Text = "¡Key correcta! Abriendo SAND..."
		task.delay(0.35, function()
			if keyFrame then
				keyFrame:Destroy()
			end
			mainFrame.Size = UDim2.new(0, ANCHO_VENTANA, 0, ALTO_VENTANA)
			contentFrame.Visible = true
			mainFrame.Visible = true
			toggleButton.Visible = false
		end)
	else
		keyStatus.TextColor3 = Color3.fromRGB(160, 30, 50)
		keyStatus.Text = "Key incorrecta. Intenta de nuevo."
	end
end

verifyBtn.MouseButton1Click:Connect(validarKey)
keyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		validarKey()
	end
end)

-- Botón principal arrastrable: abre la ventana y oculta el botón
hacerArrastrable(toggleButton, toggleButton, function()
	mainFrame.Size = UDim2.new(0, ANCHO_VENTANA, 0, ALTO_VENTANA)
	contentFrame.Visible = true
	mainFrame.Visible = true
	toggleButton.Visible = false
end)

-- Amarillo: minimiza la ventana y muestra de nuevo el botón
yellowDot.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	toggleButton.Visible = true
end)

-- Rojo: cerrar completamente el script, desconectar eventos y destruir la UI
redDot.MouseButton1Click:Connect(function()
	sistemaAtivo = false
	if touchMovedConn then touchMovedConn:Disconnect() end
	if touchEndedConn then touchEndedConn:Disconnect() end
	if heartbeatConn then heartbeatConn:Disconnect() end
	screenGui:Destroy()
	script:Destroy()
end)

-- Verde: intencionalmente sin función
greenDot.MouseButton1Click:Connect(function()
	-- No hace nada
end)

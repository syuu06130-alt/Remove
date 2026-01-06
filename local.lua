--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCRIPT 2: LocalScript (UI表示とボタン)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  場所: StarterPlayer > StarterPlayerScripts
  種類: LocalScript
  名前: LegRemoverClient
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEventを取得（最大10秒待機）
local remoteEvent = ReplicatedStorage:WaitForChild("RemoveLegEvent", 10)

if not remoteEvent then
	warn("⚠️ RemoveEvent not found! サーバースクリプトが動いているか確認してください。")
	return
end

-- ScreenGuiの作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LegRemoverGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- メインフレームの作成
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- タイトルバーの作成
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- タイトルテキスト
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🦵 Leg Remover (FE)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- 閉じるボタン
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Left Legボタン
local leftLegButton = Instance.new("TextButton")
leftLegButton.Name = "LeftLegButton"
leftLegButton.Size = UDim2.new(0, 120, 0, 50)
leftLegButton.Position = UDim2.new(0.5, -130, 0, 60)
leftLegButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
leftLegButton.BorderSizePixel = 0
leftLegButton.Text = "◀ Remove Left"
leftLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leftLegButton.TextSize = 14
leftLegButton.Font = Enum.Font.GothamBold
leftLegButton.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftLegButton

-- Right Legボタン
local rightLegButton = Instance.new("TextButton")
rightLegButton.Name = "RightLegButton"
rightLegButton.Size = UDim2.new(0, 120, 0, 50)
rightLegButton.Position = UDim2.new(0.5, 10, 0, 60)
rightLegButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
rightLegButton.BorderSizePixel = 0
rightLegButton.Text = "Remove Right ▶"
rightLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rightLegButton.TextSize = 14
rightLegButton.Font = Enum.Font.GothamBold
rightLegButton.Parent = mainFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightLegButton

-- FE表示
local feLabel = Instance.new("TextLabel")
feLabel.Size = UDim2.new(1, -20, 0, 20)
feLabel.Position = UDim2.new(0, 10, 0, 125)
feLabel.BackgroundTransparency = 1
feLabel.Text = "✅ FE Enabled (他人にも見える)"
feLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
feLabel.TextSize = 11
feLabel.Font = Enum.Font.GothamMedium
feLabel.Parent = mainFrame

-- ステータスラベル
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 50)
statusLabel.Position = UDim2.new(0, 10, 1, -60)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "Select a leg to remove"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- ドラッグ機能
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- 脚を削除する関数
local function removeLeg(legSide)
	statusLabel.Text = "Removing " .. legSide:lower() .. " leg..."
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	
	-- サーバーに削除リクエスト
	remoteEvent:FireServer(legSide)
	
	wait(0.15)
	statusLabel.Text = "✅ " .. legSide .. " leg removed!"
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	
	wait(2)
	statusLabel.Text = "Select a leg to remove"
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end

-- ボタンイベント
leftLegButton.MouseButton1Click:Connect(function()
	removeLeg("Left")
end)

rightLegButton.MouseButton1Click:Connect(function()
	removeLeg("Right")
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

print("✅ Leg Remover Client loaded!")

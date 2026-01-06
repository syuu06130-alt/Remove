--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCRIPT 2: LegRemoverClient
  場所: StarterPlayer > StarterPlayerScripts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventを取得（見つかるまで待機）
local eventName = "RemoveLegEvent"
local remoteEvent = ReplicatedStorage:WaitForChild(eventName, 20)

if not remoteEvent then
	warn("⚠️ RemoteEventが見つかりません。ServerScriptが正しく配置されているか確認してください。")
	return
end

-- 既存のGUIがあれば削除（重複防止）
if playerGui:FindFirstChild("LegRemoverGui") then
	playerGui.LegRemoverGui:Destroy()
end

-- ScreenGuiの作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LegRemoverGui"
screenGui.ResetOnSpawn = false -- リスポーンしてもGUIを残す
screenGui.Parent = playerGui

-- メインフレーム
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- ドラッグ用
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- タイトルバー
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
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- 左足ボタン
local leftLegButton = Instance.new("TextButton")
leftLegButton.Name = "LeftLegButton"
leftLegButton.Size = UDim2.new(0, 120, 0, 50)
leftLegButton.Position = UDim2.new(0.5, -130, 0, 60)
leftLegButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
leftLegButton.Text = "◀ Remove Left"
leftLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leftLegButton.Font = Enum.Font.GothamBold
leftLegButton.Parent = mainFrame
local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftLegButton

-- 右足ボタン
local rightLegButton = Instance.new("TextButton")
rightLegButton.Name = "RightLegButton"
rightLegButton.Size = UDim2.new(0, 120, 0, 50)
rightLegButton.Position = UDim2.new(0.5, 10, 0, 60)
rightLegButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
rightLegButton.Text = "Remove Right ▶"
rightLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rightLegButton.Font = Enum.Font.GothamBold
rightLegButton.Parent = mainFrame
local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightLegButton

-- ステータスラベル
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 50)
statusLabel.Position = UDim2.new(0, 10, 1, -60)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.Text = "Select a leg to remove"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- ドラッグ機能（GUIを動かせるようにする）
local dragging, dragInput, dragStart, startPos

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

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ボタン機能
local function onClick(side)
	statusLabel.Text = "Removing " .. side .. " leg..."
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	
	-- サーバーへ通知
	remoteEvent:FireServer(side)
	
	task.wait(0.2)
	statusLabel.Text = "✅ " .. side .. " leg removed!"
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	
	task.wait(1.5)
	statusLabel.Text = "Select a leg to remove"
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end

leftLegButton.MouseButton1Click:Connect(function() onClick("Left") end)
rightLegButton.MouseButton1Click:Connect(function() onClick("Right") end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

print("✅ Leg Remover Client Loaded")

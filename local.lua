local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent待機
local remoteEvent = ReplicatedStorage:WaitForChild("RemoveLegEvent", 10)
if not remoteEvent then
	warn("RemoveLegEventが見つかりません！サーバースクリプトを確認してください。")
	return
end

-- GUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LegRemoverGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- タイトルバー
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🦵 Leg Remover (FE)"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- 閉じるボタン
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- ボタン
local function createButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 0, 50)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local leftBtn = createButton("◀ Remove Left", UDim2.new(0.5, -130, 0, 60), Color3.fromRGB(60, 150, 255))
local rightBtn = createButton("Remove Right ▶", UDim2.new(0.5, 10, 0, 60), Color3.fromRGB(255, 100, 100))

-- ステータス
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 50)
status.Position = UDim2.new(0, 10, 1, -60)
status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
status.Text = "Select a leg to remove"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 13
status.TextWrapped = true
status.Parent = mainFrame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

-- FEラベル
local feLabel = Instance.new("TextLabel")
feLabel.Size = UDim2.new(1, -20, 0, 20)
feLabel.Position = UDim2.new(0, 10, 0, 125)
feLabel.BackgroundTransparency = 1
feLabel.Text = "✅ FE Enabled (他人にも見える)"
feLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
feLabel.TextSize = 12
feLabel.Parent = mainFrame

-- ドラッグ機能
local dragging, dragStart, startPos
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
		if dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end
end)

-- ボタン処理
local function removeLeg(side)
	status.Text = "Removing " .. side .. " leg..."
	status.TextColor3 = Color3.fromRGB(255, 255, 100)
	
	remoteEvent:FireServer(side)
	
	-- 少し待ってから成功表示（サーバー処理が即反映されるため）
	task.wait(0.3)
	status.Text = "✅ " .. side .. " leg removed!"
	status.TextColor3 = Color3.fromRGB(100, 255, 100)
	
	task.wait(1.5)
	status.Text = "Select a leg to remove"
	status.TextColor3 = Color3.fromRGB(200, 200, 200)
end

leftBtn.MouseButton1Click:Connect(function() removeLeg("Left") end)
rightBtn.MouseButton1Click:Connect(function() removeLeg("Right") end)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

print("✅ LegRemoverClient loaded!")

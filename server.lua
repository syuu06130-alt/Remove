--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCRIPT 1: LegRemoverServer
  場所: ServerScriptService
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEventの作成（なければ作る）
local eventName = "RemoveLegEvent"
local remoteEvent = ReplicatedStorage:FindFirstChild(eventName)
if not remoteEvent then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = eventName
	remoteEvent.Parent = ReplicatedStorage
end

-- R6とR15の脚パーツリスト
local R6_LEGS = {
	Left = {"Left Leg"},
	Right = {"Right Leg"}
}

local R15_LEGS = {
	Left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
	Right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
}

-- 脚を削除する関数
local function removeLeg(player, legSide)
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- R15かR6かを判定
	local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
	local partsToRemove = isR15 and R15_LEGS[legSide] or R6_LEGS[legSide]

	if partsToRemove then
		for _, partName in ipairs(partsToRemove) do
			local part = character:FindFirstChild(partName)
			if part then
				part:Destroy() -- パーツを破壊
			end
		end
	end
end

-- クライアントからの要求を受け取る
remoteEvent.OnServerEvent:Connect(function(player, legSide)
	if legSide == "Left" or legSide == "Right" then
		removeLeg(player, legSide)
		print(player.Name .. " の " .. legSide .. " 足を削除しました。")
	end
end)

print("✅ Leg Remover Server Script Loaded")

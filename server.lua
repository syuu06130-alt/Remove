--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCRIPT 1: ServerScript (他プレイヤーにも見えるようにする)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  場所: ServerScriptService
  種類: Script (普通のScript、LocalScriptではない！)
  名前: LegRemoverServer
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEventの作成
local remoteEvent = ReplicatedStorage:FindFirstChild("RemoveLegEvent")
if not remoteEvent then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = "RemoveLegEvent"
	remoteEvent.Parent = ReplicatedStorage
end

-- R6とR15の脚パーツ名
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
	if not character then 
		return false, "Character not found"
	end
	
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then 
		return false, "Humanoid not found"
	end
	
	-- R6かR15かを判定
	local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
	local partsToRemove = isR15 and R15_LEGS[legSide] or R6_LEGS[legSide]
	
	local removedCount = 0
	
	if partsToRemove then
		for _, partName in ipairs(partsToRemove) do
			local part = character:FindFirstChild(partName)
			if part then
				part:Destroy()
				removedCount = removedCount + 1
			end
		end
	end
	
	if removedCount > 0 then
		return true, legSide .. " leg removed! (" .. (isR15 and "R15" or "R6") .. ")"
	else
		return false, "No parts found"
	end
end

-- RemoteEventのリスナー
remoteEvent.OnServerEvent:Connect(function(player, legSide)
	if legSide == "Left" or legSide == "Right" then
		local success, message = removeLeg(player, legSide)
		print(player.Name .. " removed " .. legSide .. " leg: " .. tostring(success))
	end
end)

print("✅ Leg Remover Server Script loaded!")

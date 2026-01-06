local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent作成
local remoteEvent = ReplicatedStorage:FindFirstChild("RemoveLegEvent")
if not remoteEvent then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = "RemoveLegEvent"
	remoteEvent.Parent = ReplicatedStorage
end

-- 脚パーツ一覧
local LEG_PARTS = {
	Left = {
		R6 = {"Left Leg"},
		R15 = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}
	},
	Right = {
		R6 = {"Right Leg"},
		R15 = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
	}
}

local function removeLeg(player, side) -- side: "Left" or "Right"
	local character = player.Character
	if not character or not character:FindFirstChild("Humanoid") then
		return false, "Character not loaded"
	end

	local humanoid = character.Humanoid
	local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
	local rigType = isR15 and "R15" or "R6"
	local partsList = LEG_PARTS[side][isR15 and "R15" or "R6"]

	local removed = 0
	for _, partName in ipairs(partsList) do
		local part = character:FindFirstChild(partName)
		if part then
			part:Destroy()
			removed = removed + 1
		end
	end

	if removed > 0 then
		-- R15の場合、足がなくなった分だけHipHeightを下げる（見た目を自然に）
		if isR15 then
			humanoid.HipHeight = humanoid.HipHeight - 2 -- 調整値（必要に応じて変更）
		end
		return true, side .. " leg removed (" .. rigType .. ")"
	else
		return false, "No leg parts found"
	end
end

remoteEvent.OnServerEvent:Connect(function(player, side)
	if side ~= "Left" and side ~= "Right" then return end

	local success, msg = removeLeg(player, side)
	if success then
		print(player.Name .. ": " .. msg)
	else
		warn(player.Name .. ": Failed - " .. msg)
	end
end)

print("✅ LegRemoverServer loaded!")

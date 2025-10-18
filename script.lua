local player = game.Players.LocalPlayer
local root, clickToMove =
	(player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart"),
	require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetClickToMoveController()

local barrier = workspace:FindFirstChild("Barrier")
if barrier then barrier:Destroy() end

local profiles = game.ReplicatedStorage:WaitForChild("Profiles")
local userProfile = profiles:FindFirstChild(player.Name)
if not userProfile then
	warn("User profile not found for", player.Name)
	return
end

local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-45, 48, -42), c2 = Vector3.new(37, 48, -54)},
	["Rekindled Unborn"] = {c1 = Vector3.new(200, 0, 0), c2 = Vector3.new(0, 0, 0)}
}

local selectedMob, c1, c2
local mobFolder = userProfile:FindFirstChild("Mobs")
if mobFolder then
	for name, data in pairs(mobCases) do
		if mobFolder:FindFirstChild(name) then
			selectedMob, c1, c2 = name, data.c1, data.c2
			break
		end
	end
end

if not selectedMob then
	warn("No matching mob found in profile.")
	return
end

while task.wait(1) do
	local mobFound = mobFolder:FindFirstChild(selectedMob)
	if mobFound then
		clickToMove:MoveTo(c1)
	else
		clickToMove:MoveTo(c2)
	end
end

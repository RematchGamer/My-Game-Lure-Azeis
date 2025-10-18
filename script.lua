local player = game.Players.LocalPlayer
local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()

workspace:FindFirstChild("Barrier"):Destroy()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local endButton = Instance.new("TextButton", gui)
endButton.Size = UDim2.new(0,100,0,50)
endButton.Position = UDim2.new(0,10,1,-60)
endButton.Text = "Stop"

local running = true
endButton.MouseButton1Click:Connect(function()
	running = false
end)

local profileMobs = game.ReplicatedStorage.Profiles[player.Name].Mobs
local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1=Vector3.new(-45,48,-42), c2=Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1=Vector3.new(200,0,0), c2=Vector3.new(0,0,0)}
}

local selectedMob, c1, c2
for name,data in pairs(mobCases) do
	if profileMobs:FindFirstChild(name) then
		selectedMob, c1, c2 = name,data.c1,data.c2
		break
	end
end

local setInterval = 1
while running and selectedMob and task.wait(setInterval) do
	local mobFound = workspace.Mobs:FindFirstChild(selectedMob)
	if mobFound then
		clickToMove:MoveTo(c1)
	else
		clickToMove:MoveTo(c2)
	end
end

gui:Destroy()

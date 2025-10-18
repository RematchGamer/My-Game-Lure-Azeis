local player = game.Players.LocalPlayer
local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()
local setInterval = 1
local running = true

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local endButton = Instance.new("TextButton", gui)
endButton.Size = UDim2.new(0,100,0,50)
endButton.Position = UDim2.new(0,10,1,-60)
endButton.Text = "Stop"
endButton.MouseButton1Click:Connect(function()
	running = false
end)

local profileMobs = game.ReplicatedStorage.Profiles[player.Name]:FindFirstChild("Mobs")
local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1=Vector3.new(-45,48,-42), c2=Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1=Vector3.new(200,0,0), c2=Vector3.new(0,0,0)}
}

-- select first mob from profile that exists in mobCases
local selectedMob, c1, c2
for name, data in pairs(mobCases) do
	if profileMobs:FindFirstChild(name) then
		selectedMob = name
		c1 = data.c1
		c2 = data.c2
		break
	end
end

while running and selectedMob and task.wait(setInterval) do
	local mobFound = workspace.Mobs:FindFirstChild(selectedMob)
	if mobFound then
		clickToMove:MoveTo(c1)
	else
		clickToMove:MoveTo(c2)
	end
end

gui:Destroy()

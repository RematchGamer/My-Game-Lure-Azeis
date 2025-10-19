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

local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1=Vector3.new(-45,48,-42), c2=Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1=Vector3.new(200,0,0), c2=Vector3.new(0,0,0)}
}

local selectedMob, c1, c2
local timeout = 120
local startTime = tick()

-- Wait until any mob in workspace.Mobs exists (or 120 seconds)
while running and tick() - startTime < timeout and not selectedMob do
	for name, data in pairs(mobCases) do
		if workspace.Mobs:FindFirstChild(name) then
			selectedMob, c1, c2 = name, data.c1, data.c2
			break
		end
	end
	task.wait(0.5)
end

if selectedMob then
	local setInterval = 1
	while running and task.wait(setInterval) do
		local mobFound = workspace.Mobs:FindFirstChild(selectedMob)
		if mobFound then
			clickToMove:MoveTo(c1)
		else
			clickToMove:MoveTo(c2)
		end
	end
else
	warn("No mob found within 120 seconds")
end

gui:Destroy()
return

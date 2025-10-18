local player = game.Players.LocalPlayer
local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()
local barrier = workspace:FindFirstChild("Barrier")
if barrier then barrier:Destroy() end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local endButton = Instance.new("TextButton", gui)
endButton.Size = UDim2.new(0,100,0,50)
endButton.Position = UDim2.new(0,10,1,-60) -- bottom left
endButton.Text = "Stop"

local running = true
endButton.MouseButton1Click:Connect(function()
	running = false
end)

local prof = game.ReplicatedStorage.Profiles[player.Name]
local mobFolder = prof:FindFirstChild("Mobs")

local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1=Vector3.new(-45,48,-42), c2=Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1=Vector3.new(200,0,0), c2=Vector3.new(0,0,0)}
}

local selectedMob, c1, c2
for name,data in pairs(mobCases) do
	if mobFolder:FindFirstChild(name) then
		selectedMob, c1, c2 = name,data.c1,data.c2
		break
	end
end
if not selectedMob then return end

while running and task.wait(1) do
	local mobFound = mobFolder:FindFirstChild(selectedMob)
	if mobFound then
		clickToMove:MoveTo(c1)
	else
		clickToMove:MoveTo(c2)
	end
end

local p = game.Players.LocalPlayer
local click = require(p.PlayerScripts.PlayerModule):GetClickToMoveController()
local barrier = workspace:FindFirstChild("Barrier")
if barrier then barrier:Destroy() end

local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,100,0,50)
btn.Position = UDim2.new(0,50,0,50)
btn.Text = "Stop"

local running = true
btn.MouseButton1Click:Connect(function() running = false end)

local prof = game.ReplicatedStorage.Profiles[p.Name]
local mobFolder = prof:FindFirstChild("Mobs")

local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1=Vector3.new(-45,48,-42), c2=Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1=Vector3.new(200,0,0), c2=Vector3.new(0,0,0)}
}

local mob, c1, c2
for name,data in pairs(mobCases) do
	if mobFolder:FindFirstChild(name) then
		mob,c1,c2=name,data.c1,data.c2
		break
	end
end
if not mob then return end

while running and task.wait(1) do
	if mobFolder:FindFirstChild(mob) then click:MoveTo(c1)
	else click:MoveTo(c2) end
end

local player = game.Players.LocalPlayer
local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()

workspace:FindFirstChild("Barrier"):Destroy()

-- Load your GUI library
local library = loadstring(game:HttpGet("https://gist.githubusercontent.com/oufguy/62dbf2a4908b3b6a527d5af93e7fca7d/raw/6b2a0ecf0e24bbad7564f7f886c0b8d727843a92/Swordburst%25202%2520KILL%2520AURA%2520GUI(not%2520script)"))()
local window = library:MakeWindow("Mob Selector")

-- Hardcoded mobs and positions
local mobCases = {
	["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-45,48,-42), c2 = Vector3.new(37,48,-54)},
	["Rekindled Unborn"] = {c1 = Vector3.new(200,0,0), c2 = Vector3.new(0,0,0)}
}

-- Keep track of selected mob
local selectedMob, c1, c2
local running = true

-- Stop button
window:addButton("Stop", function()
	running = false
end)

-- Checkbox list for mob selection
local checkboxes = {}
for name,_ in pairs(mobCases) do
	local cb = window:addCheckbox(name)
	cb.Checked.Changed:Connect(function()
		if cb.Checked.Value then
			selectedMob = name
			c1 = mobCases[name].c1
			c2 = mobCases[name].c2
			-- uncheck other checkboxes
			for otherName, otherCb in pairs(checkboxes) do
				if otherName ~= name then
					otherCb.Checked.Value = false
				end
			end
		else
			if selectedMob == name then
				selectedMob = nil
				c1 = nil
				c2 = nil
			end
		end
	end)
	checkboxes[name] = cb
end)

-- Main loop
spawn(function()
	while running do
		if selectedMob then
			local mobFound = workspace.Mobs:FindFirstChild(selectedMob)
			if mobFound then
				clickToMove:MoveTo(c1)
			else
				clickToMove:MoveTo(c2)
			end
		end
		task.wait(1)
	end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()

local mobsFolder = workspace:WaitForChild("Mobs")

-- Hardcoded list of mobs with their coordinates
local mobCases = {
    ["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-45,48,-42), c2 = Vector3.new(37,48,-54)},
    ["Rekindled Unborn"] = {c1 = Vector3.new(200,0,0), c2 = Vector3.new(0,0,0)}
}

-- Threshold for calling ClickToMove
local threshold = 5

-- Load GUI library
local library = loadstring(game:HttpGet("https://gist.githubusercontent.com/oufguy/62dbf2a4908b3b6a527d5af93e7fca7d/raw/6b2a0ecf0e24bbad7564f7f886c0b8d727843a92/Swordburst%25202%2520KILL%2520AURA%2520GUI(not%2520script)"))()
local window = library:MakeWindow("Mob Selector")

local selectedMob, c1, c2
local checkboxes = {}

-- Function to uncheck all except the current
local function updateSelection(name)
    for otherName, cb in pairs(checkboxes) do
        if otherName ~= name then
            cb.Checked.Value = false
        end
    end
    selectedMob = name
    c1 = mobCases[name].c1
    c2 = mobCases[name].c2
end

-- Add checkboxes for each mob
for name,_ in pairs(mobCases) do
    local cb = window:addCheckbox(name)
    cb.Checked.Changed:Connect(function()
        if cb.Checked.Value then
            updateSelection(name)
        else
            if selectedMob == name then
                selectedMob = nil
                c1 = nil
                c2 = nil
            end
        end
    end)
    checkboxes[name] = cb
end

-- Main loop
spawn(function()
    local lastTarget = nil
    while true do
        task.wait(0.5)
        if selectedMob then
            local target = mobsFolder:FindFirstChild(selectedMob)
            local destination = target and c1 or c2
            if destination and (not lastTarget or (hrp.Position - destination).Magnitude > threshold) then
                clickToMove:MoveTo(destination)
                lastTarget = destination
            end
        end
    end
end)

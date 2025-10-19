local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local clickToMove = require(player.PlayerScripts.PlayerModule):GetClickToMoveController()
local mobsFolder = workspace:WaitForChild("Mobs")

-- Destroy Barrier
if workspace:FindFirstChild("Barrier") then
    workspace.Barrier:Destroy()
end

-- Hardcoded list of mobs with coordinates
local mobCases = {
    ["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-45,48,-42), c2 = Vector3.new(0,48,-48)},
    ["Rekindled Unborn"] = {c1 = Vector3.new(200,0,0), c2 = Vector3.new(0,0,0)}
}

local threshold = 10
local selectedMob, c1, c2
local checkboxes = {}

-- Load GUI library
local library = loadstring(game:HttpGet("https://gist.githubusercontent.com/oufguy/62dbf2a4908b3b6a527d5af93e7fca7d/raw/6b2a0ecf0e24bbad7564f7f886c0b8d727843a92/Swordburst%25202%2520KILL%2520AURA%2520GUI(not%2520script)"))()
local window = library:MakeWindow("Mob Selector")

-- Function to enforce only one checkbox selected at a time
local function updateSelection(name)
    if checkboxes then
        for otherName, cb in pairs(checkboxes) do
            if cb and otherName ~= name then
                cb.Checked.Value = false
            end
        end
    end
    selectedMob = name
    c1 = mobCases[name].c1
    c2 = mobCases[name].c2
end

-- Add checkboxes for each mob
for name,_ in pairs(mobCases) do
    local cb = window:addCheckbox(name)
    checkboxes[name] = cb
end

-- Connect the Changed events after all checkboxes are in the table
for name, cb in pairs(checkboxes) do
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
end

-- Main ClickToMove loop
local function runClickToMoveLoop()
    local lastDestination = nil
    while true do
        if selectedMob then
            local target = mobsFolder:FindFirstChild(selectedMob)
            local destination = target and c1 or c2
            if destination and (not lastDestination or (hrp.Position - destination).Magnitude > threshold) then
                clickToMove:MoveTo(destination)
                lastDestination = destination
            end
        end
        task.wait(0.5)
    end
end

spawn(runClickToMoveLoop)

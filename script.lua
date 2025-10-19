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

-- Hardcoded mob list
local mobCases = {
    ["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-45,48,-42), c2 = Vector3.new(-4,48,-48)},
    ["Rekindled Unborn"] = {c1 = Vector3.new(200,0,0), c2 = Vector3.new(0,0,0)}
}

local threshold = 10
local selectedMob, c1, c2
local running = true

-- Load GUI library
local library = loadstring(game:HttpGet("https://gist.githubusercontent.com/oufguy/62dbf2a4908b3b6a527d5af93e7fca7d/raw/6b2a0ecf0e24bbad7564f7f886c0b8d727843a92/Swordburst%25202%2520KILL%2520AURA%2520GUI(not%2520script)"))()
local window = library:MakeWindow("Mob Selector")

-- TEMP STOP button
local stopButton = window:addButton("STOP (TEMP)", function()
    running = false
    if window and window.Frame and window.Frame.Parent then
        window.Frame.Parent:Destroy()
    end
end)

-- Function that runs movement loop
local function startMovementLoop()
    spawn(function()
        local lastDestination = nil
        while running do
            local target = mobsFolder:FindFirstChild(selectedMob)
            local destination = target and c1 or c2
            if destination and (not lastDestination or (hrp.Position - destination).Magnitude > threshold) then
                pcall(function()
                    clickToMove:MoveTo(destination)
                end)
                lastDestination = destination
            end
            task.wait(0.5)
        end
    end)
end

-- Add checkboxes for each mob
for name, data in pairs(mobCases) do
    local cb = window:addCheckbox(name)
    cb.Checked.Changed:Connect(function()
        if cb.Checked.Value then
            selectedMob = name
            c1 = data.c1
            c2 = data.c2

            -- close GUI after selecting mob
            if window and window.Frame and window.Frame.Parent then
                window.Frame.Parent:Destroy()
            end

            startMovementLoop()
        end
    end)
end

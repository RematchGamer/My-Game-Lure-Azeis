local Players = game:GetService("Players")
local player = Players.LocalPlayer

local clickToMove = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetClickToMoveController()
local mobsFolder = workspace:WaitForChild("Mobs")
local threshold = 10
local interval = 1
local running = true

-- Hardcoded mobs
local mobCases = {
    ["Azeis, Spirit of the Eternal Blossom"] = {c1 = Vector3.new(-44,48,-41), c2 = Vector3.new(-4,48,-48)},
    ["Rekindled Unborn"] = {c1 = Vector3.new(200,0,0), c2 = Vector3.new(0,0,0)}
}

-- Destroy Barrier
local function removeBarrier()
    local barrier = workspace:FindFirstChild("Barrier")
    if barrier then barrier:Destroy() end
end

-- Dynamic character reference
local function getCurrentCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCurrentCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

-- Cleanup function according to rules
local function cleanupWorkspace()
    local char = getCurrentCharacter()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.CanCollide == false and
           not obj:IsDescendantOf(mobsFolder) and
           not obj:IsDescendantOf(char) and
           obj.Name ~= "HumanoidRootPart" then
            obj:Destroy()
        end
    end
end

-- TEMP stop button
local function createStopButton()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "StopButtonGUI"

    local stopButton = Instance.new("TextButton", gui)
    stopButton.Size = UDim2.new(0, 120, 0, 50)
    stopButton.Position = UDim2.new(0, 20, 1, -70)
    stopButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopButton.Font = Enum.Font.SourceSansBold
    stopButton.TextSize = 20
    stopButton.Text = "STOP (TEMP)"

    stopButton.MouseButton1Click:Connect(function()
        running = false
        gui:Destroy()
    end)
end

-- Movement logic: walks to c1 if mob exists, else goes to c2
local function StartLure(c1, c2, mobName)
    spawn(function()
        local lastDestination
        while running do
            local mob = mobsFolder:FindFirstChild(mobName)
            local hrp = getHRP()
            local destination = mob and c1 or c2

            if destination and (not lastDestination or (hrp.Position - destination).Magnitude > threshold) then
                pcall(function()
                    clickToMove:MoveTo(destination)
                end)
                if destination ~= lastDestination then
                    cleanupWorkspace()
                    lastDestination = destination
                end
            end

            task.wait(interval)
        end
    end)
end

-- Load GUI library
local function loadLibrary()
    return loadstring(game:HttpGet("https://gist.githubusercontent.com/oufguy/62dbf2a4908b3b6a527d5af93e7fca7d/raw/6b2a0ecf0e24bbad7564f7f886c0b8d727843a92/Swordburst%25202%2520KILL%2520AURA%2520GUI(not%2520script)"))()
end

-- GUI setup: mob selector
local function setupMobSelector()
    local library = loadLibrary()
    local window = library:MakeWindow("Mob Selector")

    for name, data in pairs(mobCases) do
        local cb = window:addCheckbox(name)
        cb.Checked.Changed:Connect(function()
            if cb.Checked.Value then
                -- start the lure with selected mob and positions
                StartLure(data.c1, data.c2, name)

                -- close GUI
                if window and window.Frame and window.Frame.Parent then
                    window.Frame.Parent:Destroy()
                end

                -- create TEMP stop button
                createStopButton()
            end
        end)
    end
end

-- Run everything
removeBarrier()
setupMobSelector()

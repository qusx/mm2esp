local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false

-- Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        espEnabled = not espEnabled
        print("ESP:", espEnabled and "ON" or "OFF")
        if not espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                    player.Character.ESPHighlight:Destroy()
                end
            end
        end
    end
end)

-- Apply ESP
local function applyESP(player, roleColor)
    if not player.Character then return end
    if player.Character:FindFirstChild("ESPHighlight") then
        player.Character.ESPHighlight:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Parent = player.Character
    highlight.Adornee = player.Character
    highlight.FillColor = roleColor
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
end

-- Detect role
local function getPlayerRole(player)
    local character = player.Character
    local backpack = player.Backpack
    if (backpack and backpack:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if (backpack and backpack:FindFirstChild("Gun")) or (character and character:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

-- Main loop
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = getPlayerRole(player)
            local color
            if role == "Murderer" then
                color = Color3.new(1, 0, 0)
            elseif role == "Sheriff" then
                color = Color3.new(0, 0, 1)
            else
                color = Color3.new(0, 1, 0)
            end
            applyESP(player, color)
        end
    end
end)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") then
        player.Character.ESPHighlight:Destroy()
    end
end)

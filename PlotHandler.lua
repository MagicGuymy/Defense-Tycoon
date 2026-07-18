local Players = game:GetService("Players")

local plot = script.Parent
local buttonsFolder = workspace.Plot:WaitForChild("Buttons")
local unlocksFolder = workspace.Plot:WaitForChild("Unlocks")

local player = Players.LocalPlayer
if not player then
		player = Players.PlayerAdded:Wait()
end

local button_cooldown = 0.25

local function findUnlockID(targetID)
	for _, unlock in ipairs(unlocksFolder:GetChildren()) do
		--reads the ID from unlock item
		local itemID = unlock:GetAttribute("ID_OfItemUnlock")
		if itemID == targetID then
			return unlock
		end
	end
	return nil
end

local function purchaseUnlock(button)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	
	local moneyVal = leaderstats:FindFirstChild("Money")
	if not moneyVal then return end
	-- get button attributes
	local buttonID = button:GetAttribute("ID_OfItemUnlock")
	local cost = button:GetAttribute("Cost")
	
	if not buttonID then
		warn("button"..button.Name.."is missing an ID_OfItemUnlock attribute!")
	end
	
	-- checks matching ID
	local unlockItem = findUnlockID(buttonID)
	if not unlockItem then 
		warn("No matching unlock found with ID_OfItemUnlock: ".. tostring(buttonID))
		return
	end
	
	-- checks and deducts money
	if moneyVal.Value >= cost then
		moneyVal.Value -= cost
		
		-- makes item visible
		
		button:Destroy()
		
		for _, item in ipairs(unlockItem:GetDescendants()) do
			if item:IsA("BasePart") and item.Name ~= "MainPart" then
				item.Transparency = 0
				item.CanCollide = true
				item.CanTouch = true
				item.CanQuery = true
			end
		end
		
		local dropperScript = unlockItem:FindFirstChildWhichIsA("Script", true)
		if dropperScript then
			dropperScript.Enabled = true
		end
	else
		print("Not enough money!")
	end
end
	
for _, button in ipairs(buttonsFolder:GetChildren()) do
	if button:IsA("BasePart") then
		local db = false

		button.Touched:Connect(function(hit)
			if db then return end

			local character = hit.Parent
			local hitPlayer = Players:GetPlayerFromCharacter(character)

			if hitPlayer then
				db = true
				purchaseUnlock(button)

				task.wait(button_cooldown)
				db = false
			end
		end)
	end
end


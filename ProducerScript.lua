local Players = game:GetService("Players")

local ProducerPart = script.Parent.Producer.MainPart
local Conveyor = script.Parent.Conveyor
local AbsorbingPart = script.Parent.AbsorbingPart
local MovingParts = script.Parent.MovingParts

local player = Players:GetPlayers()[1]
if not player then
	player = Players.PlayerAdded:Wait()
end

local function ConveyorFunction()
	Conveyor.AssemblyLinearVelocity = Conveyor.CFrame:VectorToWorldSpace(Vector3.new(8,0,0))
end

local function ProduceFunction()
	while task.wait(2) do
		local Part = Instance.new("Part", MovingParts)

		Part.Position = ProducerPart.Position
		Part.Size = ProducerPart.Size
		Part.Color = ProducerPart.Color
		Part.Material = ProducerPart.Material
		
		Part:SetNetworkOwner(nil)
		
		Part.Name = "Part"
		
		local PartValue = Instance.new("StringValue", Part)
		PartValue.Name = "PartValue"
		PartValue.Value = "UndefinedValue"
	end
end

local function OnTouch(hit)
	if hit.Name == "Part" then
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then return end
		
		local moneyVal = leaderstats:FindFirstChild("Money")
		if not moneyVal then return end
		
		hit:Destroy()
		
		moneyVal.Value += 10
	end
end

AbsorbingPart.Touched:Connect(OnTouch)

ConveyorFunction()
ProduceFunction()

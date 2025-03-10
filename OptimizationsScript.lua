local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local GeneratedRooms = workspace:FindFirstChild("GeneratedRooms")
local Players = game:GetService("Players")

local IgnoreNames = {
	StartPart = true,
	center = true,
	center278 = true,
	EndPart = true,
}

RunService.Stepped:Connect(function()
	local DoorNumber = ServerStorage.DoorNumber.Value
	local MinRoom = 1
	local MaxRoom = DoorNumber - 11
	
	if MaxRoom >= MinRoom then
		for DoorNumber = MinRoom, MaxRoom do
			if DoorNumber ~= 399 and DoorNumber ~= 798 and DoorNumber ~= 1202 then
				task.spawn(function()
					local RoomModel = workspace.GeneratedRooms:FindFirstChild("Room ".. DoorNumber)

					if RoomModel then
						for _, Object in pairs(RoomModel:GetDescendants()) do
							if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("UnionOperation") or Object:IsA("Model") then
								if Object:IsA("BasePart") and IgnoreNames[Object.Name] then
									Object.Transparency = 1
								else
									for _, Player in pairs(Players:GetPlayers()) do
										if Player.Character then
											local Magnitude = (Player.Character:FindFirstChild("HumanoidRootPart").Position - RoomModel:FindFirstChild("center").Position).Magnitude
											
											if Magnitude > 40 then
												Player.Character:FindFirstChild("HumanoidRootPart").CFrame = ServerStorage.LatestRoom.Value:FindFirstChild("center").CFrame
											end
										end
									end
									Object:Destroy()
								end
							end
						end
					end
				end)
			end
		end
	end
end)

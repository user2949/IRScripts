local LicencingTable = {
	Creator = "RoomGENERAT0R",
	Description = "To create a first person body resembling real life.",
	Uses = "Interminable Rooms",
	ScriptVersion = "6",
	Configuration = "Default"
} -- Licencing table for RoomGENERAT0R's publicized scripts. This table does not interfere with the script.


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Head = Character:WaitForChild("Head")

local Settings = {
	FirstPersonDistanceThreshold = 1,
	CameraOffsetYClamp = 0.5,
	DefaultCameraOffset = Vector3.new(0, 0, 0),
	FirstPersonCameraOffset = Vector3.new(0, 0, -1),
	FieldOfView = 70,
	SmoothTransition = true,
	TransitionSpeed = 0.1
}

local function IsInFirstPerson()
	if not Camera or not Head then return false end
	local Distance = (Camera.CFrame.Position - Head.Position).Magnitude
	return Distance < Settings.FirstPersonDistanceThreshold
end

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	Character = NewCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	Head = Character:WaitForChild("Head")
	for _, BodyPart in pairs(Character:GetChildren()) do
		if BodyPart:IsA("BasePart") and BodyPart.Name ~= "Head" then
			BodyPart:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				BodyPart.LocalTransparencyModifier = BodyPart.Transparency
			end)
			BodyPart.LocalTransparencyModifier = BodyPart.Transparency
		end
	end
end)

for _, BodyPart in pairs(Character:GetChildren()) do
	if BodyPart:IsA("BasePart") and BodyPart.Name ~= "Head" then
		BodyPart:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			BodyPart.LocalTransparencyModifier = BodyPart.Transparency
		end)
		BodyPart.LocalTransparencyModifier = BodyPart.Transparency
	end
end

local CurrentCameraOffset = Settings.DefaultCameraOffset

RunService.RenderStepped:Connect(function()
	if not Humanoid or not Camera then return end

	Camera.FieldOfView = Settings.FieldOfView

	local TargetOffset
	if IsInFirstPerson() then
		local LookVector = Camera.CFrame.LookVector
		local ClampedY = math.clamp(LookVector.Y, -Settings.CameraOffsetYClamp, Settings.CameraOffsetYClamp)
		TargetOffset = Vector3.new(Settings.FirstPersonCameraOffset.X, ClampedY, Settings.FirstPersonCameraOffset.Z)
	else
		TargetOffset = Settings.DefaultCameraOffset
	end

	if Settings.SmoothTransition then
		CurrentCameraOffset = CurrentCameraOffset:Lerp(TargetOffset, Settings.TransitionSpeed)
	else
		CurrentCameraOffset = TargetOffset
	end

	Humanoid.CameraOffset = CurrentCameraOffset
end)
local LicencingTable = {
	Creator = "RoomGENERAT0R",
	Description = "To create a sound everytime the person walks.",
	Uses = "Interminable Rooms",
	ScriptVersion = "469",
	Configuration = "Default"
} -- Licencing table for RoomGENERAT0R's publicized scripts. This table does not interfere with the script.

local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
script:FindFirstChild("FootstepSounds").Parent = SoundService
local MaterialSounds = SoundService:WaitForChild("FootstepSounds")
local Player = game.Players.LocalPlayer

repeat wait() until Player.Character

local Character = Player.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local NormalWalkSpeed = 16

local PlayerWalking

local function NoDefaultRunning()
	pcall(function()
		for _, Object in pairs(workspace.Players:GetDescendants()) do
			if Object:IsA("Sound") and Object.Name == "Running" then
				Object:Destroy()
			end
		end
	end)
end

Humanoid.Running:Connect(function(PlayerSpeed)
	pcall(function()
		if PlayerSpeed > Humanoid.WalkSpeed / 2 then
			PlayerWalking = true
		else
			PlayerWalking = false
		end
	end)
end)

local function GetMaterial()
	local Material
	pcall(function()
		local FloorMaterial = Humanoid.FloorMaterial

		if not FloorMaterial then
			FloorMaterial = "Air"
		end

		local MaterialRobloxString = string.split(tostring(FloorMaterial), "Enum.Material.")[2]
		Material = MaterialRobloxString
	end)

	return Material or "Air"
end

local LastMaterial

RunService.RenderStepped:Connect(function()
	pcall(function()
		if PlayerWalking then
			local Material = GetMaterial()

			if Material ~= LastMaterial and LastMaterial ~= nil then
				MaterialSounds[LastMaterial].Playing = false
			end

			local MaterialSound = MaterialSounds[Material]
			NoDefaultRunning()

			MaterialSound.PlaybackSpeed = Humanoid.WalkSpeed / NormalWalkSpeed
			MaterialSound.Playing = true

			LastMaterial = Material
		else
			for _, SoundObject in pairs(MaterialSounds:GetChildren()) do
				SoundObject.Playing = false
			end
		end
	end)
end)

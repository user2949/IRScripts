local LicencingTable = {
	Creator = "RoomGENERAT0R",
	Description = "To create a hotbar.",
	Uses = "Interminable Rooms",
	ScriptVersion = "229",
	Configuration = "Default"
} -- Licencing table for RoomGENERAT0R's publicized scripts. This table does not interfere with the script.

local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local Backpack = Player.Backpack
local Humanoid = Character:WaitForChild("Humanoid")
local Frame = script.Parent:FindFirstChild("Frame")
local Template = Frame:FindFirstChild("Template")

local IconSize = Template.Size
local IconBorder = {X = 5, Y = 15}

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local InputKeys = {
	["One"] = {Text = "1"},
	["Two"] = {Text = "2"},
	["Three"] = {Text = "3"},
	["Four"] = {Text = "4"},
	["Five"] = {Text = "5"},
	["Six"] = {Text = "6"},
	["Seven"] = {Text = "7"},
	["Eight"] = {Text = "8"},
	["Nine"] = {Text = "9"},
}

local InputOrder = {
	InputKeys["One"],
	InputKeys["Two"],
	InputKeys["Three"],
	InputKeys["Four"],
	InputKeys["Five"],
	InputKeys["Six"],
	InputKeys["Seven"],
	InputKeys["Eight"],
	InputKeys["Nine"]
}

local function HandleEquip(Tool)
	if Tool then
		if Tool.Parent ~= Character then
			Humanoid:EquipTool(Tool)
		else
			Humanoid:UnequipTools()
		end
	end
end

local function Create()
	local ToShow = #InputOrder
	local TotalX = (ToShow * IconSize.X.Offset) + ((ToShow + 1) * IconBorder.X)
	local TotalY = IconSize.Y.Offset + (2 * IconBorder.Y)

	Frame.Size = UDim2.new(0, TotalX, 0, TotalY)
	Frame.Position = UDim2.new(0.5, -(TotalX / 2), 1, -(TotalY + (IconBorder.Y * 2)))
	Frame.Visible = true

	for i = 1, #InputOrder do
		local Value = InputOrder[i]
		local Clone = Template:Clone()
		Clone.Parent = Frame
		Clone.Label.Text = Value["Text"]
		Clone.Name = Value["Text"]
		Clone.ImageTransparency = 0
		Clone.Visible = true
		Clone.Position = UDim2.new(0, (i - 1) * (IconSize.X.Offset) + (IconBorder.X * i), 0, IconBorder.Y)

		local Tool = Value["Tool"]
		if Tool then
			Clone.Tool.Image = Tool.TextureId
		end

		Clone.Tool.MouseButton1Down:Connect(function()
			HandleEquip(Value["Tool"])
		end)
	end
	Template:Destroy()
end

local function Setup()
	local Tools = Backpack:GetChildren()
	for i = 1, #Tools do
		for _, Value in ipairs(InputOrder) do
			if not Value["Tool"] then
				Value["Tool"] = Tools[i]
				break
			end
		end
	end
	Create()
end

local function Adjust()
	for _, Value in pairs(InputKeys) do
		local Tool = Value["Tool"]
		local Icon = Frame:FindFirstChild(Value["Text"])
		if Tool then
			Icon.Tool.Image = Tool.TextureId
			Icon.ImageTransparency = (Tool.Parent == Character) and 0 or 0
		else
			Icon.Tool.Image = ""
			Icon.ImageTransparency = 0
		end
	end
end

local function OnKeyPress(InputObject)
	local Key = InputObject.KeyCode.Name
	local Value = InputKeys[Key]
	if Value and UserInputService:GetFocusedTextBox() == nil then
		HandleEquip(Value["Tool"])
	end
end

local function HandleAddition(Adding)
	if Adding:IsA("Tool") then
		local New = true
		for _, Value in pairs(InputKeys) do
			if Value["Tool"] == Adding then
				New = false
				break
			end
		end

		if New then
			for i = 1, #InputOrder do
				if not InputOrder[i]["Tool"] then
					InputOrder[i]["Tool"] = Adding
					break
				end
			end
		end
		Adjust()
	end
end

local function HandleRemoval(Removing)
	if Removing:IsA("Tool") then
		if Removing.Parent ~= Character and Removing.Parent ~= Backpack then
			for i = 1, #InputOrder do
				if InputOrder[i]["Tool"] == Removing then
					InputOrder[i]["Tool"] = nil
					break
				end
			end
		end
		Adjust()
	end
end

UserInputService.InputBegan:Connect(OnKeyPress)
Character.ChildAdded:Connect(HandleAddition)
Character.ChildRemoved:Connect(HandleRemoval)
Backpack.ChildAdded:Connect(HandleAddition)
Backpack.ChildRemoved:Connect(HandleRemoval)

Setup()

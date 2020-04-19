local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientPickUpProp = ReplicatedStorage:WaitForChild("ClientPickUpProp")
local ClientPlaceProp = ReplicatedStorage:WaitForChild("ClientPlaceProp")
local ClientAnchorProp = ReplicatedStorage:WaitForChild("ClientAnchorProp")
local ClientPickUpItem = ReplicatedStorage:WaitForChild("ClientPickUpItem")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = script.Parent.Frame
local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.Camera

while not Player.Character do wait() end
local Character = Player.Character

local PlacingProps = false
local AnchoringProps = false
local AnchoringProgress = 0
local Prop, Item = nil

local PositionPreview
local PositionPreviewSafeCFrame = CFrame.new(0, 0, 0)
local Rotation = script.Rotation
Rotation.Value = CFrame.Angles(0, 0, 0)
local RotationAxis = 1 -- 0 = X, 1 = Y, 2 = Z

local Mouse = Player:GetMouse()
Mouse.TargetFilter = PositionPreview

function SearchForProps()
	local target = Mouse.Target
	if target then 
		if target.Parent:IsA("Model") and target.Parent.PrimaryPart and
			(Player.Character.HumanoidRootPart.Position - target.Parent.PrimaryPart.Position).magnitude < 8 then
				
			if target:IsDescendantOf(game:GetService("Workspace").Props) then
				return target.Parent, nil
			--elseif target:IsDescendantOf(game:GetService("Workspace").Items) then
			--	return nil, target.Parent
			end
		elseif target.Parent:IsA("Tool") and target.Parent.Handle and
			(Player.Character.HumanoidRootPart.Position - target.Parent.Handle.Position).magnitude < 8 then
			return nil, target.Parent
		end
	end
	return nil, nil
end

function PlaceProp()
	if ClientPlaceProp:InvokeServer(Prop, PositionPreviewSafeCFrame, false) then
		PositionPreview:Destroy()
		PlacingProps = false
		print("Placed " .. Prop.Name .. " at " .. tostring(Prop.PrimaryPart.CFrame))
	end
end

function AnchorProp()
	script.Parent.Anchoring.Visible = true
	print("Anchoring " .. Prop.Name)
	script.Parent.Anchoring.AnchorLabel.Text = "Anchoring..."
	if ClientPlaceProp:InvokeServer(Prop, PositionPreviewSafeCFrame, true) then
		PositionPreview:Destroy()
		PlacingProps = false
		print("Anchored " .. Prop.Name)
		script.Parent.Anchoring.AnchorLabel.Text = "ANCHORED"
		wait(1)
	else
		script.Parent.Anchoring.AnchorLabel.Text = "Anchor failed"
		wait(1)
	end
	script.Parent.Anchoring.Visible = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType.Name == "Keyboard" and not gameProcessed then
		if input.KeyCode.Name == "E" then
			if PlacingProps then
				AnchorProp()
			else
				if Prop and Prop.Parent == workspace.Props then
					PlacingProps = ClientPickUpProp:InvokeServer(Prop)
					if PlacingProps then
						PositionPreview = Prop:Clone()
						PositionPreview.Parent = Prop.Parent
						PositionPreview.PrimaryPart.Anchored = true
						PositionPreview.PrimaryPart.CFrame = Prop.PrimaryPart.CFrame -- Mainly used to copy the rotation
						for i, v in pairs(PositionPreview:GetChildren()) do
							if v:IsA("BasePart") then
								v.Anchored = false
								v.Material = Enum.Material.ForceField
								v.Color = Color3.fromRGB(25, 255, 45)
							end
						end
						Mouse.TargetFilter = PositionPreview
						print("Picked up " .. Prop.Name)
					end
				elseif Item and Item.Parent == workspace.Items then
					ClientPickUpItem:InvokeServer(Item)
				end
			end
		elseif input.KeyCode.Name == "R" then
			if PlacingProps then
				PositionPreview.PrimaryPart.Anchored = false
				
				TweenService:Create(
					Rotation,
					TweenInfo.new(0.1, Enum.EasingStyle.Circular),
					{ 
						Value = Rotation.Value * CFrame.Angles(RotationAxis == 0 and math.pi / 4 or 0, -- Rotation will change angles based on what axis is selected
						RotationAxis == 1 and math.pi / 4 or 0,
						RotationAxis == 2 and math.pi / 4 or 0)
					}
				):Play()
				
				script.Click:Play()
				--PositionPreview.PrimaryPart.Anchored = true
			end
		elseif input.KeyCode.Name == "Q" then
			if PlacingProps then
				PlaceProp()
			end
		elseif input.KeyCode == Enum.KeyCode.Z then
			if PlacingProps then
				RotationAxis = 0
			end
		elseif input.KeyCode == Enum.KeyCode.X then
			if PlacingProps then
				RotationAxis = 1
			end
		elseif input.KeyCode == Enum.KeyCode.C then
			if PlacingProps then
				RotationAxis = 2
			end
		end
	end
end)

RunService.RenderStepped:Connect(function() 	
	if PlacingProps and PositionPreview then
		if not Prop then
			PlacingProps = false
			return
		end
		
		local origin = Character.HumanoidRootPart.Position
        local ray = Ray.new(origin, (Mouse.Hit.Position - origin).Unit * 5)
        local p, Pos = workspace:FindPartOnRay(ray, PositionPreview)
        PositionPreviewSafeCFrame = CFrame.new(Pos) * CFrame.new(0, PositionPreview:GetExtentsSize().Y / 2, 0) * Rotation.Value
		PositionPreview.PrimaryPart.CFrame = PositionPreviewSafeCFrame
		
		script.Parent.Frame.Position = UDim2.new(0.5, -50, 0.5, 100)
	elseif Prop or Item then
		local screenPoint
		if Prop then
			screenPoint = Camera:WorldToScreenPoint(Prop.PrimaryPart.Position)
		elseif Item then
			screenPoint = Camera:WorldToScreenPoint(Item.Handle.Position)
		end
		
		local midpoint = UDim2.new(0, screenPoint.X, 0, screenPoint.Y):Lerp(UDim2.new(0.5, -50, 0.5, 100), 0.75)
		script.Parent.Frame.Position = midpoint
	end
end)

while wait(0.2) do
	if not PlacingProps then
		Prop, Item = SearchForProps()
		if Prop then
			script.Parent.Frame.Visible = true
			script.Parent.Frame.InteractLabel.Text = "E to Interact"
			if Prop:FindFirstChild("Health") then
				script.Parent.Frame.ObjectLabel.Text = string.upper(Prop.Name) .. " (" .. Prop.Health.Value .. "/" .. Prop.MaxHealth.Value .. ")"
			else
				script.Parent.Frame.ObjectLabel.Text = string.upper(Prop.Name)
			end
			
			script.SelectionBox.Adornee = Prop
		elseif Item then
			script.Parent.Frame.Visible = true
			script.Parent.Frame.InteractLabel.Text = "E to Pick Up"
			if Item:FindFirstChild("Count") then
				script.Parent.Frame.ObjectLabel.Text = string.upper(Item.Name) .. " (" .. Item.Count.Value .. "x)"
			else
				script.Parent.Frame.ObjectLabel.Text = string.upper(Item.Name)
			end
			
			script.SelectionBox.Adornee = Item
		else
			script.Parent.Frame.Visible = false
			script.SelectionBox.Adornee = nil
		end
	else
		local x , y , z = Rotation.Value:ToEulerAnglesXYZ()

		script.Parent.Frame.InteractLabel.Text = "Q to Drop / E to Place\nX " .. math.floor(math.deg(x) + 0.5) .. 
			" Y " .. math.floor(math.deg(y) + 0.5) .. " Z " .. math.floor(math.deg(z) + 0.5)
	end
end
local closeButton = script.Parent.ExitButton
local updateLogFrame = script.Parent
local sound = "rbxassetid://1278053521"

closeButton.MouseButton1Click:Connect(function()
	updateLogFrame.Visible = false
	sound:Play()
end)
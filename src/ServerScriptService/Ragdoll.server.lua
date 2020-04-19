game.Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		c.Humanoid.BreakJointsOnDeath = false
		c.Humanoid.Died:Connect(function()
			for _, v in pairs (c:GetDescendants()) do
				if v:IsA("Motor6D") then
					local a0,a1 = Instance.new("Attachment"), Instance.new("Attachment")
					a0.CFrame = v.C0
					a1.CFrame = v.c1
					a0.Parent = v.Part0
					a1.Parent = v.Part1
					
					local b = Instance.new("BallSocketConstraint")
					b.Attachment0 = a0
					b.Attachment1 = a1
					b.Parent = v.Part0
					
					v:Destroy()
				end
				
			end
			c.HumanoidRootPart.CanCollide = false
		end)
	end)
end)
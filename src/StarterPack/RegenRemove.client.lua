repeat wait() until script.Parent.Parent.Character:FindFirstChild("Health") --Wait until it exists.
script.Parent.Parent.Character.Health:destroy() --Destroy it.
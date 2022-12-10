if getgenv().loop then
    getgenv().loop:Disconnect()
    --getgenv().loop = false
end

local RPar = RaycastParams.new()        	
RPar.IgnoreWater = true 
RPar.FilterType = Enum.RaycastFilterType.Blacklist
RPar.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, workspace.Camera}

getgenv().loop = game.RunService.RenderStepped:Connect(function()
--while task.wait(0.1) do
    for i,v in pairs (game.Players:GetPlayers()) do
        if v.Character ~= nil and v.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("AK-47") and v.Name ~= "Vaxtrovian" then
            local Dir = v.Character.HumanoidRootPart.Position - workspace.Camera.CFrame.Position
            local Res = workspace:Raycast(workspace.Camera.CFrame.Position, Dir.Unit * Dir.Magnitude, RPar)

            if not Res then continue end
            local Hit = Res.Instance

            if not Hit:FindFirstAncestor(v.Name) then continue end

            local ohString1 = "FireWeapon"
            local ohInstance2 = game.Players.LocalPlayer.Character["AK-47"]
            local ohInstance3 = v.Character.Head
            local ohVector34 = Vector3.new(-0.1531982421875, 0.08709716796875, 0.6892414093017578)
            local ohVector35 = v.Character.Head.Position
            local ohVector36 = game.Players.LocalPlayer.Character.Head.Position

            game:GetService("ReplicatedStorage").Remotes.DamageService.WeaponEvent:FireServer(ohString1, ohInstance2, ohInstance3, ohVector34, ohVector35, ohVector36)
        end
    end

    --[[if getgenv().loop == false then
        return
    end]]
--end
end)
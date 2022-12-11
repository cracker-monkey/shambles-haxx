local WebSocket = syn.websocket.connect("ws://localhost:8022")

getgenv().fps = 0

getgenv().loop = game:GetService("RunService").RenderStepped:Connect(function(step)
	getgenv().fps = math.floor(1/step)
end)

WebSocket.OnMessage:Connect(function(msg)
	if msg == "walk" then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
		print(msg)
	elseif string.find(msg, "saycmd") then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.sub(msg, 8, #msg), "All") 
		print(msg)
	--[[elseif string.find(msg, "walkto") then
		local Plr = string.split(msg, "|")
		game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players[tostring(Plr[2])].Character.HumanoidRootPart.Position)
		print(msg)]]
	elseif string.find(msg, "botcount") then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Clients connected: " ..string.sub(msg, 10, #msg), "All") 
		print(msg)
	elseif string.find(msg, "commands") then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.sub(msg, 10, #msg), "All") 
		print(msg)
	elseif msg == "fps" then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Current FPS: " ..getgenv().fps, "All") 
		print(msg)
    elseif string.find(msg, "joke") then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.sub(msg, 6, #msg), "All") 
		print(msg)
	end
end)

print("websocket loaded.")
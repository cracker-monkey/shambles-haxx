
-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	averageFPS = 60, 
	totalFrames = 0, 
	totalTime = 0, 
	getAverageFPS = function()
		return u1.averageFPS;
	end, 
	gatherMemoryStats = function()
		return {
			Total = game:GetService("Stats"):GetTotalMemoryUsageMb(), 
			Heap = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.LuaHeap), 
			Script = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Script), 
			Gui = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Gui), 
			Signals = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Signals), 
			Sounds = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Sounds), 
			Instances = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Instances), 
			Internal = game:GetService("Stats"):GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Internal)
		};
	end, 
	generateMemoryMarker = function()
		return u1.gatherMemoryStats();
	end, 
	dump = function()
		return {
			AverageFPS = u1.averageFPS, 
			MemoryDump = u1.generateMemoryMarker()
		};
	end
};
local u2 = shared.require("network");
local u3 = shared.require("RenderSteppedRunner");
local u4 = shared.require("HeartbeatRunner");
function u1.onClose()
	print("Closing, sending performance dump");
	u2:send("perfdump", (u1.dump()));
	u3:lock();
	u4:lock();
	task.wait(0.016666666666666666);
end;
function u1.step(p1)
	u1.totalFrames = u1.totalFrames + 1;
	u1.totalTime = u1.totalTime + p1;
	u1.averageFPS = u1.totalFrames / u1.totalTime;
end;
function u1._init()
	game.OnClose = u1.onClose;
	game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(p2)
		if p2 == Enum.TeleportState.InProgress then
			game.OnClose = nil;
			u1.onClose();
		end;
	end);
	u3:addTask("FPSCounter", u1.step);
end;
return u1;


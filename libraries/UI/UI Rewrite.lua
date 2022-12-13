local InputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')
local RunService = game:GetService('RunService')
local GuiService = game:GetService('GuiService')
local RenderStepped = RunService.RenderStepped
local LocalPlayer = game:GetService('Players').LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)

local ScreenGui = Instance.new('ScreenGui')
ProtectGui(ScreenGui)

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

local Toggles = {}
local Options = {}

getgenv().Toggles = Toggles
getgenv().Options = Options

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

local Library = {
    Registry = {},
    RegistryMap = {},

    HudRegistry = {},

    FontColor = Color3.fromRGB(255, 255, 255),
    BackgroundColor = Color3.fromRGB(36, 36, 36),
    BorderColor = Color3.fromRGB(10, 10, 10),
    AccentColor = Color3.fromRGB(117, 62, 153),
    InlineColor = Color3.fromRGB(20, 20, 20),

    OpenedFrames = {},

    Signals = {},
    ScreenGui = ScreenGui,
}

function Library:GiveSignal(Signal)
    table.insert(Library.Signals, Signal)
end

function Library:Create(Class, Properties)
    local _Instance = Class

    if type(Class) == 'string' then
        _Instance = Instance.new(Class)
    end

    for Property, Value in next, Properties do
        _Instance[Property] = Value
    end

    return _Instance
end

function Library:CreateLabel(Properties, IsHud)
        local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Library.FontColor,
        TextSize = 15,
        TextStrokeTransparency = 0.5,
    })

    return Library:Create(_Instance, Properties)
end

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true

   Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            )

            if ObjPos.Y > (Cutoff or 40) then
                return
            end

            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                Instance.Position = UDim2.new(
                    0,
                    Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0,
                    Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                )

                RenderStepped:Wait()
            end
        end
    end)
end

function Library:IsMouseOverFrame(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

        return true
    end
end

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB
end

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true
        end
    end
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance)
    end
end))

function Library:Unload()
    -- Unload all of the signals
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        Connection:Disconnect()
    end

     -- Call our unload callback, maybe to undo some hooks etc
    if Library.OnUnload then
        Library.OnUnload()
    end

    ScreenGui:Destroy()
end

local BaseAddons = {};
do
    local Funcs = {};
end

function ccheck(i, min)
    if i <= min then
        return 0
    else
        return i - min
    end
end

function Library:CreateWindow(...)
    local Arguments = { ... }
    local Config = { AnchorPoint = Vector2.zero }

    if type(...) == 'table' then
        Config = ...;
    else
        Config.Title = Arguments[1]
        Config.AutoShow = Arguments[2] or false;
    end
    
    if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
    
    if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
    if typeof(Config.Size) ~= 'UDim2' then Config.Size = UDim2.fromOffset(550, 600) end

    if Config.Center then
        Config.AnchorPoint = Vector2.new(0.5, 0.5)
        Config.Position = UDim2.fromScale(0.5, 0.5)
    end

    local Window = {
        Tabs = {};
    };

    local Outer = Library:Create('Frame', {
        AnchorPoint = Config.AnchorPoint,
        BackgroundColor3 = Library.BorderColor;
        BorderSizePixel = 0;
        Position = Config.Position,
        Size = Config.Size,
        Visible = true;
        ZIndex = 1;
        Parent = ScreenGui;
    });

    Library:MakeDraggable(Outer, 25);

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.InlineColor;
        BorderColor3 = Library.BorderColor;
        BorderMode = Enum.BorderMode.Outline;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    });
    
    local AccentBar = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 1);
        Size = UDim2.new(1, -4, 0, 1);
        ZIndex = 1;
        Parent = Outer;
    });

    local AccentBar2 = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(Library.AccentColor.R * 255 - 40, Library.AccentColor.G * 255 - 40, Library.AccentColor.B * 255 - 40);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 2);
        Size = UDim2.new(1, -4, 0, 1);
        ZIndex = 1;
        Parent = Outer;
    });

    local Background = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 3);
        Size = UDim2.new(1, -4, 1, -5);
        ZIndex = 1;
        Parent = Outer;
    });

    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(0.06, Library.BackgroundColor),
            ColorSequenceKeypoint.new(1, Library.BackgroundColor)
        });
        Rotation = 90;
        Parent = Background;
    });

    local WindowLabel = Library:CreateLabel({
        Position = UDim2.new(0, 7, 0, -2);
        Size = UDim2.new(0, 0, 0, 25);
        Text = Config.Title or '';
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 2;
        Parent = Inner;
    });

    function Window:SetWindowTitle(Title)
        WindowLabel.Text = Title
    end

    local TabHolderInner = Library:Create('Frame', {
        BackgroundColor3 = Library.InlineColor;
        BorderColor3 = Library.BorderColor;
        BorderMode = Enum.BorderMode.Outline;
        BorderSizePixel = 1;
        Position = UDim2.new(0, 3, 0, 21);
        Size = UDim2.new(1, -6, 1, -24);
        ZIndex = 1;
        Parent = Background;
    });

    local TabHolderBackground = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 4);
        Size = UDim2.new(1, -4, 1, -6);
        ZIndex = 1;
        Parent = TabHolderInner;
    });

    local TabAccentBar = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 0);
        Size = UDim2.new(1, -4, 0, 1);
        ZIndex = 1;
        Parent = TabHolderInner;
    });

    local TabAccentBar2 = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(Library.AccentColor.R * 255 - 40, Library.AccentColor.G * 255 - 40, Library.AccentColor.B * 255 - 40);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 1);
        Size = UDim2.new(1, -4, 0, 1);
        ZIndex = 1;
        Parent = TabHolderInner;
    });

    local TabArea = Library:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 2, 0, 4);
        Size = UDim2.new(1, -4, 0, 34);
        ZIndex = 1;
        Parent = TabHolderInner;
    });

    Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 49, 49)),
            ColorSequenceKeypoint.new(0.06, Library.BackgroundColor),
            ColorSequenceKeypoint.new(1, Library.BackgroundColor)
        });
        Rotation = 90;
        Parent = TabHolderBackground;
    });

    local tabs = #TabHolderBackground:GetChildren()

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
        };
        local TabButtonWidth = Library:GetTextBounds(Name, Enum.Font.Code, 16);

        local TabButton = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.InlineColor;
            BorderSizePixel = 2;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 1;
            Parent = TabArea;
        });

        local TabButtonLabel = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, -1);
            Text = Name;
            ZIndex = 1;
            Parent = TabButton;
        });

        local TabFrame = Library:Create('Frame', {
            Name = 'TabFrame',
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabHolderBackground;
        });

        local LeftSide = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 8, 0, 8);
            Size = UDim2.new(0.5, -12, 0, 507);
            ZIndex = 2;
            Parent = TabFrame;
        });

        local RightSide = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 4, 0, 8);
            Size = UDim2.new(0.5, -12, 0, 507);
            ZIndex = 2;
            Parent = TabFrame;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = LeftSide;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = RightSide;
        });

        function Tab:ShowTab()
            for _, Tab in next, Window.Tabs do
                Tab:HideTab();
            end;

            Blocker.BackgroundTransparency = 0;
            TabButton.BackgroundColor3 = Library.MainColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
            TabFrame.Visible = true;
        end;

        function Tab:HideTab()
            Blocker.BackgroundTransparency = 1;
            TabButton.BackgroundColor3 = Library.BackgroundColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
            TabFrame.Visible = false;
        end;        

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Tab:ShowTab();
            end;
        end);

        if #TabHolderBackground:GetChildren() == 1 then
            Tab:ShowTab();
        end;

        local tabsize = UDim2.new(1 / tabs, 0, 1, 0)

        TabButton.Size = tabsize

        Window.Tabs[Name] = Tab;
        return Tab;
    end;

    Window.Holder = Outer

    return Window;
end;

local window = Library:CreateWindow({Title = 'Shambles Haxx', Center = true, AutoShow = true, Size = UDim2.new(0, 502, 0, 600)})
window:AddTab('Rage')
window:AddTab('Visuals')
window:AddTab('Players')


wait(3)
Library:Unload()
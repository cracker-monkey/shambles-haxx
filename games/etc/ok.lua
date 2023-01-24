local what = {
    function(Q)
        return function()
            local r = ("Seere - %s <UID: %s>"):format("Counter Blox: Remastered", getgenv().uid)
            Q[0][1][Q[0][2]] = library:New({name = r, size = Vector2.new(550, 680)})
            local W = Q[0][1][Q[0][2]]:Page({name = "Legitbot", size = 86})
            local w = Q[0][1][Q[0][2]]:Page({name = "Ragebot", size = 86})
            local l = Q[0][1][Q[0][2]]:Page({name = "Visuals", size = 86})
            local V = Q[0][1][Q[0][2]]:Page({name = "Skins", size = 86})
            local z = Q[0][1][Q[0][2]]:Page({name = "Misc", size = 86})
            local q = Q[0][1][Q[0][2]]:Page({name = "Settings", size = 86})
            do
                local B = W:Section({name = "Aimbot", side = "Left"})
                local e, X, H, L =
                    W:MultiSection({sections = {"Pistols", "SMGs", "Rifles", "Snipers"}, side = "Right", size = 225})
                local S = W:Section({name = "Triggerbot", side = "Right"})
                do
                    B:Toggle({name = "Enable", default = false, pointer = "aimbot toggle"})
                    B:Toggle(
                        {
                            name = "Show FOV",
                            default = false,
                            pointer = "show fov toggle",
                            callback = function(c)
                                Q[1][1][Q[1][2]].assist_fov.Visible = c
                                Q[1][1][Q[1][2]].silent_fov.Visible = c
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Bullet Redirection FOV Color",
                            pointer = "silent aim fov color",
                            default = Color3.new(1, 1, 0),
                            alpha = 0,
                            callback = function(R, d)
                                Q[1][1][Q[1][2]].silent_fov.Color = R
                                Q[1][1][Q[1][2]].silent_fov.Transparency = 1 - d
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Aim Assist FOV Color",
                            pointer = "silent aim fov color",
                            default = Color3.new(1, 1, 1),
                            alpha = 0,
                            callback = function(Z, b)
                                Q[1][1][Q[1][2]].assist_fov.Color = Z
                                Q[1][1][Q[1][2]].assist_fov.Transparency = 1 - b
                            end
                        }
                    )
                    B:Toggle({name = "Aim Assist", default = false, pointer = "aim assist toggle"})
                    B:Slider(
                        {
                            name = "Field of View",
                            pointer = "aim fov",
                            min = 1,
                            max = 500,
                            suffix = "\194\176",
                            default = 100,
                            increments = 0.1
                        }
                    )
                    B:Slider(
                        {
                            name = "Horizontal Smoothing",
                            pointer = "aim smoothness x",
                            min = 1,
                            max = 100,
                            suffix = "%",
                            default = 20
                        }
                    )
                    B:Slider(
                        {
                            name = "Vertical Smoothing",
                            pointer = "aim smoothness y",
                            min = 1,
                            max = 100,
                            suffix = "%",
                            default = 20
                        }
                    )
                    B:Label({name = "Silent Aimbot", middle = true})
                    B:Toggle({name = "Silent Aim", default = false, pointer = "silent aim toggle"})
                    B:Slider(
                        {
                            name = "Field of View",
                            pointer = "silent fov",
                            min = 1,
                            max = 350,
                            suffix = "\194\176",
                            default = 25,
                            increments = 0.1
                        }
                    )
                    B:Slider(
                        {
                            name = "Hitchance",
                            pointer = "silent aim hitchance",
                            min = 1,
                            max = 100,
                            suffix = "%",
                            default = 70,
                            increments = 1
                        }
                    )
                    B:Label({name = "Settings", middle = true})
                    B:Multibox(
                        {
                            name = "Checks",
                            minimum = 0,
                            options = {"Wall Check", "Team Check", "Friend Check"},
                            default = {"Team Check"},
                            pointer = "aim flags"
                        }
                    )
                    B:Multibox(
                        {
                            name = "Hitscan Priority",
                            minimum = 0,
                            options = {"Head", "Torso", "Arms", "Legs"},
                            default = {"Head", "Torso", "Arms", "Legs"},
                            pointer = "aim hitboxes"
                        }
                    )
                    do
                        do
                            e:Toggle({name = "Overwrite Configuration", default = false, pointer = "pistol cfg"})
                            e:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "pistol aim fov",
                                    min = 1,
                                    max = 500,
                                    suffix = "\194\176",
                                    default = 100,
                                    increments = 0.1
                                }
                            )
                            e:Slider(
                                {
                                    name = "Horizontal Smoothing",
                                    pointer = "pistol aim smoothness x",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            e:Slider(
                                {
                                    name = "Vertical Smoothing",
                                    pointer = "pistol aim smoothness y",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            e:Label({name = "Silent Aimbot", middle = true})
                            e:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "pistol silent fov",
                                    min = 1,
                                    max = 350,
                                    suffix = "\194\176",
                                    default = 25,
                                    increments = 0.1
                                }
                            )
                            e:Slider(
                                {
                                    name = "Hitchance",
                                    pointer = "pistol silent aim hitchance",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 70,
                                    increments = 1
                                }
                            )
                        end
                        do
                            X:Toggle({name = "Overwrite Configuration", default = false, pointer = "smg cfg"})
                            X:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "smg aim fov",
                                    min = 1,
                                    max = 500,
                                    suffix = "\194\176",
                                    default = 100,
                                    increments = 0.1
                                }
                            )
                            X:Slider(
                                {
                                    name = "Horizontal Smoothing",
                                    pointer = "smg aim smoothness x",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            X:Slider(
                                {
                                    name = "Vertical Smoothing",
                                    pointer = "smg aim smoothness y",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            X:Label({name = "Silent Aimbot", middle = true})
                            X:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "smg silent fov",
                                    min = 1,
                                    max = 350,
                                    suffix = "\194\176",
                                    default = 25,
                                    increments = 0.1
                                }
                            )
                            X:Slider(
                                {
                                    name = "Hitchance",
                                    pointer = "smg silent aim hitchance",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 70,
                                    increments = 1
                                }
                            )
                        end
                        do
                            H:Toggle({name = "Overwrite Configuration", default = false, pointer = "rifle cfg"})
                            H:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "rifle aim fov",
                                    min = 1,
                                    max = 500,
                                    suffix = "\194\176",
                                    default = 100,
                                    increments = 0.1
                                }
                            )
                            H:Slider(
                                {
                                    name = "Horizontal Smoothing",
                                    pointer = "rifle aim smoothness x",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            H:Slider(
                                {
                                    name = "Vertical Smoothing",
                                    pointer = "rifle aim smoothness y",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            H:Label({name = "Silent Aimbot", middle = true})
                            H:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "rifle silent fov",
                                    min = 1,
                                    max = 350,
                                    suffix = "\194\176",
                                    default = 25,
                                    increments = 0.1
                                }
                            )
                            H:Slider(
                                {
                                    name = "Hitchance",
                                    pointer = "rifle silent aim hitchance",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 70,
                                    increments = 1
                                }
                            )
                        end
                        do
                            L:Toggle({name = "Overwrite Configuration", default = false, pointer = "sniper cfg"})
                            L:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "sniper aim fov",
                                    min = 1,
                                    max = 500,
                                    suffix = "\194\176",
                                    default = 100,
                                    increments = 0.1
                                }
                            )
                            L:Slider(
                                {
                                    name = "Horizontal Smoothing",
                                    pointer = "sniper aim smoothness x",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            L:Slider(
                                {
                                    name = "Vertical Smoothing",
                                    pointer = "sniper aim smoothness y",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 20
                                }
                            )
                            L:Label({name = "Silent Aimbot", middle = true})
                            L:Slider(
                                {
                                    name = "Field of View",
                                    pointer = "sniper silent fov",
                                    min = 1,
                                    max = 350,
                                    suffix = "\194\176",
                                    default = 25,
                                    increments = 0.1
                                }
                            )
                            L:Slider(
                                {
                                    name = "Hitchance",
                                    pointer = "sniper silent aim hitchance",
                                    min = 1,
                                    max = 100,
                                    suffix = "%",
                                    default = 70,
                                    increments = 1
                                }
                            )
                        end
                    end
                end
                do
                    S:Toggle({name = "Enable", pointer = "tb toggle"}):Keybind(
                        {pointer = "tb bind", default = Enum.KeyCode.LeftAlt}
                    )
                    S:Toggle({name = "Magnet Trigger", pointer = "mag tb toggle"})
                    S:Slider(
                        {
                            name = "Triggerbot Delay",
                            pointer = "tb delay",
                            min = 1,
                            max = 200,
                            suffix = "ms",
                            default = 3,
                            increments = 0.1
                        }
                    )
                    S:Slider(
                        {
                            name = "Magnet Smoothness",
                            pointer = "tb mag smoothness",
                            min = 1,
                            max = 50,
                            suffix = "ms",
                            default = 3,
                            increments = 0.1
                        }
                    )
                end
            end
            do
                local p = w:Section({name = "Aimbot", side = "Left"})
                local Z, n, g =
                    w:MultiSection({sections = {"Pointscale", "Lag Comp", "Exploits"}, side = "Left", size = 150})
                local m = w:Section({name = "Anti-Aim", side = "Right"})
                do
                    p:Toggle({name = "Aimbot", default = false, pointer = "rageTgl"})
                    p:Toggle({name = "Knife Bot", default = false, pointer = "knifebotTgl"})
                    p:Toggle({name = "Silent Aim", default = false, pointer = "rageSilent"})
                    p:Toggle({name = "Auto Shoot", default = false, pointer = "autoShootTgl"})
                    p:Toggle({name = "Auto Wall", default = false, pointer = "AutoWallTgl"})
                    p:Toggle({name = "Ignore Friends", default = false, pointer = "ignore friends rage"})
                    p:Multibox(
                        {
                            name = "Hitscan Priority",
                            minimum = 0,
                            options = {"Head", "Torso", "Arms", "Legs"},
                            default = {"Head"},
                            pointer = "rage hitboxes"
                        }
                    )
                    p:Dropdown(
                        {name = "Bullet Origin", options = {"Camera", "Weapon"}, pointer = "selected_rage_origin"}
                    )
                    p:Slider(
                        {
                            name = "FOV",
                            pointer = "silentFOV",
                            min = 1,
                            max = 180,
                            suffix = Q[2][1][Q[2][2]],
                            default = 180,
                            increments = 1
                        }
                    )
                    p:Slider(
                        {
                            name = "Hitchance",
                            pointer = "silentHitchance",
                            min = 1,
                            max = 100,
                            suffix = "%",
                            default = 70,
                            increments = 1
                        }
                    )
                    p:Slider(
                        {
                            name = "Minimum Damage",
                            pointer = "mdSlider",
                            min = 1,
                            max = 100,
                            suffix = "hp",
                            default = 49,
                            increments = 1
                        }
                    )
                    Z:Slider(
                        {
                            name = "Head Pointscale",
                            pointer = "HeadScale",
                            min = 0.5,
                            max = 15,
                            default = 4.5,
                            increments = 0.01,
                            callback = function(A)
                                rawset(hbPoints, "Head", A)
                                rawset(hbPoints, "FakeHead", A)
                                rawset(hbPoints, "HeadHB", A)
                            end
                        }
                    )
                    Z:Slider(
                        {
                            name = "Body Pointscale",
                            pointer = "bodyScale",
                            min = 0.5,
                            max = 15,
                            default = 1.35,
                            increments = 0.01,
                            callback = function(O)
                                rawset(hbPoints, "UpperTorso", O)
                                rawset(hbPoints, "LowerTorso", O)
                            end
                        }
                    )
                    Z:Slider(
                        {
                            name = "Arms Pointscale",
                            pointer = "armsScale",
                            min = 0.5,
                            max = 15,
                            default = 1.2,
                            increments = 0.01,
                            callback = function(b)
                                rawset(hbPoints, "LeftUpperArm", b)
                                rawset(hbPoints, "LeftLowerArm", b)
                                rawset(hbPoints, "LeftHand", b)
                                rawset(hbPoints, "RightUpperArm", b)
                                rawset(hbPoints, "RightLowerArm", b)
                                rawset(hbPoints, "RightHand", b)
                            end
                        }
                    )
                    Z:Slider(
                        {
                            name = "Feet Pointscale",
                            pointer = "feetScale",
                            min = 0.5,
                            max = 15,
                            default = 0.82,
                            increments = 0.01,
                            callback = function(D)
                                rawset(hbPoints, "LeftUpperLeg", D)
                                rawset(hbPoints, "LeftLowerLeg", D)
                                rawset(hbPoints, "LeftFoot", D)
                                rawset(hbPoints, "RightUpperLeg", D)
                                rawset(hbPoints, "RightLowerLeg", D)
                                rawset(hbPoints, "RightFoot", D)
                            end
                        }
                    )
                end
                do
                    do
                        n:Toggle({name = "Lag Compensation", default = false, pointer = "lcEnabled"})
                        n:Slider(
                            {
                                name = "Lag Compensation Ticks",
                                pointer = "lcTicks",
                                min = 1,
                                max = 2,
                                suffix = "ticks",
                                default = 1,
                                increments = 0.1
                            }
                        )
                        n:Toggle({name = "Backtrack", default = false, pointer = "backtrackTgl"})
                        n:Toggle({name = "Visualize BT", default = false, pointer = "btChams"}):Colorpicker(
                            {
                                name = "Backtrack Chams Color",
                                pointer = "btChams color",
                                default = Color3.new(.7, .7, .7)
                            }
                        )
                        n:Slider(
                            {
                                name = "Backtrack Ticks",
                                pointer = "btTicks",
                                min = 1,
                                max = 5,
                                suffix = "ticks",
                                default = 1,
                                increments = 1
                            }
                        )
                    end
                    do
                        g:Toggle({name = "Ignore Walls", default = false, pointer = "ignore walls"})
                        g:Toggle({name = "Camera Exploit breaker", default = false, pointer = "camExpBreaker"})
                        g:Toggle({name = "Shoot Camera Exploit", default = false, pointer = "camShooter"})
                        g:Button(
                            {
                                name = "Kill All",
                                callback = function()
                                    pcall(
                                        function()
                                            local B = Q[3][1][Q[3][2]].Events.GGGHGGHG
                                            for H, x in next, Q[4][1][Q[4][2]]:GetPlayers() do
                                                if x ~= Q[5][1][Q[5][2]] and teamCheck(x, false) and x.Team ~= "TTT" then
                                                    if
                                                        x.Character ~= nil and
                                                            x.Character:FindFirstChild("HumanoidRootPart")
                                                     then
                                                        sendDamage(x.Character, "HeadHB", true)
                                                    end
                                                end
                                            end
                                        end
                                    )
                                end
                            }
                        )
                    end
                end
                do
                    m:Toggle({name = "Anti Aim", default = false, pointer = "aaTgl"})
                    m:Toggle({name = "Extended Pitch", default = false, pointer = "extendedPitch"})
                    m:Toggle({name = "Jitter", default = false, pointer = "jitterTgl"})
                    m:Label({name = "Angles", Middle = true})
                    m:Dropdown({name = "Pitch", options = {"Down", "Up"}, pointer = "AntiAim_Pitch"})
                    m:Dropdown({name = "Yaw Base", options = {"Back", "Spin", "Targets"}, pointer = "AntiAim_Base"})
                    m:Slider(
                        {
                            name = "Yaw Offset",
                            pointer = "AntiAim_Yaw_Offset",
                            min = -180.0,
                            max = 180,
                            default = 0,
                            increments = 1
                        }
                    )
                    m:Slider(
                        {
                            name = "Spin Offset",
                            pointer = "AntiAim_Spin_Power",
                            min = 1,
                            max = 180,
                            default = 90,
                            increments = 1
                        }
                    )
                    m:Slider(
                        {
                            name = "Jitter Offset",
                            pointer = "Jitter_Offset",
                            min = 1,
                            max = 180,
                            default = 90,
                            increments = 1
                        }
                    )
                    m:Slider(
                        {
                            name = "Extended Pitch",
                            pointer = "Extended_Pitch_Ammount",
                            min = -1.0,
                            max = 1,
                            default = 1.1,
                            increments = 0.1
                        }
                    )
                    m:Dropdown({name = "Legs Animations", options = {"Default", "Slide"}, pointer = "Legs_Animations"})
                    m:Label({name = "Fakelag", Middle = true})
                    m:Toggle({name = "Fake Lag", default = false, pointer = "flTgl"})
                    m:Toggle({name = "Visualize Fake", default = false, pointer = "flChamsTgl"}):Colorpicker(
                        {name = "Fake Lag Chams Color", pointer = "flChamsColor", default = Color3.new(.7, .7, .7)}
                    )
                    m:Slider(
                        {
                            name = "Fake Lag Ticks",
                            pointer = "FakeLag_Ticks",
                            min = 1,
                            max = 18,
                            default = 14,
                            increments = 0.2
                        }
                    )
                    m:Dropdown({name = "Fake Lag Mode", options = {"Static", "Dynamic"}, pointer = "FL_Mode"})
                end
            end
            do
                local s = l:Section({name = "Players", side = "Left"})
                local S, M, F =
                    l:MultiSection({sections = {"Misc", "Objects", "Viewmodel"}, side = "Right", size = 290})
                local U = l:Section({name = "Environment", side = "Right"})
                do
                    s:Toggle(
                        {
                            name = "Enable",
                            default = false,
                            pointer = "esp toggle",
                            callback = function(Z)
                                esp.enabled = Z
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Teamcheck",
                            default = false,
                            pointer = "esp teamcheck",
                            callback = function(H)
                                esp.teamcheck = H
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Bounding Box",
                            default = false,
                            pointer = "esp boxes",
                            callback = function(O)
                                esp.box[1] = O
                                esp.boxfill[1] = O
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Box Fill",
                            pointer = "esp fillboxes color",
                            default = Color3.new(1, 1, 1),
                            alpha = 1,
                            callback = function(i, b)
                                esp.boxfill[2] = i
                                esp.boxfill[3] = 1 - b
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Box Inline",
                            pointer = "esp boxes color",
                            default = Color3.new(1, 1, 1),
                            alpha = 0,
                            callback = function(J, T)
                                esp.box[2] = J
                                esp.box[3] = 1 - T
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Health Bar",
                            default = false,
                            pointer = "esp distances",
                            callback = function(x)
                                esp.barlayout["Health"].Enabled = x
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Health Color (>50)",
                            pointer = "health bar color1",
                            default = Color3.new(0, 1, 0),
                            callback = function(y)
                                esp.barlayout["Health"].Color2 = y
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Health Color (<50)",
                            pointer = "health bar color2",
                            default = Color3.new(1, 0, 0),
                            callback = function(X)
                                esp.barlayout["Health"].Color1 = X
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Skeleton",
                            default = false,
                            pointer = "esp skeleton",
                            callback = function(n)
                                esp.skeleton[1] = n
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Skeleton Color",
                            pointer = "esp skeleton color",
                            default = Color3.new(1, 1, 1),
                            alpha = .25,
                            callback = function(J, X)
                                esp.skeleton[2] = J
                                esp.skeleton[3] = 1 - X
                            end
                        }
                    )
                    s:Toggle({name = "Chams", default = false, pointer = "chams toggle"}):Colorpicker(
                        {name = "Chams Fill", pointer = "chams fill", default = Color3.new(.25, .25, .25), alpha = 0.7}
                    ):Colorpicker(
                        {
                            name = "Chams Outline",
                            pointer = "chams outline",
                            default = Color3.new(.75, .75, .75),
                            alpha = 0.2
                        }
                    )
                    s:Toggle({name = "Chams Occlusion", default = false, pointer = "chams mode"})
                    s:Toggle({name = "Radar Reveal", default = false, pointer = "esp radar"})
                    s:Dropdown(
                        {
                            name = "Custom Box",
                            options = {"Default", "Corner"},
                            default = "Default",
                            pointer = "esp bounding box",
                            callback = function(B)
                                esp.custombox = string.lower(B)
                            end
                        }
                    )
                    s:Multibox(
                        {
                            name = "Player Info",
                            minimum = 0,
                            options = {"Name", "Health", "Distance"},
                            default = {},
                            pointer = "esp infobox",
                            callback = function(A)
                                esp.textlayout["Name"].Enabled = table.find(A, "Name") and true or false
                                esp.textlayout["Distance"].Enabled = table.find(A, "Distance") and true or false
                                esp.textlayout["Health"].Enabled = table.find(A, "Health") and true or false
                            end
                        }
                    )
                    s:Dropdown(
                        {
                            name = "Name Position",
                            options = {"Top", "Bottom", "Left", "Right"},
                            default = "bottom",
                            pointer = "esp name position",
                            callback = function(X)
                                esp.textlayout["Name"].Position = string.lower(X)
                            end
                        }
                    )
                    s:Dropdown(
                        {
                            name = "Health Position",
                            options = {"Top", "Bottom", "Left", "Right"},
                            default = "left",
                            pointer = "esp health position",
                            callback = function(t)
                                esp.textlayout["Health"].Position = string.lower(t)
                                esp.barlayout["Health"].Position = string.lower(t)
                            end
                        }
                    )
                    s:Dropdown(
                        {
                            name = "Distance Position",
                            options = {"Top", "Bottom", "Left", "Right"},
                            default = "bottom",
                            pointer = "esp distance position",
                            callback = function(R)
                                esp.textlayout["Distance"].Position = string.lower(R)
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Tracers",
                            default = false,
                            pointer = "esp tracers",
                            callback = function(Y)
                                esp.tracer[1] = Y
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Tracer Color",
                            pointer = "esp tracer color",
                            default = Color3.new(1, 1, 1),
                            alpha = 0,
                            callback = function(O, L)
                                esp.tracer[2] = O
                                esp.tracer[3] = 1 - L
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Visualize Angles",
                            default = false,
                            pointer = "esp angles",
                            callback = function(R)
                                esp.angle[1] = R
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Angles Color",
                            pointer = "esp angles color",
                            default = Color3.new(1, 1, 1),
                            alpha = 0.4,
                            callback = function(E, d)
                                esp.angle[2] = E
                                esp.angle[3] = 1 - d
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Arrows",
                            default = false,
                            pointer = "esp angles",
                            callback = function(h)
                                esp.arrow[1] = h
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Onscreen Arrows",
                            pointer = "esp on_arrows color",
                            default = Color3.new(0, 1, 0),
                            alpha = 0,
                            callback = function(f, c)
                                esp.arrow[2] = f
                                esp.arrow[4] = c
                            end
                        }
                    ):Colorpicker(
                        {
                            name = "Offscreen Arrows",
                            pointer = "esp off_arrows color",
                            default = Color3.new(1, 0, 0),
                            alpha = 0.5,
                            callback = function(f, P)
                                esp.arrow[3] = f
                                esp.arrow[5] = P
                            end
                        }
                    )
                    s:Slider(
                        {
                            name = "Arrow Size",
                            pointer = "esp arrow size",
                            min = 3,
                            max = 20,
                            default = 5.5,
                            increments = 0.1,
                            callback = function(h)
                                esp.arrowsize = h
                            end
                        }
                    )
                    s:Slider(
                        {
                            name = "Arrow Radius",
                            pointer = "esp arrow Radius",
                            min = 20,
                            max = 600,
                            default = 400,
                            suffix = "\194\176",
                            increments = 0.5,
                            callback = function(p)
                                esp.arrowradius = p
                            end
                        }
                    )
                    s:Toggle(
                        {
                            name = "Limit Distance",
                            default = false,
                            pointer = "esp limit distance",
                            callback = function(e)
                                esp.limitdistance = e
                            end
                        }
                    )
                    s:Slider(
                        {
                            name = "Max Distance",
                            pointer = "esp max distance",
                            min = 50,
                            max = 1000,
                            default = 1000,
                            suffix = "m",
                            callback = function(H)
                                esp.maxdistance = H
                            end
                        }
                    )
                    U:Toggle({name = "Ambience", default = false, pointer = "world ambience"}):Colorpicker(
                        {name = "Indoor Ambience", pointer = "indoor ambience", default = Color3.new(.45, .45, .45)}
                    ):Colorpicker(
                        {name = "Outdoor Ambience", pointer = "outdoor ambience", default = Color3.new(.45, .45, .45)}
                    )
                    U:Toggle({name = "Toggle Clock", default = false, pointer = "env clock toggle"})
                    U:Slider(
                        {
                            name = "Clock Time",
                            pointer = "env clock time",
                            min = 0,
                            max = 24,
                            default = 12,
                            suffix = "am/pm",
                            increments = 0.01
                        }
                    )
                    U:Toggle(
                        {name = "Skybox Changer", default = false, pointer = "skybox changer", callback = updateSkybox}
                    )
                    U:Dropdown(
                        {
                            name = "Skyboxes",
                            options = {
                                "Aesthetic Night",
                                "Cloudy Skies",
                                "Counter Strike City",
                                "Elegant Morning",
                                "Midnight",
                                "Morning Glow",
                                "Neptune",
                                "Night Sky",
                                "Pink Daylight",
                                "Purple Nebula",
                                "Redshift",
                                "Fade Blue",
                                "Robux Gen",
                                "Setting Sun"
                            },
                            pointer = "selected skybox",
                            callback = updateSkybox
                        }
                    )
                    U:Slider(
                        {
                            name = "Map Reflectance",
                            pointer = "map reflectance",
                            min = 0,
                            max = 100,
                            default = 12,
                            suffix = "%",
                            increments = 0.1
                        }
                    )
                    U:Button(
                        {
                            name = "Delete Textures",
                            callback = function()
                                for a, f in pairs(workspace.Map:GetDescendants()) do
                                    if
                                        f:IsA("Part") or f:IsA("BasePart") or f:IsA("UnionOperation") or
                                            f:IsA("CornerWedgePart") or
                                            f:IsA("TrussPart")
                                     then
                                        f.Material = "Plastic"
                                        f.Reflectance = get("map reflectance") / 100
                                    end
                                    if f:IsA("MeshPart") then
                                        f.TextureID = Q[2][1][Q[2][2]]
                                        f.Material = "Plastic"
                                        f.Reflectance = get("map reflectance") / 100
                                    end
                                    if f:IsA("Decal") and f.Parent and f.Parent.Name ~= "Radar" then
                                        f:Destroy()
                                    end
                                end
                            end
                        }
                    )
                    U:Multibox(
                        {
                            name = "Removals",
                            minimum = 0,
                            options = {"Scope", "Blood", "Bullet Holes", "Flash", "Shadows"},
                            default = {"--"},
                            pointer = "removalstab"
                        }
                    )
                    S:Toggle({name = "Bullet Impacts", default = false, pointer = "bullet impacts"}):Colorpicker(
                        {
                            name = "Part Color (Wallbanged)",
                            pointer = "wallbang impact color",
                            default = Color3.new(1, .43, .43)
                        }
                    ):Colorpicker(
                        {name = "Part Color", pointer = "normal impact color", default = Color3.new(.43, .57, 1)}
                    )
                    S:Toggle({name = "Bullet Tracers", default = false, pointer = "bullet tracers"}):Colorpicker(
                        {name = "Tracer Color", pointer = "bullet tracer color", default = Color3.new(.7, .7, .7)}
                    ):Colorpicker(
                        {
                            name = "Tracer Color (On Hit)",
                            pointer = "bullet tracer on hit",
                            default = Color3.new(1, 0, 0)
                        }
                    )
                    S:Toggle({name = "Arm Chams", default = false, pointer = "arm chams"}):Colorpicker(
                        {name = "Arm Color", pointer = "arm color", default = Color3.new(.7, .7, .7)}
                    )
                    S:Dropdown(
                        {name = "Arm Material", options = {"Plastic", "Neon", "ForceField"}, pointer = "arm material"}
                    )
                    S:Toggle({name = "Glove Chams", default = false, pointer = "glove chams"}):Colorpicker(
                        {name = "Glove Color", pointer = "glove color", default = Color3.new(.7, .7, .7)}
                    )
                    S:Dropdown(
                        {
                            name = "Glove Material",
                            options = {"Plastic", "Neon", "ForceField"},
                            pointer = "glove material"
                        }
                    )
                    S:Toggle({name = "Sleeve Chams", default = false, pointer = "sleeve chams"}):Colorpicker(
                        {name = "Sleeve Color", pointer = "sleeve color", default = Color3.new(.7, .7, .7)}
                    )
                    S:Dropdown(
                        {
                            name = "Sleeve Material",
                            options = {"Plastic", "Neon", "ForceField"},
                            pointer = "sleeve material"
                        }
                    )
                    S:Dropdown(
                        {
                            name = "ForceField Texture",
                            options = {"Hex", "Checkers", "Pentagons", "Misc 1", "Misc 2"},
                            pointer = "chams ff texture"
                        }
                    )
                    M:Toggle({name = "Highlight Bomb", default = false, pointer = "bomb esp"}):Colorpicker(
                        {
                            name = "Bomb Highlight Color (Dropped)",
                            pointer = "dropped bomb color",
                            default = Color3.new(0, 1, 0)
                        }
                    ):Colorpicker(
                        {
                            name = "Bomb Highlight Color (Planted)",
                            pointer = "planted bomb color",
                            default = Color3.new(1, 0, 0)
                        }
                    )
                    M:Toggle({name = "Highlight Carrier", default = false, pointer = "bomb carrier esp"}):Colorpicker(
                        {name = "Bomb Carrier Color", pointer = "bomb carrier color", default = Color3.new(1, .67, .1)}
                    )
                    M:Toggle({name = "Bomb Indicator", default = false, pointer = "bomb info"})
                    M:Toggle({name = "Molotov Modulation", default = false, pointer = "molotov modulation"}):Colorpicker(
                        {name = "Molotov Color", pointer = "Molotov_Color", default = Color3.new(.7, .7, .7)}
                    )
                    M:Toggle({name = "Molotov Radius", default = false, pointer = "mollyradius"}):Colorpicker(
                        {
                            name = "Molotov Radius Color",
                            pointer = "Molotov_Color_Radius",
                            default = Color3.new(.7, .7, .7)
                        }
                    )
                    M:Toggle({name = "Grenade Radius", default = false, pointer = "heRadius"}):Colorpicker(
                        {
                            name = "Grenade Radius Color",
                            pointer = "grenade_radius_color",
                            default = Color3.new(.7, .7, .7)
                        }
                    )
                    M:Toggle({name = "Grenade Indicator", default = false, pointer = "heDamage"})
                    M:Toggle({name = "Smoke Modulation", default = false, pointer = "smoke modulation"}):Colorpicker(
                        {name = "Smoke Color", pointer = "Smoke_Color", default = Color3.new(.7, .7, .7)}
                    )
                    M:Toggle({name = "Smoke Radius", default = false, pointer = "smokeradius"}):Colorpicker(
                        {name = "Smoke Radius Color", pointer = "Smoke_Color_Radius", default = Color3.new(.7, .7, .7)}
                    )
                    M:Toggle({name = "Smoke Reduction", default = false, pointer = "smoke reduction"})
                    M:Slider(
                        {
                            name = "Reduction Rate",
                            pointer = "smoke reduction rate",
                            min = 0,
                            max = 100,
                            default = 50,
                            suffix = "%"
                        }
                    )
                    F:Toggle(
                        {
                            name = "FOV Changer",
                            default = false,
                            pointer = "fovchanger",
                            callback = function(m)
                                if m then
                                    Q[6][1][Q[6][2]]:BindToRenderStep(
                                        "fovchanged",
                                        100,
                                        function()
                                            pcall(
                                                function()
                                                    Q[7][1][Q[7][2]].FieldOfView = get("fovSlider")
                                                end
                                            )
                                        end
                                    )
                                else
                                    Q[6][1][Q[6][2]]:UnbindFromRenderStep("fovchanged")
                                    Q[7][1][Q[7][2]].FieldOfView = 75
                                end
                            end
                        }
                    )
                    F:Slider(
                        {
                            name = "Field of View",
                            pointer = "fovSlider",
                            min = 75,
                            max = 120,
                            default = Q[7][1][Q[7][2]].FieldOfView or 75,
                            suffix = "\194\176",
                            increments = 1
                        }
                    )
                    F:Toggle({name = "Viewmodel Changer", default = false, pointer = "viewmodelchange"})
                    F:Slider(
                        {
                            name = "Viewmodel X",
                            pointer = "viewmodelx",
                            min = -30.0,
                            max = 10,
                            default = 0,
                            suffix = "\194\176",
                            increments = 0.1
                        }
                    )
                    F:Slider(
                        {
                            name = "Viewmodel Y",
                            pointer = "viewmodely",
                            min = -30.0,
                            max = 10,
                            default = 0,
                            suffix = "\194\176",
                            increments = 0.1
                        }
                    )
                    F:Slider(
                        {
                            name = "Viewmodel Z",
                            pointer = "viewmodelz",
                            min = -30.0,
                            max = 10,
                            default = 0,
                            suffix = "\194\176",
                            increments = 0.1
                        }
                    )
                    F:Slider(
                        {
                            name = "Roll",
                            pointer = "viewmodelroll",
                            min = -180.0,
                            max = 180,
                            default = 0,
                            suffix = "\194\176",
                            increments = 1
                        }
                    )
                    F:Multibox(
                        {
                            name = "Removals",
                            minimum = 0,
                            options = {"Arms", "Sleeves", "Gloves"},
                            default = {Q[2][1][Q[2][2]]},
                            pointer = "arm removals"
                        }
                    )
                end
            end
            do
                local c = z:Section({name = "LocalPlayer", side = "Left"})
                local E = z:Section({name = "Exploits", side = "Left"})
                local h = z:Section({name = "Weapon Changer", side = "Right"})
                local b = z:Section({name = "Other", side = "Right"})
                do
                    c:Toggle(
                        {
                            name = "Fast Crouch",
                            default = false,
                            pointer = "fast crouch",
                            callback = function(m)
                                if m then
                                    Q[6][1][Q[6][2]]:BindToRenderStep(
                                        "Stamina",
                                        100,
                                        function()
                                            if client.crouchcooldown ~= 0 then
                                                client.crouchcooldown = 0.4
                                            end
                                        end
                                    )
                                else
                                    Q[6][1][Q[6][2]]:UnbindFromRenderStep("Stamina")
                                end
                            end
                        }
                    )
                    c:Toggle({name = "Bunny Hop", default = false, pointer = "bhopTgl"})
                    c:Slider(
                        {
                            name = "Bunny Hop Speed",
                            pointer = "bhopSpeed",
                            min = 22,
                            max = 300,
                            default = 22,
                            increments = 1
                        }
                    )
                    c:Toggle(
                        {
                            name = "Third Person",
                            default = false,
                            pointer = "third person",
                            callback = function(T)
                                if not T then
                                    Q[5][1][Q[5][2]].CameraMaxZoomDistance = 0
                                    Q[5][1][Q[5][2]].CameraMinZoomDistance = 0
                                end 
                            end
                        }
                    ):Keybind({pointer = "tp bind", default = Enum.KeyCode.LeftAlt, mode = "Toggle"})
                    c:Slider(
                        {
                            name = "Distance",
                            pointer = "third person distance",
                            min = 0,
                            max = 60,
                            default = 10,
                            increments = 0.1
                        }
                    )
                    c:Toggle(
                        {name = "Local Radius", default = false, pointer = "local radius", callback = function(x)
                            end}
                    ):Colorpicker(
                        {name = "Local Radius Color", pointer = "local radius color", default = Color3.new(1, 1, 1)}
                    )
                    c:Slider(
                        {
                            name = "Radius Size",
                            pointer = "local radius size",
                            min = 1.5,
                            max = 3.5,
                            default = 3,
                            increments = 0.1
                        }
                    )
                    c:Slider(
                        {
                            name = "Radius Offset",
                            pointer = "local radius offset",
                            min = -3.0,
                            max = 1,
                            default = 0,
                            increments = 0.01
                        }
                    )
                    E:Toggle({name = "Anti Spectate", default = false, pointer = "antiSpectateTgl"})
                    E:Toggle({name = "Infinite Ammo", default = false, pointer = "infiniteAmmoTgl"})
                    E:Toggle({name = "No Recoil", default = false, pointer = "noRecoilTgl"})
                    E:Toggle({name = "No Fall Damage", default = false, pointer = "noFallDmg"})
                    E:Toggle({name = "No Fire Damage", default = false, pointer = "noFireDamage"})
                    E:Toggle({name = "No Chat Filter", default = false, pointer = "no chat filter"})
                    E:Toggle({name = "Infinite Cash", default = false, pointer = "infMoneyEXP"})
                    E:Toggle(
                        {
                            name = "Free Guns",
                            default = false,
                            pointer = "freeItemsTgl",
                            callback = function(O)
                                if O then
                                    hookfunction(
                                        Q[8][1][Q[8][2]],
                                        function(G)
                                            return 0
                                        end
                                    )
                                end
                            end
                        }
                    )
                    E:Toggle({name = "Auto Defuse C4", default = false, pointer = "defuse Bomb"})
                    E:Button(
                        {
                            name = "Break C4",
                            callback = function()
                                if isAlive() then
                                    if workspace.Debris:FindFirstChild("C4") then
                                        if Q[5][1][Q[5][2]].Status.Team.Value == "CT" then
                                            Q[3][1][Q[3][2]].Events.PickUp:FireServer(workspace.Debris.C4)
                                            Q[3][1][Q[3][2]].Events.DestroyObject:FireServer(workspace.Debris.C4)
                                            library:CreateNotification("Bomb has been broken!", Color3.new(0, 1, 0))
                                        else
                                            library:CreateNotification(
                                                "You need to be CT to break the bomb!",
                                                Color3.new(1, 0, 0)
                                            )
                                        end
                                    else
                                        library:CreateNotification("Bomb is not dropped!", Color3.new(1, 0, 0))
                                    end
                                end
                            end
                        }
                    )
                    E:Button(
                        {
                            name = "Plant C4",
                            callback = function()
                                if isAlive() then
                                    if Q[5][1][Q[5][2]].Status.Team.Value == "T" then
                                        if Q[5][1][Q[5][2]].Character:FindFirstChild("BackC4") then
                                            local O = Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame
                                            Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame =
                                                workspace.Map.SpawnPoints.C4Plant.CFrame
                                            wait(.5)
                                            Q[3][1][Q[3][2]].Events.PlantC4:FireServer(
                                                Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame *
                                                    CFrame.new(0, -2.13, 0) *
                                                    CFrame.Angles(1.5707963267948966, 0, 3.141592653589793),
                                                "B"
                                            )
                                            wait(.5)
                                            Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame = O
                                        else
                                            library:CreateNotification("You do not have the C4", Color3.new(1, 0, 0))
                                        end
                                    else
                                        library:CreateNotification(
                                            "You need to be a Terrorist in order to plant the bomb.",
                                            Color3.new(1, 0, 0)
                                        )
                                    end
                                end
                            end
                        }
                    )
                    E:Button(
                        {
                            name = "Defuse C4",
                            callback = function()
                                if isAlive() then
                                    if Q[5][1][Q[5][2]].Status.Team.Value == "CT" then
                                        if workspace:FindFirstChild("C4") then
                                            local s = Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame
                                            Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame = workspace.C4.CFrame
                                            wait(.5)
                                            Q[5][1][Q[5][2]].Backpack.Defuse:FireServer(workspace.C4)
                                            wait(.5)
                                            Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame = s
                                            library:CreateNotification("Bomb has been defused!", Color3.new(0, 1, 0))
                                        else
                                            library:CreateNotification("Bomb is not planted!", Color3.new(1, 0, 0))
                                        end
                                    else
                                        library:CreateNotification(
                                            "You need to be CT in order to defuse the bomb!",
                                            Color3.new(1, 0, 0)
                                        )
                                    end
                                end
                            end
                        }
                    )
                    E:Button(
                        {
                            name = "Crash Spectators",
                            callback = function()
                                if Q[9][1][Q[9][2]] or not isAlive() then
                                    return
                                else
                                    Q[9][1][Q[9][2]] = true
                                    library:CreateNotification("Crashing Spectators")
                                    for u = 1, 8000 do
                                        Q[3][1][Q[3][2]].Events.ReplicateAnimation:FireServer("Fire")
                                    end
                                    library:CreateNotification("Request Completed")
                                    Q[9][1][Q[9][2]] = false
                                end
                            end
                        }
                    )
                    E:Button(
                        {
                            name = "Spawn Weapons",
                            callback = function()
                                if isAlive() then
                                    for J, D in pairs(Q[3][1][Q[3][2]].Modules.WeaponData.Assets:GetChildren()) do
                                        local L = Q[10][1][Q[10][2]][D.Name]
                                        local d = Q[5][1][Q[5][2]].Character.HumanoidRootPart.CFrame
                                        local P = 12
                                        local a = 24
                                        local i = false
                                        local C = nil
                                        local N = false
                                        local S = false
                                        Q[3][1][Q[3][2]].Events.Drop:FireServer(L, d, P, a, i, C, N, S)
                                    end
                                end
                            end
                        }
                    )
                    do
                        h:Toggle({name = "Enable", default = false, pointer = "gunGiveEXP"})
                        h:Dropdown(
                            {name = "Weapon", options = {"AWP", "Scout", "G3SG1", "AK47"}, pointer = "selected_weapon"}
                        )
                        h:Dropdown(
                            {name = "Weapon Type", options = {"Primary", "Secondary"}, pointer = "weapon_priority"}
                        )
                    end
                    do
                        b:Toggle({name = "Force Crosshair", default = false, pointer = "force crosshair"})
                        b:Toggle({name = "Hitmarkers", default = false, pointer = "hitmarkers"})
                        b:Toggle({name = "Hitlogs", default = false, pointer = "hitlogs"})
                        b:Toggle({name = "Visualize Hits", default = false, pointer = "hit chams"}):Colorpicker(
                            {name = "Hit Chams Color", pointer = "hit chams color", default = Color3.new(.7, .7, .7)}
                        )
                        b:Dropdown(
                            {
                                name = "Hitmarker Type",
                                options = {"Screen", "World"},
                                default = "Local",
                                pointer = "hitmarker type"
                            }
                        )
                        b:Dropdown(
                            {
                                name = "Hitsound",
                                options = {
                                    "Disabled",
                                    "Osu",
                                    "Quack",
                                    "Bamboo",
                                    "UI",
                                    "Baimware",
                                    "Headshot",
                                    "Hitmarker",
                                    "Minecraft",
                                    "Moan",
                                    "Neverlose",
                                    "Punch",
                                    "PVC",
                                    "Skeet",
                                    "Click"
                                },
                                pointer = "selected hitsound"
                            }
                        )
                        b:Slider(
                            {name = "Volume", pointer = "hit volume", min = 0, max = 100, default = 50, suffix = "%"}
                        )
                        b:Dropdown(
                            {
                                name = "Killsound",
                                options = {
                                    "Disabled",
                                    "Kombat",
                                    "Mario",
                                    "Headshot",
                                    "Elevator",
                                    "Sit",
                                    "Rust",
                                    "Taco Bell"
                                },
                                pointer = "selected killsound"
                            }
                        )
                        b:Slider(
                            {name = "Volume", pointer = "kill volume", min = 0, max = 100, default = 50, suffix = "%"}
                        )
                        b:Toggle({name = "Kill Say", pointer = "kill say"})
                        b:Toggle(
                            {
                                name = "Stats Debug",
                                default = false,
                                pointer = "stats debug",
                                callback = function(n)
                                    if n then
                                        Q[1][1][Q[1][2]].debugText.Visible = true
                                        Q[6][1][Q[6][2]]:BindToRenderStep(
                                            "debugStats",
                                            100,
                                            function()
                                                pcall(
                                                    function()
                                                        Q[1][1][Q[1][2]].debugText.Text =
                                                            ("Memory Usage: %smb\nData Received: %smb\nData Sent: %smb\nPosition: %s\nVelocity: %s m/s\nMinimum Damage: %s\nHitchance: %s%%\nGun: %s"):format(
                                                            math.floor(Q[11][1][Q[11][2]]:GetTotalMemoryUsageMb()),
                                                            math.floor(Q[11][1][Q[11][2]].DataReceiveKbps),
                                                            math.floor(Q[11][1][Q[11][2]].DataSendKbps),
                                                            isAlive() and
                                                                toStr(
                                                                    Q[5][1][Q[5][2]].Character.HumanoidRootPart.Position
                                                                ) or
                                                                "??",
                                                            isAlive() and
                                                                math.floor(
                                                                    math.clamp(
                                                                        (Q[5][1][Q[5][2]].Character.HumanoidRootPart.Velocity *
                                                                            Vector3.new(1, 0, 1)).magnitude * 14.85,
                                                                        0,
                                                                        600
                                                                    )
                                                                ) or
                                                                "??",
                                                            get("mdSlider"),
                                                            get("silentHitchance"),
                                                            isAlive() and
                                                                toStr(Q[5][1][Q[5][2]].Character.EquippedTool.Value) or
                                                                "??"
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    else
                                        Q[1][1][Q[1][2]].debugText.Visible = false
                                        Q[1][1][Q[1][2]].debugText.Text = Q[2][1][Q[2][2]]
                                        Q[6][1][Q[6][2]]:UnbindFromRenderStep("debugStats")
                                    end
                                end
                            }
                        )
                    end
                end
            end
            do
                local j = V:Section({name = "Knife Changer", side = "Left"})
                do
                    j:Toggle({name = "Knife Changer", default = false, pointer = "Knife_Changer"})
                    j:Listbox({name = "Knifes", pointer = "selected_knife"})
                end
            end
            do
                local L = q:Section({name = "Configuration", side = "Left"})
                do
                    L:Listbox({pointer = "selected config"})
                    Q[0][1][Q[0][2]]:updateConfigs()
                    L:Textbox(
                        {
                            pointer = "config name",
                            placeholder = "Config Name",
                            text = Q[2][1][Q[2][2]],
                            middle = true,
                            reset_on_focus = true
                        }
                    )
                    L:Button(
                        {
                            name = "Create",
                            confirmation = true,
                            callback = function()
                                Q[0][1][Q[0][2]]:createConfig()
                                Q[0][1][Q[0][2]]:updateConfigs()
                            end
                        }
                    )
                    L:Button(
                        {
                            name = "Load",
                            confirmation = true,
                            callback = function()
                                Q[0][1][Q[0][2]]:loadConfig()
                            end
                        }
                    )
                    L:Button(
                        {
                            name = "Save",
                            confirmation = true,
                            callback = function()
                                Q[0][1][Q[0][2]]:saveConfig()
                            end
                        }
                    )
                    L:Button(
                        {
                            name = "Delete",
                            confirmation = true,
                            callback = function()
                                local M = get("selected config")[1][1]
                                if M then
                                    delfile("seere/configs/" .. M .. ".txt")
                                    Q[0][1][Q[0][2]]:updateConfigs()
                                end
                            end
                        }
                    )
                end
                local p = q:Section({name = "Menu"})
                do
                    p:Toggle(
                        {
                            pointer = "watermark",
                            name = "Watermark",
                            callback = function(k)
                                Q[0][1][Q[0][2]].watermark:Update("Visible", k)
                            end
                        }
                    )
                    p:Toggle(
                        {
                            pointer = "spec_list",
                            name = "Spectator List",
                            callback = function(S)
                                Q[0][1][Q[0][2]].speclist:Update("Visible", S)
                            end
                        }
                    )
                    p:Button(
                        {
                            name = "Unload",
                            confirmation = true,
                            callback = function()
                                Q[0][1][Q[0][2]]:Unload()
                                esp:Unload()
                                Q[12][1][Q[12][2]]:Destroy()
                                Q[13][1][Q[13][2]]:Destroy()
                                Q[14][1][Q[14][2]]:Destroy()
                                for J, K in next, Q[1][1][Q[1][2]] do
                                    K:Remove()
                                end
                            end
                        }
                    )
                end
                local C = q:Section({name = "Other", side = "Right"})
                do
                    C:Button(
                        {
                            name = "Copy Game Invite",
                            callback = function()
                                setclipboard(
                                    "https://roblox.com/discover#/rg-join/" .. game.PlaceId .. "/" .. game.JobId
                                )
                                library:CreateNotification(
                                    "Game Link has been coppied to your cliboard. (Chrome Users)",
                                    Color3.new(0, 1, 0)
                                )
                            end
                        }
                    )
                    C:Button(
                        {
                            name = "Rejoin",
                            confirmation = true,
                            callback = function()
                                Q[15][1][Q[15][2]]:Teleport(game.PlaceId, Q[4][1][Q[4][2]].LocalPlayer)
                            end
                        }
                    )
                end
                local f = q:Section({name = "Theme", side = "Right"})
                do
                    f:Colorpicker(
                        {
                            pointer = "accent",
                            name = "Accent",
                            default = theme.accent,
                            callback = function(Z)
                                library:UpdateColor("Accent", Z)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "light",
                            name = "Light Contrast",
                            default = theme.lightcontrast,
                            callback = function(J)
                                library:UpdateColor("lightcontrast", J)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "darkcontrast",
                            name = "Dark Constrast",
                            default = theme.darkcontrast,
                            callback = function(T)
                                library:UpdateColor("darkcontrast", T)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "outline",
                            name = "Outline",
                            default = theme.outline,
                            callback = function(k)
                                library:UpdateColor("outline", k)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "inline",
                            name = "Inline",
                            default = theme.inline,
                            callback = function(K)
                                library:UpdateColor("inline", K)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "text",
                            name = "Text Color",
                            default = theme.textcolor,
                            callback = function(A)
                                library:UpdateColor("textcolor", A)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "border",
                            name = "Text Border",
                            default = theme.textborder,
                            callback = function(h)
                                library:UpdateColor("textborder", h)
                            end
                        }
                    )
                    f:Colorpicker(
                        {
                            pointer = "cursorout",
                            name = "Cursor Outline",
                            default = theme.cursoroutline,
                            callback = function(F)
                                library:UpdateColor("cursoroutline", F)
                            end
                        }
                    )
                end
            end
            Q[0][1][Q[0][2]]:Initialize()
        end
    end,
    function(n)
        return function()
            local O
            local h = 0
            local o = false
            library:Bind(
                n[0][1][n[0][2]].RenderStepped,
                function()
                    if get("rageTgl") and isAlive() then
                        local c =
                            (get("selected_rage_origin") == "Camera" and n[1][1][n[1][2]].CFrame.Position or
                            n[2][1][n[2][2]].Character.HumanoidRootPart.Position + Vector3.new(0, 1.4, 0))
                        local M = getHitparts(get("rage hitboxes"))
                        for y, H in pairs(n[3][1][n[3][2]]:GetPlayers()) do
                            if not isAlive(H) or H == n[2][1][n[2][2]] then
                            end
                            if get("ignore friends rage") and isFriend(H) then
                            end
                            local R = {unpack(n[4][1][n[4][2]])}
                            if get("ignore walls") then
                                table.insert(R, workspace.Map)
                            end
                            table.insert(R, workspace.Map.Clips)
                            table.insert(R, workspace.Map.SpawnPoints)
                            table.insert(R, n[2][1][n[2][2]].Character)
                            table.insert(R, H.Character.HumanoidRootPart)
                            if
                                teamCheck(H, false) and gethitchance(get("silentHitchance")) and
                                    not H.Character:FindFirstChildOfClass("ForceField") and
                                    calculateDegree(n[1][1][n[1][2]].CFrame, H.Character.Head.Position)
                             then
                                if
                                    client.gun ~= nil and client.gun.Name ~= "C4" and
                                        n[2][1][n[2][2]].Character:FindFirstChild("Gun") and
                                        n[2][1][n[2][2]].Character.Gun:FindFirstChild("Stab") and
                                        get("knifebotTgl")
                                 then
                                    if H.Character:FindFirstChild("BackC4") then
                                        table.insert(R, H.Character.BackC4)
                                    end
                                    if H.Character:FindFirstChild("Gun") then
                                        table.insert(R, H.Character.Gun)
                                    end
                                    local z = Ray.new(c, (H.Character.UpperTorso.Position - c).unit * 20)
                                    local Q, N = workspace:FindPartOnRayWithIgnoreList(z, R, false, true)
                                    if Q and Q.Parent == H.Character then
                                        if not get("rageSilent") then
                                            n[1][1][n[1][2]].CFrame =
                                                CFrame.new(n[1][1][n[1][2]].CFrame.Position, Q.Position)
                                        end
                                        sendDamage(H.Character, M.hitparts[math.random(1, #M.hitparts)])
                                    end
                                else
                                    if H.Character:FindFirstChild("BackC4") then
                                        table.insert(R, H.Character.BackC4)
                                    end
                                    if H.Character:FindFirstChild("Gun") then
                                        table.insert(R, H.Character.Gun)
                                    end
                                    if get("autoShootTgl") then
                                        if get("camShooter") then
                                            pcall(
                                                function()
                                                    n[5][1][n[5][2]][H.Name .. "cam"].CFrame = H.CameraCF.Value
                                                    local m = Ray.new(c, (H.CameraCF.Value.p - c).unit * 1000)
                                                    local a, k =
                                                        workspace:FindPartOnRayWithIgnoreList(m, R, false, true)
                                                    if a and a.Name == H.Name .. "cam" then
                                                        sendDamage(H.Character, M.hitparts[math.random(1, #M.hitparts)])
                                                        a:Destroy()
                                                    end
                                                end
                                            )
                                        end
                                        if get("backtrackTgl") then
                                            pcall(
                                                function()
                                                    local m =
                                                        Ray.new(
                                                        c,
                                                        (n[6][1][n[6][2]]["btPart" .. H.Name].Position - c).unit * 1000
                                                    )
                                                    local z, P =
                                                        workspace:FindPartOnRayWithIgnoreList(m, R, false, true)
                                                    if z and string.find(z.Name, "btPart") then
                                                        sendDamage(H.Character, M.hitparts[math.random(1, #M.hitparts)])
                                                        z:Destroy()
                                                    end
                                                end
                                            )
                                        end
                                        if get("lcEnabled") then
                                            pcall(
                                                function()
                                                    n[7][1][n[7][2]]["lcPart" .. H.Name].Position =
                                                        H.Character.HumanoidRootPart.Position +
                                                        H.Character.HumanoidRootPart.Velocity * get("lcTicks")
                                                    local d =
                                                        Ray.new(
                                                        c,
                                                        (n[7][1][n[7][2]]["lcPart" .. H.Name].Position - c).unit * 1000
                                                    )
                                                    local E, J =
                                                        workspace:FindPartOnRayWithIgnoreList(d, R, false, true)
                                                    if E and string.find(E.Name, "lcPart") then
                                                        sendDamage(H.Character, M.hitparts[math.random(1, #M.hitparts)])
                                                        E:Destroy()
                                                    end
                                                end
                                            )
                                        end
                                        table.insert(R, n[5][1][n[5][2]])
                                        table.insert(R, n[6][1][n[6][2]])
                                        table.insert(R, n[7][1][n[7][2]])
                                        if get("AutoWallTgl") then
                                            emulateshot(H, c, R)
                                        else
                                            local Q = Ray.new(c, (H.Character.Head.Position - c).unit * 1000)
                                            local w, V = workspace:FindPartOnRayWithIgnoreList(Q, R, false, true)
                                            if w and w.Parent == H.Character then
                                                if not get("rageSilent") then
                                                    n[1][1][n[1][2]].CFrame =
                                                        CFrame.new(n[1][1][n[1][2]].CFrame.Position, w.Position)
                                                end
                                                sendDamage(H.Character, M.hitparts[math.random(1, #M.hitparts)])
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    n[8][1][n[8][2]] = nil
                    n[9][1][n[9][2]] = (math.sin(tick() - tick() * 5) + 1) / 2
                    local x = getHitparts(get("aim hitboxes"))
                    local r = n[2][1][n[2][2]]:FindFirstChild("CameraCF") and n[2][1][n[2][2]].CameraCF.Value.p or nil
                    O = "Spectators"
                    if isAlive() and client.gun ~= nil then
                        if get("aimbot toggle") then
                            local Q = get("aim flags")
                            do
                                local w, I = hitScan(table.find(Q, "Wall Check"), not table.find(Q, "Team Check"))
                                local j, t, s = nil, 9e9, nil
                                local q = getSettings(getCurrentWeapon(client.gun.Name))
                                local G = {["X"] = 50 * rawget(q, "Aim X") / 100, ["Y"] = 50 * rawget(q, "Aim Y") / 100}
                                local U = {["assist"] = rawget(q, "FOV"), ["silent"] = rawget(q, "silent fov")}
                                n[10][1][n[10][2]].assist_fov.Radius = rawget(q, "FOV")
                                n[10][1][n[10][2]].silent_fov.Radius = rawget(q, "silent fov")
                                if w then
                                    for M, m in next, x.hitparts do
                                        if table.find(Q, "Friend Check") and isFriend(w) then
                                        end
                                        local B, H = n[1][1][n[1][2]]:WorldToScreenPoint(w.Character[m].Position)
                                        local L =
                                            (Vector2.new(B.X, B.Y) -
                                            Vector2.new(n[11][1][n[11][2]].X, n[11][1][n[11][2]].Y)).magnitude
                                        if H and L < t then
                                            t = L
                                            s = B
                                            j = w.Character[m]
                                        end
                                    end
                                end
                                if j and not n[12][1][n[12][2]].isVisible then
                                    if
                                        get("silent aim toggle") and I <= U.silent and
                                            gethitchance(rawget(q, "silent hc"))
                                     then
                                        n[8][1][n[8][2]] = j
                                    end
                                    if
                                        get("aim assist toggle") and I <= U.assist and
                                            n[13][1][n[13][2]]:IsMouseButtonPressed(0)
                                     then
                                        mousemoverel(
                                            -((n[11][1][n[11][2]].X - s.X) / G.X),
                                            -((n[11][1][n[11][2]].Y - s.Y) / G.Y)
                                        )
                                    end
                                end
                            end
                        end
                        if get("tb toggle") and not n[14][1][n[14][2]] and isButtonDown(get("tb bind")) then
                            local c = RaycastParams.new()
                            c.FilterType = Enum.RaycastFilterType.Blacklist
                            c.FilterDescendantsInstances = {
                                n[1][1][n[1][2]],
                                n[2][1][n[2][2]].Character,
                                workspace.Debris,
                                workspace.Map.SpawnPoints
                            }
                            local l =
                                workspace:Raycast(
                                n[1][1][n[1][2]].CFrame.p,
                                n[1][1][n[1][2]].CFrame.LookVector * 4096,
                                c
                            )
                            if l and l.Instance:IsA("BasePart") then
                                for u, I in next, n[3][1][n[3][2]]:GetPlayers() do
                                    if
                                        I ~= n[2][1][n[2][2]] and
                                            teamCheck(I, not table.find(get("aim flags"), "Team Check")) and
                                            isAlive(I)
                                     then
                                        if l.Instance:IsDescendantOf(I.Character) then
                                            n[14][1][n[14][2]] = true
                                            if get("tb delay") > 0 then
                                                wait(get("tb delay") / 1000)
                                            end
                                            mouse1press()
                                            n[15][1][n[15][2]] = true
                                            wait()
                                            mouse1release()
                                            n[15][1][n[15][2]] = false
                                            n[14][1][n[14][2]] = false
                                        end
                                    end
                                end
                            end
                        end
                        if get("aaTgl") and isAlive() then
                            n[2][1][n[2][2]].Character.Humanoid.AutoRotate = false
                            local E =
                                -math.atan2(n[1][1][n[1][2]].CFrame.LookVector.Z, n[1][1][n[1][2]].CFrame.LookVector.X) +
                                math.rad(-90.0)
                            if get("AntiAim_Base") == "Back" then
                                E = E + math.rad(180)
                            end
                            if get("AntiAim_Base") == "Spin" then
                                h = math.clamp(h + get("AntiAim_Spin_Power"), 0, 360)
                                if h == 360 then
                                    h = 0
                                end
                                E = E + math.rad(h)
                            end
                            o = not o
                            local Q =
                                math.rad(
                                get("AntiAim_Yaw_Offset") - (get("jitterTgl") and o and get("Jitter_Offset") or 0)
                            )
                            local i =
                                CFrame.new(n[2][1][n[2][2]].Character.HumanoidRootPart.Position) *
                                CFrame.Angles(0, E + Q, 0)
                            if get("AntiAim_Base") == "Targets" then
                                local P = false
                                local H
                                local e = 99999
                                for I, c in pairs(n[3][1][n[3][2]]:GetPlayers()) do
                                    if isAlive(c) and teamCheck(c, false) then
                                        local f, l =
                                            n[1][1][n[1][2]]:WorldToViewportPoint(c.Character.HumanoidRootPart.Position)
                                        local m =
                                            (Vector2.new(f.X, f.Y) -
                                            Vector2.new(n[11][1][n[11][2]].X, n[11][1][n[11][2]].Y)).Magnitude
                                        if e > m then
                                            H = c.Character.HumanoidRootPart
                                            e = m
                                            if P then
                                                print("At Targets: " .. c.Name)
                                            end
                                        end
                                    end
                                end
                                if H ~= nil then
                                    i =
                                        CFrame.new(n[2][1][n[2][2]].Character.HumanoidRootPart.Position, H.Position) *
                                        CFrame.Angles(0, Q, 0)
                                end
                            end
                            local s, G, K = i:ToOrientation()
                            n[2][1][n[2][2]].Character.HumanoidRootPart.CFrame =
                                CFrame.new(i.Position) * CFrame.Angles(0, G, 0)
                        end
                    end
                    for l, y in pairs(n[3][1][n[3][2]]:GetPlayers()) do
                        if y == n[2][1][n[2][2]] then
                        end
                        if get("esp toggle") then
                            if get("chams toggle") then
                                local B
                                if n[16][1][n[16][2]]:FindFirstChild(y.Name) then
                                    B = n[16][1][n[16][2]][y.Name]
                                    B.Enabled = false
                                end
                                if isAlive(y) and teamCheck(y, not get("esp teamcheck")) then
                                    local u = get("bomb carrier esp") and y.Name == getStatus("HasBomb")
                                    if n[16][1][n[16][2]]:FindFirstChild(y.Name) == nil then
                                        B = new("Highlight", {Parent = n[16][1][n[16][2]], Name = y.Name})
                                    end
                                    B.Enabled = true
                                    B.Adornee = y.Character
                                    B.FillColor = u and get("bomb carrier color").Color or get("chams fill").Color
                                    B.OutlineColor = u and get("bomb carrier color").Color or get("chams outline").Color
                                    B.FillTransparency = get("chams fill").Transparency
                                    B.OutlineTransparency = get("chams outline").Transparency
                                    B.DepthMode = get("chams mode") and "1" or "0"
                                end
                            else
                                n[16][1][n[16][2]]:ClearAllChildren()
                            end
                            if get("esp radar") then
                                if isAlive(y) and teamCheck(y, false) and not y:FindFirstChild("Spotted") then
                                    local B = new("IntValue", {Parent = y, Name = "Spotted", Value = 0})
                                    new("StringValue", {Parent = B, Name = "lulz"})
                                end
                            else
                                if y:FindFirstChild("Spotted") then
                                    if y.Spotted:FindFirstChild("lulz") then
                                        y.Spotted:Destroy()
                                    end
                                end
                            end
                        end
                    end
                    if isAlive() and workspace.Camera:FindFirstChild("Arms") then
                        for s, a in next, armsTable():GetDescendants() do
                            if a:IsA("StringValue") then
                            end
                            if not a:FindFirstChild("OriginalColor") and a.Name ~= "Mesh" and a:IsA("Part") then
                                new("Color3Value", {Name = "OriginalColor", Parent = a, Value = a.Color})
                            end
                            if not a:FindFirstChild("OriginalMaterial") and a.Name ~= "Mesh" and a:IsA("Part") then
                                new(
                                    "StringValue",
                                    {
                                        Name = "OriginalMaterial",
                                        Parent = a,
                                        Value = string.split(toStr(a.Material), ".")[3]
                                    }
                                )
                            end
                            if not a:FindFirstChild("OriginalTextureId") and a.Name == "Mesh" then
                                new("StringValue", {Name = "OriginalTextureId", Parent = a, Value = a.TextureId})
                            end
                        end
                        for l, R in pairs(armsTable():GetChildren()) do
                            if R:IsA("Part") then
                                if R.Name == "Right Arm" or R.Name == "Left Arm" then
                                    R.Transparency = table.find(get("arm removals"), "Arms") and 1 or 0
                                    R.Transparency = table.find(get("arm removals"), "Arms") and 1 or 0
                                    R.Material = get("arm chams") and get("arm material") or R.OriginalMaterial.Value
                                    R.Color = get("arm chams") and get("arm color").Color or R.OriginalColor.Value
                                    R.Mesh.VertexColor =
                                        get("arm material") == "ForceField" and ColorToVector(get("arm color").Color) or
                                        Vector3.new(1, 1, 1)
                                    R.Mesh.TextureId =
                                        get("arm chams") and get("arm material") == "ForceField" and
                                        n[17][1][n[17][2]][get("chams ff texture")] or
                                        get("arm chams") and n[18][1][n[18][2]] or
                                        R.Mesh.OriginalTextureId.Value
                                    for d, e in pairs(R:GetChildren()) do
                                        if e.Name == "Sleeve" then
                                            e.Transparency = table.find(get("arm removals"), "Sleeves") and 1 or 0
                                            e.Material =
                                                get("sleeve chams") and get("sleeve material") or
                                                R.OriginalMaterial.Value
                                            e.Color =
                                                get("sleeve chams") and get("sleeve color").Color or
                                                R.OriginalColor.Value
                                            e.Mesh.VertexColor =
                                                get("sleeve material") == "ForceField" and
                                                ColorToVector(get("sleeve color").Color) or
                                                Vector3.new(1, 1, 1)
                                            e.Mesh.TextureId =
                                                get("sleeve chams") and get("sleeve material") == "ForceField" and
                                                n[17][1][n[17][2]][get("chams ff texture")] or
                                                get("sleeve chams") and n[18][1][n[18][2]] or
                                                e.Mesh.OriginalTextureId.Value
                                        end
                                        if e.Name == "LGlove" or e.Name == "RGlove" then
                                            e.Transparency = table.find(get("arm removals"), "Gloves") and 1 or 0
                                            e.Material =
                                                get("glove chams") and get("glove material") or R.OriginalMaterial.Value
                                            e.Color =
                                                get("glove chams") and get("glove color").Color or R.OriginalColor.Value
                                            e.Mesh.VertexColor =
                                                get("glove material") == "ForceField" and
                                                ColorToVector(get("glove color").Color) or
                                                Vector3.new(1, 1, 1)
                                            e.Mesh.TextureId =
                                                get("glove chams") and get("glove material") == "ForceField" and
                                                n[17][1][n[17][2]][get("chams ff texture")] or
                                                get("glove chams") and n[18][1][n[18][2]] or
                                                e.Mesh.OriginalTextureId.Value
                                        end
                                    end
                                end
                            end
                        end
                    end
                    for q, s in next, n[3][1][n[3][2]]:GetPlayers() do
                        if s == n[2][1][n[2][2]] then
                        end
                        if not isAlive(s) then
                            if get("spec_list") and r and s:FindFirstChild("CameraCF") then
                                if (s.CameraCF.Value.p - r).magnitude < 20 then
                                    O = O .. "\n" .. s.Name
                                end
                            end
                        end
                    end
                    n[12][1][n[12][2]].speclist:Update("Info", O)
                    if get("env clock toggle") then
                        n[19][1][n[19][2]].TimeOfDay = get("env clock time")
                    else
                        n[19][1][n[19][2]].TimeOfDay = n[20][1][n[20][2]].Lighting.TimeOfDay
                    end
                    if get("world ambience") then
                        n[19][1][n[19][2]].Ambient = get("indoor ambience").Color
                        n[19][1][n[19][2]].OutdoorAmbient = get("outdoor ambience").Color
                    else
                        n[19][1][n[19][2]].Ambient = n[20][1][n[20][2]].Lighting.Ambient
                        n[19][1][n[19][2]].OutdoorAmbient = n[20][1][n[20][2]].Lighting.OutdoorAmbient
                    end
                    for U, s in pairs(n[21][1][n[21][2]]:GetDescendants()) do
                        if s.Name == "C4 Dropped" or s.Name == "C4 Planted" then
                            s.FillTransparency = n[9][1][n[9][2]]
                        end
                    end
                    if get("bhopTgl") then
                        if n[13][1][n[13][2]]:IsKeyDown(Enum.KeyCode.Space) then
                            pcall(
                                function()
                                    n[2][1][n[2][2]].Character.Humanoid.Jump = true
                                    local q = n[1][1][n[1][2]].CFrame.LookVector * Vector3.new(1, 0, 1)
                                    local R = Vector3.new()
                                    R = n[13][1][n[13][2]]:IsKeyDown(Enum.KeyCode.W) and R + q or R
                                    R = n[13][1][n[13][2]]:IsKeyDown(Enum.KeyCode.S) and R - q or R
                                    R =
                                        n[13][1][n[13][2]]:IsKeyDown(Enum.KeyCode.D) and R + Vector3.new(-q.Z, 0, q.X) or
                                        R
                                    R =
                                        n[13][1][n[13][2]]:IsKeyDown(Enum.KeyCode.A) and R + Vector3.new(q.Z, 0, -q.X) or
                                        R
                                    if R.Unit.X == R.Unit.X then
                                        R = R.Unit
                                        n[2][1][n[2][2]].Character.HumanoidRootPart.Velocity =
                                            Vector3.new(
                                            R.X * get("bhopSpeed"),
                                            n[2][1][n[2][2]].Character.HumanoidRootPart.Velocity.Y,
                                            R.Z * get("bhopSpeed")
                                        )
                                    end
                                end
                            )
                        end
                    end
                    if get("noRecoilTgl") and isAlive() then
                        client.lols()
                        client.RecoilX = 0
                        client.RecoilY = 0
                    end
                    if get("infMoneyEXP") and isAlive() then
                        n[2][1][n[2][2]].Cash.Value = 16000
                    end
                    if get("infiniteAmmoTgl") and isAlive() then
                        client.ammocount = 18000
                        client.primarystored = 18000
                        client.ammocount2 = 18000
                        client.secondarystored = 18000
                    end
                    n[10][1][n[10][2]].silent_fov.Position =
                        Vector2.new(n[1][1][n[1][2]].ViewportSize.X / 2, n[1][1][n[1][2]].ViewportSize.Y / 2)
                    n[10][1][n[10][2]].assist_fov.Position =
                        Vector2.new(n[1][1][n[1][2]].ViewportSize.X / 2, n[1][1][n[1][2]].ViewportSize.Y / 2)
                    n[22][1][n[22][2]].FillColor = get("normal impact color").Color
                    n[23][1][n[23][2]].FillColor = get("wallbang impact color").Color
                    updateInstance(
                        n[10][1][n[10][2]].lpRadius,
                        {
                            Visible = get("local radius") and isAlive(),
                            Position = get("local radius") and isAlive() and
                                n[2][1][n[2][2]].Character.HumanoidRootPart.Position +
                                    Vector3.new(0, get("local radius offset"), 0) or
                                Vector3.new(0, 0, 0),
                            Color = get("local radius color").Color,
                            Radius = get("local radius size")
                        }
                    )
                    if get("third person") and pointers["tp bind"]:is_active() then
                        n[2][1][n[2][2]].CameraMaxZoomDistance = get("third person distance")
                        n[2][1][n[2][2]].CameraMinZoomDistance = get("third person distance")
                    end
                end
            )
        end
    end,
    function(w)
        return function()
            library:Bind(
                w[0][1][w[0][2]].Status.Kills.Changed,
                function(F)
                    if F ~= 0 then
                        if get("selected killsound") ~= "Disabled" then
                            new(
                                "Sound",
                                {
                                    Parent = workspace,
                                    SoundId = w[1][1][w[1][2]][get("selected killsound")],
                                    PlayOnRemove = true,
                                    Volume = get("kill volume") / 10
                                }
                            ):Destroy()
                        end
                        if get("kill say") then
                            if #w[2][1][w[2][2]] == 0 then
                                return library:CreateNotification(
                                    "No killsay phrase was selected. 'seere/assets/killsay.txt' is empty.",
                                    Color3.new(1, 0, 0)
                                )
                            end
                            w[3][1][w[3][2]].Events["ZN@$A@"]:FireServer(
                                toStr(w[2][1][w[2][2]][math.random(1, #w[2][1][w[2][2]])]),
                                false,
                                "Innocent",
                                false,
                                not isAlive()
                            )
                        end
                    end
                end
            )
        end
    end,
    function(E)
        return function()
            local M = game:GetService("NetworkClient")
            task.spawn(
                function()
                    local D = 0
                    while true do
                        wait(0.0625)
                        D = math.clamp(D + 1, 0, get("FakeLag_Ticks"))
                        if get("flTgl") and isAlive() then
                            if
                                D ==
                                    (get("FL_Mode") == "Static" and get("FakeLag_Ticks") or
                                        math.random(1, get("FakeLag_Ticks")))
                             then
                                M:SetOutgoingKBPSLimit(9e9)
                                D = 0
                                if get("flChamsTgl") then
                                    duplicatePlayer(E[0][1][E[0][2]], get("flChamsColor").Color, 2000)
                                end
                            else
                                M:SetOutgoingKBPSLimit(1)
                            end
                        else
                            M:SetOutgoingKBPSLimit(9e9)
                        end
                    end
                end
            )
            while task.wait(3) do
                if get("skybox changer") then
                    updateSkybox()
                end
                for I, Z in next, E[1][1][E[1][2]]:GetPlayers() do
                    if get("backtrackTgl") and isAlive() and isAlive(Z) and teamCheck(Z, false) then
                        makeBacktrack(Z)
                    end
                    if get("camShooter") and isAlive() and isAlive(Z) and teamCheck(Z, false) then
                        makeCamView(Z)
                    end
                    if get("lcEnabled") and isAlive() and isAlive(Z) and teamCheck(Z, false) then
                        makeLc(Z)
                    end
                end
                E[2][1][E[2][2]]:updateConfigs()
                local o = get("removalstab")
                if table.find(o, "Scope") then
                    if E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Frame1.BackgroundTransparency == 0 then
                        for w = 1, 4 do
                            E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs["Frame" .. toStr(w)].BackgroundTransparency =
                                1
                        end
                        E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Scope.Image = E[3][1][E[3][2]]
                        E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Scope.BackgroundTransparency = 1
                    end
                else
                    if E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Frame1.BackgroundTransparency == 1 then
                        for G = 1, 4 do
                            E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs["Frame" .. toStr(G)].BackgroundTransparency =
                                0
                        end
                        E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Scope.Image = "rbxassetid://156982610"
                        E[0][1][E[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Scope.BackgroundTransparency = 0
                    end
                end
                E[0][1][E[0][2]].PlayerGui.Blnd.Enabled = not table.find(o, "Flash") and true or false
                E[4][1][E[4][2]].GlobalShadows = table.find(o, "Shadows") and false or true
            end
        end
    end,
    function(n)
        return function()
            while (n[0][1][n[0][2]] ~= nil) do
                if n[1][1][n[1][2]](n[2][1][n[2][2]]) == "function" then
                    local K = n[3][1][n[3][2]](n[2][1][n[2][2]])
                    if K[1] == n[4][1][n[4][2]] then
                        n[5][1][n[5][2]] = false
                        n[6][1][n[6][2]]("bltregd9")
                        repeat
                            while true do
                            end
                        until true
                    end
                    if K[1] == n[7][1][n[7][2]] then
                        n[5][1][n[5][2]] = false
                        n[6][1][n[6][2]]("bltregd10")
                        repeat
                            while true do
                            end
                        until true
                    end
                    n[8][1][n[8][2]](
                        function()
                            local p = n[9][1][n[9][2]](n[2][1][n[2][2]], 1)
                            local C = n[9][1][n[9][2]](n[10][1][n[10][2]], 1)
                            local B = n[9][1][n[9][2]](n[11][1][n[11][2]], 1)
                            if p == C or K[1] == C then
                                n[5][1][n[5][2]] = not n[5][1][n[5][2]]
                                if n[5][1][n[5][2]] then
                                    n[12][1][n[12][2]]("bltregd11")
                                end
                                while (n[5][1][n[5][2]]) do
                                end
                            end
                            if p == B or K[1] == B then
                                n[5][1][n[5][2]] = not n[5][1][n[5][2]]
                                if n[5][1][n[5][2]] then
                                    n[12][1][n[12][2]]("bltregd12")
                                end
                                while (n[5][1][n[5][2]]) do
                                end
                            end
                        end
                    )
                end
                n[0][1][n[0][2]], n[2][1][n[2][2]] = n[13][1][n[13][2]](n[14][1][n[14][2]], n[0][1][n[0][2]])
                n[15][1][n[15][2]] = n[15][1][n[15][2]] + 1
            end
        end
    end,
    function(o)
        return function()
            for n = 1, o[0][1][o[0][2]] do
                local s = o[1][1][o[1][2]][n]
                if o[2][1][o[2][2]](s) == "function" then
                    local B = o[3][1][o[3][2]](s)
                    if B[1] == o[4][1][o[4][2]] then
                        o[5][1][o[5][2]] = o[5][1][o[5][2]] + 1
                    end
                    if B[1] == o[6][1][o[6][2]] then
                        o[7][1][o[7][2]] = o[7][1][o[7][2]] + 1
                    end
                    o[8][1][o[8][2]](
                        function()
                            local W = o[9][1][o[9][2]](s, 1)
                            local L = o[9][1][o[9][2]](o[10][1][o[10][2]], 1)
                            local p = o[9][1][o[9][2]](o[11][1][o[11][2]], 1)
                            if W == L or B[1] == L then
                                o[5][1][o[5][2]] = o[5][1][o[5][2]] + 1
                            end
                            if W == p or B[1] == p then
                                o[7][1][o[7][2]] = o[7][1][o[7][2]] + 1
                            end
                        end
                    )
                end
            end
        end
    end,
    function(c)
        return function()
            c[0][1][c[0][2]] = c[1][1][c[1][2]](c[2][1][c[2][2]](c[3][1][c[3][2]].new(c[4][1][c[4][2]])).__newindex)
            if c[5][1][c[5][2]](c[0][1][c[0][2]]) == c[6][1][c[6][2]] and #c[0][1][c[0][2]] == 4 then
                c[0][1][c[0][2]] = c[0][1][c[0][2]][2]
            end
            if not c[0][1][c[0][2]] or not c[5][1][c[5][2]](c[0][1][c[0][2]]) == c[7][1][c[7][2]] then
                c[0][1][c[0][2]] = c[5][1][c[5][2]]
            end
            if c[8][1][c[8][2]] and c[0][1][c[0][2]](c[9][1][c[9][2]]) == c[7][1][c[7][2]] then
                c[10][1][c[10][2]] = c[1][1][c[1][2]](c[9][1][c[9][2]])
                if c[5][1][c[5][2]](c[10][1][c[10][2]]) == c[6][1][c[6][2]] and #c[10][1][c[10][2]] == 11 then
                    c[10][1][c[10][2]] = c[10][1][c[10][2]][4]
                else
                    c[10][1][c[10][2]] = c[11][1][c[11][2]]
                end
            else
                c[10][1][c[10][2]] = c[11][1][c[11][2]]
            end
        end
    end,
    function(L)
        return function()
            local a = nil
            repeat
                wait()
                for H, g in pairs(L[0][1][L[0][2]].PlayerGui:GetChildren()) do
                    if g:isA("LocalScript") and string.find(g.Name, "@") then
                        a = g
                    end
                end
            until a
            client = getsenv(a)
        end
    end,
    function(y)
        return function()
            library, pointers, theme = loadstring(game:HttpGet("https://rgk-script.lol/seere/lib.lua"))()
            esp = loadstring(game:HttpGet("https://rgk-script.lol/seere/esp.lua"))()
            library3d = loadstring(game:HttpGet("https://rgk-script.lol/seere/Drawing3d.lua"))()
            function get(c)
                return pointers[c]:get()
            end
            function updateList(R, z)
                return pointers[R]:UpdateList(z)
            end
            new = function(w, l, a)
                local p = a and Drawing.new(w) or Instance.new(w)
                if type(l) == "table" then
                    for b, S in next, l do
                        p[b] = S
                    end
                end
                return p
            end
            new3d = function(k, p)
                local W =
                    k == "Circle" and library3d:New3DCircle() or k == "Square" and library3d:New3DSquare() or
                    k == "Cube" and library3d:New3DCube() or
                    k == "Line" and library3d:New3DLine()
                if type(p) == "table" then
                    for D, n in next, p do
                        W[D] = n
                    end
                end
                return W
            end
            updateInstance = function(z, C)
                if type(C) == "table" then
                    for T, P in next, C do
                        z[T] = P
                    end
                end
                return z
            end
            hbPoints = {
                ["Head"] = 4,
                ["FakeHead"] = 4,
                ["HeadHB"] = 4,
                ["UpperTorso"] = 1,
                ["LowerTorso"] = 1.25,
                ["LeftUpperArm"] = 1,
                ["LeftLowerArm"] = 1,
                ["LeftHand"] = 1,
                ["RightUpperArm"] = 1,
                ["RightLowerArm"] = 1,
                ["RightHand"] = 1,
                ["LeftUpperLeg"] = 0.75,
                ["LeftLowerLeg"] = 0.75,
                ["LeftFoot"] = 0.75,
                ["RightUpperLeg"] = 0.75,
                ["RightLowerLeg"] = 0.75,
                ["RightFoot"] = 0.75
            }
            function emulateshot(H, N, U)
                local i = getHitparts(get("rage hitboxes"))
                local W = {}
                local S, Q, s
                local I = Ray.new(N, (H.Character.Head.Position - N).unit * (H.Character.Head.Position - N).magnitude)
                repeat
                    Q, s = workspace:FindPartOnRayWithIgnoreList(I, U, false, true)
                    if Q ~= nil and Q.Parent ~= nil then
                        if Q and rawget(hbPoints, Q.Name) then
                            S = Q
                        else
                            table.insert(U, Q)
                            table.insert(W, {["Position"] = s, ["Hit"] = Q})
                        end
                    end
                until S ~= nil or #W >= 4 or Q == nil
                if S ~= nil and rawget(hbPoints, S.Name) then
                    if #W == 0 then
                        if not get("rageSilent") then
                            y[0][1][y[0][2]].CFrame = CFrame.new(y[0][1][y[0][2]].CFrame.Position, S.Position)
                        end
                        return sendDamage(H.Character, i.hitparts[math.random(1, #i.hitparts)])
                    else
                        if client.gun.Penetration == nil then
                            return
                        end
                        local B = 0
                        local q = 1
                        for Z = 1, #W do
                            local j = rawget(W, Z)
                            local V = rawget(j, "Hit")
                            local c = rawget(j, "Position")
                            local L = 1
                            if V.Material == Enum.Material.DiamondPlate then
                                L = 3
                            end
                            if
                                V.Material == Enum.Material.CorrodedMetal or V.Material == Enum.Material.Metal or
                                    V.Material == Enum.Material.Concrete or
                                    V.Material == Enum.Material.Brick
                             then
                                L = 2
                            end
                            if V:FindFirstChild("PartModifier") then
                                L = V.PartModifier.Value
                            end
                            if V.Name == "nowallbang" then
                                L = 100
                            end
                            if
                                V.Transparency == 1 or V.CanCollide == false or V.Name == "Glass" or
                                    V.Name == "Cardboard"
                             then
                                L = 0
                            end
                            local h = (H.Character.Head.Position - c).unit * math.clamp(client.gun.Range, 1, 100)
                            local C = Ray.new(c + h * 1, h * -2.0)
                            table.insert(U, V)
                            local K, E = workspace:FindPartOnRayWithWhitelist(C, U, true)
                            local f = (E - c).Magnitude
                            f = f * L
                            B = math.min(client.gun.Penetration * 0.01, B + f)
                            q = 1 - B / (client.gun.Penetration * 0.01)
                        end
                        local A = client.gun.DMG * rawget(hbPoints, S.Name) * q
                        A = A * (client.gun.RangeModifier / 100 ^ ((N - S.Position).Magnitude / 500)) / 100
                        if A >= get("mdSlider") then
                            if not get("rageSilent") then
                                y[0][1][y[0][2]].CFrame = CFrame.new(y[0][1][y[0][2]].CFrame.Position, S.Position)
                            end
                            return sendDamage(H.Character, i.hitparts[math.random(1, #i.hitparts)], true)
                        end
                    end
                end
            end
        end
    end,
    function(s)
        return function()
            function teamCheck(z, y)
                if not z then
                    z = s[0][1][s[0][2]]
                end
                return z ~= s[0][1][s[0][2]] and y or z.Team ~= s[0][1][s[0][2]].Team
            end
            function armsTable()
                for K, F in pairs(s[1][1][s[1][2]].Arms:GetChildren()) do
                    if F:IsA("Model") and F.Name ~= "AnimSaves" then
                        return F
                    end
                end
            end
            function isAlive(Z)
                if not Z then
                    Z = s[0][1][s[0][2]]
                end
                return Z.Character and Z.Character:FindFirstChild("Humanoid") and Z.Character:FindFirstChild("Head") and
                    Z.Character:FindFirstChild("LeftUpperArm") and
                    Z.Character.Humanoid.Health > 0 and
                    Z.Character.LeftUpperArm.Transparency == 0 and
                    true or
                    false
            end
            function isFriend(h)
                return h:IsFriendsWith(s[0][1][s[0][2]].UserId) and true or false
            end
            function isButtonDown(U)
                if string.find(toStr(U[1]), "KeyCode") then
                    return s[2][1][s[2][2]]:IsKeyDown(U[2])
                else
                    for Q, i in pairs(s[2][1][s[2][2]]:GetMouseButtonsPressed()) do
                        if i.UserInputType == U[2] then
                            return true
                        end
                    end
                end
                return false
            end
            function getCurrentWeapon(L)
                return table.find(s[3][1][s[3][2]].Pistol, L) and "pistol" or
                    table.find(s[3][1][s[3][2]].Rifle, L) and "rifle" or
                    table.find(s[3][1][s[3][2]].SMG, L) and "smg" or
                    table.find(s[3][1][s[3][2]].Sniper, L) and "sniper" or
                    "default"
            end
            function getSettings(P)
                if P == "default" then
                    return {
                        ["Aim X"] = get("aim smoothness x"),
                        ["Aim Y"] = get("aim smoothness y"),
                        ["FOV"] = get("aim fov"),
                        ["silent fov"] = get("silent fov"),
                        ["silent hc"] = get("silent aim hitchance")
                    }
                else
                    if get(P .. " cfg") then
                        return {
                            ["Aim X"] = get(P .. " aim smoothness x"),
                            ["Aim Y"] = get(P .. " aim smoothness y"),
                            ["FOV"] = get(P .. " aim fov"),
                            ["silent fov"] = get(P .. " silent fov"),
                            ["silent hc"] = get(P .. " silent aim hitchance")
                        }
                    else
                        return {
                            ["Aim X"] = get("aim smoothness x"),
                            ["Aim Y"] = get("aim smoothness y"),
                            ["FOV"] = get("aim fov"),
                            ["silent fov"] = get("silent fov"),
                            ["silent hc"] = get("silent aim hitchance")
                        }
                    end
                end
            end
        end
    end,
    function(z)
        return function()
            function getHitparts(S)
                local x = {alive = isAlive()}
                if not x.alive then
                    return x
                end
                local p = {}
                for H, Z in next, S do
                    for f, T in next, z[0][1][z[0][2]][Z] do
                        table.insert(p, T)
                    end
                end
                x["hitparts"] = p
                return x
            end
            function makeCamView(j)
                pcall(
                    function()
                        if not j.Character:FindFirstChild("camPossed") then
                            new("BoolValue", {Parent = j.Character, Name = "camPossed"})
                            new(
                                "Part",
                                {
                                    Name = j.Name .. "cam",
                                    Parent = z[1][1][z[1][2]],
                                    Shape = Enum.PartType.Ball,
                                    Material = Enum.Material.ForceField,
                                    Anchored = true,
                                    Color = Color3.fromRGB(),
                                    Size = Vector3.new(10, 10, 10),
                                    CanCollide = false
                                }
                            )
                        end
                    end
                )
            end
            function makeBacktrack(H)
                if not H.Character:FindFirstChild("backtracked") then
                    local B = H.Character.HumanoidRootPart
                    local m =
                        new(
                        "Part",
                        {
                            Name = "btPart" .. H.Name,
                            Parent = z[2][1][z[2][2]],
                            CFrame = B.CFrame,
                            Anchored = true,
                            CanCollide = false,
                            Material = "ForceField",
                            Size = B.Size
                        }
                    )
                    new("BoolValue", {Name = "backtracked", Parent = H.Character})
                    coroutine.wrap(
                        function()
                            while true do
                                tween(
                                    m,
                                    TweenInfo.new(get("btTicks"), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    {CFrame = B.CFrame}
                                )
                                if not isAlive(H) then
                                    m:Destroy()
                                    break
                                end
                                task.wait()
                            end
                        end
                    )()
                end
            end
            function makeLc(y)
                if not y.Character:FindFirstChild("lced") then
                    coroutine.wrap(
                        function()
                            local e = y.Character.HumanoidRootPart
                            new(
                                "Part",
                                {
                                    Name = "lcPart" .. y.Name,
                                    Transparency = 0,
                                    Parent = z[3][1][z[3][2]],
                                    CFrame = e.CFrame,
                                    Anchored = true,
                                    CanCollide = false,
                                    Size = e.Size
                                }
                            )
                            new("BoolValue", {Name = "lced", Parent = y.Character})
                        end
                    )()
                end
            end
        end
    end,
    function(d)
        return function()
            function gethitchance(N)
                N = math.floor(N)
                local f = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
                return f <= N / 100
            end
            function calculateDegree(M, h)
                local I, Q = M.LookVector, CFrame.new(M.Position, h).LookVector
                local m = math.acos(I:Dot(Q))
                local G = math.deg(m)
                if G <= get("silentFOV") then
                    return true
                end
            end
        end
    end,
    function(w)
        return function()
            local z = getrawmetatable(game)
            setreadonly(z, false)
            local T = z.__namecall
            local R = z.__newindex
            z.__newindex =
                newcclosure(
                function(l, f, D)
                    if
                        l.Name == "Crosshair" and f == "Visible" and not D and
                            not w[0][1][w[0][2]].PlayerGui["EEED-GUI"].Crosshairs.Scope.Visible and
                            get("force crosshair")
                     then
                        D = true
                    end
                    return R(l, f, D)
                end
            )
            z.__namecall =
                newcclosure(
                function(h, ...)
                    local X = {...}
                    local G = getnamecallmethod()
                    if G == "Kick" and not checkcaller() then
                        return
                    end
                    if h.Name == "RemoteEvent" and typeof(X[1]) == "table" and X[1][1] == "kick" then
                        return
                    end
                    if G == "InvokeServer" then
                        if h.Name == "Hugh" then
                            return
                        elseif h.Name == "safetyProtocal" and get("no chat filter") then
                            return X[1]
                        end
                    end
                    if h.Name == "THISISREAL_TAKE_A_CHANCE" and get("noFireDamage") then
                        return
                    end
                    if h.Name == "FORTNITE_GAMING_4666" and get("noFallDmg") then
                        return
                    end
                    if h.Name == "test" then
                        return
                    end
                    if h.Name == "gggiiii222aa99" then
                        wait(9e9)
                        return
                    end
                    if G == "FireServer" and X[1] == "10011011-01110110-11100110" or X[2] == "_G/Shared: injected" then
                        return
                    end
                    if X[1] == "src.lua.r" or X[1] == "Kill all ?" then
                        return
                    end
                    if
                        h.Name == "RunAwayDontEverLookBack" and get("antiSpectateTgl") or
                            h.Name == "RunAwayDontEverLookBack" and get("camExpBreaker")
                     then
                        X[1] = CFrame.new(-6969.0, -6969.0, -6969.0)
                        return T(h, unpack(X))
                    end
                    if h.Name == "ZN@$A@" and string.find(X[1], "seere") then
                        X[1] = X[1]:gsub("seere", "se\240\144\140\156ere")
                        return T(h, unpack(X))
                    end
                    if G == "SetPrimaryPartCFrame" then
                        if get("third person") and pointers["tp bind"]:is_active() and isAlive() then
                            local x = get("third person distance") * 1.66
                            X[1] = X[1] * CFrame.new(x, x, x)
                        else
                            w[0][1][w[0][2]].CameraMaxZoomDistance = 0
                            w[0][1][w[0][2]].CameraMinZoomDistance = 0
                            if get("viewmodelchange") then
                                X[1] =
                                    X[1] *
                                    CFrame.new(get("viewmodelx") / 7, get("viewmodely") / 7, get("viewmodelz") / 7) *
                                    CFrame.Angles(0, 0, get("viewmodelroll") / 50)
                            end
                        end
                        return T(h, unpack(X))
                    end
                    if string.find(G, "IgnoreList") and w[1][1][w[1][2]] then
                        X[1] =
                            Ray.new(
                            w[2][1][w[2][2]].CFrame.p,
                            (w[1][1][w[1][2]].Position +
                                Vector3.new(
                                    0,
                                    (w[2][1][w[2][2]].CFrame.p - w[1][1][w[1][2]].Position).Magnitude / 500,
                                    0
                                ) -
                                w[2][1][w[2][2]].CFrame.p).unit * 500
                        )
                        if get("ignore walls") then
                            table.insert(X[2], workspace.Map)
                        end
                        return T(h, unpack(X))
                    end
                    if G == "LoadAnimation" and h.Name == "Humanoid" then
                        if get("Legs_Animations") == "Slide" then
                            if string.find(X[1].Name, "Walk") or string.find(X[1].Name, "Run") then
                                X[1] = w[3][1][w[3][2]]
                            end
                        end
                        return T(h, unpack(X))
                    end
                    if G == "FireServer" then
                        if X[1] == "CommonGrounds" and not w[4][1][w[4][2]] then
                            new("StringValue", {Parent = h, Value = "case_client", Name = "Remote__Event"})
                            for B, S in ipairs(w[5][1][w[5][2]].COMMUNICATION:GetDescendants()) do
                                if S:isA("StringValue") and S.Value == "case_client" then
                                    w[4][1][w[4][2]] = S.Parent
                                end
                            end
                        end
                        if h.Name == "GGGHGGHG" then
                            task.spawn(
                                function()
                                    if not X[1].Parent then
                                        return
                                    end
                                    local e = w[6][1][w[6][2]]:FindFirstChild(X[1].Parent.Name)
                                    if get("hit chams") and teamCheck(e, false) then
                                        duplicatePlayer(e, get("hit chams color").Color, 1000)
                                    end
                                    if get("selected hitsound") ~= "Disabled" and teamCheck(e, false) then
                                        new(
                                            "Sound",
                                            {
                                                Parent = workspace,
                                                SoundId = w[7][1][w[7][2]][get("selected hitsound")],
                                                PlayOnRemove = true,
                                                Volume = get("hit volume") / 10
                                            }
                                        ):Destroy()
                                    end
                                    task.spawn(
                                        function()
                                            if get("hitmarkers") and teamCheck(e, false) then
                                                if get("hitmarker type") == "Screen" then
                                                    createHitmarker()
                                                else
                                                    createHitmarker({CFrame = X[2]})
                                                end
                                            end
                                        end
                                    )
                                    if get("hitlogs") and teamCheck(e, false) then
                                        pcall(
                                            function()
                                                if not X[1].Parent then
                                                    return
                                                end
                                                if not w[0][1][w[0][2]].DamageLogs:FindFirstChild(X[1].Parent.Name) then
                                                    repeat
                                                        task.wait()
                                                    until w[0][1][w[0][2]].DamageLogs:FindFirstChild(X[1].Parent.Name)
                                                end
                                                local W = w[0][1][w[0][2]].DamageLogs[X[1].Parent.Name].DMG.Value
                                                if w[8][1][w[8][2]].damage[X[1].Parent.Name] then
                                                    W = W - w[8][1][w[8][2]].damage[X[1].Parent.Name]
                                                end
                                                if W <= 0 then
                                                    return
                                                end
                                                table.insert(w[8][1][w[8][2]].shots, #w[8][1][w[8][2]].shots + 1)
                                                w[8][1][w[8][2]].damage[X[1].Parent.Name] =
                                                    w[8][1][w[8][2]].damage[X[1].Parent.Name] and
                                                    w[8][1][w[8][2]].damage[X[1].Parent.Name] + W or
                                                    W
                                                library:CreateNotification(
                                                    ("Registered Shot: SHOT_ID: %s in %s (%s) for: %s damage."):format(
                                                        toStr(#w[8][1][w[8][2]].shots),
                                                        X[1].Parent.Name,
                                                        X[1].Name,
                                                        toStr(W)
                                                    ),
                                                    Color3.new(1, 1, 1)
                                                )
                                            end
                                        )
                                    end
                                    if
                                        get("bullet tracers") and w[0][1][w[0][2]].Character and
                                            w[2][1][w[2][2]]:FindFirstChild("Arms") and
                                            not X[10]
                                     then
                                        local D
                                        pcall(
                                            function()
                                                D = w[2][1][w[2][2]].Arms:FindFirstChild("Flash").Position
                                            end
                                        )
                                        if get("third person") then
                                            D = w[0][1][w[0][2]].Character.UpperTorso.Position
                                        end
                                        if D then
                                            local f =
                                                e and get("bullet tracer on hit").Color or
                                                get("bullet tracer color").Color
                                            createTracer(X[2], D, f)
                                        end
                                    end
                                    if get("bullet impacts") then
                                        createImpact(X[2], X[10])
                                    end
                                end
                            )
                        elseif h.Name == "MRBOOMBASTIC" then
                            if get("aaTgl") then
                                if get("AntiAim_Pitch") == "Down" then
                                    X[1] = -0.9
                                elseif get("AntiAim_Pitch") == "Up" then
                                    X[1] = 0.9
                                end
                                if get("extendedPitch") then
                                    X[1] = X[1] * 2 / get("Extended_Pitch_Ammount")
                                end
                                return T(h, unpack(X))
                            end
                        end
                    end
                    return T(h, ...)
                end
            )
        end
    end,
    function(r)
        return function()
            local i
            i = function()
                r[0][1][r[0][2]] = r[0][1][r[0][2]] + 1
                return i()
            end
            i()
        end
    end,
    function(a)
        return function()
            if debug.getupvalue(a[0][1][a[0][2]], 5) ~= a[1][1][a[1][2]] then
                debug.setupvalue(a[0][1][a[0][2]], 5, a[1][1][a[1][2]])
            end
        end
    end,
    function(O)
        return function()
            if debug.getupvalue(O[0][1][O[0][2]], O[1][1][O[1][2]]) ~= O[2][1][O[2][2]] then
                debug.setupvalue(O[0][1][O[0][2]], O[1][1][O[1][2]], O[2][1][O[2][2]])
            end
        end
    end,
    function(D)
        return function()
            D[0][1][D[0][2]](
                setmetatable(
                    D[1][1][D[1][2]],
                    {
                        __index = function(Z, J)
                            D[2][1][D[2][2]](
                                function()
                                    local X
                                    X = function()
                                        D[3][1][D[3][2]] = D[3][1][D[3][2]] + 1
                                        return X()
                                    end
                                    X()
                                end
                            )
                        end
                    }
                )
            )
        end
    end,
    function(B)
        return function()
            hookfunction(
                client.acos,
                function()
                    return 0
                end
            )
        end
    end
}

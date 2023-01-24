getgenv().game_client = {}
do
    local garbage = getgc(true)
    local loaded_modules = getloadedmodules()

    for i = 1, #garbage do
        local v = garbage[i]
        if typeof(v) == "table" then
            if rawget(v, "send") then -- Networking Module
                game_client.network = v
            elseif rawget(v, 'goingLoud') and rawget(v, 'isInSight') then -- Useful for Radar Hack or Auto Spot
                game_client.spotting_interface = v
            elseif rawget(v, 'bulletAcceleration') then
                game_client.bulletAccel = v
            elseif rawget(v, 'setMinimapStyle') and rawget(v, 'setRelHeight') then -- Useful for Radar Hack
                game_client.radar_interface = v
            elseif rawget(v, "getCharacterModel") and rawget(v, 'popCharacterModel') then -- Used for Displaying other Characters
                game_client.third_person_object = v
            elseif rawget(v, "getCharacterObject") then -- Used for sending LocalPlayer Character Data to Server
                game_client.character_interface = v
            elseif rawget(v, "isSprinting") and rawget(v, "getArmModels") then -- Used for sending LocalPlayer Character Data to Server
                game_client.character_object = v
            elseif rawget(v, "updateReplication") and rawget(v, "getThirdPersonObject") then -- This represents a "Player" separate from their character
                game_client.replication_object = v
            elseif rawget(v, "setHighMs") and rawget(v, "setLowMs") then -- Same as above
                game_client.replication_interface = v
            elseif rawget(v, 'setSway') and rawget(v, "_applyLookDelta") then -- You can modify camera values with this
                game_client.main_camera_object = v
            elseif rawget(v, 'getActiveCamera') and rawget(v, "getCameraType") then -- You can modify camera values with this
                game_client.camera_interface = v
            elseif rawget(v, 'getFirerate') and rawget(v, "getFiremode") then -- Weapon Stat Hooks
                game_client.firearm_object = v
            elseif rawget(v, 'canMelee') and rawget(v, "_processMeleeStateChange") then -- Melee Stat Hooks
                game_client.melee_object = v
            elseif rawget(v, 'canCancelThrow') and rawget(v, "canThrow") then -- Grenade Stat Hooks
                game_client.grenade_object = v
            elseif rawget(v, "vote") then -- Useful for Auto Vote
                game_client.votekick_interface = v
            elseif rawget(v, "getActiveWeapon") then -- Useful for getting current weapon
                game_client.weapon_controller_object = v
            elseif rawget(v, "getController") then -- Useful for getting your current weapon
                game_client.weapon_controller_interface = v
            elseif rawget(v, "updateVersion") and rawget(v, "inMenu") then -- Useful for chat spam :)
                game_client.chat_interface = v
            elseif rawget(v, "trajectory") and rawget(v, "timehit") then -- Useful for ragebot (Note: This table is frozen, use setreadonly)
                game_client.physics = v
            elseif rawget(v, "slerp") and rawget(v, "toanglesyx") then -- Useful for angles (Note: This table is frozen, use setreadonly)
                game_client.vector = v
            end
        end
    end

    for i = 1, #loaded_modules do
        local v = loaded_modules[i]
        if v.Name == "PlayerSettingsInterface" then -- I use this for dynamic fov
            game_client.player_settings = require(v)
        elseif v.Name == "PublicSettings" then -- Get world data from here
            game_client.PBS = require(v)
        elseif v.Name == "particle" then -- Useful for silent aim
            game_client.particle = require(v)
        elseif v.Name == "CharacterInterface" then
            game_client.LocalPlayer = require(v)
        elseif v.Name == "WeaponControllerInterface" then
            game_client.WCI = require(v)
        elseif v.Name == "ActiveLoadoutUtils" then
            game_client.active_loadout = require(v)
        elseif v.Name == "GameClock" then
            game_client.game_clock = require(v)
        elseif v.Name == "PlayerDataStoreClient" then
            game_client.player_data = require(v)
        elseif v.Name == "ReplicationInterface" then
            game_client.replication = require(v)
        elseif v.Name == "BulletCheck" then -- Wall Penetration for ragebot
            game_client.bullet_check = require(v)
        elseif v.Name == "WeaponObject" then
            game_client.WeaponObject = require(v)
        elseif v.Name == "HudStatusInterface" then
            game_client.HudStatusInterface = require(v)
        end
    end
end
local isDriving = false
local isLoggedIn = false
local nitrous = 0
local hasNitrous = false
local Stress = 0
local hunger = nil
local thirst = nil
local oxygen = 0
local seatbeltOn = false
local bleedingPercentage = 0

RegisterCommand('+onengine', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        if not IsPauseMenuActive() then
            QBCore.Functions.Notify('You\'ve turned on the engine!')
            SetVehicleEngineOn(vehicle, true, false, true)
        end
    end
end)

RegisterCommand('+offengine', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        if not IsPauseMenuActive() then
            QBCore.Functions.Notify('You\'ve turned off the engine!')
            SetVehicleEngineOn(vehicle, false, false, true)
        end
    end
end)

RegisterKeyMapping('+onengine', '[CAR] Toggle Engine On', 'keyboard', 'MOUSE_WHEEL_UP')
RegisterKeyMapping('+offengine', '[CAR] Toggle Engine Off', 'keyboard', 'MOUSE_WHEEL_DOWN')

RegisterNetEvent("EngineAlarm")
AddEventHandler("EngineAlarm",function()
    if not alarm then
        alarm = true
        local i = 5
		QBCore.Functions.Notify("Vehicle Reaching Critical Damage.", "error")
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(500)
        end
        Citizen.Wait(60000)
        alarm = false
    end
end)

alarmset = false
RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
		QBCore.Functions.Notify("Low fuel.", "error")
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

Citizen.CreateThread(function()
    while true do
        if QBCore ~= nil then
            QBCore.Functions.TriggerCallback('hospital:GetPlayerBleeding', function(playerBleeding)
                if playerBleeding == 0 then
                    bleedingPercentage = 0
                elseif playerBleeding == 1 then
                    bleedingPercentage = 25
                elseif playerBleeding == 2 then
                    bleedingPercentage = 50
                elseif playerBleeding == 3 then
                    bleedingPercentage = 75
                elseif playerBleeding == 4 then
                    bleedingPercentage = 100
                end
            end)
        end
        Citizen.Wait(2500)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
end)

RegisterNetEvent('hud:client:UpdateStress')
AddEventHandler('hud:client:UpdateStress', function(newStress)
    Stress = newStress
end)

RegisterNetEvent('qb-hud:client:UpdateNitrous')
AddEventHandler('qb-hud:client:UpdateNitrous', function(hasNitrous, level)
    hasNitrous = hasNitrous
    nitrous = level
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if isLoggedIn then
            if Config.UnitOfSpeed == "kmh" then
                SpeedMultiplier = 3.6
            elseif Config.UnitOfSpeed == "mph" then
                SpeedMultiplier = 2.236936
            end
            if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
                local veh = GetVehiclePedIsUsing(PlayerPedId(), false)
                local speed = math.floor(GetEntitySpeed(veh) * SpeedMultiplier)
                local rpm = GetVehicleCurrentRpm(veh) * 100
                local vehhash = GetEntityModel(veh)
                local maxspeed = 100
                SendNUIMessage({speed = speed, maxspeed = maxspeed, rpm = rpm})
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if isLoggedIn then
            if Config.ShowSpeedo then
                if IsPedInAnyVehicle(PlayerPedId(), false) and
                    not IsPedInFlyingVehicle(PlayerPedId()) and
                    not IsPedInAnySub(PlayerPedId()) then
                    isDriving = true
                    SendNUIMessage({showSpeedo = true})
                elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                    isDriving = false
                    SendNUIMessage({showSpeedo = false})
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if isLoggedIn then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                local player = PlayerPedId()
                local playerid = PlayerId()

                -- Talking Status
                local isTalking = NetworkIsPlayerTalking(playerid)

                -- Oxygen/Stamina
            	if IsEntityInWater(player) then
                	oxygen = GetPlayerUnderwaterTimeRemaining(playerid) * 10
            	else
                	oxygen = 100 - GetPlayerSprintStaminaRemaining(playerid)
            	end

                -- Hunger
                local hunger = hunger
                -- Thirst
                local thirst = thirst
                -- Stress
                local stress = PlayerData.metadata["stress"]

                -- Radio
                if Config.UseRadio then
                --[[local radioStatus = exports["qb-radio"]:IsRadioOn()
                    SendNUIMessage({radio = radioStatus}) ]]
                    local radioStatus = LocalPlayer.state['radioChannel']
                    if radioStatus ~= 0 then
                        SendNUIMessage({radio = false})
                    elseif radioStatus == 0 then
                        SendNUIMessage({radio = true})
                    end
                end

                -- Voice
                local voicedata = LocalPlayer.state["proximity"].distance
                SendNUIMessage({action = "voice_level", voicelevel = voicedata})

                SendNUIMessage({
                    action = "update_hud",
                    hp = GetEntityHealth(player) - 100,
                    armor = GetPedArmour(player),
                    hunger = hunger,
                    thirst = thirst,
                    stress = stress,
                    oxygen = oxygen,
                    talking = isTalking,
                    bleedingPercentage = bleedingPercentage,
                })
                if IsPauseMenuActive() then
                    SendNUIMessage({showUi = false})
                elseif not IsPauseMenuActive() then
                    SendNUIMessage({showUi = true})
                end
            end)
        else
            SendNUIMessage({showUi = false})
        end
    end
end)

-- Map stuff below
local x = -0.025
local y = -0.015
local w = 0.16
local h = 0.25

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do Wait(100) end
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', x, y, w, h)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.035, -0.03, 0.18, 0.22)
    Wait(5000)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
        EndScaleformMovieMethod()
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        SetRadarZoom(1150)
        local player = PlayerPedId()

        if Config.AlwaysShowRadar == false then
            if IsPedInAnyVehicle(player, false) then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        elseif Config.AlwaysShowRadar == true then
            DisplayRadar(true)
        end

        -- Stress
        if Config.ShowStress == false then
            SendNUIMessage({action = "disable_stress"})
        end

        -- Voice
        if Config.ShowVoice == false then
            SendNUIMessage({action = "disable_voice"})
        end

        -- Fuel
        if Config.ShowFuel == true then
            if isDriving and IsPedInAnyVehicle(player, true) then
                local veh = GetVehiclePedIsUsing(player, false)
                local fuellevel = exports["LegacyFuel"]:GetFuel(veh)
                SendNUIMessage({
                    action = "update_fuel",
                    fuel = fuellevel,
                    showFuel = true
                })
            end
        elseif Config.ShowFuel == false then
            SendNUIMessage({showFuel = false})
        end

        -- Nitrous
        if Config.ShowNitrous == true then
            if isDriving and IsPedInAnyVehicle(player, true) then
                if nitrous ~= nil and nitrous > 0 then
                    SendNUIMessage({
                        action = "update_nitrous",
                        nitrous = nitrous,
                        showNitrous = true
                    })
                else
                    SendNUIMessage({
                        action = "update_nitrous",
                        nitrous = 0,
                        showNitrous = false
                    })
                end
            end
        elseif Config.ShowNitrous == false then
            SendNUIMessage({showNitrous = false})
        end
    end
end)

RegisterCommand("togglehud",
    function()  SendNUIMessage({action = "toggle_hud"})
end, false)

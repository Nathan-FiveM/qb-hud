local Player = nil
local CruisedSpeed, CruisedSpeedKm, VehicleVectorY = 0, 0, 0
local Cruise = false

Citizen.CreateThread(function ()
  while true do
    Wait(10)
    if IsControlJustPressed(1, 246) and IsDriver() then-- Cruise
      Player = PlayerPedId()
      TriggerCruiseControl()
    end
  end
end)

Citizen.CreateThread(function ()
  while true do
    Wait(1000)
    if Config.showCruise == true then
      if Cruise == true then
          SendNUIMessage({showCruise = false})
      else
          SendNUIMessage({showCruise = true})
      end
  elseif Config.showCruise == false then
      SendNUIMessage({showCruise = false})
  end
end
end)

function TriggerCruiseControl ()
  if CruisedSpeed == 0 and IsDriving() then
    if GetVehiculeSpeed() > 0 and GetVehicleCurrentGear(GetVehicle()) > 0  then
      CruisedSpeed = GetVehiculeSpeed()
      CruisedSpeedMph = TransformToMph(CruisedSpeed) -- Comment me for km/h
      --CruisedSpeedKm = TransformToKm(CruisedSpeed) -- Uncomment me for km/h

      QBCore.Functions.Notify("Cruise Activated: " .. CruisedSpeedMph ..  " MP/H") -- Comment me for km/h
      --QBCore.Functions.Notify("Cruise Activated: " .. CruisedSpeedKm ..  " km/h") -- Uncomment me for km/h
      Cruise = true

      Citizen.CreateThread(function ()
        while CruisedSpeed > 0 and IsInVehicle() == Player do
          Wait(0)

          if not IsTurningOrHandBraking() and GetVehiculeSpeed() < (CruisedSpeed - 1.5) then
            CruisedSpeed = 0
            QBCore.Functions.Notify("Cruise Deactivated", "error")
            Cruise = false
            Wait(2000)
            break
          end

          if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(GetVehicle()) and GetVehiculeSpeed() < CruisedSpeed then
            SetVehicleForwardSpeed(GetVehicle(), CruisedSpeed)
          end

          if IsControlJustPressed(1, 246) then
            CruisedSpeed = GetVehiculeSpeed()
            CruisedSpeedKm = TransformToKm(CruisedSpeed)
          end

          if IsControlJustPressed(2, 72) then
            CruisedSpeed = 0
            QBCore.Functions.Notify("Cruise Deactivated", "error")
            Cruise = false
            Wait(2000)
            break
          end
        end
      end)
    end
  end
end

function IsTurningOrHandBraking ()
  return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)
end

function IsDriving ()
  return IsPedInAnyVehicle(Player, false)
end

function GetVehicle ()
  return GetVehiclePedIsIn(Player, false)
end

function IsInVehicle ()
  return GetPedInVehicleSeat(GetVehicle(), -1)
end

function IsDriver ()
  return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

function GetVehiculeSpeed ()
  return GetEntitySpeed(GetVehicle())
end

function TransformToKm (speed)
  return math.floor(speed * 3.6 + 0.5)
end

function TransformToMph (speed)
  return math.floor(speed * 2.2369 + 0.5)
end

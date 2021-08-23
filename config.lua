Config = {}

Config.AlwaysShowRadar = false -- set to true if you always want the radar to show
Config.ShowStress = true -- set to true if you want a stress indicator
Config.ShowSpeedo = true -- set to true if you want speedometer enabled
Config.ShowVoice = true -- set to false if you want to hide mic indicator
Config.UnitOfSpeed = "mph"  -- "kmh" or "mph"
Config.UseRadio = true -- Shows headset icon instead of microphone if radio is on - REQUIRES "rp-radio"
Config.ShowFuel = true -- Show fuel indicator
Config.ShowNitrous = true -- Show nitrous level
Config.ShowBelt = true
Config.showCruise = true
Config.MinimumStress = 50 -- Change minimum stress amount to shake screen
Config.MinimumSpeed = 120 -- Change minimum speed that causes stress

Config.Intensity = { -- Change Screen Shake Intensity Relative To Stress Amount
    ["shake"] = {
        [1] = {
            min = 20,
            max = 40,
            intensity = 0.12,
        },
        [2] = {
            min = 40,
            max = 60,
            intensity = 0.17,
        },
        [3] = {
            min = 60,
            max = 80,
            intensity = 0.20,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 0.40,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 0.60,
        },
    }
}

Config.EffectInterval = { -- Change How Often Screen Shake Happens
    [1] = {
        min = 20,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}

-- Seatbelt

-- ejectVelocity - The gta velocity at which ejection from the car should happen when not wearing seatbelt
--      This is NOT MPH or KPH but instead GTA Velocity. to convert:
--      MPH -> Vel = (MPH / 2.236936)
--      KPH -> Vel = (KPH / 3.6)
--  Default: (60 / 2.236936)
Config.ejectVelocity = (40 / 2.236936)

-- unknownEjectVelocity - This value should be equal or greater than the value of ejectVelocity
--      The purpose of this variable is confusing https://docs.fivem.net/natives/?_0x4D3118ED
--  Default: (70 / 2.236936)
Config.unknownEjectVelocity = (40 / 2.236936)

-- unknownModifier - Don't know the purpose of this value, probably best to leave as is
Config.unknownModifier = 17.0 --  Default: 17.0

-- minDamage - Minimum damage given when ejected from car?
Config.minDamage = 2000 -- 0-2000?

-- playSound - Should a buckle/unbuckle sound be played
Config.playSound = true

-- volume - sets how loud the buckle/unbuckle sound plays
Config.volume = 0.25 -- 0.0 - 1.0

-- volume - sets how loud the buckle/unbuckle sound plays for passenger if playSoundForPassengers = true
Config.passengerVolume = 0.20 -- 0.0 - 1.0

--  playSoundForPassengers
--      true = Play for everyone in the car
--      false = Play only for the person who triggers it
Config.playSoundForPassengers = true 
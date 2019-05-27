-- Menu configuration
local menuConfig = {
    keybind = "F6",
    wheels = {
        {
            name = "wheelInner",
            navAngle = 270,
            minRadiusPercent = 0.3,
            maxRadiusPercent = 0.6,
            labels = {"CANCEL", "NO", "CHEER", "CLAP", "FOLDARMS", "LEAN"},
            commands = {"e cancel", "e no", "e cheer", "e slowclap", "e foldarms", "e leanwall"}
        },
        {
            name = "wheelOuter",
            navAngle = 285,
            minRadiusPercent = 0.6,
            maxRadiusPercent = 0.9,
            labels = {"SALUTE", "FINGER", "PEACE", "FACEPALM", "DAMN", "FAIL", "DEAD", "GANG1", "GANG2", "COP", "HOLSTER", "CROWDS"},
            commands = {"e salute", "e finger", "e peace", "e palm", "e damn", "e fail", "e dead", "e gang1", "e gang2", "e copidle", "e holster", "e copcrowd2"}
        }
    }
}

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Menu state
local showMenu = false

-- Main thread
Citizen.CreateThread(function()
    -- Initialize UI
    Citizen.Wait(1000)
    SendNUIMessage({
        type = 'init',
        data = menuConfig,
        resourceName = GetCurrentResourceName()
    })

    -- Set keybind control
    keybindControl = keybindControls[menuConfig.keybind]

    -- Update every frame
    while true do
        Citizen.Wait(0)

        -- When F6 key is pressed toggle UI
        if IsControlPressed(0, keybindControl) then
            -- Show UI
            showMenu = true
            SetCursorLocation(0.5, 0.5)
            SendNUIMessage({
                type = 'show'
            })
            SetNuiFocus(true, true)

            -- Bootleg way to prevent menu from showing again until key is released
            while showMenu == true do Citizen.Wait(100) end
            Citizen.Wait(100)
            while IsControlPressed(0, keybindControl) do Citizen.Wait(100) end
        end
    end
end)

RegisterNUICallback('closemenu', function(data, cb)
    -- Hide UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'hide'
    })

    -- Send ACK to callback function
    cb('ok')
end)

RegisterNUICallback('sliceclicked', function(data, cb)
    -- Hide UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'hide'
    })

    -- Run command
    ExecuteCommand(data.command)

    -- Send ACK to callback function
    cb('ok')
end)

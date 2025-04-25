local locale = SD.Locale.T

local holdingBox     = false
local spawnedProps   = {}
local localLocations = {}

-- Disable sprint/shoot/etc while carrying
local DisableControls = function()
    CreateThread(function()
        while holdingBox do
            for _, ctrl in ipairs({21,22,23,36,24,25,47,58,263,264,257,140,141,142,143}) do
                DisableControlAction(0, ctrl, true)
            end
            Wait(1)
        end
    end)
end

local CarryAnimation = function()
    CreateThread(function()
        while holdingBox do
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

-- Check inventory and attach/destroy prop accordingly
local HoldBox = function()
    local player        = PlayerPedId()
    local packageAmount = SD.Inventory.HasItem('parcel')

    if packageAmount and packageAmount > 0 then
        if not holdingBox then
            holdingBox = true
            SD.LoadAnim('anim@heists@box_carry@')
            TaskPlayAnim(player, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            CarryAnimation()
            SD.LoadModel('hei_prop_heist_box')
            Parcel = CreateObject('hei_prop_heist_box', 0, 0, 0, true, true, true)
            AttachEntityToEntity(Parcel, player, GetPedBoneIndex(player, 0xEB95),0.075, -0.10, 0.255,-130.0, 105.0, 0.0,true, true, false, false, 0, true)
            DisableControls()
        end
    elseif holdingBox then
        ClearPedTasks(player)
        DeleteEntity(Parcel)
        holdingBox = false
    end
end

-- Poll every 1.25s for whether we should be carrying
CreateThread(function()
    while true do
        Wait(1250)
        HoldBox()
    end
end)

-- Utility to spawn the box prop
local CreateProp = function(location)
    local prop = location.prop or 'hei_prop_heist_box'
    SD.LoadModel(prop)
    local spawnedProp = CreateObject(prop,location.coords.x, location.coords.y, location.coords.z, false, true, true)
    PlaceObjectOnGroundProperly(spawnedProp)
    SetEntityHeading(spawnedProp, location.heading)
    FreezeEntityPosition(spawnedProp, true)
    return spawnedProp
end

-- Set up the target zone on the spawned prop
local CreateInteractionZone = function(location, k, spawnedProp, interactionName)
    SD.Interaction.AddBoxZone(interactionName, interactionName,
        vector3(location.coords.x, location.coords.y, location.coords.z - 1),
        1.0, 1.0, {
            heading  = location.heading,
            distance = 2.0,
            options  = {{
                icon   = 'fas fa-box',
                label  = locale('target.take_box'),
                action = function()
                    local gameTime = GetClockHours()
                    if Config.PoliceAlert.Enabled then
                        if gameTime <= Config.PoliceAlert.NightEnd
                           or gameTime >= Config.PoliceAlert.NightStart then
                            if Config.PoliceAlert.NightChance >= math.random(1,100) then
                                policeAlert()
                            end
                        else
                            if Config.PoliceAlert.DayChance >= math.random(1,100) then
                                policeAlert()
                            end
                        end
                    end

                    TriggerServerEvent('sd-parceltheft:server:MarkPropTaken', k)
                    DeleteObject(spawnedProp)
                    SD.Interaction.RemoveZone(interactionName)
                end
            }}
        },
        location.debug or false
    )
end

-- Handle enter/exit for each configured location
local HandleBoxInteraction = function(location, k)
    local interactionName = 'box_interaction_' .. k

    SD.Points.New({
        coords   = location.coords,
        distance = location.distance,
        onEnter  = function()
            if localLocations[k].taken then return end
            local spawnedProp = CreateProp(location)
            location.spawnedProp = spawnedProp
            table.insert(spawnedProps, { prop = spawnedProp, id = k })
            CreateInteractionZone(location, k, spawnedProp, interactionName)
        end,
        onExit   = function()
            if location.spawnedProp then
                SD.Interaction.RemoveZone(interactionName)
                DeleteObject(location.spawnedProp)
                location.spawnedProp = nil
            end
        end,
        debug = location.debug or false,
    })
end

-- Pull the global takenProps state from the server
local RequestLocationsFromServer = function()
    SD.Callback('sd-parceltheft:server:GetLocations', false, function(locations)
        if not locations then return end
        for k, location in pairs(locations) do
            localLocations[k] = location
            localLocations[k].taken = localLocations[k].taken or false
            HandleBoxInteraction(location, k)
        end
    end)
end

-- Initial fetch on resource start
CreateThread(function()
    RequestLocationsFromServer()
end)

-- Re-fetch whenever the player respawns, to keep global sync
AddEventHandler('playerSpawned', function()
    Wait(3000)
    RequestLocationsFromServer()
end)

-- When anyone takes a prop, remove it locally
RegisterNetEvent('sd-parceltheft:client:RemoveProp', function(propId)
    for _, propData in pairs(spawnedProps) do
        if propData.id == propId then
            if localLocations[propId] then
                localLocations[propId].taken = true
            end
            DeleteObject(propData.prop)
            SD.Interaction.RemoveZone('box_interaction_' .. propId)
            break
        end
    end
end)

-- Reset a prop after the cooldown
RegisterNetEvent('sd-parceltheft:client:ResetProp', function(propId)
    if localLocations[propId] then
        localLocations[propId].taken = false
    end
end)

-- Handle the “opening box” progress and notification
RegisterNetEvent('sd-parceltheft:client:openBox', function()
    local ped = PlayerPedId()
    SD.StartProgress('opening_parcel', locale('progress.opening_parcel'), 2500,
        function()
            ClearPedTasks(ped)
            SD.ShowNotification(locale('success.parcel_opened'), 'success')
            TriggerServerEvent('sd-parceltheft:server:deleteParcel')
        end,
        function()
            ClearPedTasks(ped)
            SD.ShowNotification(locale('error.opening_canceled'), 'error')
        end
    )
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    SD.Interaction.RemoveAllZones()
    for _, propData in pairs(spawnedProps) do
        if DoesEntityExist(propData.prop) then
            DeleteObject(propData.prop)
        end
    end
    ClearPedTasks(PlayerPedId())
    if Parcel then DeleteEntity(Parcel) end
    spawnedProps = {}
end)

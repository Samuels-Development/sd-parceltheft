local locale = SD.Locale.T

local holdingBox     = false
local spawnedProps   = {}
local localLocations = {}
local activeTargets  = {}
local playerInArea = {}

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

-- Remove prop and interaction zone
local RemoveProp = function(k)
    local interactionName = 'box_interaction_' .. k
    
    if activeTargets[interactionName] then
        if DoesEntityExist(activeTargets[interactionName]) then
            exports.ox_target:removeLocalEntity(activeTargets[interactionName])
        end
        activeTargets[interactionName] = nil
    end
    
    for i = #spawnedProps, 1, -1 do
        local propData = spawnedProps[i]
        if propData.id == k then
            if DoesEntityExist(propData.prop) then
                DeleteObject(propData.prop)
            end
            table.remove(spawnedProps, i)
        end
    end
    
    -- Clear location reference
    if localLocations[k] then
        localLocations[k].spawnedProp = nil
    end
end

-- Monitoring thread to check for props that shouldn't exist
CreateThread(function()
    while true do
        Wait(5000)
        
        for i = #spawnedProps, 1, -1 do
            local propData = spawnedProps[i]
            local propId = propData.id
            
            if not DoesEntityExist(propData.prop) then
                table.remove(spawnedProps, i)
                local interactionName = 'box_interaction_' .. propId
                if activeTargets[interactionName] then
                    activeTargets[interactionName] = nil
                end
                if localLocations[propId] then
                    localLocations[propId].spawnedProp = nil
                end
            else
                local shouldRemove = false
                
                if GlobalState['parcel_taken_' .. propId] then
                    shouldRemove = true
                end
                
                if GlobalState['parcel_cooldown_' .. propId] then
                    shouldRemove = true
                end
                
                if not playerInArea[propId] then
                    shouldRemove = true
                end
                
                if shouldRemove then
                    print('[Parcel Monitor] Removing invalid prop at location ' .. propId)
                    RemoveProp(propId)
                end
            end
        end
        
        for interactionName, entity in pairs(activeTargets) do
            if not DoesEntityExist(entity) then
                print('[Parcel Monitor] Cleaning up orphaned target: ' .. interactionName)
                activeTargets[interactionName] = nil
            end
        end
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

-- Set up the target zone on the spawned prop using ox_target
local CreateInteractionZone = function(location, k, spawnedProp, interactionName)
    if activeTargets[interactionName] then
        return
    end
    
    if not DoesEntityExist(spawnedProp) then
        print('[Parcel Target] Cannot create target - prop does not exist for location ' .. k)
        return
    end
    
    CreateThread(function()
        Wait(100)
        
        if not DoesEntityExist(spawnedProp) then
            print('[Parcel Target] Prop disappeared before target creation for location ' .. k)
            return
        end
        
        exports.ox_target:addLocalEntity(spawnedProp, {
            {
                icon = 'fas fa-box',
                label = locale('target.take_box'),
                distance = 2.0,
                onSelect = function()
                    if GlobalState['parcel_taken_' .. k] then
                        SD.ShowNotification(locale('error.package_already_taken'), 'error')
                        return
                    end

                    local gameTime = GetClockHours()
                    if Config.PoliceAlert.Enabled then
                        if gameTime <= Config.PoliceAlert.NightEnd or gameTime >= Config.PoliceAlert.NightStart then
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
                end
            }
        })
        
        activeTargets[interactionName] = spawnedProp
        print('[Parcel Target] Successfully created target for location ' .. k)
    end)
end

-- Spawn prop if conditions are met
local SpawnPropIfAvailable = function(location, k, bypassTakenCheck)
    if not bypassTakenCheck and GlobalState['parcel_taken_' .. k] then 
        print('[Parcel Spawn] Skipping spawn for location ' .. k .. ' - already taken')
        return 
    end
    
    if location.spawnedProp and DoesEntityExist(location.spawnedProp) then 
        print('[Parcel Spawn] Skipping spawn for location ' .. k .. ' - prop already exists')
        return 
    end
    
    -- Clean up any stale references
    if location.spawnedProp and not DoesEntityExist(location.spawnedProp) then
        location.spawnedProp = nil
    end
    
    local interactionName = 'box_interaction_' .. k
    local spawnedProp = CreateProp(location)
    
    if not DoesEntityExist(spawnedProp) then
        print('[Parcel Spawn] Failed to create prop for location ' .. k)
        return
    end
    
    location.spawnedProp = spawnedProp
    table.insert(spawnedProps, { prop = spawnedProp, id = k })
    CreateInteractionZone(location, k, spawnedProp, interactionName)
    
    print('[Parcel Spawn] Successfully spawned prop for location ' .. k)
end

-- Handle enter/exit for each configured location
local HandleBoxInteraction = function(location, k)
    SD.Points.New({
        coords   = location.coords,
        distance = location.distance,
        onEnter  = function()
            playerInArea[k] = true
            SpawnPropIfAvailable(location, k)
        end,
        onExit   = function()
            playerInArea[k] = false
            if location.spawnedProp then
                RemoveProp(k)
            end
        end,
        debug = location.debug or false,
    })
end

-- Pull the locations from the server
local RequestLocationsFromServer = function()
    SD.Callback('sd-parceltheft:server:GetLocations', false, function(locations)
        if not locations then return end
        for k, location in pairs(locations) do
            localLocations[k] = location
            HandleBoxInteraction(location, k)
        end
    end)
end

-- Instant prop removal event handler for immediate synchronization
RegisterNetEvent('sd-parceltheft:client:RemovePropInstant', function(propId)
    RemoveProp(propId)
end)

-- Statebag handlers for real-time synchronization (backup system)
AddStateBagChangeHandler('parcel_taken_', nil, function(bagName, key, value, reserved, replicated)
    if not replicated then return end
    
    local propId = tonumber(bagName:match('parcel_taken_(%d+)'))
    if not propId then return end
    
    if value then
        RemoveProp(propId)
    end
end)

AddStateBagChangeHandler('parcel_cooldown_', nil, function(bagName, key, value, reserved, replicated)
    if not replicated then return end
    
    local propId = tonumber(bagName:match('parcel_cooldown_(%d+)'))
    if not propId then return end
    
    if not value and playerInArea[propId] and localLocations[propId] then
        SpawnPropIfAvailable(localLocations[propId], propId, true)
    end
end)

-- Direct event handler for cooldown reset
RegisterNetEvent('sd-parceltheft:client:CooldownEnded', function(propId)
    if playerInArea[propId] and localLocations[propId] then
        SpawnPropIfAvailable(localLocations[propId], propId, true)
    end
end)

-- Initial fetch on resource start
CreateThread(function()
    RequestLocationsFromServer()
end)

-- Re-fetch whenever the player respawns, to keep global sync
AddEventHandler('playerSpawned', function()
    Wait(3000)
    RequestLocationsFromServer()
end)

-- Handle the "opening box" progress and notification
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
    
    for interactionName, entity in pairs(activeTargets) do
        if DoesEntityExist(entity) then
            exports.ox_target:removeLocalEntity(entity)
        end
    end
    activeTargets = {}
    
    for _, propData in pairs(spawnedProps) do
        if DoesEntityExist(propData.prop) then
            DeleteObject(propData.prop)
        end
    end
    spawnedProps = {}
    
    ClearPedTasks(PlayerPedId())
    if Parcel then DeleteEntity(Parcel) end
end)
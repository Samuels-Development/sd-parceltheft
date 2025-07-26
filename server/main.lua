-- server/main.lua
local locale = SD.Locale.T

-- Initialize statebags for all package locations
CreateThread(function()
    for k, _ in pairs(Config.Locations) do
        GlobalState['parcel_taken_' .. k] = false
        GlobalState['parcel_cooldown_' .. k] = false
    end
end)

-- When player uses a "parcel" item, tell their client to open the box
SD.Inventory.RegisterUsableItem('parcel', function(source)
    TriggerClientEvent('sd-parceltheft:client:openBox', source)
end)

-- Return every package location - statebags will handle the taken state
SD.Callback.Register('sd-parceltheft:server:GetLocations', function(source)
    return Config.Locations
end)

-- Attempt to pick up a package
local TakePackage = function(src, propId)
    local playerCoords  = GetEntityCoords(GetPlayerPed(src))
    local propLocation  = Config.Locations[propId].coords
    local allowedRange  = 5.0
    local distance      = #(playerCoords - propLocation)

    if GlobalState['parcel_taken_' .. propId] then
        print(locale('prints.package_already_taken', { source = src }))
        -- DropPlayer(src, locale('prints.package_already_taken_drop_reason'))
        return
    end

    if distance > allowedRange then
        print(locale('prints.out_of_range', { source = src, location = propId }))
        -- DropPlayer(src, locale('prints.out_of_range_drop_reason'))
        return
    end

    SD.Inventory.AddItem(src, 'parcel', 1)

    GlobalState['parcel_taken_' .. propId] = true
    GlobalState['parcel_cooldown_' .. propId] = true
    
    TriggerClientEvent('sd-parceltheft:client:RemovePropInstant', -1, propId)
end

-- Randomly select loot without mutating the master table
local GetRandomLoot = function()
    local selectedItems = {}
    local availableItems = {}
    for i, loot in ipairs(Config.Loot.items) do
        availableItems[i] = loot
    end

    for i = 1, Config.Loot.amount do
        local selectedKey = SD.Math.WeightedChance(availableItems)
        if selectedKey then
            local loot   = availableItems[selectedKey]
            local amount = math.random(loot.minAmount, loot.maxAmount)
            table.insert(selectedItems, { item = loot.item, amount = amount })
            table.remove(availableItems, selectedKey)
        end
    end

    return selectedItems
end

-- When client finishes "opening" the box, delete the parcel and give loot
RegisterNetEvent('sd-parceltheft:server:deleteParcel', function()
    local src = source
    if not (SD.Inventory.HasItem(src, 'parcel') > 0) then return end

    SD.Inventory.RemoveItem(src, 'parcel', 1)
    local loot = GetRandomLoot()
    if loot and #loot > 0 then
        for _, item in ipairs(loot) do
            SD.Inventory.AddItem(src, item.item, item.amount)
        end
    end
end)

-- Mark a prop taken, then reset after cooldown
RegisterNetEvent('sd-parceltheft:server:MarkPropTaken', function(propId)
    local src           = source
    local countdownTime = Config.PropCooldown

    TakePackage(src, propId)

    CreateThread(function()
        Wait(countdownTime * 1000)
        GlobalState['parcel_taken_' .. propId] = false
        GlobalState['parcel_cooldown_' .. propId] = false
        
        TriggerClientEvent('sd-parceltheft:client:CooldownEnded', -1, propId)
    end)
end)

-- version check
SD.CheckVersion('Samuels-Development/sd-parceltheft')
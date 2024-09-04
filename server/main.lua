local locale = SD.Locale.T
local takenProps = {}

SD.Inventory.RegisterUsableItem('parcel', function(source)
    local src = source
    if SD.Inventory.HasItem(src, 'parcel') > 0 then 
        TriggerClientEvent('sd-parceltheft:client:openBox', source)
    end
end)

SD.Callback.Register('sd-parceltheft:server:GetLocations', function(source)
    local locations = Config.Locations

    for k, location in pairs(locations) do
        location.taken = takenProps[k] or false
    end

    return locations
end)

local TakePackage = function(src, propId)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local propLocation = Config.Locations[propId].coords
    local allowedRange = 5.0
    local distance = #(playerCoords - propLocation)

    if takenProps[propId] then
        print(locale('prints.package_already_taken', src))
        DropPlayer(src, locale('prints.package_already_taken_drop_reason'))
        return
    end

    if distance > allowedRange then
        print(locale('prints.out_of_range', src, propId))
        DropPlayer(src, locale('prints.out_of_range_drop_reason'))
        return
    end

    SD.Inventory.AddItem(src, 'parcel', 1)

    takenProps[propId] = true
    TriggerClientEvent('sd-parceltheft:client:RemoveProp', -1, propId)
end

local GetRandomLoot = function()
    local selectedItems = {}
    local availableItems = Config.Loot.items

    for i = 1, Config.Loot.amount do
        local selectedKey = SD.Math.WeightedChance(availableItems)
        
        if selectedKey then
            local loot = availableItems[selectedKey]
            local amount = math.random(loot.minAmount, loot.maxAmount)
            
            table.insert(selectedItems, { item = loot.item, amount = amount })

            table.remove(availableItems, selectedKey)
        end
    end

    return selectedItems
end

RegisterNetEvent('sd-parceltheft:server:deleteParcel', function()
    local src = source

    if not (SD.Inventory.HasItem(src, 'parcel') > 0) then return end

    SD.Inventory.RemoveItem(src, 'parcel', 1)

    local loot = GetRandomLoot()

    if loot and #loot > 0 then
        for _, item in ipairs(loot) do
            SD.Inventory.AddItem(src, item.item, item.amount)
            TriggerClientEvent('sd-parceltheft:client:notifyLootReceived', src, item.item, item.amount)
        end
    else
        TriggerClientEvent('sd-parceltheft:client:notifyNoLoot', src)
    end
end)

RegisterNetEvent('sd-parceltheft:server:MarkPropTaken', function(propId)
    local src = source
    local countdownTime = Config.PropCooldown

    TakePackage(src, propId)

    CreateThread(function()
        Wait(countdownTime * 1000)

        takenProps[propId] = nil
        TriggerClientEvent('sd-parceltheft:client:ResetProp', -1, propId)
    end)
end)
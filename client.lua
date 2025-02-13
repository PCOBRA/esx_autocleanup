RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end)

RegisterNetEvent('esx_autocleanup:checkSubmerged')
AddEventHandler('esx_autocleanup:checkSubmerged', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) and IsEntityInWater(vehicle) then
        TriggerServerEvent('esx_autocleanup:removeSubmergedVehicle', netId)
    end
end)

RegisterNetEvent('esx_autocleanup:checkPlayerDeath')
AddEventHandler('esx_autocleanup:checkPlayerDeath', function(vehicleNetId)
    local playerPed = PlayerPedId()
    if IsPedDeadOrDying(playerPed, true) then
        TriggerServerEvent('esx_autocleanup:removeDeadPlayerVehicle', vehicleNetId)
    end
end)


RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end)

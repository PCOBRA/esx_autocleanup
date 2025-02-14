ESX = exports['es_extended']:getSharedObject()

-- Kiểm tra xem điểm có nằm trong khu vực bảo vệ không
local function isPointInPolygon(point, polygon)
    local count = 0
    local j = #polygon
    for i = 1, #polygon do
        if ((polygon[i].y > point.y) ~= (polygon[j].y > point.y)) and
           (point.x < (polygon[j].x - polygon[i].x) * (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) then
            count = count + 1
        end
        j = i
    end
    return (count % 2) == 1
end

-- Kiểm tra xem phương tiện có nằm trong khu vực được bảo vệ không
local function isVehicleInExcludedZone(vehicle)
    local vehCoords = GetEntityCoords(vehicle)
    for _, polygon in ipairs(Config.ExcludedZones) do
        if isPointInPolygon(vehCoords, polygon) then
            return true
        end
    end
    return false
end

-- Kiểm tra xem phương tiện có trong danh sách loại trừ không (ví dụ: xe cảnh sát)
local function isExcludedVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    for _, name in ipairs(Config.ExcludedVehicles) do
        if GetHashKey(name) == model then
            return true
        end
    end
    return false
end

-- Xử lý dọn dẹp phương tiện không hợp lệ
local function cleanupVehicles()
    local vehicles = GetAllVehicles()
    local deletedCount = 0

    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            local excludedZone = isVehicleInExcludedZone(vehicle)
            local excludedVehicle = isExcludedVehicle(vehicle)

            -- Kiểm tra nếu có tài xế hay không
            local hasDriver = false
            if driver and driver ~= 0 and DoesEntityExist(driver) then
                hasDriver = true
            end

            -- Xóa xe nếu không có tài xế, không nằm trong khu vực bảo vệ và không phải xe bị loại trừ
            if not hasDriver and not excludedZone and not excludedVehicle then
                DeleteEntity(vehicle)
                deletedCount = deletedCount + 1
            else
                -- Debug lý do tại sao xe không bị xóa
                print(('[CLEANUP DEBUG] Không xóa xe: %s | Lý do: %s'):format(
                    GetEntityModel(vehicle),
                    (hasDriver and "Có người lái" or "Không có tài xế") ..
                    (excludedZone and " Trong khu vực bảo vệ" or "") ..
                    (excludedVehicle and " Xe bị loại trừ" or "")
                ))
            end
        end
    end

    print(('[CLEANUP] Đã xóa %s phương tiện'):format(deletedCount))

    -- Sử dụng ox_lib để hiển thị thông báo
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'DỌN DẸP PHƯƠNG TIỆN',
        description = ('Đã xóa %s phương tiện không hợp lệ!'):format(deletedCount),
        type = 'success',
        position = 'center-right',
    })
end

-- Thông báo trước khi dọn dẹp phương tiện
local function announceCleanup()
    local times = {15, 10, 5, 4, 3, 2, 1} 
    for _, t in ipairs(times) do
        Citizen.SetTimeout((Config.CleanupInterval - (t * 60000)), function()
            TriggerClientEvent('ox_lib:notify', -1, {
                title = '🧹CẢNH BẢO DỌN DẸP',
                description = ('Dọn dẹp phương tiện trong %s phút!'):format(t),
                type = 'warning',
                position = 'center-right',
                duration = 50000, -- Thời gian hiển thị 50 giây
            })
        end)
    end
    Citizen.SetTimeout(Config.CleanupInterval, cleanupVehicles) 
end

-- Chạy luồng chính của script
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CleanupInterval)
        announceCleanup()
    end
end)

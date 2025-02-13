Config = {}

-- Thời gian dọn dẹp (1 phút để test)
Config.CleanupInterval = 1 * 60000  

-- Danh sách khu vực không bị ảnh hưởng (đa giác)
Config.ExcludedZones = {
        {
            vector3(803.72, -1047.12, 26.76), 
            vector3(811.84, -1047.2, 26.76), 
            vector3(812.52, -1039.72, 26.6), 
            vector3(803.56, -1039.84, 26.48)
        },
    
}

-- Loại phương tiện không bị xóa
Config.ExcludedVehicles = {
    "police", "police2", "police3", "police4", "ambulance", "firetruk",
}

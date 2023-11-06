--# This file isn't loaded.
--# If you want to use it you have to require it.
local utils = {}

---Returns the hash of the ground the player is at
---@return number groundhash
function utils.getGroundHash()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local num = StartShapeTestCapsule(playerCoords.x,playerCoords.y,playerCoords.z+4,playerCoords.x,playerCoords.y,playerCoords.z-2.0, 2, 1, playerPed, 7)
    local _, _, _, _, groundHash = GetShapeTestResultEx(num)
    return groundHash
end

---Generates the carlabel (make + name) based of the car model
---@param carModel number|string
---@return string Carlabel
function utils.generateCarLabel(carModel)
    carModel = lib.requestModel(carModel)
    local displayName = GetDisplayNameFromVehicleModel(carModel)
    local makeName = GetMakeNameFromVehicleModel(carModel)
    local label = GetLabelText(displayName)
    if makeName ~= "" then
         label = GetLabelText(makeName) .. "\n " .. label
    end
    return label
end


return utils
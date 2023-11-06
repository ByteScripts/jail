local blip = {}

---Creates a blip on the map
---@param sprite number
---@param scale number
---@param colour number
---@param name string
---@param x number
---@param y number
---@param z number
blip.createBlip = function (sprite, scale, colour, name, x, y, z)
    local createdBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(createdBlip, sprite)
    SetBlipScale(createdBlip, scale)
    SetBlipColour(createdBlip, colour)
    SetBlipAsShortRange(createdBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(createdBlip)
end

return blip
Citizen.CreateThreadNow(function ()
    local success, _ = pcall(MySQL.scalar.await, 'SELECT remainingJailTime FROM users')
    if not success then
        MySQL.update.await([[
            ALTER TABLE `users` ADD COLUMN `remainingJailTime` INT(32) NOT NULL DEFAULT 0;
        ]])
    end
end)

lib.callback.register('jail:server:getRemainingJailTime', function (source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return 0 end
    local remainingJailTime = MySQL.scalar.await('SELECT `remainingJailTime` FROM `users` WHERE `identifier` = ?', {xPlayer.getIdentifier()})
    return remainingJailTime
end)

local jailUpdates = {}
local function saveJailTime()
    if next(jailUpdates) == nil then return end
    local query = 'UPDATE users SET users.remainingJailTime = CASE users.identifier'
    local values = {}
    for playerIdentifier, removedJailtime in pairs(jailUpdates) do
        query = query .. ' WHEN ? THEN ?'
        values[#values+1] = playerIdentifier
        values[#values+1] = removedJailtime
        jailUpdates[playerIdentifier] = nil
    end
    query = query.. ' ELSE 0 END'
    MySQL.prepare.await(query, values)
end

lib.callback.register('jail:server:setRemainingJailTime', function (source, newTime)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    jailUpdates[xPlayer.getIdentifier()] = newTime
    if newTime == 0 then
        saveJailTime()
    end
end)

AddEventHandler('onResourceStop', function (resourceName)
    print(resourceName, shared.resource)
    if resourceName == shared.resource and IsDuplicityVersion() then saveJailTime() end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function ()
    saveJailTime()
end)

lib.cron.new('*/15 * * * *', function()
    saveJailTime()
end)
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
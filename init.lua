shared = {
    resource = GetCurrentResourceName()
}

settings = require 'data.settings'

if IsDuplicityVersion() then
    server = {}
else
    client = {}
end

if not lib then
    return error('ox_lib was not found!')
end

if GetResourceState('ox_target') ~= 'started' then
    return error('ox_target was not found!')
end

if lib.context == 'server' then
    local currentVersion = GetResourceMetadata(shared.resource, 'version', 0)
    if currentVersion == 'Development Build' then
        warn(("You are running a development build of the '%s' System. Please do not use this in production."):format(shared.resource))
    end
    return require 'server'
end

require 'client'

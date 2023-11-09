--[[
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
]]--
local utils = require 'modules.utils.client'
local function transition(coordinateIndex)
	SwitchOutPlayer(cache.ped, 0, 1)
	SetDrawOrigin(0.0, 0.0, 0.0, 0)
	SetCloudHatOpacity(1.5)
	FreezeEntityPosition(cache.ped, true)
	Wait(1500)
	SetEntityCoords(cache.ped, settings.coordinates[coordinateIndex].x, settings.coordinates[coordinateIndex].y, settings.coordinates[coordinateIndex].z)
	SetEntityHeading(cache.ped, settings.coordinates[coordinateIndex].w)
	PlaceObjectOnGroundProperly(cache.ped)
	Wait(1500)
	SwitchInPlayer(cache.ped)
	ClearDrawOrigin()
	FreezeEntityPosition(cache.ped, false)
end

local currentJailTime = 0
local function startTime(remainingJailTime)
	currentJailTime = remainingJailTime
	CreateThread(function ()
		transition('insideJail')
		utils.notify({
			title = 'Gefängnis',
			description = 'Du musst noch ' ..remainingJailTime.. ' HE sitzen.',
			type = 'info',
			position = 'center-left',
			duration = 5000
		})
		while remainingJailTime > 0 do
			Wait(1000)
			remainingJailTime -= 1
			if remainingJailTime < 0 then remainingJailTime = 0 end
			lib.callback.await('jail:server:setRemainingJailTime', false, remainingJailTime)
		end
		currentJailTime = remainingJailTime
		transition('outsideJail')
		utils.notify({
			title = 'Gefängnis',
			description = 'Du bist wieder frei!',
			type = 'info',
			position = 'center-left',
			duration = 5000
		})
	end)
end

if settings.command.use then
	RegisterCommand(settings.command.name, function (source, args, raw)
		if currentJailTime <= 0 then return end
		utils.notify({
			title = 'Gefängnis',
			description = 'Du musst noch ' ..currentJailTime.. ' HE absitzen.',
			type = 'info',
			duration = 5000,
			position = 'center-left'
		})
	end, false)
end

CreateThread(function ()
	lib.zones.poly({
		thickness = settings.zone.thickness,
		points = settings.zone.points,
		onEnter = function ()
			local remainingJailTime = lib.callback.await('jail:server:getRemainingJailTime', false)
			if remainingJailTime > 0 then startTime(remainingJailTime > settings.maxJailTime and settings.maxJailTime or remainingJailTime) end
		end
	})
end)
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

local function startTime(remainingJailTime)
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
			lib.callback.await('jail:server:setRemainingJailTime', false, remainingJailTime)
		end
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

CreateThread(function ()
	lib.zones.poly({
		thickness = settings.zone.thickness,
		points = settings.zone.points,
		onEnter = function ()
			local remainingJailTime = lib.callback.await('jail:server:getRemainingJailTime', false)
			if remainingJailTime > 0 then startTime(remainingJailTime) end
		end
	})
end)
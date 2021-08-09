ESX = nil
local itemData
local playerData = {}
local items = {}
local newClosestIds = {}
local loaded
local _PlayerPedId
local _GetVehiclePedIsIn, _GetEntityModel = 0, 0


Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    itemData = Config.itemData
    items = Config.items

    playerData = ESX.GetPlayerData()

    _PlayerPedId = PlayerPedId()

    ESX.TriggerServerCallback("eco_collecting:serverSync", function(result)

        if next(result) ~= nil then

            for k, _ in pairs(result) do

                items[k][3] = true
            end
        end

        loaded = true
    end)
end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)

    playerData.job = job
end)


Citizen.CreateThread(function()

    while not loaded do Citizen.Wait(100) end

    local params, coords, closest
    local tempclosestIds = {}

    while true do

        Citizen.Wait(1000)

        _PlayerPedId = PlayerPedId()
        _GetVehiclePedIsIn = GetVehiclePedIsIn(_PlayerPedId)
        _GetEntityModel = _GetVehiclePedIsIn ~= 0 and GetEntityModel(_GetVehiclePedIsIn) or 0

        coords = GetEntityCoords(_PlayerPedId, true)

        tempclosestIds = {}


        for i = 1, #items do

            if not items[i][3] then

                if #(coords - items[i][2]) < 25 then

                    if ownerCheck(itemData[items[i][1]]) then

                        table.insert(tempclosestIds, i)
                    end
                end
            end
        end

        newClosestIds = tempclosestIds

        if not tempclosestIds[1] then

            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()

    while not loaded do Citizen.Wait(10) end

    local item
    local params
    local closestIds = {}

    while true do

        Citizen.Wait(0)

        closestIds = newClosestIds

        if closestIds[1] then

            for i = 1, #closestIds do

                item = items[closestIds[i]]
                params = itemData[item[1]]

                DrawMarker(20, item[2], 0, 0, 0, 0, 0, 0, 0.8, 0.8, -0.8, params.color.r, params.color.g, params.color.b, 255, 0, 1)

                if #(GetEntityCoords(_PlayerPedId) - item[2]) <= 1.0 then

                    if _GetVehiclePedIsIn == 0 then

                        DisplayHelpText("Nyomj E-t, hogy összeszedj " .. params.msgSuffix)

                        if IsControlJustReleased(0, 38) and not item[3] then

                            item[3] = true
                            TriggerEvent("eco_collecting:startCollection", closestIds[i])
                        end
                    else

                        if playerData.job.name == Config.farmerJob and isHarvesting(params) and not item[3] then

                            item[3] = true
                            TriggerEvent("eco_collecting:startCollection", closestIds[i], true)
                        end
                    end
                end
            end
        else

            Citizen.Wait(1000)
        end
    end
end)


RegisterNetEvent("eco_collecting:startCollection")
AddEventHandler("eco_collecting:startCollection", function(id, useVehicle)

    local item = items[id]
    local params = itemData[item[1]]
    local divider = 1

    if useVehicle then

        TriggerServerEvent("eco_collecting:addCollected", id, params.respawnTime)
    else

        local ply, dst = ESX.Game.GetClosestPlayer()

        if ply == -1 or dst > 2 then

            if playerData.job.name == Config.farmerJob then divider = 3 end

            exports['mythic_progbar']:Progress({
                name = "...",
                duration = (params.harvestingTime / divider) * 1000,
                label = 'Összeszedsz ' .. params.msgSuffix .. ".",
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = params.dict,
                    anim = params.anim,
                },
                prop = {}
            }, function(status)

                if not status then

                    TriggerServerEvent("eco_collecting:addCollected", id, params.respawnTime, true)
                end
            end)
        else
            exports['mythic_notify']:SendAlert('inform', 'Ketten nem tudjátok szedni!', 7000, { ['background-color'] = '#000000', ['color'] = '#ffbb00' })
            items[id][3] = nil
        end
    end
end)

RegisterNetEvent("eco_collecting:addCollected")
AddEventHandler("eco_collecting:addCollected", function(id)

    if items and items[id] then

        items[id][3] = true
    end
end)

RegisterNetEvent("eco_collecting:respawn")
AddEventHandler("eco_collecting:respawn", function(respawn)

    for _, v in pairs(respawn) do

        if items[v] then

            items[v][3] = nil
        end
    end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


local speedAlert


function ownerCheck(p)

    if not p or type(p.owner) ~= 'table' or next(p.owner) == nil then

        return true
    end

    for i = 1, #p.owner do

        if p.owner[i] == playerData.job.name then

            return true
        end
    end

    return false
end


function isHarvesting(p)

    if p and type(p.harvestingVehicle) == 'table' then

        for i = 1, #p.harvestingVehicle do

            if p.harvestingVehicle[i] == _GetEntityModel then

                if GetEntitySpeed(_GetVehiclePedIsIn) * 3.6 > 15 then

                    if not speedAlert then

                        speedAlert = true
                        exports['mythic_notify']:SendAlert('error', 'Túl gyorsan hajtasz, így elhagyod a terményt!', 6000, { ['background-color'] = '#000000', ['color'] = '#ffbb00' })
                    end

                    return false
                else

                    speedAlert = nil
                    return true
                end
            end
        end
    end

    return false
end

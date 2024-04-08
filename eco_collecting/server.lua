local collected = {}

ESX.RegisterServerCallback("eco_collecting:serverSync", function(source, cb)
    cb(collected)
end)


RegisterServerEvent("eco_collecting:addCollected")
AddEventHandler("eco_collecting:addCollected", function(id, respawnTime, sendMsg)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = Config.items[id]
    local params = Config.itemData[item[1]]
    local amount = math.random(params.piece[1], params.piece[2])

    collected[id] = os.time() + respawnTime * 60

    TriggerClientEvent("eco_collecting:addCollected", -1, id)

    if xPlayer then

        xPlayer.addInventoryItem(params.name, amount)

        if sendMsg then

            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', length = 10000, text = "Összeszedtél " .. amount .. "db " .. params.msgSuffix })
        end
    end
end)


Citizen.CreateThread(function()

    local respawn = {}
    local time

    while true do

        Citizen.Wait(60000)

        if next(collected) ~= nil then

            time = os.time()

            for k, v in pairs(collected) do

                if v < time then

                    table.insert(respawn, k)
                    collected[k] = nil
                end
            end

            if respawn[1] then

                TriggerClientEvent("eco_collecting:respawn", -1, respawn)
                respawn = {}
            end
        end
    end
end)

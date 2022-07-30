local sharedItems = exports['qbr-core']:GetItems()

-------------------------------------------------------------------------------------------
-- Callback
-------------------------------------------------------------------------------------------

exports['qbr-core']:CreateCallback('kz-crafting:server:hasItem', function(source, cb, Recipe, base)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
    local cc = 0
    for i = 1, #Recipe do
        if Player.Functions.GetItemByName(Recipe[i].reqitem) and Player.Functions.GetItemByName(Recipe[i].reqitem).amount >= Recipe[i].count and Player.PlayerData.metadata['craftingrep'] >= base.reqcraftingrep then
            cc = cc + 1
        else
            TriggerClientEvent('QBCore:Notify', src, 9, "Vous n'avez pas les ressources / la réputation nécessaires.", 2000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
            cb(false)
            break
        end
    end
    if cc >= #Recipe then
        cb(true)
    end
end)

-------------------------------------------------------------------------------------------
-- Event
-------------------------------------------------------------------------------------------

RegisterServerEvent('kz-crafting:server:craft')
AddEventHandler('kz-crafting:server:craft', function(Recipe, craftedItem, craftedItemcount, base)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

    for n = 1, #Recipe do
        Player.Functions.RemoveItem(Recipe[n].reqitem, Recipe[n].count)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[Recipe[n].reqitem], "remove")
    end

    local newCraftingrep= Player.PlayerData.metadata['craftingrep'] + base.addcraftingrep
    if newCraftingrep <= 0 then
        newCraftingrep = 0
    end
    Player.Functions.SetMetaData('craftingrep', newCraftingrep)

    Player.Functions.AddItem(craftedItem, craftedItemcount)
    TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[craftedItem], "add")
end)

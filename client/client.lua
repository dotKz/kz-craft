-------------------------------------------------------------------------------------------
-- Local
-------------------------------------------------------------------------------------------

local sharedItems = exports['qbr-core']:GetItems()

-------------------------------------------------------------------------------------------
-- Function
-------------------------------------------------------------------------------------------

local function ClearMenu()
	exports['qbr-menu']:closeMenu()
end

local function closeMenuFull()
    ClearMenu()
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(9)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

-------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------

Menu = function(i)
    if i then
        local CraftingMenu = {
            {
                header = "<center><img src="..Config.MenuImg.." width=100%></center>",
                isMenuHeader = true
            },
        }
        for _,v in pairs(Config.Craft[i].CraftItems) do
            local text = ""
            for k, x in pairs(v.info.Recipe) do
                text = text .." - "..x.count.."x "..sharedItems[x.reqitem].label.. "<br>"
            end
            CraftingMenu[#CraftingMenu+1] = {
                header = "<img src=nui://qbr-inventory/html/images/"..sharedItems[v.info.craftedItem].image.." width=20px> ‎ ‎ "..sharedItems[v.info.craftedItem].label,
                txt = "Pour "..v.info.count.."x "..sharedItems[v.info.craftedItem].label.." vous avez besoins de <br>".. text,
                params = {
                    event = "kz-crafting:client:craft",
                    args = v,
                }
            }
        end
        CraftingMenu[#CraftingMenu+1] = {
            header = "⬅ Quitter",
            txt = "",
            params = {
            event = "kz-crafting:client:closemenu",
            }
        }
        exports['qbr-menu']:openMenu(CraftingMenu)
    end
end

-------------------------------------------------------------------------------------------
-- Event
-------------------------------------------------------------------------------------------

RegisterNetEvent("kz-crafting:client:craft")
AddEventHandler("kz-crafting:client:craft", function(v)
    exports['qbr-core']:TriggerCallback('kz-crafting:server:hasItem', function(has) 
        if has then
            exports['qbr-core']:Progressbar("craft", "Craft en cours", v.info.time, false, true, {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() end)
            Wait(v.info.time)
            TriggerServerEvent('kz-crafting:server:craft', v.info.Recipe, v.info.craftedItem, v.info.count, v.info)
            ClearPedTasks(PlayerPedId())
        end
    end, v.info.Recipe, v.info)
end)

RegisterNetEvent("kz-crafting:client:closemenu")
AddEventHandler("kz-crafting:client:closemenu", function()
    closeMenuFull()
end)

-------------------------------------------------------------------------------------------
-- Check
-------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local wait = 1250
        local pedcoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Config.Craft do   
        local dst = #(Config.Craft[i].config.coords - pedcoords)
            if dst <= 5.0 then
                if Config.Craft[i].config.job then
                    exports['qbr-core']:GetPlayerData(function(PlayerData)
                        PlayerJob = PlayerData.job
                        if PlayerJob.name == Config.Craft[i].config.job then
                            wait = 1
                            DrawText3D(Config.Craft[i].config.coords.x, Config.Craft[i].config.coords.y, Config.Craft[i].config.coords.z, "~e~[J]~q~ Craft")
                        end
                    end)
                else
                    wait = 1
                    DrawText3D(Config.Craft[i].config.coords.x, Config.Craft[i].config.coords.y, Config.Craft[i].config.coords.z, "~e~[J]~q~ Craft")
                end
            end
            if dst <= 2 and IsControlJustPressed(0, 0xF3830D8E) then
                Menu(i)
            end
        end
        Citizen.Wait(wait)
    end    
end)


-------------------------------------------------------------------------------------------
-- PED
-------------------------------------------------------------------------------------------


function SET_PED_RELATIONSHIP_GROUP_HASH ( iVar0, iParam0 )
    return Citizen.InvokeNative( 0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH( iParam0 ) )
end


function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH ( iParam0 )
    return Citizen.InvokeNative( 0x3CC4A718C258BDD0 , iParam0 );
end


function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

Citizen.CreateThread(function()
    for i = 1, #Config.Craft do
        if Config.Craft[i].config.ped.active then
            while not HasModelLoaded( GetHashKey(Config.Craft[i].config.ped.model) ) do
                Wait(500)
                modelrequest( GetHashKey(Config.Craft[i].config.ped.model) )
            end

            local npc = CreatePed(GetHashKey(Config.Craft[i].config.ped.model), Config.Craft[i].config.ped.coords, Config.Craft[i].config.ped.heading, false, false, 0, 0)
            Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
            ClearPedTasks(npc)
            RemoveAllPedWeapons(npc)
            SET_PED_RELATIONSHIP_GROUP_HASH(npc, GetHashKey(Config.Craft[i].config.ped.model))
            SetEntityCanBeDamagedByRelationshipGroup(npc, false, `PLAYER`)
            SetEntityAsMissionEntity(npc, true, true)
            SetModelAsNoLongerNeeded(GetHashKey(Config.Craft[i].config.ped.model))
            SetBlockingOfNonTemporaryEvents(npc,true)
            ClearPedTasksImmediately(npc)
            FreezeEntityPosition(npc, false)
            Wait(1000)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            TaskStandStill(npc, -1)
        end
    end 
end)

-------------------------------------------------------------------------------------------
-- Blips
-------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	for i = 1, #Config.Craft do
        if Config.Craft[i].config.blip.active then
            local blip = N_0x554d9d53f696d002(1664425300, Config.Craft[i].config.coords)
            hash = GetHashKey(Config.Craft[i].config.blip.hash)
            SetBlipSprite(blip, hash, 1)
            SetBlipScale(blip, 0.025)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Craft[i].config.blip.name)
        end
    end  
end)
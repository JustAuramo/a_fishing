ESX = exports["es_extended"]:getSharedObject()

function AttachEntityToPed(prop, bone_ID, x, y, z, RotX, RotY, RotZ)
    BoneID = GetPedBoneIndex(PlayerPedId(), bone_ID)
    obj = CreateObject(GetHashKey(prop), 1729.73, 6403.90, 34.56, true, true, true)
    vX, vY, vZ = table.unpack(GetEntityCoords(PlayerPedId()))
    xRot, yRot, zRot = table.unpack(GetEntityRotation(PlayerPedId(), 2))
    AttachEntityToEntity(obj, PlayerPedId(), BoneID, x, y, z, RotX, RotY, RotZ, false, false, false, false, 2, true)
    return obj
end

local draw = false
local rng22 = false

-- Kalastuksen Aloitus
RegisterNetEvent("a_fishing:start")
AddEventHandler(
    "a_fishing:start",
    function()
        local pedc = GetEntityCoords(PlayerPedId())
        local boat = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 5.0, 0, 12294)
        if IsEntityInWater(PlayerPedId()) or IsEntityInWater(boat) then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                if not IsPedSwimming(PlayerPedId()) then
                    draw = true
                    rng22 = true
                    lib.notify(
                        {
                            -- Ilmoitus
                            title = "Kalastus",
                            description = "Aloitit kalastamaan.",
                            showDuration = false,
                            position = "top-right",
                            style = {
                                backgroundColor = "#141517",
                                color = "#C1C2C5",
                                [".description"] = {
                                    color = "#ffff"
                                }
                            },
                            icon = "fas fa-fish",
                            iconColor = "#ffff"
                        }
                    )
                    TriggerEvent("a_fishing:rng")
                    fishing()
                else
                    lib.notify(
                        {
                            -- Ilmoitus
                            title = "Kalastus",
                            description = "Olet liian kaukana rannasta!",
                            showDuration = false,
                            position = "top-right",
                            style = {
                                backgroundColor = "#141517",
                                color = "#C1C2C5",
                                [".description"] = {
                                    color = "#ffff"
                                }
                            },
                            icon = "fas fa-fish",
                            iconColor = "#ffff"
                        }
                    )
                end
            end
        else
            lib.notify(
                {
                    -- Ilmoitus
                    title = "Kalastus",
                    description = "Et voi kalastaa tässä!",
                    showDuration = false,
                    position = "top-right",
                    style = {
                        backgroundColor = "#141517",
                        color = "#C1C2C5",
                        [".description"] = {
                            color = "#ffff"
                        }
                    },
                    icon = "fas fa-fish",
                    iconColor = "#ffff"
                }
            )
        end
    end
)

function fishing() -- Animaatio ja proppi kalastukselle
    RequestAnimDict("amb@world_human_stand_fishing@idle_a")
    while not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a") do
        Citizen.Wait(1)
    end
    rod = AttachEntityToPed("prop_fishing_rod_01", 60309, 0, 0, 0, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_b", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    textui()
end

function textui() -- Kertoo miten kalastuksen voi lopettaa
    while draw do
        w = 5
        DisableControlAction(0, 288, true) -- F1
        DisableControlAction(0, 289, true) -- F2
        lib.showTextUI(
            "[X] - Lopettaaksesi Kalastaminen",
            {
                -- TextUI Kalastuksen lopettamiselle
                position = "left-center",
                icon = "fas fa-fish",
                style = {
                    borderRadius = 5,
                    backgroundColor = "#111111",
                    color = "white"
                }
            }
        )
        if IsControlJustPressed(0, 73) then
            lib.hideTextUI() -- Sulkee TEXTUI:n
            lib.notify(
                {
                    -- Ilmoitus
                    title = "Kalastus",
                    description = "Lopetit kalastamisen.",
                    showDuration = false,
                    position = "top-right",
                    style = {
                        backgroundColor = "#141517",
                        color = "#C1C2C5",
                        [".description"] = {
                            color = "#ffff"
                        }
                    },
                    icon = "fas fa-fish",
                    iconColor = "#ffff"
                }
            )
            DeleteEntity(rod)
            DeleteObject(rod)
            rng22 = false
            TriggerEvent("a_fishing:rng")
            cancel()
            ClearPedTasks(PlayerPedId())
            break
        end
        Citizen.Wait(w)
    end
    while not draw do
        break
    end
end

AddEventHandler(
    "a_fishing:rng",
    function()
        -- Kalastamisen satunnaisuus
        while rng22 do
            Wait(math.random(13000, 32000))
            catchfish()
            ClearPedTasks(PlayerPedId())
            DeleteObject(rod)
            DeleteEntity(rod)
            break
        end
        while not rng22 do
            catchfish()
            break
        end
    end
)

function catchfish()
    if rng22 then
        local success = lib.skillCheck({"easy", {areaSize = 60, speedMultiplier = 1}}, {"e"})
        if success then
            --TriggerEvent('a_fishing:start') -- Mahdollisuus jatkaa kalastusta
            TriggerServerEvent("a_fishing:caught")
            cancel()
            Citizen.Wait(10)
            lib.hideTextUI()
        else
            rng22 = false
            cancel()
            ClearPedTasks(PlayerPedId())
            TriggerEvent("a_fishing:rng")
            lib.hideTextUI()
            lib.notify(
                {
                    -- Ilmoitus
                    title = "Kalastus",
                    description = "Kala pääsi karkuun, malttia ongen kanssa.",
                    showDuration = false,
                    position = "top-right",
                    style = {
                        backgroundColor = "#141517",
                        color = "#C1C2C5",
                        [".description"] = {
                            color = "#ffff"
                        }
                    },
                    icon = "fas fa-fish",
                    iconColor = "#ffff"
                }
            )
        end
    --end)
    end
end

function cancel() -- Tyhjentää kaikki tarvittavat
    draw = false
    DeleteObject(rod)
    DeleteEntity(rod)
    textui()
    ClearPedTasks(PlayerPedId())
end

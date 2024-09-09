ESX = exports["es_extended"]:getSharedObject()

-- Virveli Itemi jota voi käyttää
ESX.RegisterUsableItem('virveli', function(source)
	TriggerClientEvent('a_fishing:start', source)
end)

AddEventHandler('esx:playerLoaded', function(source)
    print('playerloaded')
	TriggerEvent('pkrp_license:getLicenses', source, function(licenses)
		TriggerClientEvent('a_fishing:loadLicenses', source, licenses)
	end)
end)


-- Kalan nappaus Logit
RegisterServerEvent('a_fishing:caught')
AddEventHandler('a_fishing:caught', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local RBrackets = math.random(1, #Config.fishes)
    local name = GetPlayerName(source)
    if xPlayer ~=nil then 
        for k,v in pairs(Config.fishes[RBrackets]) do 
            if v.type == 'item' then
                xPlayer.addInventoryItem(v.itemName, v.howmany)
                sendToDiscord(66666, "Kalastus", name .. " Sai kalan: " ..v.itemName.. ' x ' ..v.howmany..'.', "Kalastaminen")
            end
        end
    end
end)

-- Discord Webhook Logit
function sendToDiscord(color, name, message, footer)
  local embed = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }
  PerformHttpRequest(Config.fishwebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord2(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer,
              },
          }
      }
    PerformHttpRequest(Config.sellwebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end


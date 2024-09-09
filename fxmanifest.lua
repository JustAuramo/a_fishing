fx_version 'adamant'
lua54 'yes'
game 'gta5'

description 'a_fishing' --Modannut Auramo

version '1.0'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'config.lua'
}
shared_scripts {
    '@ox_lib/init.lua',
}
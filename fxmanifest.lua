fx_version 'cerulean'
name 'cosmo_hud'
description 'cosmo_hud for fivem, uses library from loading.io'
ui_page 'html/ui.html'
author 'CosmoKramer'
game 'gta5'

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css',
    'html/loading-bar.js',
    'html/nitrous.png',
    'html/buckle.ogg',
    'html/unbuckle.ogg',
    'html/seatBelt_off.png'
}

shared_scripts {
    '@qb-core/import.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'client/stress.lua',
    --'client/cruisecontrol.lua',
    'client/seatbelt.lua'
}

server_script 'server/server.lua'
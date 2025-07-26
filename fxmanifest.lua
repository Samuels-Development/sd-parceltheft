fx_version 'cerulean'
game 'gta5'

name "Parcel Theft"
author "Made with love by Samuel#0008"
Version "1.0.5"

client_scripts { 'client/*.lua' }

shared_scripts { '@sd_lib/init.lua', 'config.lua' }

server_scripts { 'server/main.lua', }

files { 'locales/*.json' }

lua54 'yes'

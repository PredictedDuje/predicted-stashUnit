fx_version 'cerulean'

author '!Predicted Duje#0956'
description 'predicted-stashUnit is a script used to give your players an option to buy, use, and sell their personal storage unit being 100% configurable using Config and Translation Files'
version '1.0'

game 'gta5'

shared_scripts {
   'Config/*.lua'
}

client_scripts {
  'client/**.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua'
}

dependency 'oxmysql'

lua54 'yes'
fx_version 'cerulean'
game 'gta5'

author 'SKryptz'
description 'XP | QBCore'
version '1.0.0'

dependencies {
    "/onesync",
}

server_scripts {
    "server/*.lua",
    "@oxmysql/lib/MySQL.lua",
}

client_scripts {
	"client/*.lua",
}

shared_script 'config.lua'

escrow_ignore {
    'config.lua',
    'server/sv_public',
    'client/cl_public'
}

lua54 'yes'
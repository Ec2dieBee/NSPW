AddCSLuaFile()
--别问,问就是继续抄SWT(有现成的为啥不用.jpg)

CreateConVar("savee_nspw_debugprint",0,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_debug_slowtrace",0,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_masslimit",35,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_heavygun",20,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_pickuprange",128,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_gun_headshotmult",3,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_gun_twohandrecoilpunish",3,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_gun_twohandaccpunish",3,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_mult",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_nonphysics",0,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_damage_massmarkasclub",10,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_dmgmul",0.65,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_dmgmulmin",0.2,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_dmgresistpermass",0.5,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_dmgtopropmul",0.5,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_dmgtoprop",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_advdect",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED}) --性能下降警告
CreateConVar("savee_nspw_block_advdect_range",45,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_weapondrop_on",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_block_weapondrop_massprovidepermass",7,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_delay_massmul",0.05,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_delay_massmulchildren",0.02,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_mass_nonphysics",0,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})

CreateConVar("savee_nspw_gun_aim_enabled",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_gun_aim_spreadreducemul",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_gun_aim_recoilreducemul",1,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})
CreateConVar("savee_nspw_gun_childrenmassmul",0.8,{FCVAR_ARCHIVE,FCVAR_PROTECTED,FCVAR_REPLICATED})

AddCSLuaFile()

--[[
	Prop Data Table
	数据概览

	如果有乘数和加减值,先乘后加
	对于枪械武器,&标记它可被应用到Attachment(其实就是其它Prop)上

	["武器模型路径"] = {

		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(-0.4,-0.3,-6), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(0,0,180), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 0, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 15, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 5, --伤害随机值(在伤害-偏移和伤害+偏移之间随机)
		AttackDamageType = DMG_CLUB, --伤害类型
		BlockMulAdjust = 0.15, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.8, --因格挡导致自己受伤时的伤害乘数
		BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
		BlockDefence = 0, --伤害防御加成(这个值越高能承受不导致武器被击飞的伤害越高)
		IsGun = true, --标记为枪械(在枪械HoldType下可射出子弹)
		BulletDamageType = DMG_BULLET, --子弹伤害类型
		BulletCount = 1, --子弹数量
		BulletDamage = 7, --子弹伤害
		BulletDamageOffset = 3, --子弹伤害偏移(同Offset)
		--如果子弹命中会调用这个Function
		--self: 武器本体,attacker: 攻击者(通常为owner),trace: 子弹检测射线, damageinfo: 伤害数据(可在此直接修改伤害),
		--BTrace: 子弹轨迹,Muzzleflash: 枪口火光,HitEffect: 命中特效
		--和Wiki上的BulletData一样,它在应用伤害之前调用(必须命中)
		--(https://wiki.facepunch.com/gmod/Structures/Bullet)
		--(你可以通过更改BTrace和Muzzleflash来让你的Attachment更炫)
		--注意: 若要修改BTrace,HitEffect或Muzzleflash,请以这种方式修改(以BTrace举例)
		--BTrace("GunshipTracer")
		BulletCallback = function(self,attacker,trace,damageinfo,BTrace,Muzzleflash,HitEffect)
			--Do Something
		end,
		BulletSpread = Angle(0,1,1), --第一个值没用&
		BulletSpreadMul = 1, --Attachment Only , 扩散乘数&
		ReloadSpeedMul = 1, --换弹时间乘数(这是个错误)
		ReloadSpeedAffectMul = 1, --换弹速度干预乘数(Attachment)&
		ReloadSpeedMulOffset = 0 --换弹速度乘数偏移(Attachment)&
		RecoilV = 0, --水平后座(一般不用设置)(Attachment: 偏移)&
		RecoilV_Offset = 0.3, --水平后座偏移&
		RecoilH = 0.4, --垂直后座(Attachment: 偏移)&
		RecoilH_Offset = 0.15, --垂直后座偏移&
		TrueRecoilMul = 0.2, --枪口上跳(不是ViewPunch),建议不大于1(为后座*该值)&
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul(所以别大于Mul)&
		RecoilVMul = 1, --给Attachment用的,修改后座&
		RecoilHMul = 1, --给Attachment用的,修改后座&
		ShootSound = "weapons/m4a1/m4a1-1.wav", --射击音效
		NoAim = false, --禁用瞄准(可能会被移除)
		DoubleHand = true, --双手武器(单手使用有惩罚,这玩意拿去标记步枪,霰弹枪等武器)
		AmmoType = "ar2", --子弹类型
		Magsize = 30, --弹夹容量(Attachment: 增加/减少的弹容量)
		MuzzlePos = Vector(5,0,2), --枪口位置(干预特效)
		MagOnBack = true, --使用和AUG(Famas,MA5B)一样的换弹方式
		Automatic = true, --是否为自动武器
		NextFireTime = 0.1, --下次射击的时间(Attachment: 下次射击时间的偏移)
		NoMag = true, --是否要手动装弹(霰弹枪)
		PumpAction = true, --泵动霰弹枪
		BoltAction = true, --栓动武器(实际上栓在左手边因为CSS)
		(二选一)
		InsertSound = "weapons/m3/m3_insertshell.wav", --填弹音效
		ForceHeavyWeapon = true, --大口径子弹模拟器

		BulletTrace = "idk", --子弹的轨迹(默认为普通子弹)&
		MuzzleFlash = "idk", --枪口火光(默认为普通火光)&
		HitEffect = "idk", --枪口火光(默认为普通火光)&
		--如有多个Trace/MuzzleFlash/HitEffect,随机选一个
		MuzzleFlashFL = 0 --火光Flag

		ReloadEvent_Start = function(self,owner) end, --在开始换弹(执行这个动作时)执行的func(也可为声音路径) &
		ReloadEvent_ClipOut = function(self,owner) end, --在拔出弹夹执行的func(也可为声音路径) &
		ReloadEvent_ChangeClip = function(self,owner) end, --[视野外]"取出另一个弹夹"(手离开屏幕时)时执行的func(也可为声音路径) &
		ReloadEvent_ClipIn = function(self,owner) end, --插入弹夹时执行的func(也可为声音路径) &
		ReloadEvent_LoadGun = function(self,owner) end, --上膛时执行的func(也可为声音路径) &
		ReloadEvent_End = function(self,owner) end, --换弹结束后func(也可为声音路径) &

		--全局骨骼修改乘数&
		BoneManipulates = {
			[BoneName] = {Pos = Vector(),Ang = Angle()}
		},
		--非换弹骨骼修改乘数&(仅枪械)
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Hand"] = {Ang = Angle(-30,0,90)},
			["ValveBiped.Bip01_L_Forearm"] = {Ang = Angle(3,5,0)},
			["ValveBiped.Bip01_L_Upperarm"] = {Ang = Angle(0,-3,0)},
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,0,2),Ang = Angle(0,0,2)},
		}.

	}
]]

local datatbl = {
	["models/props_canal/mattpipe.mdl"] = {
		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(-0.4,-0.3,-6), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(0,0,180), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 0, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 15, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 5, --伤害随机值
		AttackDamageType = DMG_CLUB, --伤害类型
		BlockMulAdjust = 0.15, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.8, --因格挡导致自己受伤时的伤害乘数
		--BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
	},
	["models/props_junk/harpoon002a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,0),
		OffsetAng = Angle(90,0,0), 
		AttackTimeModify = 0,
		AttackDamageModify = 15,
		AttackDamageModifyOffset = 5,
		AttackDamageType = DMG_SLASH,
	},
	["models/props_junk/shovel01a.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(-1,0,-15),
		OffsetAng = Angle(0,0,180), 
		AttackTimeModify = 0.5,
		AttackDamageModify = 24,
		AttackDamageModifyOffset = 7,
		AttackDamageType = DMG_CLUB,
	},
	["models/weapons/w_knife_t.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0,3),
		OffsetAng = Angle(0,0,0), 
		AttackTimeModify = 0,
		AttackDamageModify = 7,
		AttackDamageModifyOffset = 3,
		AttackDamageType = DMG_SLASH,
	},
	["models/props_c17/tools_wrench01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,0),
		OffsetAng = Angle(180,0,-90), 
		AttackTimeModify = 0,
		AttackDamageModify = 7,
		AttackDamageModifyOffset = 3,
		AttackDamageType = DMG_SLASH,
	},
	["models/props/cs_office/water_bottle.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0.8,-0.3,-3),
		OffsetAng = Angle(0,0,0), 
		AttackTimeModify = 0,
		AttackDamageModify = 7,
		AttackDamageModifyOffset = 3,
		AttackDamageType = DMG_SLASH,
	},
	["models/items/battery.mdl"] = {
		OffsetPos = Vector(-1,-1,5),
		AttackDamageType = DMG_ENERGYBEAM,
		RecoilVMul = 1.5,
		BulletCallback = function(self,attacker,trace,damageinfo,tr,_,he)
			damageinfo:SetDamage(damageinfo:GetDamage()+math.random(8,13))
			damageinfo:SetDamageType(bit.bor(damageinfo:GetDamage(),DMG_ENERGYBEAM))
			tr("GaussTracer")
			he("StunstickImpact")
		end,
		BulletSpreadMul = 1.65,
	},


	--CSS枪械

	["models/weapons/w_pist_elite_single.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1,0,2.5),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 15,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,1,1), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/elite/elite-1.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 15,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/elite/elite_clipout.wav",
		ReloadEvent_ClipIn = "weapons/elite/elite_rightclipin.wav",
		ReloadEvent_LoadGun = "weapons/elite/elite_sliderelease.wav",
	},
	["models/weapons/w_pist_usp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,2.5),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 11,
		BulletDamageOffset = 4,
		BulletSpread = Angle(0,0.8,0.8), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.35,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/usp/usp_unsil-1.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 12,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/usp/usp_clipout.wav",
		ReloadEvent_ClipIn = "weapons/usp/usp_clipin.wav",
		ReloadEvent_LoadGun = "weapons/usp/usp_sliderelease.wav",
	},
	["models/weapons/w_pist_deagle.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,2.3),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 30,
		BulletDamageOffset = 7,
		BulletSpread = Angle(0,1.2,1.2), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.5,
		RecoilH = 0.65,
		RecoilH_Offset = 0.25,
		TrueRecoilMul = 0.35, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/deagle/deagle-1.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 7,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/deagle/de_clipout.wav",
		ReloadEvent_ClipIn = "weapons/deagle/de_clipin.wav",
		ReloadEvent_LoadGun = "weapons/deagle/de_slideback.wav",
	},
	["models/weapons/w_pist_fiveseven.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,2),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 9,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,0.9,0.9), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.3,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.07, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/fiveseven/fiveseven-1.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 20,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/fiveseven/fiveseven_clipout.wav",
		ReloadEvent_ClipIn = "weapons/fiveseven/fiveseven_clipin.wav",
		ReloadEvent_LoadGun = "weapons/fiveseven/fiveseven_sliderelease.wav",
	},
	["models/weapons/w_pist_glock18.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,2.2),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 7,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.85,0.85), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.35,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.35, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/glock/glock18-1.wav",
		NoAim = false,
		Automatic = true,
		AmmoType = "pistol",
		Magsize = 20,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/glock/glock_clipout.wav",
		ReloadEvent_ClipIn = "weapons/glock/glock_clipin.wav",
		ReloadEvent_LoadGun = "weapons/glock/glock_sliderelease.wav",
		NextFireTime = 0.1,
	},
	["models/weapons/w_pist_p228.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,2.2),
		OffsetAng = Angle(2,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 18,
		BulletDamageOffset = 5,
		BulletSpread = Angle(0,0.95,0.95), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.45,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.25, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/p228/p228-1.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 13,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/p228/p228_clipout.wav",
		ReloadEvent_ClipIn = "weapons/p228/p228_clipin.wav",
		ReloadEvent_LoadGun = "weapons/p228/p228_sliderelease.wav",
		NextFireTime = 0.15,
	},
	["models/weapons/w_rif_m4a1.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,1.7),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 9,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,1,1), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/m4a1/m4a1_unsil-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.07,
		--ReloadEvent_Start = "weapons/m4a1/m4a1_unsil-1.wav",
		ReloadEvent_ClipOut = "weapons/m4a1/m4a1_clipout.wav",
		--ReloadEvent_ChangeClip = "weapons/m4a1/m4a1_unsil-1.wav",
		ReloadEvent_ClipIn = "weapons/m4a1/m4a1_clipin.wav",
		ReloadEvent_LoadGun = "weapons/m4a1/m4a1_boltpull.wav",
		--ReloadEvent_End = "weapons/m4a1/m4a1_unsil-1.wav",
	},
	["models/weapons/w_rif_aug.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,1.7),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 11,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1,1), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/aug/aug-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 30,
		MagOnBack = true,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.07,
		ReloadEvent_ClipOut = "weapons/aug/aug_clipout.wav",
		ReloadEvent_ClipIn = "weapons/aug/aug_clipin.wav",
		ReloadEvent_LoadGun = "weapons/aug/aug_boltpull.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,-1.5,-0.5)},
		},
	},
	["models/weapons/w_rif_galil.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 11,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1.5,1.5), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.45,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.25, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/galil/galil-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 35,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.09,
		ReloadEvent_ClipOut = "weapons/galil/galil_clipout.wav",
		ReloadEvent_ClipIn = "weapons/galil/galil_clipin.wav",
		ReloadEvent_LoadGun = "weapons/galil/galil_boltpull.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,-1.5,-0.5)},
		},
	},
	["models/weapons/w_rif_sg552.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 13,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.5,0.5), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.45,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.25, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/sg552/sg552-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.1,
		ReloadEvent_ClipOut = "weapons/sg552/sg552_clipout.wav",
		ReloadEvent_ClipIn = "weapons/sg552/sg552_clipin.wav",
		ReloadEvent_LoadGun = "weapons/sg552/sg552_boltpull.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,-1.5,-0.5)},
		},
	},
	["models/weapons/w_shot_xm1014.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 7,
		BulletDamage = 9,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,2.5,2.5), --第一个值没用
		ReloadSpeedMul = 0.85,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.8,
		RecoilH = 0.8,
		RecoilH_Offset = 0.35,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/sg552/sg552-1.wav",
		ShootSound = "weapons/xm1014/xm1014-1.wav",
		InsertSound = "weapons/xm1014/xm1014_insertshell.wav",
		NoAim = false,
		NoMag = true,
		DoubleHand = true,
		AmmoType = "buckshot",
		Magsize = 7,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.5,
	},
	["models/weapons/w_rif_famas.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,1.7),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,0.75,0.75), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.2,
		RecoilH = 0.3,
		RecoilH_Offset = 0.1,
		TrueRecoilMul = 0.1, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/famas/famas-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 25,
		MagOnBack = true,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.1,
		ReloadEvent_ClipOut = "weapons/famas/famas_clipout.wav",
		ReloadEvent_ClipIn = "weapons/famas/famas_clipin.wav",
		ReloadEvent_LoadGun = "weapons/famas/famas_forearm.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,-1.5,-0.5)},
		},
	},
	["models/weapons/w_smg_mac10.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.7,0,3),
		OffsetAng = Angle(5,0,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 6,
		BulletDamageOffset = 1,
		BulletSpread = Angle(0,1.35,1), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.2,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/mac10/mac10-1.wav",
		NoAim = false,
		AmmoType = "smg1",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.05,
		ReloadEvent_ClipOut = "weapons/mac10/mac10_clipout.wav",
		ReloadEvent_ClipIn = "weapons/mac10/mac10_clipin.wav",
		ReloadEvent_LoadGun = "weapons/mac10/mac10_boltpull.wav",
	},
	["models/weapons/w_smg_p90.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(-2,1,4.5),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 8,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1.25,1.15), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.45,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.3, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/p90/p90-1.wav",
		NoAim = false,
		AmmoType = "smg1",
		MagOnBack = true,
		Magsize = 50,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.05,
		ReloadEvent_ClipOut = "weapons/p90/p90_clipout.wav",
		ReloadEvent_ClipIn = "weapons/p90/p90_clipin.wav",
		ReloadEvent_LoadGun = "weapons/p90/p90_boltpull.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-1,-4,0.5)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(-2,-5,-2.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	["models/weapons/w_smg_tmp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(4,1,3),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 6,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1.35,1.35), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.1,
		RecoilH = 0.25,
		RecoilH_Offset = 0.1,
		TrueRecoilMul = 0.1, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/tmp/tmp-1.wav",
		NoAim = false,
		AmmoType = "smg1",
		--MagOnBack = true,
		Magsize = 25,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.06,
		ReloadEvent_ClipOut = "weapons/tmp/tmp_clipout.wav",
		ReloadEvent_ClipIn = "weapons/tmp/tmp_clipin.wav",
		--ReloadEvent_LoadGun = "weapons/p90/p90_boltpull.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-3,-5,-4)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(2,1,4)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	["models/weapons/w_snip_awp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 65,
		BulletDamageOffset = 15,
		BulletSpread = Angle(0,0.05,0.05), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.95,
		RecoilH_Offset = 0.3,
		TrueRecoilMul = 0.6, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/awp/awp1.wav",
		NoAim = false,
		AmmoType = "ar2",
		--MagOnBack = true,
		Magsize = 10,
		MuzzlePos = Vector(5,0,2),
		BoltAction = true,
		Automatic = true,
		NextFireTime = 0.5, --拉栓费点时间
		ReloadEvent_ClipOut = "weapons/awp/awp_clipout.wav",
		ReloadEvent_ClipIn = "weapons/awp/awp_clipin.wav",
		ReloadEvent_LoadGun = "weapons/awp/awp_bolt.wav",
		PumpSound = "weapons/awp/awp_bolt.wav",
		ForceHeavyWeapon = true,
		--[[BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-3,-5,-4)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(2,1,4)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},]]
	},
	["models/weapons/w_snip_scout.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 45,
		BulletDamageOffset = 15,
		BulletSpread = Angle(0,0.05,0.05), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.65,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/scout/scout_fire-1.wav",
		NoAim = false,
		AmmoType = "ar2",
		--MagOnBack = true,
		Magsize = 10,
		MuzzlePos = Vector(5,0,2),
		BoltAction = true,
		Automatic = true,
		NextFireTime = 0.2, --拉栓费点时间
		ReloadEvent_ClipOut = "weapons/scout/scout_clipout.wav",
		ReloadEvent_ClipIn = "weapons/scout/scout_clipin.wav",
		ReloadEvent_LoadGun = "weapons/scout/scout_bolt.wav",
		PumpSound = "weapons/scout/scout_bolt.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,2.5,1.2)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		--[[BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,2.5,1.2)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},]]
	},
	["models/weapons/w_snip_g3sg1.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 35,
		BulletDamageOffset = 5,
		BulletSpread = Angle(0,0.1,0.1), --第一个值没用
		ReloadSpeedMul = 1.35,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.45,
		RecoilH_Offset = 0.1,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/g3sg1/g3sg1-1.wav",
		NoAim = false,
		AmmoType = "ar2",
		--MagOnBack = true,
		Magsize = 20,
		MuzzlePos = Vector(5,0,2),
		--BoltAction = true,
		Automatic = true,
		NextFireTime = 0.2, --拉栓费点时间
		ReloadEvent_ClipOut = "weapons/g3sg1/g3sg1_clipout.wav",
		ReloadEvent_ClipIn = "weapons/g3sg1/g3sg1_clipin.wav",
		ReloadEvent_LoadGun = "weapons/g3sg1/g3sg1_slide.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1.5,2.5,1.2)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		--[[BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,2.5,1.2)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},]]
	},
	["models/weapons/w_snip_sg550.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 33,
		BulletDamageOffset = 7,
		BulletSpread = Angle(0,0.1,0.1), --第一个值没用
		ReloadSpeedMul = 1.35,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.45,
		RecoilH_Offset = 0.1,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/sg550/sg550-1.wav",
		NoAim = false,
		AmmoType = "ar2",
		--MagOnBack = true,
		Magsize = 20,
		MuzzlePos = Vector(5,0,2),
		--BoltAction = true,
		Automatic = true,
		NextFireTime = 0.2, --拉栓费点时间
		ReloadEvent_ClipOut = "weapons/sg550/sg550_clipout.wav",
		ReloadEvent_ClipIn = "weapons/sg550/sg550_clipin.wav",
		ReloadEvent_LoadGun = "weapons/sg550/sg550_boltpull.wav",
		--[[BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1.5,2.5,1.2)},
			--[0] = {Pos = Vector(0,0,0)},
		},]]
		--[[BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,2.5,1.2)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},]]
	},
	["models/weapons/w_smg_mp5.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(5,1,3.5),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 7,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.85,0.85), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.2,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/mp5navy/mp5-1.wav",
		NoAim = false,
		AmmoType = "smg1",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.07,
		ReloadEvent_ClipOut = "weapons/mp5navy/mp5_clipout.wav",
		ReloadEvent_ClipIn = "weapons/mp5navy/mp5_clipin.wav",
		ReloadEvent_LoadGun = "weapons/mp5navy/mp5_slideback.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,-3,-1.5)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(-2,-5,-2.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	["models/weapons/w_shot_m3super90.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,1.7),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 8,
		BulletDamage = 11,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,3,3), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 1,
		RecoilH = 1,
		RecoilH_Offset = 0.35,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/m3/m3-1.wav",
		PumpSound = "weapons/m3/m3_pump.wav",
		InsertSound = "weapons/m3/m3_insertshell.wav",
		PumpAction = true,
		NoAim = false,
		DoubleHand = true,
		AmmoType = "buckshot",
		Magsize = 8,
		NoMag = true,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 1,
	},
	["models/weapons/w_rif_ak47.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,1.5,1.5), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.5,
		RecoilH_Offset = 0.25,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/ak47/ak47-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.1,
		ReloadEvent_ClipOut = "weapons/ak47/ak47_clipout.wav",
		ReloadEvent_ClipIn = "weapons/ak47/ak47_clipin.wav",
		ReloadEvent_LoadGun = "weapons/ak47/ak47_boltpull.wav",
	},
	["models/weapons/w_smg_ump45.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(5,1,3),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 5,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,1,1), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.4,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/ump45/ump45-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "smg1",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.07,
		ReloadEvent_ClipOut = "weapons/ump45/ump45_clipout.wav",
		ReloadEvent_ClipIn = "weapons/ump45/ump45_clipin.wav",
		ReloadEvent_LoadGun = "weapons/ump45/ump45_boltslap.wav",
	},
	["models/weapons/w_mach_m249para.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10.3,1,3),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 5,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,2,2), --第一个值没用
		ReloadSpeedMul = 1.35,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.5,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.25, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.07, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/m249/m249-1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "smg1",
		Magsize = 100,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.05,
		ReloadEvent_ClipOut = "weapons/m249/m249_boxout.wav",
		ReloadEvent_ClipIn = "weapons/m249/m249_boxin.wav",
		ReloadEvent_LoadGun = "weapons/m249/m249_coverdown.wav",
	},

	--HL2枪械

	["models/weapons/w_pistol.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(2.5,0,-3.5),
		OffsetAng = Angle(-1,180-1.5,3),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.75,0.75), --第一个值没用
		ReloadSpeedMul = 0.5,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.2,
		RecoilH = 0.35,
		RecoilH_Offset = 0.1,
		TrueRecoilMul = 0.55, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/pistol/pistol_fire2.wav",
		NoAim = false,
		AmmoType = "pistol",
		Magsize = 18,
		MuzzlePos = Vector(0,0,4),
		--[[ReloadEvent_ClipOut = "weapons/p228/p228_clipout.wav",
		ReloadEvent_ClipIn = "weapons/p228/p228_clipin.wav",
		ReloadEvent_LoadGun = "weapons/p228/p228_sliderelease.wav",]]
		ReloadEvent_Start = "weapons/pistol/pistol_reload1.wav",
		NextFireTime = 0.1,
	},

	["models/weapons/w_smg1.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(6.5,1,-4.5),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 6,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1.65,1.65), --第一个值没用
		ReloadSpeedMul = 0.4,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.7,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/smg1/smg1_fire1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "smg1",
		Magsize = 45,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 0.07,
		--[[ReloadEvent_ClipOut = "weapons/ump45/ump45_clipout.wav",
		ReloadEvent_ClipIn = "weapons/ump45/ump45_clipin.wav",
		ReloadEvent_LoadGun = "weapons/ump45/ump45_boltslap.wav",]]
		ReloadEvent_Start = "weapons/smg1/smg1_reload.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-4,-5,-4)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(0,0,0)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(3,4,6)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	["models/weapons/w_irifle.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(13.5,1,-2.5),
		OffsetAng = Angle(-11,179.5,-3),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 13,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,0.5,0.5), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 0.7,
		RecoilH_Offset = 0.15,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/ar2/fire1.wav",
		NoAim = false,
		DoubleHand = true,
		AmmoType = "ar2",
		Magsize = 30,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		HitEffect = "AR2Impact",
		BulletTrace = "AR2Tracer",
		MuzzleFlashFL = 5,
		NextFireTime = 0.1,
		--[[ReloadEvent_ClipOut = "weapons/ump45/ump45_clipout.wav",
		ReloadEvent_ClipIn = "weapons/ump45/ump45_clipin.wav",
		ReloadEvent_LoadGun = "weapons/ump45/ump45_boltslap.wav",]]
		ReloadEvent_Start = "weapons/ar2/ar2_reload.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-2,-2,-2)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	["models/weapons/w_shotgun.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(14,1,-4),
		OffsetAng = Angle(-17,178.5,-3),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 12,
		BulletDamage = 8,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,3.5,3.5), --第一个值没用
		ReloadSpeedMul = 1,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.3,
		RecoilH = 1.5,
		RecoilH_Offset = 0.35,
		TrueRecoilMul = 0.2, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/shotgun/shotgun_dbl_fire7.wav",
		NoAim = false,
		DoubleHand = true,
		NoMag = true,
		PumpAction = true,
		PumpSound = "weapons/shotgun/shotgun_cock.wav",
		InsertSound = {
			"weapons/shotgun/shotgun_reload1.wav",
			"weapons/shotgun/shotgun_reload2.wav",
			"weapons/shotgun/shotgun_reload3.wav",
		},
		AmmoType = "buckshot",
		Magsize = 8,
		MuzzlePos = Vector(5,0,2),
		Automatic = true,
		NextFireTime = 1,
		--[[ReloadEvent_ClipOut = "weapons/ump45/ump45_clipout.wav",
		ReloadEvent_ClipIn = "weapons/ump45/ump45_clipin.wav",
		ReloadEvent_LoadGun = "weapons/ump45/ump45_boltslap.wav",]]
		--ReloadEvent_Start = "weapons/ar2/ar2_reload.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,1,0)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
	},
	--Attachment
	["models/items/combine_rifle_ammo01.mdl"] = {
		
		BulletCallback = function(self,attacker,trace,damageinfo)
			if math.random(1,100) <= 10 then
				damageinfo:SetDamage(DMG_DISSOLVE)
			end
		end,

	},
	["models/items/combine_rifle_cartridge01.mdl"] = {
		
		Magsize = 25,
		RecoilVMul = 0.95,
		ReloadSpeedMulOffset = 0.15,

	},
}

--InheritFromData(string ToPropModel, string FromPropModel,table modify)

local function InheritFromData(to,from,mod)

	local tbl = table.Copy(datatbl[from] or {})

	local key = {}

	for i,_ in pairs(mod) do

		key[i] = true

	end

	for i,data in pairs(tbl) do

		if !key[i] then

			mod[i] = data

		end

	end

	datatbl[to] = mod

end

InheritFromData("models/weapons/w_rif_m4a1_silencer.mdl","models/weapons/w_rif_m4a1.mdl",{
	BulletDamage = 8,
	BulletDamageOffset = 2,
	ShootSound = "weapons/m4a1/m4a1-1.wav",
	NextFireTime = 0.08,
})
InheritFromData("models/weapons/w_pist_usp_silencer.mdl","models/weapons/w_pist_usp.mdl",{
	OffsetPos = Vector(0.7,0,2),
	RecoilV = 0,
	RecoilV_Offset = 0.28,
	RecoilH = 0.3,
	RecoilH_Offset = 0.12,
	TrueRecoilMul = 0.12, --枪口上跳?(不是ViewPunch),建议不大于1
	TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul
	BulletSpread = Angle(0,0.7,0.7),
	BulletDamage = 10,
	ShootSound = "weapons/usp/usp1.wav",
})

--好,别忘了加客户端发服务端的"自定义数据获取请求"

local Count = 0
for _,_ in pairs(datatbl) do
	Count = Count+1
end

NSPW_DATA_PROPDATA = datatbl

print("NSPW的Prop数据现在有[原版]: "..Count)

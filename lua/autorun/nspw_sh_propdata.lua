AddCSLuaFile()

--[[
	Prop Data Table
	数据概览

	如果有乘数和加减值,先乘后加
	对于枪械武器,&标记它可被应用到Attachment(其实就是其它Prop)上

	(难蚌,枪械设置多于近战武器)
	(待办事项: 更加细分的细分模拟器的细分,Ctrl+B是倒角所以不)

	["武器模型路径"] = {

		--全局

		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(-0.4,-0.3,-6), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(0,0,180), --偏移(以Local计(虽然跟啥也没说一样))

		--近战

		AttackTimeModify = 0, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 15, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 5, --伤害随机值(在伤害-偏移和伤害+偏移之间随机)
		AttackDamageType = DMG_CLUB, --伤害类型
		BlockMulAdjust = 0.15, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.8, --因格挡导致自己受伤时的伤害乘数
		BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
		BlockDefence = 0, --伤害防御加成(这个值越高能承受不导致武器被击飞的伤害越高)
		BlockSound = "", --格挡时的音效
		MeleeHitSound = "", --进攻打到什么玩意时的音效(可为Table)
		MeleeHitEffect = "", --进攻打到什么玩意时的特效(可为Table)

		--枪械

		-->核心+其它

		IsGun = true, --标记为枪械(在枪械HoldType下可射出子弹)
		DoubleHand = true, --双手武器(单手使用有惩罚,这玩意拿去标记步枪,霰弹枪等武器)
		Automatic = true, --是否为自动武器&(哪种类型的修改最多就有哪种,e.g: 有5个强制全自动配件,5个强制半自动配件,那么看武器本体是否为全自动(这个当然也会加进去),反正就是比大小)
		NextFireTime = 0.1, --下次射击的时间(Attachment: 下次射击时间的偏移)

		(二选一)
		PumpAction = true, --泵动霰弹枪
		BoltAction = true, --栓动武器(实际上栓在左手边因为CSS)

		MuzzlePos = Vector(5,0,2), --枪口位置(干预特效)
		ForceHeavyWeapon = true, --大口径子弹模拟器

		-->子弹

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

		-->弹丸

		ProjectileClass = "crossbow_bolt", --弹丸种类,方向仍然受扩散影响
		ProjectileVelocity = 1000, --Local值
		ProjectileVelocityRotateAng = Angle(90,0,0), --旋转方向
		ProjectileAngle = Angle(0,0,0), --反Bug
		ProjectilePreCreate = function(projectile) end --生成前
		ProjectleCreated = function(projectile) end --生成后

		-->换弹

		FreeReload = false, --允许在手枪/步枪双Style下换弹(否则只能在对应Style下换弹,因为我没做)(适用于SMG1,TMP,MAC10等弹夹插在握把上的武器)
		ReloadSpeedMul = 1, --换弹速度乘数(越大越快)
		ReloadSpeedAffectMul = 1, --换弹速度干预乘数(Attachment)&
		ReloadSpeedMulOffset = 0 --换弹速度乘数偏移(Attachment)&

		-->瞄准

		NoAim = false, --禁用瞄准(可能会被移除)&
		AimOffsetPos = Vector(), --瞄准位置偏移
		AimOffsetAng = Angle(), --瞄准角度偏移
		AimUseScope = false, --使用瞄准镜瞄准(狙击枪)&
		AimMouseSensMul = 1, --瞄准时鼠标灵敏度乘数(只要你瞄准你灵敏度就会低)&
		AimFovMul = 1, --瞄准时FOV乘数(瞄准时有降低,越低FOV越小(适用于瞄准镜))&
		AimSpreadMul = 0.85, --瞄准时的扩散乘数(建议不为0)&
		AimRecoilMul = 0.85, --瞄准时的后座乘数(建议不为0)&
		ScopeType = 0, --0: 不绘制,1: 一个点,2: 十字准星(适用于狙击镜),3: 十字+点
		ScopeDotColor = Color(185,0,0,235), --默认颜色
		ScopeDotSize = 1, --红点大小
		ScopeCrossColor = Color(0,0,0,235), --默认颜色
		ScopeCrossSize = 1, --如果你想你的十字变得更炫.....
		ScopeCrossWidth = 1, --防止十字过大影响射击

		-->后座

		RecoilV = 0, --水平后座(一般不用设置)(Attachment: 偏移)&
		RecoilV_Offset = 0.3, --水平后座偏移&
		RecoilH = 0.4, --垂直后座(Attachment: 偏移)&
		RecoilH_Offset = 0.15, --垂直后座偏移&
		TrueRecoilMul = 0.2, --枪口上跳(不是ViewPunch),建议不大于1(为后座*该值)&
		TrueRecoilMul_Offset = 0.05, --这个东西修改的是Mul(所以别大于Mul)&
		RecoilVMul = 1, --给Attachment用的,修改后座&
		RecoilHMul = 1, --给Attachment用的,修改后座&

		-->弹药/弹夹

		AmmoType = "ar2", --子弹类型
		Magsize = 30, --弹夹容量(Attachment: 增加/减少的弹容量)
		MagOnBack = true, --使用和AUG(Famas,MA5B)一样的换弹方式(手枪: 使用左轮的换弹方式,不管它的弹仓是怎么工作的)
		MagOnFront = true, --使用和G11(或者十字弩)一样的换弹方式
		NoMag = true, --是否要手动装弹(霰弹枪)

		-->音效

		ShootSound = "weapons/m4a1/m4a1-1.wav", --射击音效(可为Table)
		InsertSound = "weapons/m3/m3_insertshell.wav", --填弹音效(可为Table)

		-->特效

		--如有多个Trace/MuzzleFlash/HitEffect,随机选一个

		BulletTrace = "idk", --子弹的轨迹(默认为普通子弹)&
		MuzzleFlash = "idk", --枪口火光(默认为普通火光)&
		HitEffect = "idk", --枪口火光(默认为普通火光)&
		MuzzleFlashFL = 0 --火光Flag

		-->事件/事件音效

		ReloadEvent_Start = function(self,owner) end, --在开始换弹(执行这个动作时)执行的func(也可为声音路径) &
		ReloadEvent_ClipOut = function(self,owner) end, --在拔出弹夹执行的func(也可为声音路径) &
		ReloadEvent_ChangeClip = function(self,owner) end, --[视野外]"取出另一个弹夹"(手离开屏幕时)时执行的func(也可为声音路径) &
		ReloadEvent_ClipIn = function(self,owner) end, --插入弹夹时执行的func(也可为声音路径) &
		ReloadEvent_LoadGun = function(self,owner) end, --上膛时执行的func(也可为声音路径) &
		ReloadEvent_End = function(self,owner) end, --换弹结束后func(也可为声音路径) &

		-->骨骼修改

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
		},
		--全局骨骼修改乘数&(仅单手枪械)
		BoneManipulatesPistol = {
			[BoneName] = {Pos = Vector(),Ang = Angle()}
		},
		--非换弹骨骼修改乘数&(仅单手枪械)
		BoneManipulatesAnimationPistol  = {
			["ValveBiped.Bip01_L_Hand"] = {Ang = Angle(-30,0,90)},
			["ValveBiped.Bip01_L_Forearm"] = {Ang = Angle(3,5,0)},
			["ValveBiped.Bip01_L_Upperarm"] = {Ang = Angle(0,-3,0)},
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,0,2),Ang = Angle(0,0,2)},
		},

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
	["models/weapons/w_spade.mdl"] = {
		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(0,0.5,-45), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(0,0,180), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 1, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 18, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 5, --伤害随机值
		AttackDamageType = DMG_CLUB, --伤害类型
		BlockMulAdjust = 0.25, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.7, --因格挡导致自己受伤时的伤害乘数
		--BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
	},
	["models/weapons/w_stunbaton.mdl"] = {
		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(0,-0.3,-7), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(-90,90,0), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 0.65, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 12, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 3, --伤害随机值
		AttackDamageType = DMG_SHOCK, --伤害类型
		BlockMulAdjust = 0.15, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.9, --因格挡导致自己受伤时的伤害乘数
		MeleeHitSound = {
			"weapons/stunstick/stunstick_fleshhit1.wav",
			"weapons/stunstick/stunstick_fleshhit2.wav",
			"weapons/stunstick/stunstick_impact1.wav",
			"weapons/stunstick/stunstick_impact2.wav",
		},
		MeleeHitEffect = "StunstickImpact",
		--BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
	},
	["models/weapons/w_crowbar.mdl"] = {
		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(0,0.2,-7), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(-90,-45,0), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 0, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 8, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 3, --伤害随机值
		AttackDamageType = DMG_SLASH, --伤害类型
		BlockMulAdjust = 0.15, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.9, --因格挡导致自己受伤时的伤害乘数
		--BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
		MeleeHitSound = {
			"weapons/crowbar/crowbar_impact1.wav",
			"weapons/crowbar/crowbar_impact2.wav"
		},
	},
	["models/props/cs_militia/axe.mdl"] = {
		Priority = 2, --优先级越高越优先被放到手上
		OffsetPos = Vector(0,-0.2,-8), --偏移(以Local计(虽然跟啥也没说一样))
		OffsetAng = Angle(0,0,-90), --偏移(以Local计(虽然跟啥也没说一样))
		AttackTimeModify = 0.6, --负数: 减少下次攻击所需时间,正数相反 :(
		AttackDamageModify = 32, --负数: 减少伤害,正数相反
		AttackDamageModifyOffset = 4, --伤害随机值
		AttackDamageType = DMG_SLASH, --伤害类型
		BlockMulAdjust = 0.25, --格挡伤害乘数,值越高格挡时受到的伤害越低
		BlockDamageMul = 0.8, --因格挡导致自己受伤时的伤害乘数
		--BlockDamageType = DMG_GENERIC, --因格挡而受伤时强制的伤害类型
		--[[MeleeHitSound = {
			"weapons/crowbar/crowbar_impact1.wav",
			"weapons/crowbar/crowbar_impact2.wav"
		},]]
	},
	["models/props_junk/harpoon002a.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0,-25),
		OffsetAng = Angle(90,0,0), 
		AttackTimeModify = -8.5,
		AttackDamageModify = -145,
		AttackDamageModifyOffset = -17,
		AttackDamageType = DMG_SLASH,
	},
	["models/props_junk/ibeam01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,-55),
		OffsetAng = Angle(90,0,0), 
		AttackDamageType = DMG_CLUB,
	},
	["models/props_lab/bewaredog.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(1,0,5),
		--OffsetAng = Angle(90,0,0), 
		AttackDamageType = DMG_CLUB,
	},
	["models/props_lab/desklamp01.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(5,0,-4),
		--OffsetAng = Angle(90,0,0), 
		AttackDamageType = DMG_CLUB,
	},
	["models/props_junk/ibeam01a_cluster01.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,-55),
		OffsetAng = Angle(90,0,0), 
		AttackDamageType = DMG_CLUB,
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
	["models/props_junk/meathook001a.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(3,0,-13),
		OffsetAng = Angle(0,90,180), 
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
		AttackDamageModify = 4,
		AttackDamageModifyOffset = 3,
		AttackDamageType = DMG_SLASH,
	},
	["models/props_c17/tools_pliers01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,0),
		OffsetAng = Angle(180,0,-90), 
		AttackTimeModify = 0,
		AttackDamageModify = 4,
		AttackDamageModifyOffset = 2,
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
	["models/props_interiors/furniture_lamp01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,0,-15),
		--OffsetAng = Angle(0,0,0), 
		AttackTimeModify = 0.1,
		AttackDamageModify = 4,
		AttackDamageModifyOffset = 2,
		AttackDamageType = DMG_CLUB,
	},
	["models/props_c17/chair_stool01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-0.5,10),
		--OffsetAng = Angle(0,0,0), 
		AttackTimeModify = -1,
		AttackDamageModify = -7,
		AttackDamageModifyOffset = 3,
		AttackDamageType = DMG_CLUB,
	},
	["models/props_c17/chair_office01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-0.5,10),
		--OffsetAng = Angle(0,0,0), 
		AttackTimeModify = -1.5,
		AttackDamageModify = -12,
		AttackDamageModifyOffset = 5,
		AttackDamageType = DMG_CLUB,
	},
	["models/props_c17/chair02a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(-8,-3,-5),
		--OffsetAng = Angle(0,0,0), 
		AttackTimeModify = 0,
		AttackDamageModify = 0,
		AttackDamageModifyOffset = 0,
		AttackDamageType = DMG_CLUB,
	},
	["models/props_c17/furniturechair001a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(9,-8,-15),
		--OffsetAng = Angle(0,0,0), 
		AttackTimeModify = 0,
		AttackDamageModify = 0,
		AttackDamageModifyOffset = 0,
		AttackDamageType = DMG_CLUB,
	},
	["models/props_c17/furnituretable001a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(15,-15,-8),
		--OffsetAng = Angle(0,0,0), 
	},
	["models/props_c17/furnituretable002a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(15,-27,-8),
		--OffsetAng = Angle(0,0,0), 
	},
	["models/props_c17/furnituretable003a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(13,-20,-3),
		--OffsetAng = Angle(0,0,0), 
	},
	["models/props_c17/computer01_keyboard.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-3,-7),
		OffsetAng = Angle(0,-50,90), 
	},
	["models/props_c17/metalpot002a.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0.2,-8),
		OffsetAng = Angle(90,140,0), 
		AttackTimeModify = 0.5,
		AttackDamageModify = 7,
		AttackDamageModifyOffset = 5,
		AttackDamageType = DMG_CLUB,
		MeleeHitSound = {
			"doors/vent_open3.wav",
		},
	},
	["models/props_c17/trappropeller_blade.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0,-5),
		OffsetAng = Angle(0,-75,0), 
		AttackTimeModify = -7,
		AttackDamageModify = -120,
		AttackDamageModifyOffset = 35,
		AttackDamageType = DMG_SLASH,
	},
	["models/props_trainstation/payphone_reciever001a.mdl"] = {
		OffsetPos = Vector(9,0,18),
		OffsetAng = Angle(0,180,0), 
	},
	["models/props_vehicles/carparts_muffler01a.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(9,-2,-22),
		OffsetAng = Angle(90,0,90), 
	},
	["models/props_phx/misc/fender.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(-2,-2,-13),
		OffsetAng = Angle(90,180,0), 
		AttackTimeModify = 1.2,
		AttackDamageModify = 25,
		AttackDamageModifyOffset = 5,
		AttackDamageType = DMG_CLUB,
	},
	--这玩意我一开始以为是一把刀...
	["models/props_wasteland/prison_throwswitchlever001.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0,-7),
		OffsetAng = Angle(0,180,180), 
		AttackTimeModify = -0.3,
		AttackDamageType = DMG_CLUB,
	},
	--替代扫把(大虚)
	["models/props_wasteland/tram_lever01.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(0,0,-15),
		OffsetAng = Angle(10,180,180), 
		AttackTimeModify = 0,
		AttackDamageModify = 7,
		AttackDamageModifyOffset = 5,
		AttackDamageType = DMG_CLUB,
	},
	--Wiremod Stuffs
	["models/bull/various/usb_stick.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-2,0),
		OffsetAng = Angle(-90,0,0), 
	},
	["models/cheeze/wires/wireless_card.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-2,0),
		OffsetAng = Angle(90,0,0), 
	},
	["models/fasteroid/plugs/sd_card.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-2,-5),
		OffsetAng = Angle(0,90,90), 
	},
	["models/cheeze/wires/ram.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(0,-2,0),
		OffsetAng = Angle(0,0,90), 
	},


	--CSS枪械

	["models/weapons/w_pist_elite_single.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1,0.8,2.2),
		OffsetAng = Angle(10.6,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 20,
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
		AimOffsetPos = Vector(0,0,-0.3),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_pist_usp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1,0.8,2),
		OffsetAng = Angle(10.6,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 25,
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
		OffsetPos = Vector(0.2,0.8,2.3),
		OffsetAng = Angle(10,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 70,
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
		ForceHeavyWeapon = true,
		AmmoType = "pistol",
		Magsize = 7,
		MuzzlePos = Vector(0,0,4),
		ReloadEvent_ClipOut = "weapons/deagle/de_clipout.wav",
		ReloadEvent_ClipIn = "weapons/deagle/de_clipin.wav",
		ReloadEvent_LoadGun = "weapons/deagle/de_slideback.wav",
		NextFireTime = 0.25,
		AimOffsetPos = Vector(0,0,-0.3),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_pist_fiveseven.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1.3,0.8,2),
		OffsetAng = Angle(10.6,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 3,
		BulletDamage = 22,
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
		AimOffsetPos = Vector(0,0,0.2),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_pist_glock18.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1,0.8,2.2),
		OffsetAng = Angle(10.6,0,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 18,
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
		AimOffsetPos = Vector(0,0,0.1),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_pist_p228.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.8,0.8,2.2),
		OffsetAng = Angle(10.6,0,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 30,
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
		OffsetAng = Angle(11,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 30,
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
		AimOffsetPos = Vector(0,0,-3.4),
		AimOffsetAng = Angle(),
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,-1.3,-0.5)},
		},
	},
	["models/weapons/w_rif_aug.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,1.7),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 35,
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
		NextFireTime = 0.12,
		ReloadEvent_ClipOut = "weapons/aug/aug_clipout.wav",
		ReloadEvent_ClipIn = "weapons/aug/aug_clipin.wav",
		ReloadEvent_LoadGun = "weapons/aug/aug_boltpull.wav",
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,-1.5,-0.5)},
		},
		AimUseScope = true,
		AimOffsetPos = Vector(0,0,-3.4),
		AimOffsetAng = Angle(),
		AimFovMul = 0.9
	},
	["models/weapons/w_rif_galil.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-1),
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
		AimOffsetPos = Vector(0,0,-2.2),
		AimOffsetAng = Angle(),
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
		AimUseScope = true,
		AimOffsetPos = Vector(0,0,-3),
		AimOffsetAng = Angle(),
		AimFovMul = 0.9
	},
	["models/weapons/w_shot_xm1014.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,2),
		OffsetAng = Angle(11,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 7,
		BulletDamage = 9,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,2.5,2.5), --第一个值没用
		ReloadSpeedMul = 1.25,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.8,
		RecoilH = 0.8,
		RecoilH_Offset = 0.35,
		TrueRecoilMul = 0.4, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
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
		AimOffsetPos = Vector(0,0,-1),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_rif_famas.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,1.7),
		OffsetAng = Angle(11,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 22,
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
		AimOffsetPos = Vector(0,0,-4.5),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_smg_mac10.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(0.3,0.8,3),
		OffsetAng = Angle(13.6,-0.8,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		FreeReload = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 7,
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
		DoubleHand = true,
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
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-3,-5,-4)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(3,1,4)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		AimOffsetPos = Vector(0,0,-4),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_smg_p90.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(-2,1,4.5),
		OffsetAng = Angle(11,-1.6,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		DoubleHand = true,
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
		AimOffsetPos = Vector(0,0,-5),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_smg_tmp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(4,0.5,3),
		OffsetAng = Angle(11,-2.5,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		FreeReload = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 7,
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
		DoubleHand = true,
		--MagOnBack = true,
		Magsize = 25,
		MuzzlePos = Vector(2,0,3.5),
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
		AimOffsetPos = Vector(2,0,-3.2),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_snip_awp.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 125,
		BulletDamageOffset = 5,
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
		DoubleHand = true,
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
		AimOffsetPos = Vector(0,0,-3.2),
		AimOffsetAng = Angle(),
		AimUseScope = true,
		AimMouseSensMul = 0.2,
		AimFovMul = 0.2,
		AimSpreadMul = 0.1,
		ScopeType = 2,
	},
	["models/weapons/w_snip_scout.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(11,1,2),
		OffsetAng = Angle(11,-0.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 65,
		BulletDamageOffset = 7,
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
		DoubleHand = true,
		NextFireTime = 0.2, --拉栓费点时间
		ReloadEvent_ClipOut = "weapons/scout/scout_clipout.wav",
		ReloadEvent_ClipIn = "weapons/scout/scout_clipin.wav",
		ReloadEvent_LoadGun = "weapons/scout/scout_bolt.wav",
		PumpSound = "weapons/scout/scout_bolt.wav",
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,2.5,1.2)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		AimOffsetPos = Vector(0,0,-3.2),
		AimOffsetAng = Angle(),
		AimUseScope = true,
		AimMouseSensMul = 0.35,
		AimFovMul = 0.3,
		AimSpreadMul = 0.05,
		ScopeType = 2,
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
		BulletDamage = 45,
		BulletDamageOffset = 5,
		BulletSpread = Angle(0,0.1,0.1), --第一个值没用
		ReloadSpeedMul = 0.65,
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
		DoubleHand = true,
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
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,-2,-1.6)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(0,-2,-2)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		AimOffsetPos = Vector(0,0,-3.2),
		AimOffsetAng = Angle(),
		AimUseScope = true,
		AimMouseSensMul = 0.4,
		AimFovMul = 0.4,
		AimSpreadMul = 0.1,
		ScopeType = 2,
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
		BulletDamage = 40,
		BulletDamageOffset = 7,
		BulletSpread = Angle(0,0.1,0.1), --第一个值没用
		ReloadSpeedMul = 0.65,
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
		DoubleHand = true,
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
		AimOffsetPos = Vector(0,0,-3.2),
		AimOffsetAng = Angle(),
		AimUseScope = true,
		AimMouseSensMul = 0.4,
		AimFovMul = 0.4,
		AimSpreadMul = 0.1,
		ScopeType = 2,
	},
	["models/weapons/w_smg_mp5.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(5,0.3,3.5),
		OffsetAng = Angle(11,-1,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		DoubleHand = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 9,
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
		AimOffsetPos = Vector(2,0.1,-2.8),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_shot_m3super90.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,1,1.7),
		OffsetAng = Angle(11,-1.5,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 8,
		BulletDamage = 15,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,2.5,2.5), --第一个值没用
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
		AimOffsetPos = Vector(3,0.3,-1.5),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_rif_ak47.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10,0.6,2),
		OffsetAng = Angle(11,-1.2,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 28,
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
		AimOffsetPos = Vector(0,0,-2),
		AimOffsetAng = Angle(),
		
	},
	["models/weapons/w_smg_ump45.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(5,0.8,3),
		OffsetAng = Angle(11,-1.2,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
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
		AimOffsetPos = Vector(2,-0.1,-2.7),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_mach_m249para.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(10.3,0.8,3),
		OffsetAng = Angle(11,-1.5,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 12,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,1.25,1.35), --第一个值没用
		ReloadSpeedMul = 0.65,
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
		MuzzlePos = Vector(6,-0.5,3.5),
		Automatic = true,
		NextFireTime = 0.05,
		ReloadEvent_ClipOut = "weapons/m249/m249_boxout.wav",
		ReloadEvent_ClipIn = "weapons/m249/m249_boxin.wav",
		ReloadEvent_LoadGun = "weapons/m249/m249_coverdown.wav",
		AimOffsetPos = Vector(5,0,-2.2),
		AimOffsetAng = Angle(),
		AimMouseSensMul = 0.9,
		AimFovMul = 0.95,
	},

	--HL2枪械

	["models/weapons/w_pistol.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(2.5,0.3,-3.5),
		OffsetAng = Angle(-9.8,180+1.2,5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.75,0.75), --第一个值没用
		ReloadSpeedMul = 2,
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
		AimOffsetPos = Vector(0,0,0.2),
		AimOffsetAng = Angle(),
	},

	["models/weapons/w_smg1.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(6.5,1.5,-4.5),
		OffsetAng = Angle(11,0.2,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		FreeReload = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 12,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,1.65,1.65), --第一个值没用
		ReloadSpeedMul = 1.6,
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
		AimOffsetPos = Vector(0,0,-3.1),
	},
	["models/weapons/w_irifle.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(13.5,1,-2.5),
		OffsetAng = Angle(-11,178.5,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 38,
		BulletDamageOffset = 5,
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
		AimOffsetPos = Vector(2,0.4,-3.2),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_shotgun.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(14,0.8,-4),
		OffsetAng = Angle(-17,177.5,-5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BUCKSHOT,
		BulletCount = 12,
		BulletDamage = 10,
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
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-0.3,3,1.4)},
			--["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(2,1,0.5)},
			--[0] = {Pos = Vector(0,0,0)},
		},
		AimOffsetPos = Vector(5,0.1,-2.2),
		AimOffsetAng = Angle(),
	},
	["models/weapons/w_357.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(-2,1,-2),
		OffsetAng = Angle(6,-0.8,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 65,
		BulletDamageOffset = 10,
		BulletSpread = Angle(0,0.25,0.25), --第一个值没用
		ReloadSpeedMul = 0.8,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 3.55,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.45, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.2, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/357/357_fire3.wav",
		NoAim = false,
		AmmoType = "357",
		--ForceHeavyWeapon = true,
		Magsize = 6,
		MuzzlePos = Vector(0,0,4),
		MagOnBack = true,
		ForceHeavyWeapon = true,
		ReloadEvent_ClipOut = "weapons/357/357_reload1.wav",
		ReloadEvent_ClipIn = "weapons/357/357_reload3.wav",
		ReloadEvent_LoadGun = "weapons/357/357_spin1.wav",
		ReloadEvent_Start = "weapons/357/357_reload4.wav",
		NextFireTime = 0.5,
		AimOffsetPos = Vector(0,0,-1),
	},
	["models/weapons/w_alyx_gun.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(1.5,-0.1,-4.5),
		OffsetAng = Angle(-15,-169.3,12),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 12,
		BulletDamageOffset = 3,
		BulletSpread = Angle(0,0.45,0.45), --第一个值没用
		ReloadSpeedMul = 1.3,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.55,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = {
			--"weapons/alyx_gun/alyx_gun_fire3.wav",
			--"weapons/alyx_gun/alyx_gun_fire4.wav",
			"weapons/alyx_gun/alyx_gun_fire5.wav",
			"weapons/alyx_gun/alyx_gun_fire6.wav",
		},
		NoAim = false,
		AmmoType = "357",
		--ForceHeavyWeapon = true,
		Magsize = 25,
		MuzzlePos = Vector(0,0,4),
		--MagOnBack = true,
		--ForceHeavyWeapon = true,
		ReloadEvent_Start = "weapons/pistol/pistol_reload1.wav",
		NextFireTime = 0.1,
		Automatic = true,
		AimOffsetPos = Vector(0,0,0),
	},
	["models/weapons/w_crossbow.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(-4,2.8,-0.2),
		OffsetAng = Angle(10,-2,-1),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		DoubleHand = true,
		BulletCount = 1,
		ProjectileClass = "crossbow_bolt",
		ProjectileVelocity = 2500, --Local值
		ProjectileAngle = Angle(0,0,0), --反Bug
		ProjectilePreCreate = function(proj)

			--proj:SetCollisionGroup(COLLISION_GROUP_NONE)

			--proj:AddCallback("BuildFlexWeights", function(proj)
			
			--print(proj)
			local ctrl = ents.Create("base_point")
			ctrl:SetPos(proj:GetPos())
			ctrl:SetParent(proj)
			proj:DeleteOnRemove(ctrl)
			ctrl:NextThink(CurTime() + .01)

			function ctrl:Think(spawnthink)

				--print(1)
				if !spawnthink and proj:GetMoveType() == MOVETYPE_NONE then
					self:Remove()
					--print("REM")
					return 
				end


				local tr = util.TraceLine({
					start = proj:GetPos(),
					endpos = proj:GetPos() + (proj:GetAngles():Forward()) * 35,
					mask = MASK_SHOT,
					filter = function(e)
						if e == proj or e == self or (spawnthink and e == proj:GetOwner()) then return false end
						local res = hook.Run("ShouldCollide", proj, e)
						if res == nil then res = true end
						--print(e,res)
						return res
					end,
				})

				self:NextThink(CurTime() + .01)
				if !IsValid(tr.Entity) then return true end

				local dinfo = DamageInfo()
				dinfo:SetDamageType(DMG_SLASH)
				dinfo:SetDamage(100)
				dinfo:SetAttacker(proj:GetOwner())
				tr.Entity:TakeDamageInfo(dinfo)
				--self:Remove()
				return true

			end

			ctrl:Spawn()

			ctrl:Think(true)
			
			--end)

		end,
		BulletSpread = Angle(0,0.1,0.1), --第一个值没用
		ReloadSpeedMul = 1.3,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.55,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/crossbow/fire1.wav",
		NoAim = false,
		AmmoType = "XBowBolt",
		AimUseScope = true,
		AimFovMul = 0.2,
		AimMouseSensMul = 0.2,
		--ForceHeavyWeapon = true,
		Magsize = 1,
		MuzzlePos = Vector(0,0,4),
		MagOnFront = true,
		ForceHeavyWeapon = true,
		ReloadEvent_Start = "weapons/crossbow/reload1.wav",
		ReloadEvent_ClipIn = {"weapons/crossbow/bolt_load1.wav","weapons/crossbow/bolt_load2.wav"},
		NextFireTime = 0.1,
		Automatic = true,
		AimOffsetPos = Vector(0,0,-4),
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(1,0,0),Ang = Angle(0,0,2)},
		},
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-2.3,-3,0),Ang = Angle(0,0,2)},
		},
	},
	["models/weapons/w_rocket_launcher.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(12,1.2,-2.5),
		OffsetAng = Angle(-10.7,179.5,5),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		DoubleHand = true,
		BulletCount = 1,
		ProjectileClass = "rpg_missile",
		ProjectileVelocity = 0, --Local值
		ProjectileVelocityRotateAng = Angle(0,0,0),
		ProjectileAngle = Angle(0,0,0), --反Bug
		ProjectileCreated = function(proj)

			--proj:SetCollisionGroup(COLLISION_GROUP_NONE)

			--proj:AddCallback("BuildFlexWeights", function(proj)
			
			--print(proj)

			local donttargetowner = true

			proj:SetVelocity(Vector(0,0,70))
			local ctrl = ents.Create("base_point")
			ctrl:SetPos(proj:GetPos())
			ctrl:SetParent(proj)
			proj:DeleteOnRemove(ctrl)


			function ctrl:Think()

				local tr = util.TraceLine({
					start = proj:GetPos(),
					endpos = proj:GetPos() + (proj:GetAngles():Forward()) * 25,
					mask = MASK_SHOT,
					filter = function(e)
						if e == proj or e == self or (e == proj:GetOwner()) then return false end
						local res = hook.Run("ShouldCollide", proj, e)
						if res == nil then res = true end
						--print(e,res)
						return res
					end,
				})

				self:NextThink(CurTime() + .01)
				if !tr.Hit then return true end

				--print("HIT")
				if !IsValid(proj) then return end
				local pos, owner = proj:GetPos(), proj:GetOwner()
				--print(owner)
				util.BlastDamage(
				proj, 
				IsValid(owner) and owner or proj, 
				pos, 512, math.random(85,130))
				self:Remove()
				return true

			end

			ctrl:Spawn()

			
			--[[timer.Simple(0.5,function()
				--print("1")
				if !IsValid(ctrl) then return end

				donttargetowner = false
			
			end)]]

		end,
		BulletSpread = Angle(0,0,0), --第一个值没用
		ReloadSpeedMul = 1.3,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 0.4,
		RecoilH = 0.55,
		RecoilH_Offset = 0.2,
		TrueRecoilMul = 0.15, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = "weapons/rpg/rocketfire1.wav",
		NoAim = false,
		AmmoType = "RPG_Round",
		--ForceHeavyWeapon = true,
		Magsize = 1,
		MuzzlePos = Vector(0,0,4),
		MagOnFront = true,
		ForceHeavyWeapon = true,
		--ReloadEvent_Start = "weapons/crossbow/reload1.wav",
		--ReloadEvent_ClipIn = {"weapons/crossbow/bolt_load1.wav","weapons/crossbow/bolt_load2.wav"},
		NextFireTime = 0.1,
		Automatic = true,
		AimOffsetPos = Vector(0,0,-4),
		--[[BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(2,0,0),Ang = Angle(0,0,2)},
		},]]
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-1.3,-7,-2),Ang = Angle(0,0,2)},
		},
	},
	--Joke Weapons
	["models/weapons/w_toolgun.mdl"] = {
		Priority = 3,
		OffsetPos = Vector(-2.5,0.6,-1.5),
		OffsetAng = Angle(10,-0.5,-2),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,0.05,0.05), --第一个值没用
		ReloadSpeedMul = 1,
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
		MagOnBack = true,
		--[[ReloadEvent_ClipOut = "weapons/p228/p228_clipout.wav",
		ReloadEvent_ClipIn = "weapons/p228/p228_clipin.wav",
		ReloadEvent_LoadGun = "weapons/p228/p228_sliderelease.wav",]]
		ReloadEvent_Start = "weapons/pistol/pistol_reload1.wav",
		NextFireTime = 0.1,
	},
	["models/combine_turrets/ground_turret.mdl"] = {
		Priority = 2,
		OffsetPos = Vector(16,-9,15),
		OffsetAng = Angle(172,179.5,0),
		AttackDamageType = DMG_CLUB,
		IsGun = true,
		BulletDamageType = DMG_BULLET,
		BulletCount = 1,
		BulletDamage = 10,
		BulletDamageOffset = 2,
		BulletSpread = Angle(0,3,3), --第一个值没用
		ReloadSpeedMul = 0.5,
		ReloadSpeedAffectMul = 1,
		RecoilV = 0,
		RecoilV_Offset = 1.35,
		RecoilH = 1.75,
		RecoilH_Offset = 0.65,
		TrueRecoilMul = 0.55, --枪口上跳?(不是ViewPunch),建议不大于1
		TrueRecoilMul_Offset = 0.1, --这个东西修改的是Mul
		--RecoilVMul = 1, --给Attachment用的
		--RecoilHMul = 1, --给Attachment用的
		ShootSound = {
			"npc/turret_floor/shoot1.wav",
			"npc/turret_floor/shoot2.wav",
			"npc/turret_floor/shoot3.wav",
		},
		NoAim = true,
		AmmoType = "ar2",
		Magsize = 200,
		MuzzlePos = Vector(25,0,-17),
		MagOnBack = true,
		DoubleHand = true,
		FreeReload = true,
		Automatic = true,
		BulletTrace = "HunterTracer",
		--[[ReloadEvent_ClipOut = "weapons/p228/p228_clipout.wav",
		ReloadEvent_ClipIn = "weapons/p228/p228_clipin.wav",
		ReloadEvent_LoadGun = "weapons/p228/p228_sliderelease.wav",]]
		--ReloadEvent_Start = "weapons/pistol/pistol_reload1.wav",
		NextFireTime = 0.06,
		BoneManipulates = {
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(-1,-5,5.5),Ang = Angle(0,0,0)},
			["ValveBiped.Bip01_R_Clavicle"] = {Pos = Vector(0,0,-1),Ang = Angle(0,0,0)},
		},
		ForceHeavyWeapon = true,
		MuzzleFlashFL = 5,
	},
	--Attachment
	["models/items/combine_rifle_ammo01.mdl"] = {
		
		BulletCallback = function(self,attacker,trace,damageinfo)
			if math.random(1,100) <= 10 then
				damageinfo:SetDamage(DMG_DISSOLVE)
			end
		end,

	},
	["models/items/battery.mdl"] = {
		OffsetPos = Vector(-1,-1,5),
		AttackDamageType = DMG_ENERGYBEAM,
		RecoilVMul = 1.5,
		BulletCallback = function(self,attacker,trace,damageinfo,tr,_,he)
			damageinfo:SetDamage(damageinfo:GetDamage()+math.random(8,13))
			damageinfo:SetDamageType(bit.bor(damageinfo:GetDamageType(),DMG_ENERGYBEAM))
			tr("GaussTracer")
			he("StunstickImpact")
		end,
		BulletSpreadMul = 1.65,
		NextFireTime = -0.05,
	},
	["models/props_junk/gascan001a.mdl"] = {
		OffsetPos = Vector(15,-1.5,-2),
		OffsetAng = Angle(180,90,90),
		AttackDamageType = DMG_CLUB,
		RecoilVMul = 2,
		BulletCallback = function(self,attacker,trace,damageinfo,tr,_,he)
			damageinfo:SetDamageType(bit.bor(damageinfo:GetDamageType(),DMG_BURN))
		end,
		BulletSpreadMul = 2,
		NextFireTime = 0.1,
	},
	["models/items/car_battery01.mdl"] = {
		
		BulletTrace = "HunterTracer",
		BulletCallback = function(self,attacker,trace,damageinfo,tr)
			damageinfo:SetDamageType(bit.bor(damageinfo:GetDamageType(),DMG_SHOCK))
			damageinfo:SetDamage(damageinfo:GetDamage()+math.random(1,3))
			--tr("HunterTracer")
		end,
		BulletSpreadMul = 0.55,
		ReloadSpeedMulOffset = 0.3,
		NextFireTime = -0.03,

	},
	["models/props_combine/combinethumper002.mdl"] = {
		
		BulletTrace = "HunterTracer",
		BulletCallback = function(self,attacker,trace,damageinfo,tr)
			damageinfo:SetDamageType(bit.bor(damageinfo:GetDamageType(),DMG_ENERGYBEAM))
			damageinfo:SetDamage(damageinfo:GetDamage()+math.random(17,30))
			--tr("HunterTracer")
		end,
		BulletSpreadMul = 0.35,
		ReloadSpeedMulOffset = 0.5,
		NextFireTime = 0.6,
		RecoilV_Offset = 0.3, --水平后座偏移&
		RecoilH = 0.5, --垂直后座(Attachment: 偏移)&
		RecoilH_Offset = 0.35, --垂直后座偏移&
		Magsize = -10,

	},
	["models/items/combine_rifle_cartridge01.mdl"] = {
		
		Magsize = 7,
		RecoilVMul = 0.95,
		RecoilHMul = 1.15,
		ReloadSpeedMulOffset = 0.15,

	},
	["models/items/boxsrounds.mdl"] = {
		
		Magsize = 5,
		RecoilVMul = 0.85,
		ReloadSpeedMulOffset = 0.1,
		--Automatic = true,
		NextFireTime = 0.02,

	},
	["models/items/boxmrounds.mdl"] = {
		
		Magsize = 15,
		RecoilVMul = 0.55,
		ReloadSpeedMulOffset = 0.3,
		Automatic = true,
		NextFireTime = 0.04,

	},
	["models/items/boxbuckshot.mdl"] = {
		
		Magsize = 2,
		BulletSpreadMul = 2,
		BulletCount = 3,
		NextFireTime = 0.15,

	},
	--射出额外弹丸,请
	["models/items/crossbowrounds.mdl"] = {
		
		OffsetPos = Vector(0,0,-5),
		OffsetAng = Angle(90,0,0),
		AttackDamageType = DMG_SLASH,

	},
	["models/props_c17/utilityconnecter006.mdl"] = { --玩高压电线玩的
		
		OffsetPos = Vector(0,0,-5),
		OffsetAng = Angle(0,0,90),
		AttackDamageType = DMG_SHOCK,
		BulletTrace = "LaserTracer",
		BulletCallback = function(self,attacker,trace,damageinfo,tr)
			if math.random(1,100) <= 45 then 
				damageinfo:SetDamageType(DMG_SHOCK)
				damageinfo:SetDamage(damageinfo:GetDamage()+math.random(1,3))
			end
		end,

	},
	--你家装煤气的现在拿煤气罐子轮你了,喜欢吗
	["models/props_explosive/explosive_butane_can.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(31,-5,0),
		OffsetAng = Angle(0,90,90), 
		AttackDamageType = DMG_CLUB,
		BulletCallback = function(self,attacker,trace,damageinfo,tr)
			
			if math.random(1,100) <= 15 then 
				damageinfo:SetDamageType(DMG_SLOWBURN)
				damageinfo:SetDamage(damageinfo:GetDamage()-math.random(5,13))
			end
		end,
	},
	--别问,问就是我定睛一看当场下了这玩意容量比上面那玩意大的定义
	["models/props_explosive/explosive_butane_can02.mdl"] = {
		Priority = 1,
		OffsetPos = Vector(40,-5,0),
		OffsetAng = Angle(45,90,90), 
		AttackDamageType = DMG_CLUB,
		BulletCallback = function(self,attacker,trace,damageinfo,tr)
			if math.random(1,100) <= 35 then 
				damageinfo:SetDamageType(bit.bor(damageinfo:GetDamageType(),DMG_BURN))
				damageinfo:SetDamage(damageinfo:GetDamage()-math.random(3,9))
			end
		end,
	},
}

--InheritFromData(string ToPropModel, string FromPropModel,table modify)

local function InheritFromData(from,to,mod)

	if !mod then mod = {} end

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

InheritFromData("models/weapons/w_rif_m4a1.mdl","models/weapons/w_rif_m4a1_silencer.mdl",{
	BulletDamage = 8,
	BulletDamageOffset = 2,
	ShootSound = "weapons/m4a1/m4a1-1.wav",
	NextFireTime = 0.08,
})
InheritFromData("models/weapons/w_pist_usp.mdl","models/weapons/w_pist_usp_silencer.mdl",{
	OffsetPos = Vector(1,0.8,2),
		--OffsetAng = Angle(10.6,-0.5,-2),,
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

InheritFromData("models/props_junk/gascan001a.mdl","models/props_junk/metalgascan.mdl")
InheritFromData("models/props/cs_militia/axe.mdl","models/props_forest/axe.mdl")

--好,别忘了加客户端发服务端的"自定义数据获取请求"

local Count = 0
for _,_ in pairs(datatbl) do
	Count = Count+1
end

local MetaTable = {}
function datatbl:__index(key)

	if isentity(key) and IsValid(key) and key.NSPW_PROP_DISABLEPROPERTIES then
		--print("因数据被强制取消而返还空")
		return {}
	end

	if isentity(key) and IsValid(key) and key.NSPW_PROP_PROPDATA then
		--print("进程: 实体有特技")

		if key.NSPW_PROP_PROPDATA_FORCEOVERRIDE then
			--print("->返还了实体本身的表")
			return key.NSPW_PROP_PROPDATA
		else

			local tbl = table.Copy(key.NSPW_PROP_PROPDATA)

			local keys = {}

			for i,_ in pairs(tbl) do

				keys[i] = true

			end

			--print(isentity(key) and IsValid(key) and key.NSPW_PROP_PROPDATA)

			for i,data in pairs(datatbl[key:GetModel()] or {}) do

				if !keys[i] then

					tbl[i] = data

				end

			end
			--print("-> 返还了普通的表")

			return tbl
		end

	else
		if isentity(key) and !IsValid(key) then return {} end
		local tbl = datatbl[isentity(key) and string.lower(key:GetModel() or "") or (string.lower(key or ""))]
		if !istable(tbl) then 
			--print("这是一坨被加工的屎,其中这坨屎是",IsValid(key))
			tbl = {} 
		end
		--print("这是一坨屎")
		return tbl
	end

end

setmetatable(MetaTable,datatbl)

NSPW_DATA_PROPDATA = MetaTable
--[[NSPW_DATA_PROPDATA = function(key)

	if isentity(key) and !IsValid(key) then return {} end

	if isentity(key) and IsValid(key) and key.NSPW_PROP_DISABLEPROPERTIES then
		--print("因数据被强制取消而返还空")
		return {}
	end

	if isentity(key) and IsValid(key) and key.NSPW_PROP_PROPDATA then
		--print("进程: 实体有特技")

		if key.NSPW_PROP_PROPDATA_FORCEOVERRIDE then
			--print("->返还了实体本身的表")
			return key.NSPW_PROP_PROPDATA
		else

			local tbl = table.Copy(key.NSPW_PROP_PROPDATA)

			local keys = {}

			for i,_ in pairs(tbl) do

				keys[i] = true

			end

			--print(isentity(key) and IsValid(key) and key.NSPW_PROP_PROPDATA)

			for i,data in pairs(datatbl[key:GetModel()] or {}) do

				if !keys[i] then

					tbl[i] = data

				end

			end
			--print("-> 返还了普通的表")

			return tbl
		end

	else
		local tbl = datatbl[isentity(key) and string.lower(key:GetModel() or "") or (string.lower(key or ""))]
		if !istable(tbl) then 
			--print("这是一坨被加工的屎,其中这坨屎是",IsValid(key))
			tbl = {} 
		end
		--print("这是一坨屎")
		return tbl
	end
end]]
_NSPW_DATA_PROPDATA = datatbl

print("NSPW的Prop数据现在有[原版]: "..Count)

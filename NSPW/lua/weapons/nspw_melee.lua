--[[

	好的,所以我想到一个很新的计算方法
	我们可以在服务端设立一个NWString之类的东西
	然后把Prop(Dupe)数据一股脑都存进去,最后强奸一遍客户端,这样数据就发上去了
	(以及我们可能需要客户端支持,读取客户端针对特定Prop的支持..??????)
	我相信INVSYS能让你知道Wut 2 do next lol

	好好好,任务已经完成了,雷普了一遍NWVar然后把整个实体存进去了
	(别是Cycle格式)

	我宣布这玩意现在是melee和gun(2023/10/2)

]]

AddCSLuaFile()

local TestTbl = 
{
	"melee",
	"melee2",
	"knife",
	"slam",
	"fists",
	"normal",
}

local SomeSBStuffs = "Wrong HoldType >:)"

--汉化,请
--确保这些东西在客户端被直接引用的时候是不影响主功能的
--(反 作 弊)
local Style = {
	["melee"] = {
		Name = "One-Handed",
		Desc = "Hold your weapon in your right hand \n Classic!",
		Goods = "Classic",
		Bads = "Classic...",
		AttackStart = 0.05,
		AttackEnd = 0.15,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_melee.mdl",
	},
	["melee2"] = {
		Name = "Double-Handed",
		Desc = "Hold your weapon with both of your hand \n Just like swing an axe!",
		Goods = "Less swing cooldown time",
		Bads = "Shorter attack distance \n (Still one-handed in viewmodel)",
		SwingTimeMod = 0.3,
		AttackStart = 0.1,
		AttackEnd = 0.35,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_melee2.mdl",
	},
	["knife"] = {
		Name = "Knife",
		Desc = "Hold your weapon like CS:S",
		Goods = "Longer attack distance",
		Bads = "[机翻]检测时间更少 \n (Also no proper viewmodel lol)",
		AttackStart = 0.05,
		AttackEnd = 0.15,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_knife.mdl",
	},
	["slam"] = {
		Name = "Hold",
		Desc = "Hold your weapon",
		Goods = "Always blocking \n (good for shields)",
		Bads = "You can't attack",
		NoAttack = true,
		AlwaysBlock = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		InvertDWHL = true,
		VM = "models/weapons/c_yhg_un_itemanim.mdl",
	},
	--[[["fist"] = {
		Name = "Fists",
		Desc = "Hold your weapon,and use your fists to attack",
		Goods = "Good for boxing",
		Bads = "You can only use your right hand,for NO reason lol",
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		VM = "models/weapons/c_arms.mdl",
	},]]
	--[[["fist"] = {
		Name = "Fists",
		Desc = "Hold your weapon,and use your fists to attack",
		Goods = "Good for boxing",
		Bads = "You can only use your right hand,for NO reason lol",
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		VM = "models/weapons/c_arms.mdl",
	},]]
	--[[["fist"] = {
		Name = "Hold2",
		Desc = "Hold your weapon",
		Goods = "Always blocking \n (good for shields)",
		Bads = "You can't attack",
		NoAttack = true,
		AlwaysBlock = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		InvertDWHL = true,
		VM = "models/weapons/c_yhg_un_itemanim.mdl",
	},]]
	["normal"] = {
		Name = "Do nothing",
		Desc = "Lay down your hand",
		Goods = "Make you look less hostile \n (Good for RP)",
		Bads = "You can't do anything",
		DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		HolsterPrevVM = true,
	},
	["passive"] = {
		Name = "Do nothing(gun)",
		Desc = "Lay down your gun",
		Goods = "Looks cool \n (Good for RP)",
		Bads = "You can't do anything",
		DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		HolsterPrevVM = true,
	},
	["pistol"] = {
		Name = "[Gun]One-handed",
		Desc = "Allow you fire your gun",
		Goods = "Shoot faster",
		Bads = "Less control to ur gun",
		--DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_pistol.mdl",
		IsGun = true,
		ReloadTime = 2,
		RecoilMul = 2,
		VMOffsetPos = Vector(-1,0,0.5),
		VMOffsetAng = Angle(0,0,0),
		VMPropOffsetPos = Vector(0,-0.3,0.5),
		VMPropOffsetAng = Angle(13,14.5,-1),
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Clavicle"] = {Ang = Angle(35,-35,0)},
		},
		--HolsterPrevVM = true,
	},
	["revolver"] = {
		Name = "[Gun]Pistol Two-handed",
		Desc = "Allow you fire your gun",
		Goods = "我不到",
		Bads = "准一点",
		--DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_pistol.mdl",
		IsGun = true,
		ReloadTime = 2,
		VMOffsetPos = Vector(-1,0,0.5),
		VMOffsetAng = Angle(0,0,0),
		VMPropOffsetPos = Vector(0,-0.3,0.5),
		VMPropOffsetAng = Angle(13,14.5,-1),
		--HolsterPrevVM = true,
	},
	["ar2"] = {
		Name = "[Gun]Rifle Two-handed",
		Desc = "Allow you fire your gun",
		Goods = "我不到",
		Bads = "准一点",
		--DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		VMOffsetPos = Vector(0,0,0),
		VMOffsetAng = Angle(0,0,0),
		IsGun = true,
		DoubleHand = true,
		ReloadTime = 3,
		RecoilMul = 1,
		AttackActivity = ACT_VM_PRIMARYATTACK,
		VM = "models/weapons/c_nspw_doublehandgun.mdl",
		VMPropOffsetPos = Vector(0,-0.3,1),
		VMPropOffsetAng = Angle(13,14.5,-1),
		--HolsterPrevVM = true,
	},
	["smg"] = {
		Name = "[Gun]Rifle Two-handed(Grip)",
		Desc = "Allow you fire your gun",
		Goods = "我不到",
		Bads = "准一点",
		--DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		--[[VM = "models/weapons/cstrike/c_smg_ump45.mdl",
		VMOffsetPos = Vector(0,0,0),
		VMOffsetAng = Angle(0,0,0),
		VMPropOffsetPos = Vector(-1,0,1),
		VMPropOffsetAng = Angle(10,10,0),]]
		IsGun = true,
		DoubleHand = true,
		ReloadTime = 3,
		RecoilMul = 1,
		AttackActivity = ACT_VM_PRIMARYATTACK,
		--InvertDWHL = true,
		VM = "models/weapons/c_nspw_doublehandgun.mdl",
		VMPropOffsetPos = Vector(0,-0.3,1),
		VMPropOffsetAng = Angle(13,14.5,-1),
		BoneManipulatesAnimation = {
			["ValveBiped.Bip01_L_Hand"] = {Ang = Angle(-30,0,90)},
			["ValveBiped.Bip01_L_Forearm"] = {Ang = Angle(3,5,0)},
			["ValveBiped.Bip01_L_Upperarm"] = {Ang = Angle(0,-3,0)},
			["ValveBiped.Bip01_L_Clavicle"] = {Pos = Vector(0,0,2),Ang = Angle(0,0,2)},
			["ValveBiped.Bip01_L_Finger0"] = {Ang = Angle(20,20,0)},
			["ValveBiped.Bip01_L_Finger01"] = {Ang = Angle(0,0,0)},
			["ValveBiped.Bip01_L_Finger02"] = {Ang = Angle(0,0,0)},
			["ValveBiped.Bip01_L_Finger1"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger11"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger12"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger2"] = {Ang = Angle(-10,-20,0)},
			["ValveBiped.Bip01_L_Finger21"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger22"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger3"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger31"] = {Ang = Angle(0,-10,0)},
			["ValveBiped.Bip01_L_Finger32"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger4"] = {Ang = Angle(0,-20,0)},
			["ValveBiped.Bip01_L_Finger41"] = {Ang = Angle(0,-10,0)},
			["ValveBiped.Bip01_L_Finger42"] = {Ang = Angle(0,-20,0)},
		}
		--HolsterPrevVM = true,
	},
	["shotgun"] = {
		Name = "[Gun]Shotgun",
		Desc = "Allow you fire your gun",
		Goods = "我不到",
		Bads = "准一点",
		--DoNothing = true,
		AttackStart = 0.15,
		AttackEnd = 0.35,
		AttackVM = 0,
		--[[VM = "models/weapons/cstrike/c_shot_m3super90.mdl",
		VMOffsetPos = Vector(0,0,0),
		VMOffsetAng = Angle(0,0,2.5),
		VMPropOffsetPos = Vector(),
		VMPropOffsetAng = Angle(9.5,8,-5),]]
		VM = "models/weapons/c_nspw_doublehandgun.mdl",
		VMOffsetPos = Vector(3,0,-0.5),
		VMOffsetAng = Angle(0,0,0),
		VMPropOffsetPos = Vector(0,-0.3,1),
		VMPropOffsetAng = Angle(13,14.5,-1),
		IsGun = true,
		DoubleHand = true,
		ReloadTime = 3,
		RecoilMul = 1,
		AttackActivity = ACT_VM_PRIMARYATTACK,
		AllowNoMag = true,
		--InvertDWHL = true,
		--HolsterPrevVM = true,
	},
}

SWEP.PrintName = "Prop"

SWEP.InReload = false

SWEP.UseHands = true

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.ViewModel = "models/weapons/c_nspw_melee2.mdl"
SWEP.WorldModel = "models/weapons/cstrike/c_knife_t.mdl" --实际上这玩意啥也不是

SWEP.NextReload = 0

if SERVER then

	--该表记录已经攻击过的敌人

	SWEP.Attacked = {}
	SWEP.MeleeHitTriggered = false

	SWEP.NeedPump = false

end

--科技原件丢了

local function CloneAtoB(A,B)
	
	B:SetModel(A:GetModel())
	B:SetMaterial(A:GetMaterial())
	B:SetRenderMode(A:GetRenderMode())
	B:SetRenderFX(A:GetRenderFX())
	B:SetSkin(A:GetSkin())

	--[[for i=0,A:GetNumBodyGroupCount() do
		B:SetBodygroup(i, v)
	end]]

end

SWEP.ViewModelFOV = 58

--[[function SWEP:TranslateFOV(fov)

	return fov

end]]

--print("WOSHISHABI")
function SWEP:SetupDataTables()

	self:NetworkVar("Bool",0,"Blocking")
	self:NetworkVar("Bool",1,"Aiming")
	--self:NetworkVar("Bool",0,"Reloading")
	self:NetworkVar("Float",0,"BlockStartTime")
	--self:NetworkVar("String",0,"Style")

end

function SWEP:SendVMAnim(ACT)

	local o = self:GetOwner()

	if !IsValid(o) or !o:IsPlayer() then return end

	local VModel = o:GetViewModel()
	if !IsValid(VModel) then return end
	local EnumToSeq = VModel:SelectWeightedSequence( tonumber(ACT) or ACT_VM_PRIMARYATTACK )
	--print(VModel:GetSequenceName(EnumToSeq))
	--print(VModel:GetModel(),EnumToSeq)

	--local Name = VModel:GetSequenceName(EnumToSeq)
	--print(Name)

	--self:SendVMAnimSequence(Name)

	VModel:SendViewModelMatchingSequence( EnumToSeq )

end
-- 我阐述你的梦
function SWEP:SendVMAnimSequence(Seq)

	local o = self:GetOwner()

	if !IsValid(o) or !o:IsPlayer() then return end

	local VModel = o:GetViewModel()
	if !IsValid(VModel) then return end
	local index = isnumber(Seq) and Seq or VModel:LookupSequence(tostring(Seq))
	--print(index,VModel:GetSequenceName(index),VModel:GetSequenceActivityName(index))
	--print(VModel:GetSequenceName(EnumToSeq))

	VModel:SendViewModelMatchingSequence( index )

end

function SWEP:Initialize()
	
	--print(self:GetPropEntity40())
	--self:Remove()
	--单人叫不到
	--print("?2")
	--timer.Create(ID,0,1,function())
	--self:SetWeaponHoldType("melee")
	self.Initialized = true
	self:SetHoldType("melee")

	local DefineTable = {
		HoldType = "melee",
		WireIO_E2List = {},
		WireIO_ShouldAttack = true,
		WireIO_ShouldBlock = true,
	}
	if SERVER then
		DefineTable = {
			HoldType = "melee",
			WireIO_E2List = {},
			WireIO_ShouldAttack = true,
			WireIO_ShouldBlock = true,
		}
	else

		DefineTable = {
			DupeData = {},
			DupeDataInitialized = false
		}

	end
	for i,v in pairs(DefineTable) do
		if self[i] then 
			--print("JB",i)
			continue 
		end
		--print(i,v)
		self[i] = v
	end

	--local CCT()
	if self:GetOwner():IsNPC() then
		local ID = "NSPW_WEAPONTHINK_"..self:EntIndex().."_NPC"
		timer.Create(ID, 0,0,function()

			if !IsValid(self) then timer.Remove(ID) return end
			self:Think()

		end)
	end
end

function SWEP:GetStyleData()

	return Style[self.LastStyle or self.HoldType or self:GetHoldType()] or {}

end

if SERVER then


	function SWEP:SetStyle(s)

		self.InReload = false
		self:SetAiming(false)

		self:SendWeaponAnim(ACT_VM_IDLE) --清空之前的动画
		local owner = self:GetOwner()

		local CSD = Style[s]

		if !CSD then return end

		if IsValid(owner) and owner:IsPlayer() then
			local VM = owner:GetViewModel()
			self.ViewModel = CSD.VM
			if IsValid(VM) and !CSD.HolsterPrevVM then
				VM:SetWeaponModel(CSD.VM or "",self)
			end
		end


		local OldStyle = self:GetStyleData()
		if OldStyle.HolsterPrevVM and CSD.HolsterPrevVM then return end

		self.HoldType = s

		if CSD.HolsterPrevVM then
			self:SendVMAnim(CSD.InvertDWHL and ACT_VM_DRAW or ACT_VM_HOLSTER)
		else
			self:SendVMAnim(CSD.InvertDWHL and ACT_VM_HOLSTER or ACT_VM_DRAW)
			self:SetNextPrimaryFire(CurTime()+0.7)
		end


		self:SetBlocking(false)


	end

	function SWEP:ThinkHandlePropPosition(owner)

		--print(self:Get)

		if !IsValid(self.DupeDataC) then 
			self:Remove()
			return
		end
		--self:SetStyle(self.HoldType)
		self:SetHoldType((self:GetBlocking() and !self:GetStyleData().IsGun) and "passive" or self.HoldType)
		--print(owner:GetSequenceName(owner:GetSequence()))
		--owner:SetSequence("idle_melee")

		local Bone = owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0
		--local mat = owner:GetBoneMatrix(Bone)
		--print(Bone)
		--if !mat then return end
		--local BPos,BAng = mat:GetTranslation(),mat:GetAngles()

		local BPos,BAng = owner:GetBonePosition(Bone)

		--我们需要先设置父级,再设置子级,注意优先级

		local DPos = self.DupeData[self.DupeDataC].Pos
		local DAng = self.DupeData[self.DupeDataC].Angle
			--print(owner:GetPoseParameterName(3))
		if self.DupeDataC:GetParent() != owner then

			local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}
			--BAng.p = 0
			--困扰撒蜜蜂114514年的bug-1
			local FPos,FAng = LocalToWorld(DPos, DAng+Angle(0,0,180),BPos,owner:EyeAngles())
			self.DupeDataC:FollowBone(owner, Bone)
			--self.DupeDataC:SetParent(owner, 13)
			--self.DupeDataC:SetPos(DPos+Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
			--self.DupeDataC:SetAngles(FAng+(PropData.OffsetAng or Angle()))
			self.DupeDataC:SetLocalPos(Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
			self.DupeDataC:SetLocalAngles(Angle(0,0,180)+(PropData.OffsetAng or Angle()))
			
		end
			--self.DupeDataC:SetAngles(DAng)

		for ent,data in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			

			local pobj = ent:GetPhysicsObject()

			if IsValid(pobj) then
				pobj:EnableMotion(false)
				--pobj:EnableCollisions(false)
				pobj:Sleep()
			end

			if !ent.NSPW_PROP_MYPARENT then
				ent.NSPW_PROP_MYPARENT = ent:GetParent()
			end

			local Pos = data.Pos
			local Ang = data.Angle

			--local NewPos = Pos-DPos
			--NewPos:Rotate(DAng)

			if ent != self.DupeDataC and ent:GetParent() != self.DupeDataC then
				--print("CALL")
				--[[local FPos,FAng = LocalToWorld(
					Pos,
					Ang,
					self.DupeDataC:GetPos(),
					self.DupeDataC:GetAngles()
				)
				ent:SetPos(FPos)
				ent:SetAngles(FAng)]]
				ent:SetParent(self.DupeDataC)
				ent:SetLocalPos(Pos)
				ent:SetLocalAngles(Ang)
				--ent:SetPos(Pos)
				--ent:SetAngles(Ang)
				--ent:SetAngles(Ang-BAng)
			end

			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			ent:SetCustomCollisionCheck(true)

			ent:SetNWVector("NSPW_PROP_NW_POS",ent:GetPos())
			ent:SetNWAngle("NSPW_PROP_NW_ANG",ent:GetAngles())
			ent.NSPW_PROP_RELATEDWEAPON = self

		end

	end

	function SWEP:ThinkHandleAttack(owner)

		local on = self.MeleeAttacking

		if !on then return end

		local start = self.MeleeAttackStart
		local endtime = self.MeleeAttackEnd

		if CurTime() < start then return end

		if on and CurTime() > endtime then

			self.Attacked = {}
			self.MeleeAttacking = false
			--self.MeleeHit = false
			self.MeleeHitTriggered = false

			for ent,_ in pairs(self.DupeData) do

				ent.NSPW_MeleeHitTriggered = false

			end

			return

		end

		local Ents = {}

		for ent,_ in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			Ents[#Ents+1] = ent

		end

		local filter = table.Copy(Ents)

		table.Add(filter, {self,owner})
		table.Add(filter,self.Attacked)

		local Hit

		for _,ent in pairs(Ents) do

			if !IsValid(ent) then continue end

			local tr = util.TraceEntityHull({
				start = ent:GetPos(),
				endpos = ent:GetPos()+owner:GetAimVector()*40,
				ignoreworld = true,
				filter = filter,
				mask = MASK_ALL
			}, ent)

			if IsValid(tr.Entity) then
				local trd = util.TraceLine({
					start = ent:GetPos(),
					endpos = owner:GetShootPos(),
					filter = filter,
					mask = MASK_SHOT
				}) 
				if trd.Hit then continue end --穿墙击杀,扣钱
				
				if owner:IsNPC() and owner:Disposition(tr.Entity) != D_HT and owner:Disposition(tr.Entity) != D_FR then
					self.Attacked[#self.Attacked+1] = tr.Entity
					continue
				end


				Hit = true

				local PropData = NSPW_DATA_PROPDATA[ent] or {}

				local dmgmod = PropData.AttackDamageModify or 0
				local random = PropData.AttackDamageModifyOffset or 0

				local dmg = math.random(dmgmod-random,dmgmod+random)
				local pobj = ent:GetPhysicsObject()
				local DmgType = PropData.AttackDamageType or DMG_GENERIC
				if IsValid(pobj) then 
					dmg = dmg + pobj:GetMass()
					if pobj:GetMass() >= GetConVar("savee_nspw_damage_massmarkasclub"):GetFloat() and !PropData.AttackDamageType then

						Dmgtype = DMG_CLUB

					end
				else
					dmg = dmg + GetConVar("savee_nspw_damage_nonphysics"):GetFloat()
				end

				dmg = dmg*GetConVar("savee_nspw_damage_mult"):GetFloat()


				local Dmginfo = DamageInfo()
				Dmginfo:SetDamage(dmg)
				Dmginfo:SetDamageType(DmgType)
				Dmginfo:SetDamageForce(owner:GetAimVector()*650)
				Dmginfo:SetDamagePosition(tr.HitPos)
				Dmginfo:SetInflictor(ent)
				Dmginfo:SetAttacker(owner)
				tr.Entity:TakeDamageInfo(Dmginfo)
				self.Attacked[#self.Attacked+1] = tr.Entity

				if !ent.NSPW_MeleeHitTriggered then

					local tempval = PropData.MeleeHitSound

					ent.NSPW_MeleeHitTriggered = true
					
					owner:EmitSound(
						istable(tempval) and tempval[math.random(1,#tempval)] or
						tempval or "")

					tempval = PropData.MeleeHitEffect

					if tempval then
						local ed = EffectData()
						ed:SetOrigin(tr.HitPos)
						ed:SetStart(tr.HitPos)
						ed:SetScale(1)
						util.Effect(istable(tempval) and tempval[math.random(1,#tempval)] or tempval,ed,true,true)
					end

				end

			end

		end

		if Hit and !self.MeleeHitTriggered then
			owner:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav",60,math.random(90,140))
			self.MeleeHitTriggered = true
		end

	end

	function SWEP:ThinkHandleGun(owner)

		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

		if !self.DupeDataC.NSPW_GUNCLIP1 then
			self.DupeDataC.NSPW_GUNCLIP1 = PropData.Magsize
			self:SetClip1(PropData.Magsize)
		else
			self.DupeDataC.NSPW_GUNCLIP1 = self:Clip1()
		end

		local magsize = PropData.Magsize

		for ent,_ in pairs(self.DupeData) do 
		
			if !IsValid(ent) or ent == self.DupeDataC then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			magsize = magsize + (PropData.Magsize or 0)

		end

		self.Primary.ClipSize = magsize

		if owner:IsNPC() and IsValid(owner:GetEnemy()) then

			local dist = owner:GetPos():DistToSqr(owner:GetEnemy():GetPos())
			if self.HoldType == "shotgun" and dist > 250000  then
				owner:SetCondition(COND.TOO_FAR_TO_ATTACK)
				--owner:SetSchedule(SCHED_MOVE_TO_WEAPON_RANGE)
			elseif dist <= 3600 and owner:SelectWeightedSequence(ACT_MELEE_ATTACK1) >= 0 and !owner:IsCurrentSchedule(SCHED_MELEE_ATTACK1) then
				--[[local oldht = self.HoldType
				if owner:SelectWeightedSequence(ACT_MELEE_ATTACK1) < 0 then
					self.HoldType = "melee"
					owner:SetActivity(ACT_MELEE_ATTACK_SWING)
				end]]
				owner:SetSchedule(SCHED_MELEE_ATTACK1)
				timer.Simple(0.2,function()
					if !IsValid(owner) or !IsValid(self) then return end
					self:Swing(owner,PropData,self:GetStyleData())
					--self.HoldType = oldht
				end)
				--print("1")
				--owner:SetSchedule(SCHED_MOVE_TO_WEAPON_RANGE)
			end

		end

	end

	function SWEP:ThinkHandleGunReload(owner)

		local MyStyle = self:GetStyleData()
		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]

		local Mul = 1

		local Heavy
		local NoMag = PropData.NoMag
		local mass = 0

		for ent,_ in pairs(self.DupeData) do 
		
			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			Mul = Mul * (PropData.ReloadSpeedMul or 1)
			Mul = Mul + (PropData.ReloadSpeedMulOffset or 0)

			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			if PropData.IsMag then
				NoMag = false
			end

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == self.DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				mass = mass + pobj:GetMass()*CV:GetFloat()
			else
				mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end

		end

		if mass >= GetConVar("savee_nspw_heavygun"):GetFloat() then

			Heavy = true

		end

		if NoMag then
			if !self.ReloadSetup then
				self.ReloadSetup = true
				self.NeedPump = self.NeedPump or PropData.PumpAction and self:Clip1() == 0
				self:SendVMAnim(ACT_SHOTGUN_RELOAD_START)
				self.ReloadAmmoTime = CurTime()+0.3
				self.ReloadStage = 0
				self.InsertedSlug = false
				return true
			end
			--if !MyStyle.AllowNoMag then return end

			--local function DoReload()
			if self.ReloadAmmoTime <= CurTime() then
					--self:SendVMAnim(ACT_RELOAD_SHOTGUN)
				local magsize = PropData.Magsize

				for ent,_ in pairs(self.DupeData) do 

					if !IsValid(ent) or ent == self.DupeDataC then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}
					magsize = magsize + (PropData.Magsize or 0)

				end
				
				if self.ReloadStage == 0 then

					--self:SendVMAnimSequence("anim_reload_sg")


					--ZS模拟器
					if self:Clip1() == magsize or !owner:KeyDown(IN_RELOAD) then 
						self:SendVMAnim((Heavy or !self.NeedPump or !self.InsertedSlug) and ACT_SHOTGUN_RELOAD_FINISH or ACT_VM_RELOAD_DEPLOYED)
						--print(Heavy , !self.NeedPump)
						self:SetBlocking(false)
						if !Heavy and self.NeedPump then 
							self.ReloadAmmoTime = CurTime() + 0.5
							self.ReloadStage = 2
							self.NeedPump = false 
							self:SetNextPrimaryFire(CurTime()+1.5)
							--print("?")
						else
							self.InReload = false
							self:SetNextPrimaryFire(CurTime()+0.5)
						end
						--return
					else
						self:SendVMAnim(ACT_RELOAD_SHOTGUN)
						--DoReload()
						self.ReloadAmmoTime = CurTime() + 0.2*Mul
						self.ReloadStage = 1
					end

				elseif self.ReloadStage == 1 then

					--print("?")
					local ac = owner:GetAmmoCount(PropData.AmmoType or "pistol")
					if ac <= 0 then 
						self:SetBlocking(false) 
						self:SendVMAnim((Heavy and !self.NeedPump) and ACT_SHOTGUN_RELOAD_FINISH or ACT_VM_RELOAD_DEPLOYED) 
						if !Heavy and self.NeedPump then 
							self.ReloadAmmoTime = CurTime() + 0.5
							self.ReloadStage = 2
							self.NeedPump = false 
						else
							self.InReload = false
						end
						--if !Heavy and self.NeedPump then self.NeedPump = false end
						return
					end
					owner:SetAmmo(ac-1, PropData.AmmoType or "pistol")
					self:SetClip1(math.min(self:Clip1()+1,magsize))
					self.InsertedSlug = true

					if PropData.InsertSound then
						owner:EmitSound(istable(PropData.InsertSound) and 
							PropData.InsertSound[math.random(1,#PropData.InsertSound)]or PropData.InsertSound,45)
					end

					self.ReloadAmmoTime = CurTime() + 0.15*Mul

					self.ReloadStage = 0

				else

					if self.InsertedSlug then --填弹了就放动画

						owner:EmitSound(PropData.PumpSound or "weapons/m3/m3_pump.wav",55)

					end
					--print("?")
					self.InReload = false
					self.NeedPump = false

					--self:SetNextPrimaryFire(CurTime()+2)


				end
				--end)

			--end
			end
			--timer.Simple(0.1,function()
				--[[if !IsValid(self) or self:GetOwner() != owner then return end
				DoReload()]]
			--end)
		else

			--你说得对但是清一色3秒/1秒
			if !self.ReloadSetup then
				self.ReloadSetup = true
				self.NeedPump = self.NeedPump or self:Clip1() == 0
				--做动画的时候忘了比对了,比真实距离要远一点
				self:SendVMAnim(PropData.MagOnBack and ACT_DOD_RELOAD_GARAND or ACT_VM_RELOAD)
				self.ReloadAmmoTime = CurTime()+0.45*Mul*(MyStyle.ReloadTime or 1)/3 --(MyStyle.ReloadTime or 1)*Mul
				self.ReloadStage = 0
				self:SetBlocking(true)
				for ent,_ in pairs(self.DupeData) do 
			
					if !IsValid(ent) then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}
					local TargetVal = PropData.ReloadEvent_Start

					if TargetVal then

						if isfunction(TargetVal) then 
							TargetVal(self,owner)
						else
							owner:EmitSound(TargetVal,55)
						end

					end


				end
				return
			end

			if self.ReloadAmmoTime <= CurTime() then

				if self.ReloadStage == 0 then

					for ent,_ in pairs(self.DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ClipOut

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+0.65*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 1
				elseif self.ReloadStage == 1 then

					for ent,_ in pairs(self.DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ChangeClip

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+(MyStyle.DoubleHand and 0.7 or 0.35)*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 2

				elseif self.ReloadStage == 2 then

					for ent,_ in pairs(self.DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ClipIn

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+0.7*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 3

				elseif self.ReloadStage == 3 then

					for ent,_ in pairs(self.DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_LoadGun

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+(MyStyle.DoubleHand and 0.5 or 0.7)*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 4

					self.NeedPump = false

				else
					local magsize = PropData.Magsize

					for ent,_ in pairs(self.DupeData) do 

						if !IsValid(ent) or ent == self.DupeDataC then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						magsize = magsize + (PropData.Magsize or 0)

						local TargetVal = PropData.ReloadEvent_End

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							else
								owner:EmitSound(TargetVal,55)
							end

						end

					end

					local ac = owner:GetAmmoCount(PropData.AmmoType or "pistol") + self:Clip1()
					local mag = math.min(ac,magsize)
					owner:SetAmmo(ac-mag, PropData.AmmoType or "pistol")
					self:SetClip1(mag)
					--self.Primary.ClipSize = magsize
					self:SetBlocking(false)
					--self:SendVMAnim(ACT_VM_IDLE)


					self.InReload = false

				end

			end
		end


	end

	function SWEP:Reload()

		local owner = self:GetOwner()

		--self:SendVMAnimSequence("anim_fire")

		if self.NextReload > CurTime() then return end

		self:SetAiming(false)

		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

		if !owner:KeyDown(IN_USE) and !self:GetBlocking() and MyStyle.IsGun and PropData.IsGun and self:Clip1() < self:GetMaxClip1() and !self.InReload then

			--print("SEND")
			if !PropData.FreeReload and tobool(MyStyle.DoubleHand) != tobool(PropData.DoubleHand) then
				owner:PrintMessage(4,SomeSBStuffs) --翻译...
				--return
			else
				owner:DoReloadEvent()
				self:CallOnClient("DoReloadEvent")
	
				--self:SendWeaponAnim(ACT_VM_IDLE)
				self:SendVMAnim(ACT_VM_RELOAD)
				--self:SendVMAnim(ACT_VM_PRIMARYATTACK_3)
				--self:SetBlocking(true)
	
				self.ReloadStartTime = CurTime()
				self.ReloadSetup = false
				self.InReload = true
			end


		end

		if game.SinglePlayer() then
			self:CallOnClient("Reload")
		end

		self.NextReload = CurTime()+0.1
		--owner:PrintMessage(4, "JB")

	end

	function SWEP:Swing(owner,PropData,MyStyle)

		--local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}
		local time = 0.1

		if owner:IsPlayer() then owner:DoAttackEvent() end
		self:CallOnClient("DoAttackEvent")

		timer.Simple(MyStyle.AttackVM,function()
			if !IsValid(self) then return end
			self:SendWeaponAnim(ACT_VM_MISSCENTER)
		end)

		owner:EmitSound("weapons/slam/throw.wav",75,math.random(90,140))

		for ent,_ in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}

			time = time + (PropData.AttackTimeModify or 0)

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == self.DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				time = time + pobj:GetMass()*CV:GetFloat()
			else
				time = time + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end

				--time = time*GetConVar("savee_nspw_damage_mult"):GetFloat()
			--print(time)

		end


		self.MeleeAttackStart = CurTime()+MyStyle.AttackStart
		self.MeleeAttackEnd = CurTime()+MyStyle.AttackEnd

		self.MeleeAttacking = true
		self:SetNextPrimaryFire(CurTime()+math.max(0.3,time))


	end	

else

	local NSPW_SettingMenu

	function SWEP:Reload()

		local owner = self:GetOwner()

		if !IsValid(owner) or !owner:KeyDown(IN_USE) or IsValid(NSPW_SettingMenu) then return end

		local f = vgui.Create("DFrame")

		f:MakePopup()
		f:SetSize(200,600)
		f:Center()

		local dsp = vgui.Create( "DScrollPanel", f )
		dsp:Dock( FILL )

		local StyleBtns = {}

		for i,data in pairs(Style) do
			local Index = #StyleBtns + 1
			local Btn = dsp:Add( "DButton" )
			Btn:SetText( "["..Index.."]"..data.Name )
			Btn:Dock( TOP )
			Btn:DockMargin( 0, 0, 0, 5 )
			Btn:SetToolTip("Description:\n"..data.Desc.."\n\n Goods: \n"..data.Goods.."\n\n Bads: \n"..data.Bads)
			
			function Btn:DoRightClick()

				net.Start("NSPW_TransStyleMessage")
					net.WriteString(i)
				net.SendToServer()

			end

			function Btn:DoClick()

				self:DoRightClick()
				f:Remove()

			end
			

			StyleBtns[Index] = Btn
		end

		function f:OnKeyCodePressed(c)

			for i,B in pairs(StyleBtns) do

				if c == input.GetKeyCode(input.LookupBinding("slot"..i)) then
					
					B:DoClick()

				end

			end

		end
		

		NSPW_SettingMenu = f
		--print("?")
		

	end

	function SWEP:DoAttackEvent()

		local owner = self:GetOwner()
		if !IsValid(owner) or !owner:IsPlayer() then return end

		owner:DoAttackEvent()

	end
	function SWEP:DoReloadEvent()

		local owner = self:GetOwner()
		if !IsValid(owner) or !owner:IsPlayer()  then return end

		owner:DoReloadEvent()

	end

end

function SWEP:Think()

	local owner = self:GetOwner()

	if !self.Initialized then
		self:Initialize()
		return
	end

	--self:SetWeaponHoldType("melee")

	--print("?")

	--print("RRRR")

	if SERVER then

		if !IsValid(owner) then 
			self:RemoveMySelf()
			--print("RRR")
			return
		end

		--请在之后放入检测物品是否全部消失的设置
		if !self.DupeData or !IsValid(self.DupeDataC) then 
			self:RemoveMySelf()
			return
		end

		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

		local Total = 0
		for ent,_ in pairs(self.DupeData or {}) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			if PropData.Automatic != nil then

				if PropData.Automatic then
					Total = Total + 1
				else
					Total = Total - 1
				end

			end
			
		end

		if Total == 0 and PropData.Automatic or Total > 0 then
			Total = true
		else
			Total = false
		end

		self:ThinkHandlePropPosition(owner)
		if MyStyle.IsGun and PropData.IsGun then
			self.Primary.Automatic = Total
			self.Primary.Ammo = PropData.AmmoType or "pistol"
			self.Secondary.Ammo = "none"
			self:ThinkHandleGun(owner)
			if self.InReload then
				self:ThinkHandleGunReload(owner)
			end
			if owner:IsNPC() and owner:IsCurrentSchedule(SCHED_MELEE_ATTACK1) then
				self:ThinkHandleAttack(owner)
			end
			--print("?")
		else
			self.Primary.Automatic = true
			self.Primary.Ammo = "none"
			self.Secondary.Ammo = "none"
			self:ThinkHandleAttack(owner)

			--print("THICCED THICC EDUCATHICC WITH VICHICC STROVTHICC")
				--self:SetWeaponHoldType("melee")
			--print(owner:GetEnemy())
			if owner:IsNPC() and IsValid(owner:GetEnemy()) then


				self:SetHoldType("melee")
				if !owner:IsCurrentSchedule(SCHED_MELEE_ATTACK1) and !owner:IsCurrentSchedule(SCHED_CHASE_ENEMY) then

					local dist = owner:GetPos():DistToSqr(owner:GetEnemy():GetPos())
					if dist <= 4000  then
						owner:SetSchedule(SCHED_MELEE_ATTACK1)
						--owner:SetActivity(ACT_MELEE_ATTACK1)
						timer.Simple(0.2,function()
							if !IsValid(owner) or !IsValid(self) then return end
							self:PrimaryAttack()
						end)
						--print("KTE")
					elseif dist > 4000 and owner:GetCurrentSchedule() != SCHED_CHASE_ENEMY then
						owner:SetSchedule(SCHED_CHASE_ENEMY)
						--print("EXE",dist)
					end

				end

			end

		end
		--self:SetNextThink(0)
		--print("?")

		--[[if !MyStyle.HolsterPrevVM then
			--print("?")
		end]]

		return true

	else

		--self:ManipulateBonePosition(0,Vector(-10,0,0))

		if !self.DupeDataInitialized or !IsValid(self.DupeDataC) or !owner:IsPlayer() then return end

		local vm = owner:GetViewModel()
		local block = self:GetBlocking()
		if IsValid(vm) then

			--print("?")

		end

		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}
		--print(self.DupeDataC:GetModel())

		--self:ThinkHandlePropPosition(owner)
		if MyStyle.IsGun and PropData.IsGun then
			self.Primary.Automatic = true
			self.Primary.Ammo = PropData.AmmoType or "pistol"
			self.Secondary.Ammo = "none"
		else
			self.Primary.Automatic = true
			self.Primary.Ammo = "none"
			self.Secondary.Ammo = "none"
		end

		if !self.DupeDataInitialized or !self.DupeData or !self.DupeDataC then
			--self.DupeData = {}
			net.Start("NSPW_TransPropTableMessage")
				net.WriteEntity(self)
			net.SendToServer()
			--print("?")
		end

		self:SetNextClientThink(CurTime())
		return true
	end

end

function SWEP:RemoveMySelf()
	if CLIENT then return end

	for ent,_ in pairs(self.DupeData or {}) do
		if IsValid(ent) then ent:Remove() end
	end

	self:Remove()

end

local WhiteList = {
	["NSPW_GUNCLIP1"] = true,
	["NSPW_GUNCLIP2"] = true,
}

function SWEP:DropMySelf()
	
	local owner = self:GetOwner()

	self.Removing = true

	if SERVER then

		if !IsValid(self.DupeDataC) then return end

		self.DupeDataC:FollowBone(NULL,0)
		self.DupeDataC:SetCustomCollisionCheck(self.DupeDataC.NSPW_PROP_OLDCOLLISIONCHECK)
		self.DupeDataC:SetCollisionGroup(self.DupeDataC.NSPW_PROP_OLDCOLLISIONGROUP or 0)
		--print(self.DupeDataC.NSPW_PROP_OLDCOLLISIONGROUP,COLLISION_GROUP_IN_VEHICLE)
		for i,_ in pairs(self.DupeDataC:GetTable()) do
				
			if string.StartWith(i, "NSPW_") and !WhiteList[i] then

				self.DupeDataC[i] = nil

			end

		end
		self.DupeDataC:SetPos(IsValid(owner) and owner:EyePos()+owner:GetAimVector()*15 or self:GetPos())
		local pobj = self.DupeDataC:GetPhysicsObject()
		if IsValid(pobj) then
			pobj:EnableMotion(true)
			pobj:Wake()
			if IsValid(owner) then
				pobj:ApplyForceCenter(owner:GetAimVector()*145)
			end
		end
		--self.DupeDataC:SetVelocity(owner:GetAimVector()*45)
		

		for ent,data in pairs(self.DupeData or {}) do
			--print("?")
			if IsValid(ent) and ent != self.DupeDataC and ent.NSPW_PROP_OLDCOLLISIONGROUP then 
				ent:FollowBone(NULL,0)
				--print(ent,ent.NSPW_PROP_MYPARENT)
				ent:SetCustomCollisionCheck(ent.NSPW_PROP_OLDCOLLISIONCHECK)
				ent:SetCollisionGroup(ent.NSPW_PROP_OLDCOLLISIONGROUP)
				ent:SetParent(ent.NSPW_PROP_MYPARENT or NULL)
				ent:SetLocalPos(data.Pos)
				ent:SetLocalAngles(data.Angle)

				--print(ent,ent.NSPW_PROP_MYPARENT)

				for i,_ in pairs(ent:GetTable()) do

					if string.StartWith(i, "NSPW_") then

						--print(i)

						ent[i] = nil

					end

				end
				local pobj = ent:GetPhysicsObject()
				if !IsValid(pobj) then continue end
				pobj:EnableMotion(true)
				pobj:Wake()
				if IsValid(owner) then
					pobj:ApplyForceCenter(owner:GetAimVector()*145)
				end
			end
		end

		self:Remove()
	else

		for ent,_ in pairs(self.DupeData or {}) do

			if !IsValid(ent) then continue end

			ent:SetRenderOrigin(nil)
			ent:SetRenderAngles(nil)

			ent:SetNoDraw(false)

			if ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
				ent.RenderOverride = ent.NSPW_PROP_CL_RENDEROVERRIDE
				ent.NSPW_PROP_CL_RENDEROVERRIDE = nil
				ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = nil
			end

		end

	end

end

local Reload = {
	["anim_reload"] = {0.3,0.85},
	["anim_bolt"] = {0.1,0.8},
	["anim_reloadaug"] = {0.1,0.7},
	["anim_reloadsg"] = true,
	["anim_reloadsgloop"] = true,
	["anim_reloadsg_in"] = {0.6,0},
	["anim_reloadsg_out"] = {0,0.6},
}

function SWEP:PreDrawViewModel(vm)

	local ht = self:GetHoldType()
	local MyStyle = Style[ht] or {}
	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]

	if !MyStyle.HolsterPrevVM then
		vm:SetModel(MyStyle.VM or "")
		self.CurViewModel = vm:GetModel()
		self.LastStyle = ht
	else
		self.ViewModel = MyStyle.VM
		ht = self.LastStyle or ht
		MyStyle = Style[self.LastStyle] or {}
		--print(ht)
	end
	--[[if self.LastHoldType != ht then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("anim_draw"))
	end
	self.LastHoldType = ht]]

	--[[vm:SetupBones()
	for i=0, vm:GetBoneCount()-1 do
		local m = vm:GetBoneMatrix(i)
		if !m then continue end
		m:SetTranslation(Vector())
		vm:SetBoneMatrix(i,m)
	end]]
	--local hand = self:GetOwner():GetHands()
	--hand:SetParent(vm)
	--vm:AddGesture(1)
	--vm:SetSequence("idle_knife")
	if !IsValid(self.VMAnim) then
		self.VMAnim = ClientsideModel(vm:GetModel(),RENDERGROUP_VIEWMODEL)
		self.VMAnim:SetParent(vm)
		self.VMAnim:SetRenderMode(RENDERMODE_TRANSALPHA)
		self.VMAnim:SetColor(Color(0,0,0,0))
		--self.VMAnim:SetAlpha(Color(0,0,0,0))
		self.VMAnim:SetTransmitWithParent(true)
	end
	self.VMAnim:SetupBones()
	self.VMAnim:SetPos(vm:GetPos())
	self.VMAnim:SetAngles(vm:GetAngles())

	--复制两个function改着费劲,看着傻逼,占用太大,所以感觉不如立个local function(即使这玩意是双料娃中娃还是不停套的,难蚌(但是架不住可以少设值))
	local function Manipulate(vm)
		for i=0,vm:GetBoneCount() - 1 do
			vm:ManipulateBonePosition(i,Vector())
			vm:ManipulateBoneAngles(i,Angle())
		end
		vm:ManipulateBonePosition(0,MyStyle.VMOffsetPos or Vector())
		vm:ManipulateBoneAngles(0,MyStyle.VMOffsetAng or Angle())


		for i,data in pairs(MyStyle.BoneManipulates or {}) do

			local bi = isnumber(i) and i or vm:LookupBone(i) 

			if bi <= 0 then continue end

			vm:ManipulateBonePosition(bi,data.Pos or Vector())
			vm:ManipulateBoneAngles(bi,data.Ang or Angle())


		end
		local Seq = Reload[vm:GetSequenceName(vm:GetSequence())]
		local Cyc = math.abs(vm:GetCycle())
		if isbool(Seq) and Seq then
			Cyc = 1
		elseif istable(Seq) then
			if Cyc <= Seq[2] then
				Cyc = Lerp(math.min(1,Cyc/Seq[1]),0,1)
			else
				Cyc = Lerp(math.min(1,(Cyc-Seq[2])/(1-Seq[2])),1,0)
			end
		else
			Cyc = 0
			--print("1")
		end
		for i,data in pairs(MyStyle.BoneManipulatesAnimation or {}) do

			local bi = isnumber(i) and i or vm:LookupBone(i) 

			if bi <= 0 then continue end


			vm:ManipulateBonePosition(bi,vm:GetManipulateBonePosition(bi)+(LerpVector(Cyc,(data.Pos or Vector()),Vector())))
			vm:ManipulateBoneAngles(bi,vm:GetManipulateBoneAngles(bi)+(LerpAngle(Cyc,(data.Ang or Angle()),Angle())))


		end
		for ent,_ in pairs(self.DupeData) do 
			
			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			
			local BMA = MyStyle.DoubleHand and PropData.BoneManipulatesAnimation or PropData.BoneManipulatesAnimationPistol
			local BM = MyStyle.DoubleHand and PropData.BoneManipulates or PropData.BoneManipulatesPistol

			if !BMA and !BM then continue end

			for i,data in pairs(BM or {}) do

				local bi = isnumber(i) and i or vm:LookupBone(i) 

				if bi <= 0 then continue end

				vm:ManipulateBonePosition(bi,data.Pos or Vector())
				vm:ManipulateBoneAngles(bi,data.Ang or Angle())


			end

			for i,data in pairs(BMA or {}) do

				local bi = isnumber(i) and i or vm:LookupBone(i) 

				if bi <= 0 then continue end

				vm:ManipulateBonePosition(bi,vm:GetManipulateBonePosition(bi)+(LerpVector(Cyc,(data.Pos or Vector()),Vector())))
				vm:ManipulateBoneAngles(bi,vm:GetManipulateBoneAngles(bi)+(LerpAngle(Cyc,(data.Ang or Angle()),Angle())))


			end

		end

		local Mul = FrameTime() * 3

		if self:GetAiming() then

			self.LastAim = (self.LastAim or 0) + Mul
			self.LastAimRaw = (self.LastAimRaw or 0) + Mul
			self.SwayScale = 0.15
			self.BobScale = 0.1

		else

			self.LastAim = (self.LastAim or 0) - Mul
			self.LastAimRaw = self.LastAim
			self.SwayScale = 1
			self.BobScale = 1

		end

		--猫娘在发情期憋太久了会憋坏(SMJB)
		--其实我想表述的是LerpVector和LerpAngle不像Lerp那样有限制

		self.LastAim = math.min(1,math.max(self.LastAim,0))

		vm:ManipulateBonePosition(0,self:GetManipulateBonePosition(0) + LerpVector(
			self.LastAim,
			Vector(0,0,0),
			Vector(-5,6.8,4.7)+(PropData.AimOffsetPos or Vector())+(PropData.AimUseScope and self.LastAim >= 0.8 and Vector(-1000,-1000,-1000) or Vector())
			)
		)
		vm:ManipulateBoneAngles(0,self:GetManipulateBoneAngles(0) + LerpAngle(
			self.LastAim,
			Angle(0,0,0),
			Angle(-2,0,(MyStyle.DoubleHand and -1 or -0.2))+(PropData.AimOffsetAng or Angle())
			)
		)
	end

	Manipulate(vm)

	--local i = 39
	--m:Scale(Vector(0,0,0))
	--vm:SetSequence("anim_block")
	--vm:SetCycle(0.5)
	local block = self:GetBlocking()

	--print(!MyStyle.IsGun)

	--self.VMAnim:SetNoDraw(true)

	if !MyStyle.IsGun and block then
		self.InAnimation = true
		--print("嗨嗨嗨")
		--print(!MyStyle.IsGun)
		--self.VMAnim:SetParent(vm)
		--vm:SetPlaybackRate(0)
		--vm:SetSaveValue("m_flCycle", 0.2)
		--vm:SendViewModelMatchingSequence(vm:LookupSequence("anim_block"))
		if !self.VMAnim_Blocking then
			self.VMAnim:SetModel(vm:GetModel())
			self.VMAnim:SetCycle(0)
			self.VMAnim:ResetSequence("anim_block")

			local Mul = 1

			for ent,_ in pairs(self.DupeData) do 
			
				if !IsValid(ent) then continue end

				local PropData = NSPW_DATA_PROPDATA[ent] or {}
				Mul = Mul * (PropData.ReloadSpeedMul or 1)
				Mul = Mul + (PropData.ReloadSpeedMulOffset or 0)


			end

			self.VMAnim:SetPlaybackRate(1/(MyStyle.ReloadTime or 1)/Mul)
			self.VMAnim_Blocking = true
		elseif !MyStyle.IsGun then
			self.VMAnim:SetCycle(math.min(self.VMAnim:GetCycle()+FrameTime()*self.VMAnim:GetPlaybackRate(),0.5))
		else
			self.VMAnim:SetCycle(math.min(self.VMAnim:GetCycle()+FrameTime()*self.VMAnim:GetPlaybackRate(),1))
		end
			--self.VMAnim:SetPlaybackRate(1)
	elseif MyStyle.IsGun and block then
		self.InAnimation = true
		if !self.VMAnim_Blocking then
			self.VMAnim:SetModel(vm:GetModel())
			self.VMAnim:SetCycle(0)
			self.VMAnim:ResetSequence(vm:GetSequence())

			local Mul = 1

			for ent,_ in pairs(self.DupeData) do 
			
				if !IsValid(ent) then continue end

				local PropData = NSPW_DATA_PROPDATA[ent] or {}
				Mul = Mul * (PropData.ReloadSpeedMul or 1)
				Mul = Mul + (PropData.ReloadSpeedMulOffset or 0)


			end

			self.VMAnim:SetPlaybackRate(1/(MyStyle.ReloadTime or 1)/Mul)
			self.VMAnim_Blocking = true
			self:SendVMAnim(ACT_VM_IDLE)
		else
			self.VMAnim:SetCycle(math.min(self.VMAnim:GetCycle()+FrameTime()*self.VMAnim:GetPlaybackRate(),1.1))
			if self.VMAnim:GetCycle() >= 1.1 then
				self.VMAnim_Blocking = nil
				self.InAnimation = false
				vm:SetupBones()
				--vm:ResetSequence()
				--print("?")
			end
		end
	else
		self.VMAnim:SetCycle(math.min(self.VMAnim:GetCycle()+FrameTime(),1))
		if self.VMAnim:GetCycle() >= 1 then
			self.VMAnim_Blocking = nil
			self.InAnimation = false
		end
	end
	--self:SendVMAnim(ACT_VM_IDLE)
	if self.InAnimation then
		self.VMAnim:SetupBones()
		vm:SetupBones()
		--优化: 你好
		Manipulate(self.VMAnim)
		self.VMAnim:SetPos(vm:GetPos())
		self.VMAnim:SetAngles(vm:GetAngles())

		local Cyc = self.VMAnim:GetCycle()
		Cyc = (Cyc <= 0.1 and Cyc/0.1) or (Cyc >= 0.9 and 1-(Cyc-0.9)/0.1) or 1
		--贝塞尔曲线(大虚)
		local LerpVal = math.ease.InOutCubic(Cyc,0,1)

		for i=0,vm:GetBoneCount()-1 do
			local mtx = vm:GetBoneMatrix(i)
			local mtxanim = self.VMAnim:GetBoneMatrix(i)
			--print("1")
			if !mtx or !mtxanim then continue end
			--print("2")


			mtx:SetTranslation(LerpVector(LerpVal,mtx:GetTranslation(),mtxanim:GetTranslation()))
			mtx:SetAngles(LerpAngle(LerpVal,mtx:GetAngles(),mtxanim:GetAngles()))
			vm:SetBoneMatrix(i,mtx)
		end
	end

	--vm:SetColor(Color(255,255,255,255))

	--vm:SetRenderMode(RENDERMODE_TRANSALPHA)
	--self.VMAnim:DrawModel()

	vm:SetMaterial("savee/transchand/invisiblemat/invisiblemat")
	--vm:DrawModel()
	--return true

end


function SWEP:PostDrawViewModel(draw)

	--print("我真的在画")
	if !draw or self.Removing then return end

	--print("热修复还活着")
	if !IsValid(self.DupeDataC) then
		self:RequestPropInfo()
	end

	local owner = self:GetOwner()

	local vm = owner:GetViewModel()

	--[[for i=0,vm:GetBoneCount() - 1 do
		print(vm:GetBoneName(i))
	end]]
	--v_weapon.Knife_Handle
	local mtx = vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand"))

	if !mtx then return end

	owner:SetupBones()
	local omtx = owner:GetBoneMatrix(owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
	if !omtx then return end
	local Pos,Ang = mtx:GetTranslation(),mtx:GetAngles()

	

	for ent,_ in pairs(self.DupeData or {}) do

		--local ent = self["GetPropEntity"..i](self)

		if !IsValid(ent) then continue end
		
		
		ent:SetNoDraw(true)

		if !ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
			ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = true
			ent.NSPW_PROP_CL_RENDEROVERRIDE = ent.RenderOverride
			--ent.RenderOverride = function(self) self:DrawShadow(false) end
		end
		ent:SetRenderOrigin(nil)
		ent:SetRenderAngles(nil)

		--print(ent:GetPos(),ent:GetAngles())
		--ent:SetupBones()
		ent.NSPW_PROP_CL_Origin = ent:GetPos()
		ent.NSPW_PROP_CL_Angle = ent:GetAngles()
		--[[local FPos,FAng
		local OldMeta = getmetatable(ent)
		----PrintTable(OldMeta)
		local NewMeta = table.Copy(OldMeta)
		function NewMeta:GetRealPos() return self.NSPW_PROP_CL_Origin end
		function NewMeta:GetRealAngles() return self.NSPW_PROP_CL_Angle end
		function NewMeta:GetPos() return FPos end
		function NewMeta:GetAngles() return FAng end
		function NewMeta:__index(key,...)
			--print(key)
			--[[if key == "GetPos" then
				--print("?")
				return NewMeta[key]
			elseif key == "GetAngles" then
				--print("?")
				return NewMeta[key]
			end
			if NewMeta[key] then return NewMeta[key] end
			return OldMeta.__index(self,key,...)
		end

		debug.setmetatable(ent, NewMeta)]]

		local MyStyle = self:GetStyleData()

		local OPos,OAng = LocalToWorld((MyStyle.VMPropOffsetPos or Vector()),(MyStyle.VMPropOffsetAng or Angle()),omtx:GetTranslation(),omtx:GetAngles())

		OPos,OAng = WorldToLocal(ent:GetPos(),ent:GetAngles(),OPos,OAng)
		local FPos,FAng = LocalToWorld(OPos,OAng,Pos,Ang)
--
		--OAng.z = -OAng.z
		--print(OPos)
		--[[ent:AddEffects(EF_FOLLOWBONE)
		ent:SetRenderOrigin(FPos)
		ent:SetRenderAngles(FAng)]]

		--ent:SetParent(vm)
		--ent:SetPredictable(true)
		--PrintTable(ent:GetSaveTable(true))
		ent:DrawShadow(false)
		local pobj = self:GetPhysicsObject()

		
		--ent:SetNetworkOrigin(FPos)
		--ent:SetRender
		ent:SetRenderOrigin(FPos)
		ent:SetRenderAngles(FAng)
		ent.RenderOverride = function(self) 
			self:DestroyShadow()

			self:SetupBones()
			--self:SetPos(FPos)
			--self:SetAngles(FAng)
			--self:SetPos(self:GetRenderOrigin())
			--print("SUS")
			--self:SetPos(FPos)
			--self:SetAngles(FAng)
			
			--if isfunction(self.Draw) then
				--self:Draw()
			--else
				self:DrawModel()
			--end
			--self:DrawModel()

			--self:SetPos(self.NSPW_PROP_CL_OFFSETPOS)
			--self:SetAngles(self.NSPW_PROP_CL_OFFSETANG)

			--print(ent:GetBoneMatrix(0))
		end
		ent:DestroyShadow()
		--欺骗Draw

		--local OldPos = ent:GetPos()
		
		--ent.NSPW_PROP_CL_OFFSETPOS = OPos
		--ent.NSPW_PROP_CL_OFFSETANG = OAng
		--ent:SetAngles(FAng)
		--ent.NSPW_PROP_CL_OFFSETPOS = ent:GetPos()
		--ent:SetupBones()
		local c = ent:GetColor()
		render.SetColorModulation(c.r/255,c.g/255,c.b/255)
		if isfunction(ent.Draw) then
			
			--local BPos,BAng = ent:GetPos(),ent:GetAngles()
			ent:SetPos(FPos)
			ent:SetAngles(FAng)

			ent:SetupBones()
			ent:Draw()

			ent:SetPos(ent.NSPW_PROP_CL_Origin)
			ent:SetAngles(ent.NSPW_PROP_CL_Angle)
			--ent:SetPos(BPos)
			--ent:SetAngles(BAng)
			ent:SetupBones()

		else
			ent:DrawModel()
		end
		--ent:SetupBones()
		--ent:SetupBones()

		--ent:Draw()
		--ent:SetPos(OldPos)

		--debug.setmetatable(ent, OldMeta)
		--ent:GetDrawShadow(false)
		ent.RenderOverride = function(self) 
			self:DestroyShadow()
			self:DrawShadow(false) 
		end
		--self.NSPW_WEP_CLENTS[i]:SetRenderOrigin(FPos)
		--self.NSPW_WEP_CLENTS[i]:SetRenderAngles(FAng)
		--self.NSPW_WEP_CLENTS[i]:DrawModel()
		
		
		

	end

end

function SWEP:AdjustMouseSensitivity()

	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]

	if self:GetAiming() then
		return 0.7 * (PropData.AimMouseSensMul or 1)
	end

	return 1

end


function SWEP:RequestPropInfo()

	if (self.NextRequest or 0) > 0 then
		self.NextRequest = self.NextRequest - FrameTime()
		return
	end
	
	self.NextRequest = 1
	net.Start("NSPW_TransPropTableMessage",true)
	net.SendToServer()

end

function SWEP:DrawWorldModel()

	--print("?")
	
	if !IsValid(self.DupeDataC) then
		self:RequestPropInfo()
	end

	for ent,_ in pairs(self.DupeData) do

		--local ent = self["GetPropEntity"..i](self)

		if !IsValid(ent) then continue end

		ent:SetRenderOrigin(nil)
		ent:SetRenderAngles(nil)

		ent:SetNoDraw(false)

		if ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
			ent.RenderOverride = ent.NSPW_PROP_CL_RENDEROVERRIDE
			ent.NSPW_PROP_CL_RENDEROVERRIDE = nil
			ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = nil
		end

		ent:DrawModel()
		--ent:SetParent(nil)



	end

	--别问,问就是尊重实例

	--[[local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

	render.SetColorMaterial()

	local MPos = PropData.MuzzlePos or Vector(0,0,0)

	--修改

	--print(MPos)


	MPos = LocalToWorld(MPos,Angle(),self.DupeDataC:GetNetworkOrigin(),self.DupeDataC:GetNetworkAngles())
	--print(self.DupeDataC:GetPos())

	-- Draw the sphere!
	render.DrawSphere( MPos, 50, 30, 30, Color( 0, 175, 175,100 ) )]]

end

function SWEP:ResetVM()

	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsPlayer() then
		local vm = owner:GetViewModel()
		vm:SetMaterial("")
		for i=0,vm:GetBoneCount()-1 do

			vm:ManipulateBonePosition(i,Vector())
			vm:ManipulateBoneAngles(i,Angle())

		end
	end

end

function SWEP:OnRemove()

	self:DropMySelf()
	if CLIENT then

		--[[for i=1,self:GetPropEntityCount() do

			if IsValid(self.NSPW_WEP_CLENTS[i]) then
				self.NSPW_WEP_CLENTS[i]:Remove()
			end

		end]]
		if IsValid(self.VMAnim) then self.VMAnim:Remove() end

		self:ResetVM()
		
	end

end

function SWEP:Deploy()

	local owner = self:GetOwner()

	--客户端的Draw会自己帮我们处理

	if SERVER then


		self:SetBlocking(false)

		local MyStyle = self:GetStyleData()

		if MyStyle.HolsterPrevVM or MyStyle.InvertDWHL then
			self:SendWeaponAnim(ACT_VM_HOLSTER)
		end
		--local Bone = owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0
		--local BPos,BAng = owner:GetBonePosition(Bone)

		--我们需要先设置父级,再设置子级,注意优先级

		--self.DupeDataC:SetMoveParent(self.DupeDataC)

		--self:GetWeaponViewModel():AddGestureSequence()
		--self:Think()

		--[[for ent,data in pairs(self.DupeData or {}) do

			if !IsValid(ent) then continue end

			if !ent.NSPW_PROP_OLDCOLLISIONGROUP then

				ent.NSPW_PROP_OLDCOLLISIONGROUP = ent:GetCollisionGroup()
				--print(ent.NSPW_PROP_OLDCOLLISIONGROUP == COLLISION_GROUP_WORLD)

			end

			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		end]]

		--self:Think()

	end

	return true

end

function SWEP:Holster()

	local owner = self:GetOwner()

	if SERVER then

		self.InReload = false
		self:SetAiming(false)

		for ent,data in pairs(self.DupeData or {}) do

			if !IsValid(ent) then continue end

			ent:FollowBone(NULL,0)
			--ent:SetMoveParent(owner)
			--超高级保险措施! 以后再也不用担心玩家找到了! 因为根本找不到!
			ent:SetPos(Vector(7000,7000,7000))
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

			for i=0,ent:GetPhysicsObjectCount()-1 do
				local pobj = ent:GetPhysicsObjectNum(i)
				if !IsValid(pobj) then continue end
				pobj:EnableMotion(false)
				pobj:Sleep()
			end

		end

	else

		for ent,_ in pairs(self.DupeData or {}) do

			--local ent = self["GetPropEntity"..i](self)

			if !IsValid(ent) then continue end

			ent:SetNoDraw(true)

			if !ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
				ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = true
				ent.NSPW_PROP_CL_RENDEROVERRIDE = ent.RenderOverride
				ent.RenderOverride = function(self) self:DrawShadow(false) end
			end

		end

		--复位
		self:ResetVM()

	end

	return true

end

function SWEP:TranslateFOV(fov)

	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]

	if self:GetAiming() or (self.LastAim or 0) > 0 then

		return Lerp((PropData.AimUseScope and (self.LastAimRaw or 0)*2 - 1.3 or self.LastAim or 0),fov,(fov - 15) * (PropData.AimFovMul or 1))

	end

	return fov

end

--vgui/scope_shadowmask

--我不是ZS作者所以我不会绘制超酷材质,当然你想让我用结合人的那个也不是不行
local ScopeMat = Material("vgui/scope_shadowmask_test")

function SWEP:DrawHUD()

	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]

	if PropData.AimUseScope and self.LastAim > 0.8 then
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(ScopeMat)
		surface.DrawTexturedRect(0,(ScrH()-ScrW())/2,ScrW(),ScrW())
		surface.SetDrawColor(0,0,0,Lerp(((self.LastAimRaw or 0)-1),255,0))
		surface.DrawRect(0,0,ScrW(),ScrH())
	end

end

--NSPW 主要功能


function SWEP:CanSecondaryAttack()

	--CurTime() >= self:GetNextPrimaryFire() and 
	
	return CurTime() >= self:GetNextSecondaryFire()

end

function SWEP:SecondaryAttack()

	if !self:CanSecondaryAttack() then return end

	local owner = self:GetOwner()
	if !IsValid(owner) then return end

	if SERVER then

		local MyStyle = self:GetStyleData()
		local PropData = NSPW_DATA_PROPDATA[self.DupeDataC]
			--print(!MyStyle.IsGun and !MyStyle.AlwaysBlock and !MyStyle.DoNothing)

		if owner:KeyDown(IN_USE) then
			self:DropMySelf()
		elseif !MyStyle.IsGun and !MyStyle.AlwaysBlock and !MyStyle.DoNothing then
			local oldBlock = self:GetBlocking()

			--print("?")

			self:SetBlocking(!oldBlock)
			if oldBlock then
				self:SetNextPrimaryFire(CurTime()+0.5)
			end
		elseif MyStyle.IsGun and !self.InReload and !PropData.NoAim then

			self:SetAiming(!self:GetAiming())

		end
		self:SetNextSecondaryFire(CurTime()+0.1)
	end
	--self:DropMySelf()

end

function SWEP:CanPrimaryAttack()

	local MyStyle = self:GetStyleData()
	--local Mag = MyStyle.IsGun

	return !MyStyle.NoAttack and !MyStyle.DoNothing and !self:GetBlocking() and CurTime() >= self:GetNextPrimaryFire()

end

function SWEP:PrimaryAttack()

	--print("?")
	if !self:CanPrimaryAttack() then return end
	

	local owner = self:GetOwner()

	if !IsValid(owner) then return end

		--self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if SERVER then

		if game.SinglePlayer() then
			self:CallOnClient("PrimaryAttack")
		end

		local MyStyle = self:GetStyleData()

		local time = 0.1
		--print(#self.WireIO_E2List == 0)
		local Count = 0
		self:SetNextPrimaryFire(CurTime()+0.05)
		for ent,_ in pairs(self.WireIO_E2List) do

			--print("?")
			if !IsValid(ent.entity) then continue end
			
			Count = Count + 1

			ent.data.NSPWClk = true
			ent.data.NSPWAttack = true

			ent.entity:Execute()

			ent.data.NSPWAttack = nil
			ent.data.NSPWClk = nil

		end
		if Count == 0 or self.WireIO_ShouldAttack then




			--print(self:GetHoldType())

			--Style检测

			local Ents = {}
			if MyStyle.SwingTimeMod then
				time = time + MyStyle.SwingTimeMod
			end


			local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

			if MyStyle.IsGun and PropData.IsGun then
				
				local AmmoToTake = 1

				local Heavy --= true
				local mass = 0

				for ent,_ in pairs(self.DupeData) do

					if !IsValid(ent) then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}
					if PropData.ForceHeavyWeapon then
						Heavy = true
					end

					local pobj = ent:GetPhysicsObject()
					local CV = GetConVar(ent == self.DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
					if IsValid(pobj) then 
						mass = mass + pobj:GetMass()*CV:GetFloat()
					else
						mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
					end


				end

				if mass >= GetConVar("savee_nspw_heavygun"):GetFloat() then

					Heavy = true

				end

				if (PropData.PumpAction or PropData.BoltAction) and self.NeedPump then
					
					if !PropData.FreeReload and tobool(MyStyle.DoubleHand) != tobool(PropData.DoubleHand) then
						owner:PrintMessage(4,SomeSBStuffs)
						return
					end
					self:SendVMAnim(PropData.BoltAction and ACT_VM_PRIMARYATTACK_3 or Heavy and ACT_VM_PRIMARYATTACK_DEPLOYED_1 or ACT_VM_PRIMARYATTACK_DEPLOYED)
					if !Heavy and !PropData.BoltAction then owner:EmitSound(PropData.PumpSound or "weapons/m3/m3_pump.wav",55) end
					timer.Simple(0.2, function()
						if !IsValid(self) or self:GetOwner() != owner then return end
						if Heavy or PropData.BoltAction then owner:EmitSound(PropData.PumpSound or "weapons/m3/m3_pump.wav",55) end
						self.NeedPump = false
					end)
					self:SetNextPrimaryFire(CurTime()+((PropData.BoltAction or Heavy) and 1 or 0.3))
					return
				end


				if self:Clip1() < AmmoToTake then return end

				if owner:IsPlayer() then owner:DoAttackEvent() end
				self:CallOnClient("DoAttackEvent")
				
				--self:SendWeaponAnim(ACT_VM_IDLE)
				--timer.Simple(0,function()
					--if !IsValid(self) then return end
					--self:SendWeaponAnim(ACT_VM_DRAW)
				--end)
				--self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)

				self:SendVMAnim(Heavy and ACT_VM_PRIMARYATTACK_2 or (MyStyle.DoubleHand and PropData.PumpAction) and ACT_VM_PRIMARYATTACK_1 or MyStyle.AttackActivity)

				if (Heavy or !MyStyle.DoubleHand) and PropData.PumpAction or PropData.BoltAction then

					self.NeedPump = true
				elseif PropData.PumpAction then

					timer.Simple(0.3, function()
						if !IsValid(self) or self:GetOwner() != owner then return end
						owner:EmitSound(PropData.PumpSound or "weapons/m3/m3_pump.wav",55)
					end)

				end

				self:SetClip1(self:Clip1()-AmmoToTake)

				local snd = PropData.ShootSound
				owner:EmitSound(istable(snd) and snd[math.random(1,snd)] or snd or "weapons/pistol/pistol_fire2.wav",75)

				local dmgmod = PropData.BulletDamage or 0
				local random = PropData.BulletDamageOffset or 0

				local dmg = math.random(dmgmod-random,dmgmod+random)
				--self:SetModel(self.DupeDataC:GetModel())

				local T = {owner,self}

				for ent,_ in pairs(self.DupeData) do

					table.insert(T,ent)

				end


				time = PropData.NextFireTime or time

				local MPos = PropData.MuzzlePos or Vector(0,0,0)
				local DmgType = PropData.BulletDamageType or DMG_BULLET

				local HS = PropData.BulletHullSize or 0

				local RecoilH = PropData.RecoilH or 0.1
				local RecoilV = PropData.RecoilV or 0.1

				local OffsetH = PropData.RecoilH_Offset or 0.1
				local OffsetV = PropData.RecoilV_Offset or 0.1

				local TrueRecoil = PropData.TrueRecoilMul or 0.3
				local TrueRecoilOffset = PropData.TrueRecoilMul_Offset or 0

				local Spread = PropData.BulletSpread or Angle(0,0,0)

				local Trace,MF,HitEffect = {},{},{}

				local BC = (PropData.BulletCount or 1)

				for ent,_ in pairs(self.DupeData) do 
		
					if !IsValid(ent) then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}

					if PropData.BulletTrace then
						Trace[#Trace+1] = PropData.BulletTrace
					end
					if PropData.MuzzleFlash then
						MuzzleFlash[#MuzzleFlash+1] = PropData.MuzzleFlash
					end
					if PropData.HitEffect then
						HitEffect[#HitEffect+1] = PropData.HitEffect
					end

					if ent == self.DupeDataC then continue end

					BC = BC + (PropData.BulletCount or 0)

					time = time + (PropData.NextFireTime or 0)
					MPos = MPos + (PropData.MuzzlePos or Vector(0,0,0))

					RecoilV = RecoilV * (PropData.RecoilVMul or 1)
					RecoilH = RecoilH * (PropData.RecoilHMul or 1)

					RecoilV = RecoilV + (PropData.RecoilV or 0)
					RecoilH = RecoilH + (PropData.RecoilH or 0)

					OffsetV = OffsetV + (PropData.RecoilV_Offset or 0)
					OffsetH = OffsetH + (PropData.RecoilH_Offset or 0)

					TrueRecoil = TrueRecoil + (PropData.TrueRecoilMul or 0)
					TrueRecoilOffset = TrueRecoilOffset + (PropData.TrueRecoilMul_Offset or 0)

					Spread = Spread * (PropData.BulletSpreadMul or 1)
					Spread = Spread + (PropData.BulletSpread or Angle())

				end
				--print(math.random(1,#Trace),#Trace)
				BC = math.max(1,BC)
				

				RecoilH = -math.Rand(RecoilH-OffsetH,RecoilH+OffsetH)
				RecoilV = -math.Rand(RecoilV-OffsetV,RecoilV+OffsetV)

				local Recoil = Angle(RecoilH,RecoilV,0)

				local DHand = PropData.DoubleHand

				local AccPunishMul = 1

				if !MyStyle.DoubleHand and DHand then --重量检测

					Recoil = Recoil * GetConVar("savee_nspw_damage_gun_twohandrecoilpunish"):GetFloat()

					AccPunishMul = GetConVar("savee_nspw_damage_gun_twohandaccpunish"):GetFloat()

				end


				MPos = self.DupeDataC:LocalToWorld(MPos)

				--local HPos = owner:IsPlayer() and owner:GetEyeTrace().HitPos or util.QuickTrace(owner:EyePos(),owner:GetAimVector(),owner).HitPos

				for i=1,BC do
					--local AimVec = (HPos-MPos):GetNormalized()
					local Trace = {Trace[math.random(1,#Trace)]}
					local MF = {MF[math.random(1,#MF)]}
					local HitEffect = {HitEffect[math.random(1,#HitEffect)]}
					
					local AimVec = owner:GetAimVector()
					if Spread != Angle(0,0,0) then

						local bs = Spread
						local p,y,r = bs.p,bs.y,bs.r
						p = p * AccPunishMul
						y = y * AccPunishMul
						r = r * AccPunishMul
						p = math.Rand(-p,p)
						y = math.Rand(-y,y)
						r = math.Rand(-r,r)
						AimVec:Rotate(Angle(p,y,r))

					end

					--[[self:FireBullets({
						Attacker = owner,
						Callback = function(attacker,tr,dinfo)
							if isfunction(PropData.BulletCallback) then
								PropData.BulletCallback(self,attacker,tr,dinfo)
							end
							--print("?")
						end,
						Damage = dmg,
						Force = PropData.BulletForce or dmg/10,
						Distance = PropData.BulletDistance or 56756,
						HullSize = PropData.BulletHullSize or 0,
						Num = 1,
						Src = MPos,
						Dir = AimVec,
						IgnoreEntity = T,
					})]]

					local tr = {
						maxs = Vector(HS,HS,HS),
						mins = Vector(-HS,-HS,-HS),
						start = owner:EyePos(),
						endpos = owner:EyePos()+AimVec*(PropData.BulletDistance or 56756),
						mask = MASK_SHOT,
						filter = T,
					}

					if PropData.BulletHullSize then
						tr = util.TraceHull(tr)
					else
						tr = util.TraceLine(tr)
					end
					local trwater = util.TraceLine({
						start = MPos,
						endpos = tr.HitPos,
						mask = MASK_WATER,
						filter = T,
					})


					TrueRecoil = math.Rand(TrueRecoil-TrueRecoilOffset,TrueRecoil+TrueRecoilOffset)
					if owner:IsPlayer() then
						owner:ViewPunch(Recoil*(MyStyle.RecoilMul or 1))
						owner:SetEyeAngles(owner:EyeAngles()+Recoil*TrueRecoil*(MyStyle.RecoilMul or 1))
					end

					if tr.Hit then

						--local

						local Dmginfo = DamageInfo()
						--Dmginfo:SetHit
						if tr.HitGroup == HITGROUP_HEAD then
							dmg = dmg * GetConVar("savee_nspw_damage_gun_headshotmult"):GetFloat()
						end

						local Force = 500

						if tr.Entity:Health() <= dmg and tr.Entity:GetMaxHealth() > 0 then
							Force = Force*3
						end

						Dmginfo:SetDamage(dmg)
						Dmginfo:SetDamageType(DmgType)
						Dmginfo:SetDamageForce(AimVec*Force*(PropData.BulletForce or 1))
						Dmginfo:SetDamagePosition(tr.HitPos)
						Dmginfo:SetReportedPosition(tr.HitPos)
						Dmginfo:SetInflictor(self.DupeDataC)
						Dmginfo:SetAttacker(owner)

						for ent,_ in pairs(self.DupeData) do

							if !IsValid(ent) then continue end

							local PropData = NSPW_DATA_PROPDATA[ent] or {}

							if isfunction(PropData.BulletCallback) then
								--print("?")
								PropData.BulletCallback(self,owner,tr,Dmginfo,function(v)
									Trace[#Trace + 1] = v
								end,function(v)
									MF[#MF + 1] = v
								end,function(v)
									HitEffect[#HitEffect + 1] = v
								end)
							end

						end
						tr.Entity:TakeDamageInfo(Dmginfo)
					end

					--print(AimVec)

					Trace = Trace[math.random(1,#Trace)]
					MF = MF[math.random(1,#MF)]
					HitEffect = HitEffect[math.random(1,#HitEffect)]

					--虽然util.Effect可以同步到客户端(多人),但是我们要求精细化(神他妈方格弹孔)
					if !game.SinglePlayer() then
						--Trace数据不重要,它就是一特效
						net.Start("NSPW_TransTraceMessage",true)
							net.WriteEntity(self)
							net.WriteFloat(MPos.x)
							net.WriteFloat(MPos.y)
							net.WriteFloat(MPos.z)
							net.WriteFloat(AimVec.x)
							net.WriteFloat(AimVec.y)
							net.WriteFloat(AimVec.z)
							net.WriteTable(T)
							net.WriteString(HitEffect or "Impact")
							net.WriteString(Trace or "Tracer")
							net.WriteUInt(PropData.MuzzleFlashFL or 1,5)
							net.WriteString(MF or "MuzzleFlash")
						net.Broadcast()
					else --单人模式下可以直接在服务端发粒子
						local ed = EffectData()
						ed:SetOrigin( tr.HitPos )
						ed:SetNormal(tr.HitNormal)
						ed:SetEntity(tr.Entity)
						ed:SetDamageType(DMG_BULLET)
						ed:SetStart(MPos)
						ed:SetSurfaceProp(tr.SurfaceProps)
						--ed:SetEntity(self)
						util.Effect( HitEffect or "Impact", ed )
						if (tr.MatType == MAT_ANTLION or tr.MatType == MAT_FLESH) and IsValid(tr.Entity) and tr.Entity:GetMaxHealth() > 0 then

							util.Effect( "BloodImpact", ed )

						end
						--local ed = EffectData()
						ed:SetOrigin( trwater.HitPos )
						ed:SetScale(5)
						util.Effect( "waterripple", ed )

						ed:SetScale(GetConVar("savee_nspw_debug_slowtrace"):GetBool() and 100 or 10000)
						--print(Trace)
						util.Effect( Trace or "Tracer", ed )

						ed = EffectData()
						ed:SetAttachment(1)
						ed:SetAngles(Angle())
						ed:SetOrigin(MPos)
						ed:SetFlags(PropData.MuzzleFlashFL or 1)

						ed:SetEntity(self.DupeDataC)
						util.Effect(MF or "MuzzleFlash",ed)

					end

				end

				if self:GetAiming() then

					time = time + 0.03

				end

				self:SetNextPrimaryFire(CurTime()+math.max(0.02,time))
			elseif !MyStyle.IsGun then

				self:Swing(owner,PropData,MyStyle)

			end

		end

		--print("?")
	else

	end


end

SWEP.OnDrop = SWEP.OnRemove

function SWEP:GetNPCBurstSettings()

	if !self.Initialized or !self.DupeDataC then return end

	local MyStyle = self:GetStyleData()

	local time = 0.1
	--print(#self.WireIO_E2List == 0)
	local Count = 0




	--print(self:GetHoldType())

	--Style检测

	--local Ents = {}
	--local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		local Heavy --= true
		local mass = 0
		time = PropData.NextFireTime or time

		for ent,_ in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == self.DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				mass = mass + pobj:GetMass()*CV:GetFloat()
			else
				mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end
			time = time + (PropData.NextFireTime or 0)


		end

		if mass >= GetConVar("savee_nspw_heavygun"):GetFloat() then

			Heavy = true

		end

		if PropData.PumpAction then
			return 1,1,1
		end

		return time < 0.65 and 2 or 1,time < 0.45 and 5 or 2,time


			

	elseif !MyStyle.IsGun then

		return 1,1,1

	end


end

function SWEP:GetNPCBulletSpread(pro)

	if !self.Initialized or !self.DupeDataC then return end

	local MyStyle = self:GetStyleData()




	--print(self:GetHoldType())

	--Style检测

	--local Ents = {}
	--local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		local Heavy --= true
		local mass = 0
		time = PropData.NextFireTime or time
		local Spread = PropData.BulletSpread or Angle(0,0,0)

		for ent,_ in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == self.DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				mass = mass + pobj:GetMass()*CV:GetFloat()
			else
				mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end

			Spread = Spread * (PropData.BulletSpreadMul or 1)
			Spread = Spread + (PropData.BulletSpread or Angle())


		end

		if mass >= GetConVar("savee_nspw_heavygun"):GetFloat() then

			Heavy = true

		end

		if PropData.PumpAction then
			return 15/pro
		end

		--Spread = (Spread.y+Spread.r)/2

		return math.max(4*(Heavy and 1.6 or 1)-pro,0.05)


			

	elseif !MyStyle.IsGun then

		return 0

	end


end

function SWEP:GetNPCRestTimes()

	if !self.Initialized or !self.DupeDataC then return end

	local MyStyle = self:GetStyleData()

	local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[self.DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		time = PropData.NextFireTime or time

		for ent,_ in pairs(self.DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			time = time + (PropData.NextFireTime or 0)


		end

		return time-0.05,time+0.1


			

	elseif !MyStyle.IsGun then

		return 0,0

	end

end


SWEP.ActivityTranslateAINSPW = {
	["melee"] = {
		--[1] = ACT_IDLE_MELEE,
		[ACT_IDLE] = ACT_IDLE_ANGRY_MELEE,
		[ACT_IDLE_ANGRY] = ACT_IDLE_ANGRY_MELEE,
		[ACT_IDLE_AGITATED] = ACT_IDLE_ANGRY_MELEE,
		[ACT_IDLE_AIM_AGITATED] = ACT_IDLE_ANGRY_MELEE,
		[ACT_IDLE_AIM_RELAXED] = ACT_IDLE_ANGRY_MELEE,
		[ACT_IDLE_RELAXED] = ACT_IDLE_ANGRY_MELEE,
		[ACT_RUN] = ACT_RUN,
		[ACT_WALK] = ACT_WALK,
		[ACT_RUN_AIM] = ACT_RUN,
		[ACT_WALK_AIM] = ACT_WALK,
		[ACT_WALK_ANGRY] = ACT_WALK,
		--[ACT_RANGE_ATTACK1] = ACT_MELEE_ATTACK1,
		--[ACT_RANGE_ATTACK1_LOW] = ACT_MELEE_ATTACK1,
		[ACT_MELEE_ATTACK1] = ACT_MELEE_ATTACK_SWING,
		[ACT_MELEE_ATTACK2] = ACT_MELEE_ATTACK_SWING,
	},
	["shotgun"] = {
		[ACT_CROUCHIDLE_AIM_STIMULATED] = ACT_RANGE_AIM_AR2_LOW,
		[ACT_CROUCHIDLE_AGITATED] = ACT_RANGE_AIM_AR2_LOW,
		[ACT_CROUCHIDLE_STIMULATED] = ACT_CROUCHIDLE_STIMULATED,
	},
	["pistol"] = {
		[ACT_CROUCHIDLE_AIM_STIMULATED] = ACT_RANGE_AIM_PISTOL_LOW,
		[ACT_CROUCHIDLE_AGITATED] = ACT_RANGE_AIM_PISTOL_LOW,
		[ACT_CROUCHIDLE_STIMULATED] = ACT_CROUCHIDLE_STIMULATED,
	}
}

function SWEP:TranslateActivity( act )

	if ( self:GetOwner():IsNPC() ) then
		local ht = self.HoldType
		--print(self.ActivityTranslateAINSPW[ht] and self.ActivityTranslateAINSPW[ht][act])
		self:SetupWeaponHoldTypeForAI(self.HoldType)
		if self.ActivityTranslateAINSPW[ht] and self.ActivityTranslateAINSPW[ht][act] then
			--print(act)
			return self.ActivityTranslateAINSPW[ht][act]
		elseif self.ActivityTranslateAI[act] then
			return self.ActivityTranslateAI[act]
		end
		return -1
	elseif ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end

	return -1

end

function SWEP:GetCapabilities()
	local ht = self.HoldType
	if ht == "melee" then 
		--print("?")
		return CAP_WEAPON_MELEE_ATTACK1 
	end
	return bit.bor(
		CAP_WEAPON_MELEE_ATTACK1,
		CAP_WEAPON_RANGE_ATTACK1,
		CAP_INNATE_RANGE_ATTACK1)
end
--SWEP.OwnerChanged = SWEP.OnRemove


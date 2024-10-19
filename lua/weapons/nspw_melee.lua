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

-- 仅攻击裆部的NPC列表,适合某些跑得快的东西
local bodyOnly = {
	["npc_fastzombie"] = true,
}

local LeftArmBone = {
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,
	["ValveBiped.Bip01_L_Ulna"] = true,
	["ValveBiped.Bip01_L_Wrist"] = true,
	["ValveBiped.Bip01_L_Elbow"] = true,
	["ValveBiped.Bip01_L_Bicep"] = true,
	["ValveBiped.Bip01_L_Shoulder"] = true,
	["ValveBiped.Bip01_L_Trapezius"] = true,
	["ValveBiped.Bip01_L_Finger0"] = true,
	["ValveBiped.Bip01_L_Finger01"] = true,
	["ValveBiped.Bip01_L_Finger02"] = true,
	["ValveBiped.Bip01_L_Finger1"] = true,
	["ValveBiped.Bip01_L_Finger11"] = true,
	["ValveBiped.Bip01_L_Finger12"] = true,
	["ValveBiped.Bip01_L_Finger2"] = true,
	["ValveBiped.Bip01_L_Finger21"] = true,
	["ValveBiped.Bip01_L_Finger22"] = true,
	["ValveBiped.Bip01_L_Finger3"] = true,
	["ValveBiped.Bip01_L_Finger31"] = true,
	["ValveBiped.Bip01_L_Finger32"] = true,
	["ValveBiped.Bip01_L_Finger4"] = true,
	["ValveBiped.Bip01_L_Finger41"] = true,
	["ValveBiped.Bip01_L_Finger42"] = true,
}
local RightArmBone = {
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Hand"] = true,
	["ValveBiped.Bip01_R_Ulna"] = true,
	["ValveBiped.Bip01_R_Wrist"] = true,
	["ValveBiped.Bip01_R_Elbow"] = true,
	["ValveBiped.Bip01_R_Bicep"] = true,
	["ValveBiped.Bip01_R_Shoulder"] = true,
	["ValveBiped.Bip01_R_Trapezius"] = true,
	["ValveBiped.Bip01_R_Finger0"] = true,
	["ValveBiped.Bip01_R_Finger01"] = true,
	["ValveBiped.Bip01_R_Finger02"] = true,
	["ValveBiped.Bip01_R_Finger1"] = true,
	["ValveBiped.Bip01_R_Finger11"] = true,
	["ValveBiped.Bip01_R_Finger12"] = true,
	["ValveBiped.Bip01_R_Finger2"] = true,
	["ValveBiped.Bip01_R_Finger21"] = true,
	["ValveBiped.Bip01_R_Finger22"] = true,
	["ValveBiped.Bip01_R_Finger3"] = true,
	["ValveBiped.Bip01_R_Finger31"] = true,
	["ValveBiped.Bip01_R_Finger32"] = true,
	["ValveBiped.Bip01_R_Finger4"] = true,
	["ValveBiped.Bip01_R_Finger41"] = true,
	["ValveBiped.Bip01_R_Finger42"] = true,
}

local GameIsSP = game.SinglePlayer() --他们来了,他们去了,你想的那个人永远不会来到

local DebugMessageDraw = !true

--这里不会对它做变动所以直接拿原来的
--我知道这么做肯定会减兼容性,这没办法(就像Arc9对INVSYS那样,虽然他们没义务这么做)
--但是如果不这么整你将不能拿起你亲爱的探鬼仪然后把它们轮到GM13 Construct的鬼的脸上

--该值用于处理一些修改过Metatable的实体
--至于值不同步... 别问我
local EntMeta = FindMetaTable("Entity")
--给客户端用的,或许也有其他地方能用
local ModEntMeta = table.Copy(EntMeta)
local LOCALVAL_POS,LOCALVAL_ANG = Vector(),Angle()
function ModEntMeta:GetPos()
	return LOCALVAL_POS
end
function ModEntMeta:LocalToWorld(Vec)
	return LOCALVAL_POS
end
function ModEntMeta:GetAngles()
	return LOCALVAL_ANG
end

local function DebugMessage(...)

	if !GetConVar("savee_nspw_debugprint"):GetBool() then return end

	local tbl = {...}

	--下一Tick恢复

	if DebugMessageDraw then
		print("---------------==========START NSP2W DEBUG PRINT START==========---------------")
		DebugMessageDraw = false
	end

	for _,v in pairs(tbl) do

		if istable(v) then 
			print("-----===NewLine===-----")
			PrintTable(v)
			print("-----===NewLine===-----")
		else
			print(v)
		end

	end



	timer.Create("NSPW_DEBUG_RESETTIMER",0,1,function()
		print("---------------==========ENDOF NSP2W DEBUG PRINT ENDOF==========---------------")
		DebugMessageDraw = true
	end)

end

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
		AttackStart = 0.1,
		AttackEnd = 0.25,
		AttackVM = 0,
		VM = "models/weapons/c_nspw_melee.mdl",
	},
	["melee2"] = {
		Name = "Two-Handed",
		Desc = "Hold your weapon with both of your hand \n Just like swing an axe!",
		Goods = "Less swing cooldown time",
		Bads = "Shorter attack distance \n (Still one-handed in viewmodel)",
		SwingTimeMod = 0.3,
		AttackStart = 0.15,
		AttackEnd = 0.4,
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

SWEP.ViewModel = "models/weapons/c_nspw_melee.mdl"
SWEP.WorldModel = "models/weapons/cstrike/c_knife_t.mdl" --实际上这玩意啥也不是

SWEP.NextReload = 0

if SERVER then

	--该表记录已经攻击过的敌人

	SWEP.Attacked = {}
	SWEP.MeleeHitTriggered = false

	SWEP.NeedPump = false

else

	SWEP.NextRequestData = 1
	SWEP.DupeDataInitialized = false

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

--DupeData构成: DupeDataC和Data(原self.DupeData)
function SWEP:GetDupeData(Slot)

	--print(self.Removing)
	if CLIENT then
		--PrintTable(self.DupeData)
	end
	if !self.Initialized or self.Removing or !self.DupeData then return end
	--print("1")
	if #self.DupeData < 1 then 
		if SERVER then self:Remove() end
		return
	end
	Slot = Slot or self:GetCurSlot()
	local DupeData = self.DupeData[Slot] or {}
	local DupeDataC = DupeData.DupeDataC
	if !DupeDataC then
		if SERVER then self:ChangeSlot(Slot-1,true) end
		return 
	end

	return Slot,DupeData.Data,DupeDataC,DupeData

end

function SWEP:ChangeSlot(to,noholster)

	if to == 0 then to = 1 end
	--print("?")
	--if !self.DupeData[to] then print("CINEMAR") return end
	if !noholster then self:Holster_Slot(self:GetSlot()) end


	--local _,_,datac = self:GetDupeData()
	local _,_,todatac,rawData = self:GetDupeData(to)


	self:SetCurSlot(to)
	self:NextThink(CurTime()+0.1)


	if SERVER then

		if rawData.Style then
			self:SetStyle(rawData.Style)
		end

		self.WireIO_E2List = {}
		self.WireIO_ShouldAttack = true
		self.WireIO_ShouldBlock = true
	end

	if todatac.NSPW_GUNCLIP1 then self:SetClip1(todatac.NSPW_GUNCLIP1) end

	self:Deploy()

end

--print("WOSHISHABI")
function SWEP:SetupDataTables()

	self:NetworkVar("Int",0,"CurSlot")
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

	if self:GetCurSlot() == 0 then
		self:SetCurSlot(1)
	end

	local DefineTable = { --这玩意有意义?
		--[[HoldType = "melee",
		WireIO_E2List = {},
		WireIO_ShouldAttack = true,
		WireIO_ShouldBlock = true,]]
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

		--self.

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

	
	--print(self)
	return Style[self.LastStyle or self.HoldType or (!self.MarkedAsLambdaWep and self:GetHoldType() or "pistol")] or {}

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

		local _,_,_,data = self:GetDupeData()
		data.Style = s

		self:SetBlocking(false)


	end

	function SWEP:ThinkHandlePropPosition(owner)

		--print(self:Get)
		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end
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

		local DPos = DupeData[DupeDataC].Pos
		local DAng = DupeData[DupeDataC].Angle
			--print(owner:GetPoseParameterName(3))
		if DupeDataC:GetParent() != owner then

			local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}
			--BAng.p = 0
			--困扰撒蜜蜂114514年的bug-1
			--local FPos,FAng = LocalToWorld(DPos, DAng+Angle(0,0,180),BPos,owner:EyeAngles())
			DupeDataC:FollowBone(owner, Bone)
			--DupeDataC:SetParent(owner, 13)
			--DupeDataC:SetPos(DPos+Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
			--DupeDataC:SetAngles(FAng+(PropData.OffsetAng or Angle()))
			DupeDataC:SetLocalPos(Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
			DupeDataC:SetLocalAngles(Angle(0,0,180)+(PropData.OffsetAng or Angle()))
			
		end
			--DupeDataC:SetAngles(DAng)

		--一些东西早就有了
		for ent,data in pairs(DupeData) do

			if !IsValid(ent) then continue end

			hook.Run(_NSPW_HOOK_NAME_ONTHINK_PROP,ent,ply,wep)


			local pobj = ent:GetPhysicsObject()

			if IsValid(pobj) then
				--pobj:EnableCollisions(false)
				if ent.NSPW_PROP_NOCONSTRAINT then
					pobj:EnableMotion(true)
					pobj:Wake()
					--print(ent)
				else
					pobj:EnableMotion(false)
					pobj:SetPos(ent:GetPos()) --防止位置出问题
					pobj:SetAngles(ent:GetAngles()) --防止角度出问题
					pobj:Sleep()
				end
			end

			if !ent.NSPW_PROP_MYPARENT then
				ent.NSPW_PROP_MYPARENT = ent:GetParent()
			end

			local Pos = data.Pos
			local Ang = data.Angle

			--local NewPos = Pos-DPos
			--NewPos:Rotate(DAng)

			if ent != DupeDataC and EntMeta.GetParent(ent) != DupeDataC and !ent.NSPW_PROP_NOCONSTRAINT then
				--print("CALL")
				--[[local FPos,FAng = LocalToWorld(
					Pos,
					Ang,
					DupeDataC:GetPos(),
					DupeDataC:GetAngles()
				)
				ent:SetPos(FPos)
				ent:SetAngles(FAng)]]
				--print("WAITWUT?")
				EntMeta.SetParent(ent,DupeDataC)
				EntMeta.SetLocalPos(ent,Pos)
				EntMeta.SetLocalAngles(ent,Ang)
				--print(ent)
				--ent:SetPos(Pos)
				--ent:SetAngles(Ang)
				--ent:SetAngles(Ang-BAng)
			elseif ent.NSPW_PROP_NOCONSTRAINT then
				EntMeta.SetParent(ent,ent.NSPW_PROP_MYPARENT)
				--print(ent:GetMoveParent())
			end

			--if !ent.NSPW_PROP_NOCONSTRAINT then
				EntMeta.SetCollisionGroup(ent,COLLISION_GROUP_DEBRIS)
			--end
			ent:SetCustomCollisionCheck(true)

			ent:SetNWVector("NSPW_PROP_NW_POS",ent:GetPos())
			ent:SetNWAngle("NSPW_PROP_NW_ANG",ent:GetAngles())
			ent.NSPW_PROP_RELATEDWEAPON = self

		end

	end

	function SWEP:ThinkHandleAttack(owner)

		local on = self.MeleeAttacking
		--owner:SetSequence(self.OwnerSwingSeq)

		if !on then return end
		

		local start = self.MeleeAttackStart
		local endtime = self.MeleeAttackEnd

		if CurTime() < start then return end

		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end

		if on and CurTime() > endtime then

			self.Attacked = {}
			self.MeleeAttacking = false
			--print("??")
			--self.MeleeHit = false
			self.MeleeHitTriggered = false

			for ent,_ in pairs(DupeData) do

				ent.NSPW_MeleeHitTriggered = false

			end

			return

		end

		local Ents = {}

		for _,data in pairs(self.DupeData) do

			for ent,_ in pairs(data.Data) do
				if !IsValid(ent) then continue end

				Ents[#Ents+1] = ent
			end

		end

		local filter = table.Copy(Ents)

		table.Add(filter, {self,owner})
		table.Add(filter,self.Attacked)

		local Hit

		for _,ent in pairs(Ents) do

			if !IsValid(ent) then continue end

			local tr = util.TraceEntityHull({
				start = ent:GetPos()-owner:GetAimVector()*5,
				endpos = ent:GetPos()+owner:GetAimVector()*40,
				ignoreworld = true,
				filter = filter,
				mask = MASK_ALL
			}, ent)

			if IsValid(tr.Entity) then
				local trd = util.TraceLine({
					start = ent:GetPos(),
					endpos = (isfunction(owner.GetShootPos) and owner:GetShootPos() or owner:EyePos()),
					filter = filter,
					mask = MASK_SHOT_PORTAL
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
				EntMeta.TakeDamageInfo(tr.Entity,Dmginfo)
				self.Attacked[#self.Attacked+1] = tr.Entity

				if !ent.NSPW_MeleeHitTriggered then

					local tempval = PropData.MeleeHitSound

					ent.NSPW_MeleeHitTriggered = true
					
					owner:EmitSound(
						istable(tempval) and tempval[math.random(1,#tempval)] or
						tempval or "")

					tempval = PropData.MeleeHitEffect

					--PrintTable(PropData)

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

		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end

		local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

		if !DupeDataC.NSPW_GUNCLIP1 then
			DupeDataC.NSPW_GUNCLIP1 = PropData.Magsize
			self:SetClip1(PropData.Magsize)
		else
			DupeDataC.NSPW_GUNCLIP1 = self:Clip1()
		end

		local magsize = PropData.Magsize

		for ent,_ in pairs(DupeData) do 
		
			if !IsValid(ent) or ent == DupeDataC then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			magsize = magsize + (PropData.Magsize or 0)

		end

		self.Primary.ClipSize = magsize

		if owner:IsNPC() and IsValid(owner:GetEnemy()) then


			local dist = owner:GetPos():DistToSqr(owner:GetEnemy():GetPos())
			--print(self.MeleeAttacking)
			if self.HoldType == "shotgun" and dist > 250000  then
				owner:SetCondition(39)
				--owner:SetSchedule(SCHED_MOVE_TO_WEAPON_RANGE)
			elseif dist <= 6400 and !owner:IsCurrentSchedule(SCHED_MELEE_ATTACK1) and owner:SelectWeightedSequence(ACT_MELEE_ATTACK1) != - 1 then
				--[[local oldht = self.HoldType
				if owner:SelectWeightedSequence(ACT_MELEE_ATTACK1) < 0 then
					self.HoldType = "melee"
					owner:SetActivity(ACT_MELEE_ATTACK_SWING)
				end]]
				local SelectedSequence = owner:SelectWeightedSequence(ACT_MELEE_ATTACK1)
				if SelectedSequence < 0 then
					--local old = self.HoldType
					--self:SetHoldType("melee")
					SelectedSequence = owner:SelectWeightedSequence(ACT_MELEE_ATTACK_SWING)
					--print(owner:GetSequenceName(SelectedSequence))
					--self:SetHoldType(old)
					
				end

				--print("AA")

				local Dur = owner:SequenceDuration(SelectedSequence)
				owner:ClearSchedule()
				owner:ClearGoal()
				owner:SetSchedule(SCHED_MELEE_ATTACK1)
				--owner:StartEngineTask(113, 5)
				owner:SetSequence(SelectedSequence)
				--owner:ResetSequence(SelectedSequence)
				--owner:FrameAdvance(1)
				--owner:TaskComplete()

				self.OwnerSwingSeq = SelectedSequence
				self:Swing(owner,PropData,self:GetStyleData())
					--self.HoldType = oldht
				--end)
				--print("1")
				--owner:SetSchedule(SCHED_MOVE_TO_WEAPON_RANGE)
			end

			if owner:GetMoveVelocity():LengthSqr() <= 1600 then
				self:SetAiming(true)
			else
				self:SetAiming(false)
			end

			if owner:GetActivity() == ACT_RANGE_ATTACK1 then
				self:PrimaryAttack()
			end

			--[[if self:Clip1() == 0 then
				--owner:SetSchedule(SCHED_RELOAD)
			end]]

		end

	end

	function SWEP:ThinkHandleGunReload(owner)

		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end

		local MyStyle = self:GetStyleData()
		local PropData = NSPW_DATA_PROPDATA[DupeDataC]

		local Mul = 1

		local Heavy
		local NoMag = PropData.NoMag
		local mass = 0

		for ent,_ in pairs(DupeData) do 
		
			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			Mul = Mul / (PropData.ReloadSpeedMul or 1)
			Mul = Mul + (PropData.ReloadSpeedMulOffset or 0)

			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			if PropData.IsMag then
				NoMag = false
			end

			local pobj = ent:GetPhysicsObject()

			local CV = ent == DupeDataC and 1 or GetConVar("savee_nspw_gun_childrenmassmul"):GetFloat()
			if IsValid(pobj) then 
				mass = mass + pobj:GetMass()*CV
			else
				mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV
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

				for ent,_ in pairs(DupeData) do 

					if !IsValid(ent) or ent == DupeDataC then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}
					magsize = magsize + (PropData.Magsize or 0)

				end
				
				if self.ReloadStage == 0 then

					--self:SendVMAnimSequence("anim_reload_sg")


					--ZS模拟器
					if self:Clip1() == magsize or (!self.MarkedAsLambdaWep and !owner:KeyDown(IN_RELOAD)) then 
						self:SendVMAnim((Heavy or !self.NeedPump or !self.InsertedSlug) and ACT_SHOTGUN_RELOAD_FINISH or ACT_VM_RELOAD_DEPLOYED)
						--print(Heavy , !self.NeedPump)
						self:SetBlocking(false)
						if !Heavy and self.NeedPump then 
							self.ReloadAmmoTime = CurTime() + 0.5
							self.ReloadStage = 2
							self.NeedPump = false 
							self:SetNextPrimaryFire(CurTime()+1.5)
							
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

					
					local ac = self.MarkedAsLambdaWep and 9999 or owner:GetAmmoCount(PropData.AmmoType or "pistol")
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

					if owner:IsPlayer() then owner:SetAmmo(ac-1, PropData.AmmoType or "pistol") end

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
				self:SendVMAnim(
				(PropData.MagOnBack and ACT_DOD_RELOAD_GARAND) 
				or (PropData.MagOnFront and ACT_DOD_RELOAD_RIFLE)
				or ACT_VM_RELOAD)
				self.ReloadAmmoTime = CurTime()+0.45*Mul*(MyStyle.ReloadTime or 1)/3 --(MyStyle.ReloadTime or 1)*Mul
				self.ReloadStage = 0
				self:SetBlocking(true)
				for ent,_ in pairs(DupeData) do 
			
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

					for ent,_ in pairs(DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ClipOut

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							elseif istable(TargetVal) then
								owner:EmitSound(TargetVal[math.random(1,#TargetVal)],55)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+0.65*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 1
				elseif self.ReloadStage == 1 then

					for ent,_ in pairs(DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ChangeClip

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							elseif istable(TargetVal) then
								owner:EmitSound(TargetVal[math.random(1,#TargetVal)],55)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+(MyStyle.DoubleHand and 0.7 or 0.35)*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 2

				elseif self.ReloadStage == 2 then

					for ent,_ in pairs(DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_ClipIn

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							elseif istable(TargetVal) then
								owner:EmitSound(TargetVal[math.random(1,#TargetVal)],55)
							else
								owner:EmitSound(TargetVal,55)
							end

						end


					end

					self.ReloadAmmoTime = CurTime()+0.7*Mul*(MyStyle.ReloadTime or 1)/3 
					self.ReloadStage = 3

				elseif self.ReloadStage == 3 then

					for ent,_ in pairs(DupeData) do 
			
						if !IsValid(ent) then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						local TargetVal = PropData.ReloadEvent_LoadGun

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							elseif istable(TargetVal) then
								owner:EmitSound(TargetVal[math.random(1,#TargetVal)],55)
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

					for ent,_ in pairs(DupeData) do 

						if !IsValid(ent) or ent == DupeDataC then continue end

						local PropData = NSPW_DATA_PROPDATA[ent] or {}
						magsize = magsize + (PropData.Magsize or 0)

						local TargetVal = PropData.ReloadEvent_End

						if TargetVal then

							if isfunction(TargetVal) then 
								TargetVal(self,owner)
							elseif istable(TargetVal) then
								owner:EmitSound(TargetVal[math.random(1,#TargetVal)],55)
							else
								owner:EmitSound(TargetVal,55)
							end

						end

					end

					local ac = self.MarkedAsLambdaWep and 9999 or owner:GetAmmoCount(PropData.AmmoType or "pistol") + self:Clip1()
					local mag = math.min(ac,magsize)
					if owner:IsPlayer() then owner:SetAmmo(ac-mag, PropData.AmmoType or "pistol") end
					self:SetClip1(mag)
					--self.Primary.ClipSize = magsize
					self:SetBlocking(false)


					self.InReload = false
					--self:SendWeaponAnim(ACT_VM_IDLE)
					--self:SendVMAnim(ACT_VM_IDLE)

				end

			end
		end


	end

	function SWEP:Reload()

		local owner = self:GetOwner()

		if !IsValid(owner) then
			self:Remove()
			return
		end

		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end

		--self:SendVMAnimSequence("anim_fire")

		if self.NextReload > CurTime() then return end

		self:SetAiming(false)

		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

		if (self.MarkedAsLambdaWep or !owner:KeyDown(IN_USE)) and !self:GetBlocking() and MyStyle.IsGun and PropData.IsGun and self:Clip1() < self:GetMaxClip1() and !self.InReload then

			--print("SEND")
			if !PropData.FreeReload and tobool(MyStyle.DoubleHand) != tobool(PropData.DoubleHand) then
				owner:PrintMessage(4,SomeSBStuffs) --翻译...
				--return
			else
				if owner:IsPlayer() then owner:DoReloadEvent() end
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

		if GameIsSP then
			self:CallOnClient("Reload")
		end

		self.NextReload = CurTime()+0.1
		--owner:PrintMessage(4, "JB")

	end

	function SWEP:Swing(owner,PropData,MyStyle)

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

		--local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}
		local time = 0.1

		if owner:IsPlayer() then owner:DoAttackEvent() end
		self:CallOnClient("DoAttackEvent")

		--timer.Simple(MyStyle.AttackVM,function()
			--if !IsValid(self) then return end
			self:SendWeaponAnim(ACT_VM_MISSCENTER)
		--end)

		owner:EmitSound("weapons/slam/throw.wav",75,math.random(90,140))

		for ent,_ in pairs(DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}

			time = time + (PropData.AttackTimeModify or 0)

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				time = time + pobj:GetMass()*CV:GetFloat()
			else
				time = time + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end

				--time = time*GetConVar("savee_nspw_damage_mult"):GetFloat()
			--print(time)

		end

		local Dur = owner:SequenceDuration(self.OwnerSwingSeq or owner:GetSequence())
		--print(Dur,owner:GetSequenceName(owner:GetSequence()))


		self.MeleeAttackStart = CurTime()+(owner:IsPlayer() and MyStyle.AttackStart or Dur*0.35)
		self.MeleeAttackEnd = CurTime()+(owner:IsPlayer() and MyStyle.AttackEnd or Dur*0.55)

		self.MeleeAttacking = true
		self:SetNextPrimaryFire(owner:IsPlayer() and CurTime()+math.max(0.3,time) or 0)


	end	

else

	local sdraw = include("saveelib/cl_saveelib_draw.lua")

	local NSPW_SettingMenu

	local List = {
		{
			Name = "[Style]",
			Tip = "Select weapon's holdtype",
			Function = function()
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

						--if !i then continue end

						if c == input.GetKeyCode(input.LookupBinding("slot"..i) or "") then

							B:DoClick()

						end

					end

				end
				--这是成为主体的部分
				return f
			end,
		},
		{
			Name = "[Slot]",
			Tip = "Change your weapon",
			Function = function(self)
				local f = vgui.Create("DFrame")

				f:MakePopup()
				f:SetSize(220,600)
				f:Center()

				local dsp = vgui.Create( "DScrollPanel", f )
				dsp:Dock( FILL )

				local StyleBtns = {}

				for i,data in pairs(self.DupeData) do
					local Index = #StyleBtns + 1
					local Btn = dsp:Add( "DButton" )
					Btn:SetSize(200,200)
					Btn:SetText("")--"["..Index.."]"..data.Name )
					Btn:Dock( TOP )
					Btn:DockMargin( 0, 0, 0, 5 )
					Btn:SetToolTip("LMB: Select|RMB: Drop")

					function Btn:DoRightClick()

						net.Start("NSPW_TransMiscMessage")
							net.WriteUInt(0,4)
							net.WriteBool(true)
							net.WriteUInt(i,8)
						net.SendToServer()

						self:Remove()

					end

					function Btn:DoClick()

						--self:DoRightClick()
						net.Start("NSPW_TransMiscMessage")
							net.WriteUInt(0, 4)
							net.WriteBool(false)
							net.WriteUInt(i, 8)
						net.SendToServer()
						f:Remove()

					end

					Btn.Paint = function(Btn,w,h)

						draw.RoundedBox(5, 0,0,w,h,Color(25,25,25))
						local Slot,DupeData,DupeDataC,Raw = self:GetDupeData(i)
						if !Slot then return end

						local NSPW_DrawSize,NSPW_DrawAxis = Raw.NSPW_DrawSize,Raw.NSPW_DrawAxis

						if self.Removing or !IsValid(DupeDataC) or !self.DupeDataInitialized then return end

						--cam.Start2D()
						--wide,tall = ScrW(),ScrH()
						local Vec,Ang = Vector(
							-math.abs(NSPW_DrawSize[3]+
								(NSPW_DrawSize[2]+NSPW_DrawSize[1])/2
							),
							math.abs(NSPW_DrawSize[1]),
							math.abs(NSPW_DrawSize[2])*1.2),
							Angle(0,0,0)
						--print(self.NSPW_DrawSize[1]*self.NSPW_DrawSize[2])
						local DA = NSPW_DrawAxis or "x"
						if DA == "x" then
							Ang.p = 0
						elseif DA == "y" then
							Ang.y = 90
						else
							Ang.r = 0
						end
						--print(self.NSPW_DrawAxis)
						Vec:Rotate(Ang)

						local x,y = Btn:LocalToScreen(0, 0)
						--x,y = Btn:GetPos()
						--print(x,y)

						cam.Start3D(Vec,Ang,80,x,y,w,h)

							render.SuppressEngineLighting( true )
							render.SetLightingOrigin( DupeDataC:GetPos() )
							render.ResetModelLighting( 1,1,1 )

							render.SetScissorRect( x,y,x+w,y+h, true )

							for ent,data in pairs(DupeData) do

								if !IsValid(ent) then continue end
								local c = ent:GetColor()
								render.SetColorModulation(c.r/255,c.g/255,c.b/255)
								render.SetBlend(c.a/255)

								--ent:SetParent(NULL)

								local OldRO = ent.RenderOverride

								ent.RenderOverride = nil

								local OldPos,OldAng = ent:GetRenderOrigin(),ent:GetRenderAngles()
								local OldRealPos,OldRealAng = ent:GetPos(),ent:GetAngles()

								ent:SetPos(data.Pos)
								ent:SetAngles(data.Angle)
								ent:SetRenderOrigin(data.Pos)
								ent:SetRenderAngles(data.Angle)
								ent:SetupBones()
								ent:DrawModel()

								ent.RenderOverride = OldRO

								ent:SetRenderOrigin(OldPos)
								ent:SetRenderAngles(OldAng)
								ent:SetupBones()
								ent:SetPos(OldRealPos)
								ent:SetAngles(OldRealAng)
								ent:SetupBones()
								ent:DrawModel()
							end

							render.SetScissorRect( 0, 0, 0, 0, false )

							render.SuppressEngineLighting( false )

						cam.End3D()

					end


					StyleBtns[Index] = Btn
				end

				function f:OnKeyCodePressed(c)

					for i,B in pairs(StyleBtns) do

						--if !i then continue end

						if c == input.GetKeyCode(input.LookupBinding("slot"..i) or "") then

							B:DoClick()

						end

					end

				end
				--这是成为主体的部分
				return f
			end,
		},
	}

	function SWEP:Reload()

		local owner = self:GetOwner()

		if !IsValid(owner) or !owner:KeyDown(IN_USE) or IsValid(NSPW_SettingMenu) then return end

		local wep = self

		local f = vgui.Create("DFrame")

		f:MakePopup()
		f:SetSize(200,600)
		f:Center()

		local dsp = vgui.Create( "DScrollPanel", f )
		dsp:Dock( FILL )

		local StyleBtns = {}

		for i,data in pairs(List) do
			local Index = #StyleBtns + 1
			local Btn = dsp:Add( "DButton" )
			Btn:SetText( "["..Index.."]"..data.Name )
			Btn:Dock( TOP )
			Btn:DockMargin( 0, 0, 0, 5 )
			Btn:SetToolTip(data.Tip or "None Provided")

			--[[function Btn:DoRightClick()

				net.Start("NSPW_TransStyleMessage")
					net.WriteString(i)
				net.SendToServer()

			end]]

			function Btn:DoClick()

				--self:DoRightClick()
				NSPW_SettingMenu = data.Function(wep)

				f:Remove()

			end


			StyleBtns[Index] = Btn
		end

		function f:OnKeyCodePressed(c)

			for i,B in pairs(StyleBtns) do

				--if !i then continue end

				if c == input.GetKeyCode(input.LookupBinding("slot"..i) or "") then

					B:DoClick()

				end

			end

		end
		

		NSPW_SettingMenu = f
		
		

	end

	--[[function SWEP:DoScreenShake()

		--ErrorNoHalt("JUMBAR")
		--util.ScreenShake(Vector(),2,20,0.1,1,true)

	end]]

	function SWEP:GenerateName()

		local Slot,DupeData,DupeDataC = self:GetDupeData()
		if !Slot then return end

		local FinalName = "Prop"
		local Count = 0

		for _,_ in pairs(DupeData) do
			Count = Count + 1
		end

		--print(Count)

		return FinalName

	end

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
		--do return end

		local Slot,DupeData,DupeDataC,Raw = self:GetDupeData()
		if !Slot then return end

		local NSPW_DrawSize,NSPW_DrawAxis = Raw.NSPW_DrawSize,Raw.NSPW_DrawAxis

		if self.Removing or !IsValid(DupeDataC) or !self.DupeDataInitialized then return end

		--cam.Start2D()
		--wide,tall = ScrW(),ScrH()
		local Vec,Ang = Vector(
			-math.abs(NSPW_DrawSize[3]+
				(NSPW_DrawSize[2]+NSPW_DrawSize[1])/2
			),
			math.abs(NSPW_DrawSize[1]),
			math.abs(NSPW_DrawSize[2])*1.2),
			Angle(0,0,0)
		--print(self.NSPW_DrawSize[1]*self.NSPW_DrawSize[2])
		local DA = NSPW_DrawAxis or "x"
		if DA == "x" then
			Ang.p = 0
		elseif DA == "y" then
			Ang.y = 90
		else
			Ang.r = 0
		end
		--print(self.NSPW_DrawAxis)
		Vec:Rotate(Ang)

		cam.Start3D(Vec,Ang,80,x,y,wide,tall)

			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( DupeDataC:GetPos() )
			render.ResetModelLighting( 1,1,1 )

			render.SetScissorRect( x,y,x+wide,y+tall, true )

			for ent,data in pairs(DupeData) do

				if !IsValid(ent) then continue end
				local c = ent:GetColor()
				render.SetColorModulation(c.r/255,c.g/255,c.b/255)
				render.SetBlend(c.a/255)

				--ent:SetParent(NULL)

				local OldRO = ent.RenderOverride

				ent.RenderOverride = nil
			
				local OldPos,OldAng = ent:GetRenderOrigin(),ent:GetRenderAngles()
				local OldRealPos,OldRealAng = ent:GetPos(),ent:GetAngles()

				ent:SetPos(data.Pos)
				ent:SetAngles(data.Angle)
				ent:SetRenderOrigin(data.Pos)
				ent:SetRenderAngles(data.Angle)
				ent:SetupBones()
				ent:DrawModel()

				ent.RenderOverride = OldRO

				ent:SetRenderOrigin(OldPos)
				ent:SetRenderAngles(OldAng)
				ent:SetupBones()
				ent:SetPos(OldRealPos)
				ent:SetAngles(OldRealAng)
				ent:SetupBones()
				ent:DrawModel()
			end

			render.SetScissorRect( 0, 0, 0, 0, false )

			render.SuppressEngineLighting( false )

		cam.End3D()
		
		--cam.Start2D()
		--print("?")
		-- Set us up the texture
		--surface.SetDrawColor( 255, 255, 255, alpha )
		--surface.SetTexture( self.WepSelectIcon )
--
		---- Lets get a sin wave to make it bounce
		--local fsin = 0
--
		--if ( self.BounceWeaponIcon == true ) then
		--	fsin = math.sin( CurTime() * 10 ) * 5
		--end
--
		---- Borders
		--y = y + 10
		--x = x + 10
		--wide = wide - 20

		-- Draw that mother
		--surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

		-- Draw weapon info box
		--self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

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

	

	--print("RRRR")

	if self.Removing then return end

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if SERVER then

		if !IsValid(owner) then 
			self:RemoveMySelf()
			--print("RRR")
			return
		end

		--请在之后放入检测物品是否全部消失的设置
		if !DupeData or !IsValid(DupeDataC) then 
			self:RemoveMySelf()
			return
		end

		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

		local Total = 0
		for ent,_ in pairs(DupeData or {}) do

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
			if owner:IsNPC() and (owner:IsCurrentSchedule(SCHED_MELEE_ATTACK1) or self.MeleeAttacking) then
				self:ThinkHandleAttack(owner)
			end
			
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
					if dist <= 4500  then
						local SelectedSequence = owner:SelectWeightedSequence(ACT_MELEE_ATTACK_SWING)

						owner:SetSchedule(SCHED_MELEE_ATTACK1)
						--owner:SetSequence(SelectedSequence)
						owner:StartEngineTask(103,SelectedSequence)
						self.OwnerSwingSeq = SelectedSequence
						self:PrimaryAttack()
						--end)
						--print("KTE")
					elseif dist > 4000 and owner:GetCurrentSchedule() != SCHED_CHASE_ENEMY then
						owner:SetSchedule(SCHED_CHASE_ENEMY)
						--print("EXE",dist)
					end

				end

			end

		end
		--self:SetNextThink(0)
		

		--[[if !MyStyle.HolsterPrevVM then
			
		end]]

		return true

	else

		--print(DupeData)
		--self:ManipulateBonePosition(0,Vector(-10,0,0))
		--print("?")
		if !self.DupeDataInitialized or !DupeData or !DupeDataC then
			self:RequestPropInfo()
			return
		end
		if !self.DupeDataInitialized or !IsValid(DupeDataC) or !owner:IsPlayer() then return end

		local vm = owner:GetViewModel()
		local block = self:GetBlocking()
		--[[if IsValid(vm) then

			

		end]]

		--EntMeta.SetParent(DupeDataC,NULL)
		local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}
		--DupeDataC:SetupBones()
		--[[DupeDataC:SetParent(NULL)
		DupeDataC:SetParent(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
		DupeDataC:SetLocalPos(Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
		DupeDataC:SetLocalAngles(Angle(0,0,180)+(PropData.OffsetAng or Angle()))]]
		--DupeDataC:SetupBones()

		--DupeDataC:SetLocalPos(Vector(0,100,0))
		--print("????")
		--DupeDataC:SetPredictable(true)
		--DupeDataC:FollowBone(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

		--print(owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

		--Outfitter支持(是的,当你是塔尔斯EXE时你的武器不再会跑到模型额头前的那撮毛上从而导致你看上去像是头部中矛了一样)
		--哦顺带说嘴Tails可爱捏
		--EntMeta.FollowBone(DupeDataC,owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)


		local MyStyle = self:GetStyleData()

		local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

		--print(DupeDataC:GetModel())

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

		self:SetNextClientThink(CurTime())
		return true
	end

end

function SWEP:RemoveMySelf()
	if CLIENT then return end

	if #self.DupeData < 1 then 
		return
	end
	for _,DupeData in pairs(self.DupeData) do
		for ent,_ in pairs(DupeData or {}) do
			if IsValid(ent) then ent:Remove() end
		end
	end

	self:Remove()

end

local WhiteList = {
	["NSPW_GUNCLIP1"] = true,
	["NSPW_GUNCLIP2"] = true,
	["NSPW_PROP_NOCONSTRAINT"] = true,
	["NSPW_PROP_PROPDATA"] = true,
}

function SWEP:DropMySelf(slot,owner)
	
	--print("CALL!")

	local owner = owner or self:GetOwner()
	if slot == "all" then
		for i=1,#self.DupeData do
			self:DropMySelf(1,owner)
		end
		--print("R")
		return
	end


	local Slot,DupeData,DupeDataC = self:GetDupeData(slot)
	--print("?")
		--print(Slot,DupeData)
	if !Slot then return end
	--self:Holster()

	if SERVER then

		if !IsValid(DupeDataC) or !IsValid(self) or self.Removing then return end

		self:CallOnClient("DropMySelf")
		hook.Run(_NSPW_HOOK_NAME_ONDROP,owner,DupeData)

		DupeDataC:FollowBone(NULL,0)
		DupeDataC:SetCustomCollisionCheck(DupeDataC.NSPW_PROP_OLDCOLLISIONCHECK)
		EntMeta.SetCollisionGroup(DupeDataC,DupeDataC.NSPW_PROP_OLDCOLLISIONGROUP or 0)
		--print(DupeDataC.NSPW_PROP_OLDCOLLISIONGROUP,COLLISION_GROUP_IN_VEHICLE)
		for i,_ in pairs(DupeDataC:GetTable()) do
				
			if string.StartWith(i, "NSPW_") and !WhiteList[i] then

				DupeDataC[i] = nil

			end

		end
		DupeDataC:SetPos(IsValid(owner) and owner:EyePos()+owner:GetAimVector()*15 or self:GetPos())
		local pobj = DupeDataC:GetPhysicsObject()
		if IsValid(pobj) then
			pobj:EnableMotion(true)
			pobj:Wake()
			if IsValid(owner) then
				pobj:ApplyForceCenter(owner:GetAimVector()*145)
			end
		end
		--DupeDataC:SetVelocity(owner:GetAimVector()*45)
		
		local Tbl = {}
		for ent,data in pairs(DupeData or {}) do
			
			if IsValid(ent) then

				ent:SetNoDraw(ent.NSPW_PROP_SV_NODRAW)
				table.insert(Tbl,ent:EntIndex())

			
				--EntMeta.SetTransmitWithParent(ent,ent.NSPW_PROP_TRANSMITWITHPARENT)

				--EntMeta.SetMoveType(ent,ent.NSPW_PROP_MOVETYPE or MOVETYPE_VPHYSICS)

			end
			--ent:SetMoveParent(ent)
			if IsValid(ent) and ent != DupeDataC and ent.NSPW_PROP_OLDCOLLISIONGROUP then 
				--print("IM TRIGGERED")

				--print(ent,ent.NSPW_PROP_MYPARENT)

				local oldparent = ent.NSPW_PROP_MYPARENT


				ent:SetCustomCollisionCheck(ent.NSPW_PROP_OLDCOLLISIONCHECK)
				EntMeta.SetCollisionGroup(ent,ent.NSPW_PROP_OLDCOLLISIONGROUP)

				--print(IsValid(oldparent) , oldparent , DupeData[oldparent])
				local REF = DupeData[IsValid(oldparent) and oldparent or DupeDataC]
				if !REF then
					REF = DupeData[DupeDataC]
				end
				local pos,ang = WorldToLocal(data.Pos,data.Angle,REF.Pos,REF.Angle)
				--[[if IsValid(oldparent) and oldparent != ent then
					pos = oldparent:WorldToLocal(pos)
					ang = oldparent:WorldToLocalAngles(ang)
				end]]

				--local Bone = owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0

				--EntMeta.FollowBone(ent,owner, Bone)


				EntMeta.FollowBone(ent,NULL,-1)

				EntMeta.SetParent(ent,oldparent or NULL)
				
				EntMeta.SetLocalPos(ent,data.Pos)
				EntMeta.SetLocalAngles(ent,data.Angle)
				--print(oldparent)

				--print(ent,ent.NSPW_PROP_MYPARENT)
				--print(ent:GetParent(),ent:GetMoveParent(),ent:GetMoveType(),ent.NSPW_PROP_OLDCOLLISIONCHECK,ent.NSPW_PROP_OLDCOLLISIONGROUP)

				for i,_ in pairs(ent:GetTable()) do

					if WhiteList[i] then continue end

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

		net.Start("NSPW_TransDroppedPropMessage")
			net.WriteTable(Tbl)
		net.Broadcast()

		if #self.DupeData <= 1 then
			self:Remove()
			self.Removing = true
			--print("WTF")
		else
			self:RemoveSlot(Slot)
			--table.SortByKey(self.DupeData)
			if Slot == 1 then
				self:ChangeSlot(Slot)
			else
				self:ChangeSlot(Slot - 1)
			end
		end
	else
		if #self.DupeData <= 1 then
			--self:Remove()
			self.Removing = true
		end
	
		for ent,_ in pairs(DupeData or {}) do

			if !IsValid(ent) then continue end

			--self:DrawWorldModel()
			--hook.Run("NotifyShouldTransmit", ent,ent.NSPW_PROP_CL_PREDICTABLE or false)
			--print(ent.NSPW_PROP_CL_PREDICTABLE)

			--重置,不然显示Bug
			--ent:SetPos(ent.NSPW_PROP_CL_Origin) --虫豸
			ent:SetNoDraw(false)

			ent:SetRenderOrigin(nil)
			ent:SetRenderAngles(nil)


			if ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
				ent.RenderOverride = ent.NSPW_PROP_CL_RENDEROVERRIDE
				ent.NSPW_PROP_CL_RENDEROVERRIDE = nil
				ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = nil
			end

			EntMeta.DrawModel(ent)

			EntMeta.SetPredictable(ent,ent.NSPW_PROP_CL_PREDICTABLE or false)
			--EntMeta.FollowBone(ent,NULL,-1)
			--EntMeta.SetParent(ent,NULL)



			ent.NSPW_PROP_CL_PREDICTABLE = nil
			--ent:SetCollisionGroup(0)

			--print(ent:GetCollisionGroup())

		end

	end

	--self.Removing = true

end

local Reload = {
	["anim_reload"] = {0.3,0.85},
	["anim_reloadrev"] = {0.3,0.85},
	["anim_reloadcrossbow"] = {0.3,0.85},
	["anim_bolt"] = {0.1,0.8},
	["anim_reloadaug"] = {0.1,0.7},
	["anim_reloadsg"] = true,
	["anim_reloadsgloop"] = true,
	["anim_reloadsg_in"] = {0.6,0},
	["anim_reloadsg_out"] = {0,0.6},
}

function SWEP:PreDrawViewModel(vm)

	if #self.DupeData < 1 then 
		return
	end
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	local ht = self:GetHoldType()
	local MyStyle = Style[ht] or {}
	local PropData = NSPW_DATA_PROPDATA[DupeDataC]

	self.ViewModel = MyStyle.VM
	if !MyStyle.HolsterPrevVM then
		--print(MyStyle.VM)
		vm:SetModel(MyStyle.VM or "")
		self.CurViewModel = vm:GetModel()
		self.LastStyle = ht
		--print(2)
	else
		ht = self.LastStyle or ht
		MyStyle = Style[self.LastStyle] or {}
		--print(1)
		--print(ht)
	end
	--vm:SetupBones()
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

			local bi = isnumber(i) and i or vm:LookupBone(i) or -1

			if bi <= 0 then continue end


			vm:ManipulateBonePosition(bi,vm:GetManipulateBonePosition(bi)+(LerpVector(Cyc,(data.Pos or Vector()),Vector())))
			vm:ManipulateBoneAngles(bi,vm:GetManipulateBoneAngles(bi)+(LerpAngle(Cyc,(data.Ang or Angle()),Angle())))


		end
		for ent,_ in pairs(DupeData) do 
			
			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}

			if !PropData then PropData = {} end
			
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
		--其实LerpVector和LerpAngle不像Lerp那样有限制

		self.LastAim = math.min(1,math.max(self.LastAim,0))
		--print(PropData)
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

			for ent,_ in pairs(DupeData) do 
			
				if !IsValid(ent) then continue end

				local PropData = NSPW_DATA_PROPDATA[ent] or {}
				Mul = Mul / (PropData.ReloadSpeedMul or 1)
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

			for ent,_ in pairs(DupeData) do 
			
				if !IsValid(ent) then continue end

				local PropData = NSPW_DATA_PROPDATA[ent] or {}
				Mul = Mul / (PropData.ReloadSpeedMul or 1)
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

/*function SWEP:PostDrawViewModel(draw)

	--print("我真的在画")
	if !draw or self.Removing then return end

	--[[ed = EffectData()
						ed:SetAttachment(1)
						ed:SetAngles(Angle())
						ed:SetOrigin(DupeDataC:GetPos())
						ed:SetFlags(1)

						ed:SetEntity(DupeDataC)
						util.Effect("MuzzleFlash",ed)]]

	--print("热修复还活着")
	if !IsValid(DupeDataC) then
		self:RequestPropInfo()
	end

	local owner = self:GetOwner()

	local vm = owner:GetViewModel()

	--[[EntMeta.SetParent(DupeDataC,NULL)
	DupeDataC:SetupBones()
	DupeDataC:FollowBone(owner,10)
	DupeDataC:SetupBones()]]

	--[[for i=0,vm:GetBoneCount() - 1 do
		print(vm:GetBoneName(i))
	end]]
	--v_weapon.Knife_Handle
	--vm:SetupBones()
	local mtx = vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

	if !mtx then return end

	owner:SetupBones()
	local omtx = owner:GetBoneMatrix(owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
	if !omtx then return end
	local Pos,Ang = mtx:GetTranslation(),mtx:GetAngles()

	

	for ent,data in pairs(DupeData or {}) do

		--local ent = self["GetPropEntity"..i](self)

		if !IsValid(ent) then continue end
		
		--local old = EntMeta.GetPredictable(ent)
		--EntMeta.SetPredictable(ent,true)
		
		ent:SetNoDraw(true)

		if !ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
			ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = true
			ent.NSPW_PROP_CL_RENDEROVERRIDE = ent.RenderOverride
			--ent.RenderOverride = function(self) self:DrawShadow(false) end
		end
		EntMeta.SetRenderOrigin(ent,nil)
		EntMeta.SetRenderAngles(ent,nil)

		--print(ent:GetPos(),ent:GetAngles())
		--ent:SetupBones()
		ent.NSPW_PROP_CL_Origin = ent:GetPos()
		ent.NSPW_PROP_CL_Angle = ent:GetAngles()
			--[[ent:SetParent(DupeDataC)
			ent:SetLocalPos(data.Pos)
			ent:SetLocalAngles(data.Angle)]]
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
				
				return NewMeta[key]
			elseif key == "GetAngles" then
				
				return NewMeta[key]
			end
			if NewMeta[key] then return NewMeta[key] end
			return OldMeta.__index(self,key,...)
		end

		debug.setmetatable(ent, NewMeta)]]

		--ent:SetupBones()

		local MyStyle = self:GetStyleData()
		local mtxpos,mtxang = omtx:GetTranslation(),omtx:GetAngles()

		local FPos,FAng

		if ent:GetNWBool("NSPW_NW_PROP_NOCONSTRAINTFREEDRAW") then

			FPos,FAng = ent:GetPos(),ent:GetAngles()

		else

			local OPos,OAng = LocalToWorld((MyStyle.VMPropOffsetPos or Vector()),(MyStyle.VMPropOffsetAng or Angle()),mtxpos,mtxang)

			OPos,OAng = WorldToLocal(EntMeta.GetPos(ent),EntMeta.GetAngles(ent),OPos,OAng)
			--OAng:Normalize()
			--if ent != DupeDataC then
			--	FPos,FAng = LocalToWorld(OPos,OAng,ent:GetRenderO())
			--else
				FPos,FAng = LocalToWorld(OPos,OAng,Pos,Ang)
			--end

		end
--
		ent.NSPW_PROP_CL_DrawOrigin = FPos
		ent.NSPW_PROP_CL_DrawAngle = FAng
		--OAng.z = -OAng.z
		--print(OPos)
		--[[ent:AddEffects(EF_FOLLOWBONE)
		ent:SetRenderOrigin(FPos)
		ent:SetRenderAngles(FAng)]

		--ent:SetParent(vm)
		--ent:SetPredictable(true)
		--PrintTable(ent:GetSaveTable(true))
		ent:DrawShadow(false)
		local pobj = self:GetPhysicsObject()

		
		--ent:SetNetworkOrigin(FPos)
		--ent:SetRender
		--[[if ent != DupeDataC and IsValid(EntMeta.GetParent(ent)) then
			--ent:SetParent(DupeDataC)
			--ent:SetLocalPos(data.Pos)
			ent:SetLocalAngles(data.Angle)
			FAng = ent:GetAngles()
		end]]
		EntMeta.SetRenderOrigin(ent,FPos)
		EntMeta.SetRenderAngles(ent,FAng)
		ent.RenderOverride = function(self) 
			self:DestroyShadow()
			--EntMeta.SetRenderOrigin(ent,FPos)
			--EntMeta.SetRenderAngles(ent,FAng)

			--self:SetPos(FPos)
			--self:SetAngles(FAng)
			--EntMeta.SetupBones(self)
			--self:SetPos(self:GetRenderOrigin())
			--print("SUS")
			--self:SetPos(FPos)
			--self:SetAngles(FAng)
			--self:SetPredictable(true)
			EntMeta.DrawModel(self)
			--self:SetPredictable(false)
			--self:DrawModel()

			--self:SetPos(self.NSPW_PROP_CL_Origin)
			--self:SetAngles(self.NSPW_PROP_CL_Angle)

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
		render.SetBlend(c.a/255)
		--render.Se

		if isfunction(ent.Draw) then
			--EntMeta.SetPredictable(ent,true)
			--EntMeta.DrawModel(ent)
			--EntMeta.SetPos(ent,FPos)
			--EntMeta.SetAngles(ent,FAng)
			--print(ent)
			EntMeta.SetPos(ent,FPos)
			EntMeta.SetAngles(ent,FAng)
			EntMeta.SetupBones(ent)
			--EntMeta.SetRenderOrigin(ent,FPos)
			--EntMeta.SetRenderAngles(ent,FAng)
			ent:Draw()
			--print("?")
			--LOCALVAL_ANG = FAng
			--LOCALVAL_POS = FPos
			--debug.setmetatable(ent,ModEntMeta)
			--EntMeta.SetupBones(ent)

			EntMeta.SetPos(ent,ent.NSPW_PROP_CL_Origin)
			EntMeta.SetAngles(ent,ent.NSPW_PROP_CL_Angle)
			EntMeta.SetupBones(ent)

			--EntMeta.DrawModel(ent,STUDIO_NOSHADOWS)
			--ent.RenderOverride = function(self) self:DrawModel end
			--hook.Run("PreDrawOpaqueRenderables")
			--hook.Run("PostDrawOpaqueRenderables")

			--debug.setmetatable(ent,EntMeta)
		else
			--ent:SetPos(ent.NSPW_PROP_CL_Origin)
			--ent:SetAngles(ent.NSPW_PROP_CL_Angle)
			EntMeta.SetupBones(ent)
			EntMeta.DrawModel(ent)
		end
		--PAC3采用CLModel
		--hook.Run("PostDrawOpaqueRenderables")
		--hook.Run("PostDrawTranslucentRenderables")
			--EntMeta.SetupBones(ent)
			--ent:Draw()
	
		--ent:SetupBones()
		--ent:SetupBones()

		--ent:Draw()
		--ent:SetPos(OldPos)

		--debug.setmetatable(ent, OldMeta)
		--ent:GetDrawShadow(false)
		ent.RenderOverride = function(self) 
			--EntMeta.SetRenderOrigin(self,FPos)
			--EntMeta.SetRenderAngles(self,FAng)
			--EntMeta.DrawModel(self)
			self:DestroyShadow()
			self:DrawShadow(false) 
		end
		--EntMeta.SetPredictable(ent,false)
		--EntMeta.SetPredictable(ent,old)
		--EntMeta.DrawModel(ent)
		--ent:DrawModel()
		--self.NSPW_WEP_CLENTS[i]:SetRenderOrigin(FPos)
		--self.NSPW_WEP_CLENTS[i]:SetRenderAngles(FAng)
		--self.NSPW_WEP_CLENTS[i]:DrawModel()

		
		
		

	end

	render.SetColorModulation(1,1,1)
	render.SetBlend(1)

	self.VMRendered = true

end*/

function SWEP:AdjustMouseSensitivity()

	if #self.DupeData < 1 then 
		return
	end
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	local PropData = NSPW_DATA_PROPDATA[DupeDataC]

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
	
	self.NextRequest = 5
	--print("你说得对,但是我玩原神,我有权利性侵服务器的交通")
	net.Start("NSPW_TransPropTableMessage",true)
		net.WriteEntity(self)
	net.SendToServer()

end

function SWEP:DrawWorldModel()

	--do return end

	if #self.DupeData < 1 then 
		return
	end
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end
	
	if !IsValid(DupeDataC) then
		self:RequestPropInfo()
		return
	end

	local owner = self:GetOwner()
	--owner:SetupBones()

	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}
	--DupeDataC:SetupBones()
	DupeDataC:SetParent(NULL)
	DupeDataC:SetParent(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
	DupeDataC:SetLocalPos(Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()))
	DupeDataC:SetLocalAngles(Angle(0,0,180)+(PropData.OffsetAng or Angle()))
	--DupeDataC:SetupBones()

	--DupeDataC:SetLocalPos(Vector(0,100,0))
	--print("????")
	--DupeDataC:SetPredictable(true)
	--DupeDataC:FollowBone(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

	--print(owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

	--Outfitter支持(是的,当你是塔尔斯EXE时你的武器不再会跑到模型额头前的那撮毛上从而导致你看上去像是头部中矛了一样)
	EntMeta.FollowBone(DupeDataC,owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
	

	for ent,_ in pairs(DupeData) do

		--local ent = self["GetPropEntity"..i](self)

		if !IsValid(ent) then continue end

		--render.SetMaterial(ent:GetMaterial())
		local c = ent:GetColor()
		render.SetColorModulation(c.r/255,c.g/255,c.b/255)
		render.SetBlend(c.a/255)

		ent:SetRenderOrigin(nil)
		ent:SetRenderAngles(nil)

		ent:SetNoDraw(false)

		if ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
			ent.RenderOverride = ent.NSPW_PROP_CL_RENDEROVERRIDE
			ent.NSPW_PROP_CL_RENDEROVERRIDE = nil
			ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = nil
		end

		
		--print(ent:GetParentAttachment(),owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		--DupeDataC:SetParent(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
		--ent:FollowBone(owner,owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

		ent:DrawModel()
		ent:SetNoDraw(true)
		--self:PreDrawViewModel()
		--self:PostDrawViewModel()
		--ent:SetParent(nil)



	end

	render.SetColorModulation(1,1,1)
	render.SetBlend(1)

	--别问,问就是尊重实例

	--[[local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

	render.SetColorMaterial()

	local MPos = PropData.MuzzlePos or Vector(0,0,0)

	--修改

	--print(MPos)


	MPos = LocalToWorld(MPos,Angle(),DupeDataC:GetNetworkOrigin(),DupeDataC:GetNetworkAngles())
	--print(DupeDataC:GetPos())

	-- Draw the sphere!
	render.DrawSphere( MPos, 50, 30, 30, Color( 0, 175, 175,100 ) )]]

end

function SWEP:ResetVM()

	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsPlayer() then
		local vm = owner:GetViewModel()
		if !IsValid(vm) then return end
		vm:SetMaterial("")
		for i=0,vm:GetBoneCount()-1 do

			vm:ManipulateBonePosition(i,Vector())
			vm:ManipulateBoneAngles(i,Angle())

		end
	end

end

function SWEP:OnRemove()

	self:DropMySelf("all")
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

	if #self.DupeData < 1 then 
		if SERVER then self:Remove() end
		return
	end
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if SERVER then


		if GameIsSP then
			self:CallOnClient("Deploy")
		end

		self:SetBlocking(false)

		local MyStyle = self:GetStyleData()

		if MyStyle.HolsterPrevVM or MyStyle.InvertDWHL then
			self:SendWeaponAnim(ACT_VM_HOLSTER)
		end

		--local Bone = owner:LookupBone("ValveBiped.Bip01_R_Hand") or 0
		--local BPos,BAng = owner:GetBonePosition(Bone)

		--我们需要先设置父级,再设置子级,注意优先级

		--DupeDataC:SetMoveParent(DupeDataC)

		--self:GetWeaponViewModel():AddGestureSequence()
		--self:Think()

		for ent,data in pairs(DupeData or {}) do

			if !IsValid(ent) then continue end

			--EntMeta.FollowBone(ent,NULL,0)
			--[[if ent.NSPW_PROP_TRANSMITWITHPARENT == nil then

				ent.NSPW_PROP_TRANSMITWITHPARENT = EntMeta.GetTransmitWithParent(ent)

			end]]

			--EntMeta.SetTransmitWithParent(ent,true)

			EntMeta.SetMoveParent(ent,IsValid(ent.NSPW_PROP_MOVEPARENT) and ent.NSPW_PROP_MOVEPARENT or ent)
			ent:SetNoDraw(ent.NSPW_PROP_SV_NODRAW)
			

		end

		--self:Think()

	else

		self.PrintName = self:GenerateName()

		--[[for ent,data in pairs(DupeData or {}) do

			if !IsValid(ent) then continue end

			--EntMeta.SetPredictable(ent,true)

		end]]
		

	end

	return true

end

--此段为新检测方式
function SWEP:PostDrawViewModel(draw)

	if !draw or self.Removing then return end

	if #self.DupeData < 1 then 
		--self:Remove()
		return
	end
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if !IsValid(DupeDataC) then
		self:RequestPropInfo()
		return
	end

	local owner = self:GetOwner()
	if !owner then return end
	owner:SetupBones()

	local vm = self.InAnimation and self.VMAnim or owner:GetViewModel() --看起来和VM同步有延迟,使用VMAnim是为了防止保加利亚模式(H O P)
	if !vm then return end
	--vm:SetupBones() --会干烂Smooth所以别开
	if EntMeta.GetParent(DupeDataC) != vm then

		EntMeta.SetParent(DupeDataC,vm,vm:LookupBone("ValveBiped.Bip01_R_Hand") or 0)

	end
	local MyStyle = self:GetStyleData()
	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}
	local OPos,OAng = Vector(3,-1.5,0)+(PropData.OffsetPos or Vector()),Angle(0,0,180)+(PropData.OffsetAng or Angle())
	OPos,OAng = WorldToLocal(OPos,OAng,(MyStyle.VMPropOffsetPos or Vector()),(MyStyle.VMPropOffsetAng or Angle()))
	EntMeta.SetLocalPos(DupeDataC,OPos)
	EntMeta.SetLocalAngles(DupeDataC,OAng)
	--DupeDataC:SetLocalPos(OPos)
	--DupeDataC:SetLocalAngles(OAng)

	EntMeta.SetupBones(DupeDataC)
	for ent,data in pairs(DupeData) do
		if !IsValid(ent) then continue end
		local c = ent:GetColor()
		render.SetColorModulation(c.r/255,c.g/255,c.b/255)
		render.SetBlend(c.a/255)
		--ent:SetNoDraw(false)
		ent:SetRenderOrigin(nil)
		ent:SetRenderAngles(nil)
		ent:SetNoDraw(true)
		ent.RenderOverride = function(self) self:DrawShadow(false) self:DrawModel() end
		if ent != DupeDataC then
			ent:SetRenderOrigin(ent:GetPos())
			ent:SetRenderAngles(ent:GetAngles())
		end
		EntMeta.SetupBones(ent)
		ent:DrawModel()
		--ent:DrawModel()
		--ent:SetupBones()
	end
	render.SetColorModulation(1,1,1)
	render.SetBlend(1)

end

function SWEP:Holster_Slot(slot)

	local owner = self:GetOwner()
	if !IsValid(owner) or slot == self:GetSlot() then return end

	if slot == "all" then
		for i = 1,#self.DupeData do
			self:Holster_Slot(i)
		end
	else


		local DupeData = self.DupeData[slot]
		if !DupeData then return end
		local DupeDataC = DupeData.DupeDataC
		DupeData = DupeData.Data
		if SERVER then

			self:CallOnClient("Holster_Slot",slot)
			for ent,data in pairs(DupeData or {}) do

				if !IsValid(ent) then continue end

				ent:FollowBone(NULL,0)

				--EntMeta.SetMoveType(ent,MOVETYPE_NONE)
				--print("?2")

				if !self.Removing then
					if !ent.NSPW_PROP_MOVEPARENT then
						ent.NSPW_PROP_MOVEPARENT = ent:GetMoveParent()
					end
					--GetTransmitWithParent()
					--EntMeta.SetTransmitWithParent(ent,ent.NSPW_PROP_TRANSMITWITHPARENT)
					EntMeta.SetMoveParent(ent,owner)

					EntMeta.SetLocalPos(ent,data.Pos)
					EntMeta.SetLocalAngles(ent,data.Angle)
				end
				--超高级保险措施! 以后再也不用担心玩家找到了! 因为根本找不到!
				--ent:SetPos(Vector(7000,7000,7000))
				EntMeta.SetCollisionGroup(ent,COLLISION_GROUP_IN_VEHICLE)
				if ent.NSPW_PROP_SV_NODRAW == nil then
					ent.NSPW_PROP_SV_NODRAW = ent:GetNoDraw()
				end
				ent:SetNoDraw(true)
				for i=0,ent:GetPhysicsObjectCount()-1 do
					local pobj = ent:GetPhysicsObjectNum(i)
					if !IsValid(pobj) then continue end
					pobj:EnableMotion(false)
					pobj:Sleep()
				end

			end

			--local ent = DupeDataC
			--EntMeta.SetLocalPos(ent,Vector(0,0,10))
			--EntMeta.SetAngles(ent,Angle(0,0,0))

		else

			self:DrawWorldModel() --它是世界的(如果不这么做VM有Bug)

			for ent,_ in pairs(DupeData or {}) do

				--local ent = self["GetPropEntity"..i](self)

				if !IsValid(ent) then continue end

				--print("CUM")
				--ent:FollowBone(owner,0)

				--EntMeta.SetPredictable(ent,ent.NSPW_PROP_CL_PREDICTABLE or false)

				ent:SetNoDraw(true)

				if !ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
					ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = true
					ent.NSPW_PROP_CL_RENDEROVERRIDE = ent.RenderOverride
					ent.RenderOverride = function(self) self:DrawShadow(false) end
				end

			end
		end

	end

end

function SWEP:Holster()

	if self.Removing then return end

	local owner = self:GetOwner()
	
	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return true end

	if SERVER then

		self.InReload = false
		self:SetAiming(false)

		for ent,data in pairs(DupeData or {}) do

			if !IsValid(ent) then continue end

			ent:FollowBone(NULL,0)

			--EntMeta.SetMoveType(ent,MOVETYPE_NONE)
			--print("?2")

			if !self.Removing then
				if !ent.NSPW_PROP_MOVEPARENT then
					ent.NSPW_PROP_MOVEPARENT = ent:GetMoveParent()
				end
				--GetTransmitWithParent()
				--EntMeta.SetTransmitWithParent(ent,ent.NSPW_PROP_TRANSMITWITHPARENT)
				EntMeta.SetMoveParent(ent,owner)

				EntMeta.SetLocalPos(ent,data.Pos)
				EntMeta.SetLocalAngles(ent,data.Angle)
			end
			--超高级保险措施! 以后再也不用担心玩家找到了! 因为根本找不到!
			--ent:SetPos(Vector(7000,7000,7000))
			EntMeta.SetCollisionGroup(ent,COLLISION_GROUP_IN_VEHICLE)
			if ent.NSPW_PROP_SV_NODRAW == nil then
				ent.NSPW_PROP_SV_NODRAW = ent:GetNoDraw()
			end
			ent:SetNoDraw(true)
			for i=0,ent:GetPhysicsObjectCount()-1 do
				local pobj = ent:GetPhysicsObjectNum(i)
				if !IsValid(pobj) then continue end
				pobj:EnableMotion(false)
				pobj:Sleep()
			end

		end

		--local ent = DupeDataC
		--EntMeta.SetLocalPos(ent,Vector(0,0,10))
		--EntMeta.SetAngles(ent,Angle(0,0,0))

	else

		self:DrawWorldModel() --它是世界的(如果不这么做VM有Bug)

		for ent,_ in pairs(DupeData or {}) do

			--local ent = self["GetPropEntity"..i](self)

			if !IsValid(ent) then continue end

			--print("CUM")
			--ent:FollowBone(owner,0)

			--EntMeta.SetPredictable(ent,ent.NSPW_PROP_CL_PREDICTABLE or false)

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

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	local PropData = NSPW_DATA_PROPDATA[DupeDataC]

	if self:GetAiming() or (self.LastAim or 0) > 0 then

		return Lerp((PropData.AimUseScope and (self.LastAimRaw or 0)*2 - 1.3 or self.LastAim or 0),fov,(fov - 15) * (PropData.AimFovMul or 1))

	end

	return fov

end

--vgui/scope_shadowmask

--我不是ZS作者所以我不会绘制超酷材质,当然你想让我用结合人的那个也不是不行
local ScopeMat = Material("sprites/scope_arc")


function SWEP:DrawHUD()

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	local TextureSize = 500*ScrH()/1080
	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

	local W,H = ScrW(),ScrH()
	local MulW,MulH = ScrW()/1920,ScrH()/1080

	if PropData.AimUseScope and self.LastAim > 0.8 then
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,W,H/2-TextureSize+2)
		surface.DrawRect(0,H/2+TextureSize-2,W,H/2-TextureSize+2)
		surface.DrawRect(0,H/2-TextureSize+2,W/2-TextureSize+2,H)
		surface.DrawRect(W/2+TextureSize-2,H/2-TextureSize+2,W/2-TextureSize+2,H)
		surface.SetDrawColor(255,255,255,255)
		--[[render.RenderView( {
			origin = EyePos(),
			angles = EyeAngles(),
			x = W/2-TextureSize+1,
			y = H/2-TextureSize+1,
			w = TextureSize*2-2,
			h = TextureSize*2-2
		} )]]
		surface.SetMaterial(ScopeMat)
		surface.DrawTexturedRectRotated(W/2+TextureSize/2,H/2+TextureSize/2,TextureSize,TextureSize,0)
		surface.DrawTexturedRectRotated(W/2+TextureSize/2,H/2-TextureSize/2,TextureSize,TextureSize,90)
		surface.DrawTexturedRectRotated(W/2-TextureSize/2,H/2-TextureSize/2,TextureSize,TextureSize,180)
		surface.DrawTexturedRectRotated(W/2-TextureSize/2,H/2+TextureSize/2,TextureSize,TextureSize,270)
		--render.SetScissorRect(W/2-500,H/2-500,1250,1000,true)
		--draw.RoundedBox(0,0,0,1145,1145,Color(255,255,255))

		local ScopeType = PropData.ScopeType or 0

		local function DrawCross()

			local CrossWidth = (PropData.ScopeCrossWidth or 3)*MulH
			local CrossColor = PropData.ScopeCrossColor or Color(0,0,0,235)

			surface.SetDrawColor(CrossColor)

			surface.DrawRect(0, (H-CrossWidth)/2, W, CrossWidth)
			surface.DrawRect((W-CrossWidth)/2, 0, CrossWidth, H)

		end

		local function DrawDot()

			local DotSize = (PropData.ScopeDotSize or 7)*MulH
			local DotColor = PropData.ScopeDotColor or Color(185,0,0,235)

			draw.RoundedBox(100, (W-DotSize)/2,(H-DotSize)/2,DotSize,DotSize,DotColor)

		end

		if ScopeType == 1 then

			DrawDot()

		elseif ScopeType == 2 then

			DrawCross()

		elseif ScopeType == 3 then

			DrawCross()
			DrawDot()

		end

		surface.SetDrawColor(0,0,0,Lerp(((self.LastAimRaw or 0)-1),255,0))
		surface.DrawRect(0,0,W,H)

		--render.SetScissorRect( 0, 0, 0, 0, false )

	end

end

function SWEP:RemoveSlot(slot)
	if SERVER then
		self:CallOnClient("RemoveSlot", slot)
	end
	table.remove(self.DupeData,slot)
	self.Removing = false
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

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end
			--print("?")

	if SERVER then

		local MyStyle = self:GetStyleData()
		local PropData = NSPW_DATA_PROPDATA[DupeDataC]
			--print(!MyStyle.IsGun and !MyStyle.AlwaysBlock and !MyStyle.DoNothing)

		if owner:KeyDown(IN_USE) then
			self:DropMySelf()
			--self:CallOnClient("DropMySelf")
		elseif !MyStyle.IsGun and !MyStyle.AlwaysBlock and !MyStyle.DoNothing then
			local oldBlock = self:GetBlocking()

			

			self:SetBlocking(!oldBlock)
			if oldBlock then
				self:SetNextPrimaryFire(CurTime()+0.5)
			end
		elseif MyStyle.IsGun and !self.InReload and !PropData.NoAim then

			local OldState = self:GetAiming()

			--[[for ent,_ in pairs(self.WireIO_E2List or {}) do

			
				if !IsValid(ent.entity) then continue end

				Count = Count + 1

				ent.data.NSPWAiming = !OldState
			
			end]]

			self:SetAiming(GetConVar("savee_nspw_gun_aim_enabled"):GetBool() and !OldState)

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

	
	if !self:CanPrimaryAttack() then return end
	

	local owner = self:GetOwner()

	if !IsValid(owner) then return end

		--self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if SERVER then

		--[[if game.SinglePlayer() then
			self:CallOnClient("PrimaryAttack")
		end]]

		local MyStyle = self:GetStyleData()

		local time = 0.1
		--print(#self.WireIO_E2List == 0)
		local Count = 0
		self:SetNextPrimaryFire(CurTime()+0.05)
		for ent,_ in pairs(self.WireIO_E2List or {}) do

			
			if !IsValid(ent.entity) then continue end
			
			Count = Count + 1

			ent.data.NSPWClk = true
			ent.data.NSPWAttack = true

			ent.entity:Execute()

			ent.data.NSPWAttack = nil
			ent.data.NSPWClk = nil

		end
			--print("1")
		if Count == 0 or DupeData.WireIO_ShouldAttack then



			--print(self:GetHoldType())

			--Style检测

			local Ents = {}
			if MyStyle.SwingTimeMod then
				time = time + MyStyle.SwingTimeMod
			end


			local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

			if MyStyle.IsGun and PropData.IsGun then
				
				local AmmoToTake = 1

				local Heavy --= true
				local mass = 0

				for ent,_ in pairs(DupeData) do

					if !IsValid(ent) then continue end

					local PropData = NSPW_DATA_PROPDATA[ent] or {}
					if PropData.ForceHeavyWeapon then
						Heavy = true
					end

					local pobj = ent:GetPhysicsObject()

					local CV = ent == DupeDataC and 1 or GetConVar("savee_nspw_gun_childrenmassmul"):GetFloat()
					if IsValid(pobj) then 
						mass = mass + pobj:GetMass()*CV
					else
						mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV
					end


				end

				DebugMessage(mass)

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
				owner:EmitSound(istable(snd) and snd[math.random(1,#snd)] or snd or "weapons/pistol/pistol_fire2.wav",75)

				local dmgmod = PropData.BulletDamage or 0
				local random = PropData.BulletDamageOffset or 0

				local dmg = math.random(dmgmod-random,dmgmod+random)
				--self:SetModel(DupeDataC:GetModel())

				local T = {owner,self}

				for ent,_ in pairs(DupeData) do

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
				local AimSpreadMul = 1
				local AimRecoilMul = 1

				local Trace,MF,HitEffect = {},{},{}

				local BC = (PropData.BulletCount or 1)

				for ent,_ in pairs(DupeData) do 
		
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

					if ent == DupeDataC then continue end

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

					AimSpreadMul = AimSpreadMul * (PropData.AimSpreadMul or 1)
					AimRecoilMul = AimRecoilMul * (PropData.AimRecoilMul or 1)

				end
				--print(math.random(1,#Trace),#Trace)
				BC = math.max(1,BC)
				
				local BigVal = (RecoilH+OffsetH+RecoilV+OffsetV)/2
				RecoilR = -math.Rand(-BigVal,BigVal)
				RecoilH = -math.Rand(RecoilH-OffsetH,RecoilH+OffsetH)
				RecoilV = -math.Rand(RecoilV-OffsetV,RecoilV+OffsetV)



				MPos = DupeDataC:LocalToWorld(MPos)

				if self:GetAiming() then

					Spread = Spread * (0.85*AimSpreadMul) * GetConVar("savee_nspw_gun_aim_spreadreducemul"):GetFloat() 

					local FV = 0.85 * AimRecoilMul * GetConVar("savee_nspw_gun_aim_recoilreducemul"):GetFloat()

					RecoilH = RecoilH * FV
					RecoilV = RecoilV * FV

					OffsetH = OffsetH * FV
					OffsetV = OffsetV * FV

					TrueRecoil = TrueRecoil * FV
					TrueRecoilOffset = TrueRecoilOffset * FV
				
				end
				
				local Recoil = Angle(RecoilH,RecoilV,RecoilR)

				local DHand = PropData.DoubleHand

				local AccPunishMul = 1

				if !MyStyle.DoubleHand and DHand then --重量检测

					Recoil = Recoil * GetConVar("savee_nspw_damage_gun_twohandrecoilpunish"):GetFloat()

					AccPunishMul = GetConVar("savee_nspw_damage_gun_twohandaccpunish"):GetFloat()

				end
				--local HPos = owner:IsPlayer() and owner:GetEyeTrace().HitPos or util.QuickTrace(owner:EyePos(),owner:GetAimVector(),owner).HitPos

				--self:CallOnClient("DoScreenShake")

				for i=1,BC do
					--local AimVec = (HPos-MPos):GetNormalized()
					local Trace = {Trace[math.random(1,#Trace)]}
					local MF = {MF[math.random(1,#MF)]}
					local HitEffect = {HitEffect[math.random(1,#HitEffect)]}
					
					local AimVec = owner:GetAimVector()
					if self.MarkedAsLambdaWep and IsValid(self.nspw_LambdaTarget)then
						AimVec = (self.nspw_LambdaTarget:WorldSpaceCenter() - owner:EyePos()):GetNormalized()
					elseif owner:IsNPC() and (IsValid(owner:GetTarget()) or IsValid(owner:GetEnemy())) then
						local tar = IsValid(owner:GetTarget()) and owner:GetTarget() or owner:GetEnemy()
						--print(tar)
						AimVec = (LerpVector(bodyOnly[tar:GetClass()] and 0 or math.random(4,9)/10, tar:WorldSpaceCenter(), tar:EyePos()) - owner:EyePos()):GetNormalized()
					end


					if Spread != Angle(0,0,0) then

						local bs = Spread
						local p,y,r = bs.p,bs.y,bs.r
						if owner:IsNPC() then

							local offset = self:GetNPCBulletSpread(owner:GetCurrentWeaponProficiency())
							p = p + offset
							y = y + offset
							r = r + offset

						end
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



					TrueRecoil = math.Rand(TrueRecoil-TrueRecoilOffset,TrueRecoil+TrueRecoilOffset)
					if owner:IsPlayer() then
						owner:ViewPunch(Recoil*(MyStyle.RecoilMul or 1)-owner:GetViewPunchAngles()/10)
						Recoil.z = 0
						owner:SetEyeAngles(owner:EyeAngles()+Recoil*TrueRecoil*(MyStyle.RecoilMul or 1))
					end

					if PropData.ProjectileClass then


						local proj = ents.Create(PropData.ProjectileClass)
						proj:SetOwner(owner)
						proj.NSPW_Projectile = true
						proj:SetCustomCollisionCheck(true)
						proj:SetPos(owner:EyePos() + owner:GetAimVector() * 10)
						proj:SetAngles(AimVec:Angle() + PropData.ProjectileAngle)
						if isfunction(PropData.ProjectilePreCreate) then
							--print("?")
							PropData.ProjectilePreCreate(proj)
						end
						proj:SetVelocity(AimVec * PropData.ProjectileVelocity)
						proj:Spawn()
						if isfunction(PropData.ProjectileCreated) then
							PropData.ProjectileCreated(proj)
						end
						proj:Activate()


						if PropData.ProjectileVelocityRotateAng then
							AimVec:Rotate(PropData.ProjectileVelocityRotateAng)
						end
						--timer.Simple(FrameTime(),function()
							--if !IsValid(proj) then return end
						--end)

					else

						local tr = {
							maxs = Vector(HS,HS,HS),
							mins = Vector(-HS,-HS,-HS),
							start = owner:EyePos(),
							endpos = owner:EyePos()+AimVec*(PropData.BulletDistance or 56756),
							mask = MASK_SHOT_PORTAL,
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

						if tr.Hit then

							--local

							local Dmginfo = DamageInfo()
							--Dmginfo:SetHit
							if tr.HitGroup == HITGROUP_HEAD then
								dmg = dmg * GetConVar("savee_nspw_damage_gun_headshotmult"):GetFloat()
							end

							local Force = 500

							if tr.Entity:Health() <= dmg and tr.Entity:GetMaxHealth() > 0 then
								Force = Force*2
							end

							Dmginfo:SetDamage(dmg)
							Dmginfo:SetDamageType(DmgType)
							Dmginfo:SetDamageForce(AimVec*Force*(PropData.BulletForce or math.min(10,dmg/5)))
							Dmginfo:SetDamagePosition(tr.HitPos)
							--Dmginfo:SetHit
							Dmginfo:SetReportedPosition(tr.HitPos)
							Dmginfo:SetInflictor(DupeDataC)
							Dmginfo:SetAttacker(owner)

							for ent,_ in pairs(DupeData) do

								if !IsValid(ent) then continue end

								local PropData = NSPW_DATA_PROPDATA[ent] or {}

								if isfunction(PropData.BulletCallback) then

									PropData.BulletCallback(self,owner,tr,Dmginfo,function(v)
										Trace[#Trace + 1] = v
									end,function(v)
										MF[#MF + 1] = v
									end,function(v)
										HitEffect[#HitEffect + 1] = v
									end)
								end

							end
							EntMeta.TakeDamageInfo(tr.Entity,Dmginfo)
						end

						--print(AimVec)

						Trace = Trace[math.random(1,#Trace)]
						MF = MF[math.random(1,#MF)]
						HitEffect = HitEffect[math.random(1,#HitEffect)]

						--虽然util.Effect可以同步到客户端(多人),但是我们要求精细化(神他妈方格弹孔)
						if !GameIsSP then
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

							ed:SetEntity(DupeDataC)
							util.Effect(MF or "MuzzleFlash",ed)

						end

					end

				end

				--[[if self:GetAiming() then

					time = time + 0.03

				end]]

				self:SetNextPrimaryFire(CurTime()+math.max(0.02,time))
			elseif !MyStyle.IsGun then

				self:Swing(owner,PropData,MyStyle)

			end

		end

		
	else

	end


end

function SWEP:OnDrop()
	if CLIENT then return end
	self:DropMySelf("all")
	self:Remove()
end

function SWEP:GetNPCBurstSettings()

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if !self.Initialized or !DupeDataC then return end

	local MyStyle = self:GetStyleData()

	local time = 0.1
	--print(#self.WireIO_E2List == 0)
	local Count = 0




	--print(self:GetHoldType())

	--Style检测

	--local Ents = {}
	--local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		local Heavy --= true
		local mass = 0
		time = PropData.NextFireTime or time

		for ent,_ in pairs(DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
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

		return time < 0.65 and 3 or 1,time < 0.45 and 7 or 2,time-0.05


			

	elseif !MyStyle.IsGun then

		return 1,1,1

	end


end

function SWEP:GetNPCBulletSpread(pro)

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if !self.Initialized or !DupeDataC then return end

	local MyStyle = self:GetStyleData()




	--print(self:GetHoldType())

	--Style检测

	--local Ents = {}
	--local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		local Heavy --= true
		local mass = 0
		time = PropData.NextFireTime or time

		for ent,_ in pairs(DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			if PropData.ForceHeavyWeapon then
				Heavy = true
			end

			local pobj = ent:GetPhysicsObject()
			local CV = GetConVar(ent == DupeDataC and "savee_nspw_delay_massmul" or "savee_nspw_delay_massmulchildren")
			if IsValid(pobj) then 
				mass = mass + pobj:GetMass()*CV:GetFloat()
			else
				mass = mass + GetConVar("savee_nspw_mass_nonphysics"):GetFloat()*CV:GetFloat()
			end


		end

		if mass >= GetConVar("savee_nspw_heavygun"):GetFloat() then

			Heavy = true

		end

		if PropData.PumpAction then
			return 15/pro
		end

		--Spread = (Spread.y+Spread.r)/2
		--print(pro)
		return math.max(3*(Heavy and (self:GetAiming() and 1.4 or 1.8) or 1.2)-pro,0.005)


			

	elseif !MyStyle.IsGun then

		return 0

	end


end

function SWEP:GetNPCRestTimes()

	--if !self.Initialized then return end

	local Slot,DupeData,DupeDataC = self:GetDupeData()
	if !Slot then return end

	if !self.Initialized or !DupeDataC then return end

	local MyStyle = self:GetStyleData()

	local time = 0.1


	local PropData = NSPW_DATA_PROPDATA[DupeDataC] or {}

	if MyStyle.IsGun and PropData.IsGun then

		time = PropData.NextFireTime or time

		for ent,_ in pairs(DupeData) do

			if !IsValid(ent) then continue end

			local PropData = NSPW_DATA_PROPDATA[ent] or {}
			time = time + (PropData.NextFireTime or 0)


		end

		return time+0.2,time+0.5


			

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
		
		return CAP_WEAPON_MELEE_ATTACK1 
	end
	return bit.bor(
		CAP_WEAPON_MELEE_ATTACK1,
		CAP_WEAPON_RANGE_ATTACK1,
		CAP_INNATE_RANGE_ATTACK1)
end
--SWEP.OwnerChanged = SWEP.OnRemove


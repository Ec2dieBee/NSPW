--占位符
--(它是否要依赖SAL?)
--玩家捡起东西,然后送光刻仪,然后一切物品全部NoDraw,然后该全绘制的时候就全绘制
--[[

	真.Credit
	>代码
	>>[YHG]骨灰蜜蜂: 做了这坨屎(SPW)
	>>Savee14702: 修复这坨屎并真正Re-worked这坨屎(是的这个东西应该是"重做..?"而不是"又工作了")
	>>稻谷MCUT: 优化,绘制优化

	>测试
	>>tie_chun_nya(铁锤): 早期测试(帮忙查出来一堆勾使Bug)

	>宣传
	>>TheBillinator3000: 介绍SPW(或者SP2W)
	>>NecrosViedos: 介绍SPW(或者SP2W)(以及留了个能用的存档)


	所以你都看到这了,你为什么不想办法帮我Port几个Miku模型到kenshi呢?
	(顺便帮忙Port几个Miku R-18模型到Gmod,谢了)
]]

--[[
	需要引入的文件
	某个库..?
]]

--[[
	你现在要做的事

	[完成的]
	捡起武器并传输数据 --解决
	攻击判定(避免玩家打不到人然后痛骂你一顿)
	攻击伤害检测(好了..?)
	伤害类型检测(好了)
	延迟判定(差不多)
	枪械角度强制兼容 --(说实话手对上了角度也就差不多了)

	[需进一步观望的]
	Zeta(其实是Lambda) NPCS 兼容
	Parented Entities(父子级实体)支持(修复了..?)
	更好的Network(?)
	格挡(武器击飞)
	NPC Support
	单手枪械动画
	Attachment(附加Prop)
	流星锤支持

	[未 竟 事 业]
	工具
	->PROPERTIES MODIFY
	--近战动画重做
	NPC神必小武器支持(怎么刻数据?)
	枪械系统完善
	-> 瞄准[完成]
	-> 手感优化(?)
	PropData100%全收集
	--Wiremod支持...
	E2 Functions
	->添加/移除一个Prop
	->即时检测约束
	便于他人查看的UI
	翻新(?)
	优化

	[半步入土的]
	STYLE UI重做 --几把的太懒了
	SPW彩蛋(指暴击系统和一枪头模拟器)

	[死了的]
	(啥时候能捡起布娃娃?)
	INVSYS(不这个其实是另一个Addon)
	
]]

if !SERVER then return end --放正确的地方

AddCSLuaFile("saveelib/cl_saveelib_draw.lua")

util.AddNetworkString("NSPW_TransStyleMessage")
util.AddNetworkString("NSPW_TransTraceMessage")
util.AddNetworkString("NSPW_TransPropTableMessage")
util.AddNetworkString("NSPW_TransDroppedPropMessage")

net.Receive("NSPW_TransStyleMessage", function(_,p)


	if !IsValid(p) then return end
	local Wep = p:GetActiveWeapon()

	if !IsValid(Wep) or Wep:GetClass() != "nspw_melee" then return end

	Wep:SetStyle(net.ReadString())

end)

net.Receive("NSPW_TransPropTableMessage",function(_,p)

	local Wep = net.ReadEntity()
	if !IsValid(Wep) then return end
	local Maxs = Wep.DupeData_MAX
	local Mins = Wep.DupeData_MIN
	local lenx,leny,lenz = Maxs.x-Mins.x,
						   Maxs.y-Mins.y,
						   Maxs.z-Mins.z
	local cenx,ceny,cenz = (Maxs.x+Mins.x)/2,
						   (Maxs.y+Mins.y)/2,
						   (Maxs.z+Mins.z)/2
	--print(RDupe.Maxs,RDupe.Mins)
	local x,y,z = math.abs(leny*lenz),math.abs(lenx*lenz),math.abs(lenx*leny)
	local Tar = "x"
	local len1 = cenx
	local len2 = cenz
	local fin = math.max(x,y,z)
	if fin == y then
		Tar = "y"
		len1 = ceny
		len2 = cenz
	elseif fin == z then
		Tar = "z"
		len1 = cenz
		len2 = ceny
	end
	local NewData = {}
	for ent,data in pairs(Wep.DupeData) do
		--ProtectedCall(ent.Think)
		--print(ent)
		if ent == TargetEnt then continue end
		NewData[ent:EntIndex()] = {
			--Ent = ent,
			Pos = data.Pos,
			Angle = data.Angle
		}
	end
	local Cmp = util.Compress(util.TableToJSON(NewData))
	local BA = #Cmp
	--print(util.TableToJSON(NewData))
	timer.Simple(.02+FrameTime()*10,function()

		--local Cmp = util.Compress(util.TableToJSON(NewData))
		--local BA = #Cmp
		if !IsValid(self) or !IsValid(wep) then return end

		net.Start("NSPW_TransPropTableMessage")
			net.WriteEntity(wep)
			net.WriteEntity(TargetEnt)

			net.WriteString(Tar)
			net.WriteFloat(fin^0.5)
			net.WriteFloat(len1)
			net.WriteFloat(len2)
			
			net.WriteUInt(BA, 16)
			net.WriteData(Cmp, BA)
			--net.WriteTable(Dupe)
			--net.WriteUInt(#Count,16)
			--[[for ent,data in pairs(Dupe) do
				--print(ent)
				net.WriteEntity(ent)
				--net.WriteVector(data.Pos)
				--net.WriteAngle(data.Angle)
			end]]
		net.Broadcast()

	end)
	--PrintTable(TBL)

end)

NSPW_TEMP_ENTITYCOUNT = 0

-- 原版复制器不支持世界模型,但是NSPW是SPW的究极无敌Plus,所以必须支持
-- 要解决它只能杀Dupe

--这是主要需要解决的东西

local function GetAllConstrainedEntitiesAndConstraints( ent, EntTable, ConstraintTable )

	--print("Stage0")
	if ( !IsValid( ent ) && !ent:IsWorld() ) then return end
	--print("Stage1")
	-- Translate the class name
	local classname = ent:GetClass()
	if ( ent.ClassOverride ) then classname = ent.ClassOverride end

	-- Is the entity in the dupe whitelist?
	-- 白名单将调用NSPW的,不需要这个
	if ( ent:IsWorld() or ent:GetMoveType() != MOVETYPE_VPHYSICS ) then
		-- MsgN( "duplicator: ", classname, " isn't allowed to be duplicated!" )
		return
	end
	--print("Stage2")

	-- Entity doesn't want to be duplicated.
	-- 但是这也不是复制
	--if ( ent.DoNotDuplicate ) then return end

	if ( !ent:IsWorld() ) then 
		EntTable[ ent:EntIndex() ] = ent 
	else
		return
	end

	if ( !constraint.HasConstraints( ent ) ) then return end

	local ConTable = constraint.GetTable( ent )

	for key, constr in pairs( ConTable ) do

		local index = constr.Constraint:GetCreationID()

		if ( !ConstraintTable[ index ] ) then

			-- Add constraint to the constraints table
			ConstraintTable[ index ] = constr

			-- Run the Function for any ents attached to this constraint
			for _, ConstrainedEnt in pairs( constr.Entity ) do

				if ( !ConstrainedEnt.Entity:IsWorld() ) then

					GetAllConstrainedEntitiesAndConstraints( ConstrainedEnt.Entity, EntTable, ConstraintTable )

				end

			end

		end
	end

	return EntTable, ConstraintTable

end

local duplicator = table.Copy(duplicator)

function duplicator.Copy( Ent, AddToTable )

	--print("我叫了几次")

	local Ents = {}
	local Constraints = {}

	GetAllConstrainedEntitiesAndConstraints( Ent, Ents, Constraints )

	local EntTables = {}
	if ( AddToTable != nil ) then EntTables = AddToTable.Entities or {} end

	for k, v in pairs( Ents ) do
		EntTables[ k ] = duplicator.CopyEntTable( v )
	end

	local ConstraintTables = {}
	if ( AddToTable != nil ) then ConstraintTables = AddToTable.Constraints or {} end

	for k, v in pairs( Constraints ) do
		ConstraintTables[ k ] = v
	end

	local mins, maxs = duplicator.WorkoutSize( EntTables )

	return {
		Entities = EntTables,
		Constraints = ConstraintTables,
		Mins = mins,
		Maxs = maxs
	}

end

function duplicator.CopyEnts( Ents )

	local Ret = { Entities = {}, Constraints = {} }

	for k, v in pairs( Ents ) do

		Ret = duplicator.Copy( v, Ret )

	end

	return Ret

end



local DebugMessageDraw = true

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

local ConstraintWhiteList = {
	["Weld"] = true,
	["NoCollide"] = true,
	["Rope"] = true,
	["Axis"] = true,
	--["Rope"] = true,
}
--false: 仍然在视觉模型上绘制,不归位(无碰撞)
--true: 绘制世界模型,收放强制归位(有碰撞)
--local NotSoConstraintWhiteList = {
--}

local _ply = FindMetaTable("Player")

function _ply:NSPW_PickupItem()

	local TargetEnt = self:GetEyeTrace().Entity

	--查距离,大伙都不是长臂猿
	--求一个值的平方的占用比开一个值的方小(确信)
	if TargetEnt:GetPos():DistToSqr(self:GetPos()) > GetConVar("savee_nspw_pickuprange"):GetFloat()^2 then return end

	local function WhoIsMyDaddy(child)

		local father = child:GetParent()

		if !IsValid(father) or father == child then return child end
		
		return WhoIsMyDaddy(father)

	end

	TargetEnt = WhoIsMyDaddy(TargetEnt)

	--等下暗影刀?????
	--if TargetEnt.NSPW_PROP_NOCONSTRAINT then return end

	

	--过第一遍检测,检测有没有非白名单约束+查优先级
	local Dupe = duplicator.Copy(TargetEnt)

	DebugMessage("[NSP2W捡起检测]Dupe表",Dupe)

	for _,data in pairs(Dupe.Constraints) do
		--防止某人做的流星锤崩服
		--PrintTable(data)
		if !ConstraintWhiteList[data.Type] then 
			DebugMessage("[NSP2W捡起检测] 发现非白名单约束,开润",data.Type)
			return
		end
	end


	--查询优先级
	local CurPriority = 0
	local PropData = {}
	for i,data in pairs(Dupe.Entities) do

		local ent = Entity(i)
		local NPropData = NSPW_DATA_PROPDATA[ent]

		if !IsValid(ent) or !NPropData or ent.NSPW_PROP_NOCONSTRAINT then continue end

		if (NPropData.Priority or 0) > CurPriority then

			CurPriority = NPropData.Priority
			TargetEnt = ent
			--print("城镇交替")
			PropData = NPropData

		end

	end


	DebugMessage("[NSP2W捡起检测]检测成功,开始同步数据 优先级最大的实体: ",TargetEnt)

	--[[local DPos,DAng = LocalToWorld(
		(PropData.OffsetPos or Vector()),
		(PropData.OffsetAng or Angle()),
		TargetEnt:GetPos(),
		TargetEnt:GetAngles()
	)

	duplicator.SetLocalPos(DPos)
	duplicator.SetLocalAng(DAng)]]
	duplicator.SetLocalPos(TargetEnt:GetPos())
	duplicator.SetLocalAng(TargetEnt:GetAngles())

	--duplicator.Copy(Entity ent, table tableToAdd={})

	local Children = {}
	--local Found = {}

	local function GetChildrens(ent)

		if !IsValid(ent) then return end
		--print(114)
		--PrintTable(ent:GetChildren())
		--[[for _,cent in pairs(ent:GetChildren()) do
			if !IsValid(cent) or Children[cent] then continue end
			Children[cent] = true
			GetChildrens(cent)
		end]]
		--事实: 上面那个东西查不到太多 
		for _,cent in pairs(ents.GetAll()) do 

			if !IsValid(cent) or Children[cent] then continue end
			
			if cent:GetParent() != ent then continue end
			--print(cent,ent)

			--Found[cent] = true
			Children[cent] = true
			GetChildrens(cent)
			--print(cent)
			--print(ent)


		end

	end

	for i,data in pairs(table.Copy(Dupe.Entities)) do
		
		if !tonumber(i) then continue end

		local Ent = Entity(i)
		
		if !IsValid(Ent) then continue end

		GetChildrens(Ent)

		if istable(Ent.NSPW_EXTRAENT) then
			table.Merge(Children,Ent.NSPW_EXTRAENT)
			--[[for e,_ in pairs(Ent.NSPW_EXTRAENT) do
				if !Children[e] then
					Children[e] = true
				end
			end]]
		end

	end

	RDupe = duplicator.Copy(TargetEnt)
	local Const = RDupe.Constraints
	Dupe = RDupe.Entities
	--PrintTable(Children)
	--local data = duplicator.CopyEnts(Children).Entities
	for i,_ in pairs(Children) do

		if !IsValid(i) then continue end

		local ei = i:EntIndex()
		--print(i)

		if Dupe[ei] then continue end
		Dupe[ei] = duplicator.CopyEntTable(i)

	end
	--PrintTable(duplicator.CopyEnts(Children).Entities)

	duplicator.SetLocalPos(vector_origin)
	duplicator.SetLocalAng(angle_zero)
	--接替
	--local ConstEntTbl = {}
	local Count = {}

	local function AddData(i,data)
		local e = Entity(tonumber(i))
		parent = e:GetParent()
		--TODO: 加PPM
		--[[if !e.NSPW_PROP_NOCONSTRAINT and (!IsValid(parent) or parent == e) then
			--ConstEntTbl[e] = data
			data.NSPW_PROP_TEMP_HASPARENT
			--print("?")
		end]]

		if IsValid(parent) and parent != e then
			e.NSPW_PROP_PARENTLPos = e:GetLocalPos()
			e.NSPW_PROP_PARENTLAng = e:GetLocalAngles()
		end

		e.NSPW_PROP_MYPARENT = parent
		e.NSPW_PROP_OLDCOLLISIONCHECK = e:GetCustomCollisionCheck()
		e.NSPW_PROP_OLDCOLLISIONGROUP = e:GetCollisionGroup()
		
		if !e:GetNoDraw() then
			Count[#Count + 1] = i
			--if !e.NSPW_PROP_NOCONSTRAINT then
			Dupe[e] = data
			--end
		end
		Dupe[i] = nil
	end
	for i,data in pairs(table.Copy(Dupe)) do
		AddData(i,data)
	end

	--在这里做枪械/近战检测
	DebugMessage(Dupe)
	SetGlobalInt("NSPW_TEMP_ENTITYCOUNT",#Count)

	if self:HasWeapon("nspw_melee") then
		self:StripWeapon("nspw_melee")--:Remove()
	end

	local wep = ents.Create("nspw_melee")

	wep:SetOwner(self)

	--这些数据发给客户端用于绘制,真正位移在服务端
	--wep:SetPropEntityCount(#Count)
	--wep:SetPropParentEntity(TargetEnt)
	--[[for i, index in pairs(Count) do

		wep["SetPropEntity"..i](wep,Entity(index))
		--print(Entity(index))

	end]]
	wep.DupeData = table.Copy(Dupe)
	wep.DupeData_MAX = RDupe.Maxs
	wep.DupeData_MIN = RDupe.Mins
	--wep.DupeDataConstraint = ConstEntTbl
	wep.DupeDataC = TargetEnt
	--wep:Spawn()
	wep:Holster()
	self:PickupWeapon(wep)
	--在下一Tick的下一Tick(大概)调用它,因为它出现在客户端需要亿点点Tick
	--Todo: 帧影响
	--table.Merge(Dupe,NoConstraint)
	--[[for _,d in pairs(Const) do
		
		--NAH I'M JUST A CONSTRAINT. ARE YOU EXPECTING TO GET ANYTHING FROM ME?

		if !IsValid(d.Constraint) or !d.Constraint:IsConstraint() then continue end
		Dupe[d.Constraint] = {}

	end]]
	--RDupe.Maxs = RDupe.Maxs - TargetEnt:OBBCenter()
	--RDupe.Mins = RDupe.Mins - TargetEnt:OBBCenter()
	local lenx,leny,lenz = RDupe.Maxs.x-RDupe.Mins.x,
						   RDupe.Maxs.y-RDupe.Mins.y,
						   RDupe.Maxs.z-RDupe.Mins.z
	local cenx,ceny,cenz = (RDupe.Maxs.x+RDupe.Mins.x)/2,
						   (RDupe.Maxs.y+RDupe.Mins.y)/2,
						   (RDupe.Maxs.z+RDupe.Mins.z)/2
	--print(RDupe.Maxs,RDupe.Mins)
	local x,y,z = math.abs(leny*lenz),math.abs(lenx*lenz),math.abs(lenx*leny)
	local Tar = "x"
	local len1 = cenx
	local len2 = cenz
	local fin = math.max(x,y,z)
	if fin == y then
		Tar = "y"
		len1 = ceny
		len2 = cenz
	elseif fin == z then
		Tar = "z"
		len1 = cenz
		len2 = ceny
	end
	local NewData = {}
	for ent,data in pairs(Dupe) do
		--ProtectedCall(ent.Think)
		--print(ent)
		if ent == TargetEnt then continue end
		NewData[ent:EntIndex()] = {
			--Ent = ent,
			Pos = data.Pos,
			Angle = data.Angle
		}
	end
	local Cmp = util.Compress(util.TableToJSON(NewData))
	local BA = #Cmp
	--print(util.TableToJSON(NewData))
	timer.Simple(.02+FrameTime()*10,function()

		--local Cmp = util.Compress(util.TableToJSON(NewData))
		--local BA = #Cmp
		if !IsValid(self) or !IsValid(wep) then return end

		net.Start("NSPW_TransPropTableMessage")
			net.WriteEntity(wep)
			net.WriteEntity(TargetEnt)

			net.WriteString(Tar)
			net.WriteFloat(fin^0.5)
			net.WriteFloat(len1)
			net.WriteFloat(len2)
			
			net.WriteUInt(BA, 16)
			net.WriteData(Cmp, BA)
			--net.WriteTable(Dupe)
			--net.WriteUInt(#Count,16)
			--[[for ent,data in pairs(Dupe) do
				--print(ent)
				net.WriteEntity(ent)
				--net.WriteVector(data.Pos)
				--net.WriteAngle(data.Angle)
			end]]
		net.Broadcast()

	end)
	--end
	--print(#Count)
	--wep:Spawn()



end

concommand.Add("savee_nspw_debug_pickup",function(p)
	p:NSPW_PickupItem()
end)

--[[local BlackList = {
	[MOVETYPE_VPHYSICS] = true,
}]]

hook.Add("ShouldCollide","NSPW_Hooks_NoCollideWeapon",function(e1,e2)

	--print(e1,e2,(e2:GetMoveType() != MOVETYPE_VPHYSICS or e1:GetMoveType() != MOVETYPE_VPHYSICS))
		--print(e1,e2)
	if IsValid(e1.NSPW_PROP_RELATEDWEAPON) and IsValid(e1.NSPW_PROP_RELATEDWEAPON:GetOwner()) and 
	(
		(
			(isfunction(e1.NSPW_PROP_RELATEDWEAPON:GetOwner().GetActiveWeapon) and e1.NSPW_PROP_RELATEDWEAPON:GetOwner():GetActiveWeapon() != e1.NSPW_PROP_RELATEDWEAPON)
			or e2 == e1.NSPW_PROP_RELATEDWEAPON:GetOwner() 
			or e2.NSPW_PROP_RELATEDWEAPON) 
		--[[or 
		(
			!BlackList[e2:GetMoveType()]
		)]]
	) then -- and (e2:GetMoveType() != MOVETYPE_VPHYSICS or e1:GetMoveType() != MOVETYPE_VPHYSICS) then
		--print("?")
		return false
	end

end)

local AllowedDamageTable = {
	[DMG_CLUB] = true,
	[DMG_GENERIC] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
}

hook.Add("EntityTakeDamage","NSPW_Hooks_BlockDamage",function(ply,dinfo)

	if !IsValid(ply) or !ply:IsPlayer() then return end

	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) or wep:GetClass() != "nspw_melee" or !(wep:GetBlocking() or wep:GetStyleData().AlwaysBlock) then return end

	
	local dmg = dinfo:GetDamage()
	local dmgtype = dinfo:GetDamageType()
	local dmgpos = dinfo:GetDamagePosition()

	if !AllowedDamageTable[dmgtype] then return end
	
	local mul = GetConVar("savee_nspw_block_dmgmul"):GetFloat()

	local mindmg = dmg * GetConVar("savee_nspw_block_dmgmulmin"):GetFloat()

	local advdecton = GetConVar("savee_nspw_block_advdect"):GetBool()
	local DRpermass = GetConVar("savee_nspw_block_dmgresistpermass"):GetFloat()
	local dmgToPropMul = GetConVar("savee_nspw_block_dmgtopropmul"):GetFloat()

	local dmgToPropBase = dmg - dmg*mul
	dmg = dmg*mul

	local Count = 0

	local TargetProp = {}

	for ent,data in pairs(wep.DupeData) do

		if !IsValid(ent) then continue end

		local PropData = NSPW_DATA_PROPDATA[ent] or {}

		local pobj = ent:GetPhysicsObject()
		local mass
		if IsValid(pobj) then 
			mass = pobj:GetMass()
		else
			mass = GetConVar("savee_nspw_mass_nonphysics"):GetFloat()
		end

		if advdecton and 
		ent:GetPos():DistToSqr(dmgpos) > GetConVar("savee_nspw_block_advdect_range"):GetFloat()^2 
		then 
			continue 
		end
			--print("?")

		local dmgresist = math.floor(mass*DRpermass)*(1+(PropData.BlockMulAdjust or 0))

		dmgToPropBase = dmgToPropBase + dmgresist
		dmg = dmg - dmgresist
		TargetProp[#TargetProp + 1] = ent

		Count = Count + 1

	end

	local def = 0

	--local OriginalDamage = d

	for _,ent in pairs(TargetProp) do
		
		if !IsValid(ent) then continue end


		local PropData = NSPW_DATA_PROPDATA[ent] or {}
		--武器击飞
		if GetConVar("savee_nspw_block_weapondrop_on"):GetBool() then

			local Val = GetConVar("savee_nspw_block_weapondrop_massprovidepermass"):GetFloat()

			def = def + (PropData.BlockDefence or 0)

			local pobj = ent:GetPhysicsObject()
			if IsValid(pobj) then 
				--print(pobj:GetMass())
				def = def + pobj:GetMass() * Val
			else
				def = def + GetConVar("savee_nspw_mass_nonphysics"):GetFloat() * Val
			end

		end

		--武器破损
		if GetConVar("savee_nspw_block_dmgtoprop"):GetBool() then

			dmgToPropBase = dmgToPropBase/Count*dmgToPropMul




			local di = DamageInfo()
			di:SetAttacker(dinfo:GetAttacker())
			di:SetDamagePosition(dmgpos)
			di:SetInflictor(dinfo:GetInflictor())
			di:SetDamageType(PropData.BlockDamageType or dmgtype)
			di:SetBaseDamage(dinfo:GetBaseDamage())
			di:SetDamage(dmgToPropBase*(PropData.BlockDamageMul or 1))
			di:SetDamageForce(dinfo:GetDamageForce())
			di:SetReportedPosition(dinfo:GetReportedPosition())

			ent:TakeDamageInfo(di)
		end

	end

	if GetConVar("savee_nspw_block_weapondrop_on"):GetBool() and def < dinfo:GetDamage() then

		wep:DropMySelf()
		ply:PrintMessage(4, "你武器被震掉了")

	end

	dmg = math.max(dmg,mindmg)

	ply:EmitSound("physics/metal/weapon_impact_hard"..math.random(1,3)..".wav",80,math.random(90,140))

	dinfo:SetDamage(dmg)

	

end)

duplicator.RegisterEntityModifier( "NSPW_MODIFIER_PROPERTIESSTATE", function(p,e,d)

	e.NSPW_PROP_DISABLEPROPERTIES = d[1]

end)
duplicator.RegisterEntityModifier( "NSPW_MODIFIER_NOCONSTRAINT", function(p,e,d)

	e.NSPW_PROP_NOCONSTRAINT = d[1]

end)

--[[local ent = ents.Create("prop_physics")
ent:SetModel("models/props_c17/oildrum001.mdl")
ent:SetPos(Vector(8000,8000,8000))
ent:Spawn()
timer.Simple(5, function()
	net.Start("NSPW_TransPropTableMessage")
		net.WriteUInt(ent:EntIndex(),16)
	net.Broadcast()
end)]]

--DebugMessage("DSB")

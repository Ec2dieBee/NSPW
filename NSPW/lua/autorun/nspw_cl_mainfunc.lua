AddCSLuaFile()

if SERVER then return end

local EntMeta = FindMetaTable("Entity")

net.Receive("NSPW_TransTraceMessage",function()

	local Wep = net.ReadEntity()
	local Src = Vector(net.ReadFloat(),net.ReadFloat(),net.ReadFloat())
	local Dir = Vector(net.ReadFloat(),net.ReadFloat(),net.ReadFloat())
	local owner = Wep:GetOwner()
	local _,_,DupeDataC = Wep:GetDupeData()
	local PropData = NSPW_DATA_PROPDATA[DupeDataC:GetModel()]
	local HS = PropData.BulletHullSize or 0
	--print(IsValid(o) , o:GetShootPos() , Wep:GetPos())

	--print(Dir)
	--print(Src)
	--print("CALL")
	local T = net.ReadTable()

	local tr = {
		maxs = Vector(HS,HS,HS),
		mins = Vector(-HS,-HS,-HS),
		start = owner:EyePos(),
		endpos = owner:EyePos() + Dir * (PropData.BulletDistance or 56756),
		mask = MASK_SHOT,
		filter = T,
	}

	if PropData.BulletHullSize then
		tr = util.TraceHull(tr)
	else
		tr = util.TraceLine(tr)
	end
	local trwater = util.TraceLine({
		start = Src,
		endpos = tr.HitPos,
		mask = MASK_WATER,
		filter = T,
	})

	local ed = EffectData()
	ed:SetOrigin( tr.HitPos )
	ed:SetNormal(tr.HitNormal)
	ed:SetEntity(tr.Entity)
	ed:SetDamageType(DMG_BULLET)
	ed:SetStart(Src)
	ed:SetSurfaceProp(tr.SurfaceProps)
	--ed:SetEntity(self)
	util.Effect( net.ReadString(), ed )
	if (tr.MatType == MAT_ANTLION or tr.MatType == MAT_FLESH) and IsValid(tr.Entity) and tr.Entity:GetMaxHealth() > 0 then

		util.Effect( "BloodImpact", ed )

	end
	--local ed = EffectData()
	ed:SetOrigin( trwater.HitPos )
	ed:SetScale(5)
	util.Effect( "waterripple", ed )

	ed:SetScale(GetConVar("savee_nspw_debug_slowtrace"):GetBool() and 100 or 10000)
	--print(Trace)
	util.Effect( net.ReadString(), ed )

	ed = EffectData()
	ed:SetAttachment(1)
	ed:SetAngles(Angle())
	ed:SetOrigin(Src)
	ed:SetFlags(net.ReadUInt(5))

	ed:SetEntity(DupeDataC)
	util.Effect(net.ReadString(),ed)

end)

net.Receive("NSPW_TransPropTableMessage",function()

	--print("REC")
	--print(Entity(net.ReadUInt(16)))

	--do return end


	local wep = net.ReadEntity()
	local DupeDataC = net.ReadEntity()
	local Slot = net.ReadUInt(8)

	--if Wep.DupeDataInitialized then return end
	--print("IRECEIVEa!")

	local DrawAxis = net.ReadString()
	local Dist,DrawX,DrawY = net.ReadFloat(),net.ReadFloat(),net.ReadFloat()
	--local Count = net.ReadUInt(16)
	local DupeData = {}
	local BA = net.ReadUInt(16)
	local Data = net.ReadData(BA)
	local DeCmp = util.Decompress(Data or "")
	local Tbl = util.JSONToTable(DeCmp or "") or {}

	for ei,data in pairs(Tbl) do
		DupeData[Entity(ei)] = data
	end
	--local DupeDataC = DupeData.DupeDataC
	DupeData[DupeDataC] = {
		Pos = Vector(),
		Angle = Angle(),
	}


	for ent,_ in pairs(DupeData) do
		--local Ent = net.ReadEntity()

		--print(Ent)

		if !IsValid(ent) then continue end
		--print(Wep.DupeData)
		--Ent:SetParent(NULL)
		if ent.NSPW_PROP_CL_PREDICTABLE == nil then
			ent.NSPW_PROP_CL_PREDICTABLE = EntMeta.GetPredictable(ent)
		end
		print(ent)
		--if isfunction(Ent.Draw) then
			EntMeta.SetPredictable(ent,true)
			--EntMeta.SetParent(Ent,NULL)
			--print("?")
		--end
		--[[timer.Simple(1,function()
			if !IsValid(Ent) then return end
		end)]]
		--GM.NotifyShouldTransmit(Ent,true)

		--DupeData[Ent] = {} --{Pos = net.ReadVector(),Ang = net.ReadAngle()}

	end
	--Wep.DupeDataC = DupeDataC
	if !wep.DupeData then wep.DupeData = {} end
	wep.DupeData[Slot] = {
		DupeDataC = DupeDataC,
		Data = DupeData,
		NSPW_DrawAxis = DrawAxis,
		NSPW_DrawSize = {DrawX,DrawY,Dist}
		}
	wep.DupeDataInitialized = true
	if Slot != wep:GetSlot() then
		wep:Holster_Slot(Slot)
	end
	--Wep.NSPW_DrawAxis = DrawAxis
	--Wep.NSPW_DrawSize = {DrawX,DrawY,Dist}
	--Wep.DataSynced = true
	--PrintTable(TBL)

end)

net.Receive("NSPW_TransDroppedPropMessage",function()

	local Tbl = net.ReadTable()

	for _,ei in pairs(Tbl or {}) do

		--print("?")

		local ent = Entity(ei)

		if !IsValid(ent) then continue end

		ent:SetNoDraw(false)

		ent:SetRenderOrigin(nil)
		ent:SetRenderAngles(ent:IsPlayer() and ent:GetAngles() or nil)


		if ent.NSPW_PROP_CL_RENDEROVERRIDESETTED then
			ent.RenderOverride = ent.NSPW_PROP_CL_RENDEROVERRIDE
			ent.NSPW_PROP_CL_RENDEROVERRIDE = nil
			ent.NSPW_PROP_CL_RENDEROVERRIDESETTED = nil
		end

		EntMeta.DrawModel(ent)

		--EntMeta.FollowBone(ent,NULL,-1)
		--EntMeta.SetParent(ent,NULL)
		EntMeta.SetPredictable(ent,ent.NSPW_PROP_CL_PREDICTABLE or false)



		ent.NSPW_PROP_CL_PREDICTABLE = nil


	end

end)

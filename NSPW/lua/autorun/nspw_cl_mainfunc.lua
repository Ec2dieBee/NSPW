AddCSLuaFile()

if SERVER then return end

net.Receive("NSPW_TransTraceMessage",function()

	local Wep = net.ReadEntity()
	local Src = Vector(net.ReadFloat(),net.ReadFloat(),net.ReadFloat())
	local Dir = Vector(net.ReadFloat(),net.ReadFloat(),net.ReadFloat())
	local owner = Wep:GetOwner()
	local PropData = NSPW_DATA_PROPDATA[Wep.DupeDataC:GetModel()]
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

	ed:SetEntity(Wep.DupeDataC)
	util.Effect(net.ReadString(),ed)

end)

net.Receive("NSPW_TransPropTableMessage",function()

	local Wep = net.ReadEntity()
	local DupeDataC = net.ReadEntity()
	local Count = net.ReadUInt(16)
	local DupeData = {}

	for i = 1,Count do
		local Ent = net.ReadEntity()

		--print(Ent)

		if !IsValid(Ent) then continue end
		--print(Wep.DupeData)
		DupeData[Ent] = {}

	end
	Wep.DupeDataC = DupeDataC
	Wep.DupeData = DupeData
	Wep.DupeDataInitialized = true
	--PrintTable(TBL)

end)

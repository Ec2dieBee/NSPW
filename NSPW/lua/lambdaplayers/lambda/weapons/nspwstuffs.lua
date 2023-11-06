AddCSLuaFile()

include("autorun/nspw_sh_propdata.lua")

if SERVER then
	if !NSPW_DATA_LAMBDADUPES then NSPW_DATA_LAMBDADUPES = {} end
	
	local function Load()
		for _,data in pairs(file.Find("saveestuffs/nspw/*.json","DATA")) do

			local val = string.sub(data, 0,#data - 5)
			NSPW_DATA_LAMBDADUPES[val] = util.JSONToTable(file.Read("saveestuffs/nspw/"..data))

			--GenLambdaWep(val,data)

			--print("?")
			
		end
	end

	Load()
end
local NSPW_WEAPON = weapons.Get("nspw_melee")

local WepMeta = table.Copy(FindMetaTable("Weapon"))
local EntMeta = table.Copy(FindMetaTable("Entity"))
--table.Inherit(WepMeta, EntMeta)

--WepMeta = table.Merge(EntMeta,WepMeta)

--PrintTable(debug.getinfo(WepMeta.__concat))--WepMeta)

--[[function WepMeta:__index(key)

	print(1,self,key)

end]]

function EntMeta:__index( key )

	--debug.setmetatable(self, EntMeta)

	--
	-- Search the metatable. We can do this without dipping into C, so we do it first.
	--

	--
	-- Search the entity metatable
	--
	local val = EntMeta[key]
	if ( val != nil ) then return val end

	local val = WepMeta[key]
	if ( val != nil ) then return val end
	--
	-- Search the entity table
	--
	local tab = EntMeta.GetTable( self )
	if ( tab != nil ) then
		local val = tab[ key ]
		if ( val != nil ) then return val end
	end

	--
	-- Legacy: sometimes use self.Owner to get the owner.. so lets carry on supporting that stupidness
	-- This needs to be retired, just like self.Entity was.
	--
	if ( key == "Owner" ) then return EntMeta.GetOwner( self ) end
	
	return nil
	
end

EntMeta.MetaName = "NSPW LAMBDA WEAPON"

function EntMeta:GetHoldType()

	return self.HoldType or "pistol"

end
function EntMeta:SetHoldType(ht)

	self.HoldType = ht

end
function EntMeta:GetNextPrimaryFire()

	return self._nspwnextattack or 0

end
function EntMeta:SetNextPrimaryFire(v)

	self._nspwnextattack = v

end
function EntMeta:CallOnClient()


end

function EntMeta:SendWeaponAnim()

end

function EntMeta:SetClip1(v)

	self:GetOwner().l_Clip = v

end
function EntMeta:Clip1(v)

	return self:GetOwner().l_Clip

end
function EntMeta:GetMaxClip1()

	return self.Primary.ClipSize

end

--if SERVER then PrintTable(EntMeta) end

--WepMeta.__newindex = EntMeta.__newindex


--setmetatable(NSPW_WEAPON,WepMeta)

local ConstraintWhiteList = {
	["Weld"] = true,
	["Rope"] = true,
	["NoCollide"] = true,
}

local function NSPW_PickupItem(TargetEnt,wep)



	--查距离,大伙都不是长臂猿
	--求一个值的平方的占用比开一个值的方小

	local function WhoIsMyDaddy(child)

		local father = child:GetParent()

		if !IsValid(father) or father == child then return child end
		
		return WhoIsMyDaddy(father)

	end

	TargetEnt = WhoIsMyDaddy(TargetEnt)

	

	--过第一遍检测,检测有没有非白名单约束+查优先级
	local Dupe = duplicator.Copy(TargetEnt)


	for _,data in pairs(Dupe.Constraints) do
		--防止某人做的流星锤崩服
		if !ConstraintWhiteList[data.Type] then 
			return
		end
	end


	--查询优先级
	local CurPriority = 0
	local PropData = {}
	for i,data in pairs(Dupe.Entities) do

		if !NSPW_DATA_PROPDATA[data.Model] then continue end

		if (NSPW_DATA_PROPDATA[data.Model].Priority or 0) > CurPriority then

			CurPriority = NSPW_DATA_PROPDATA[data.Model].Priority
			TargetEnt = Entity(i)
			--print("城镇交替")
			PropData = NSPW_DATA_PROPDATA[data.Model]

		end

	end


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
	local Found = {}

	local function GetChildrens(ent)

		if !IsValid(ent) then return end
		--print(114)
		--PrintTable(ent:GetChildren())
		--for _,ent in pairs(ent:GetChildren()) do
		--事实: 上面那个东西查不到太多 
		for _,cent in pairs(ents.GetAll()) do 

			if !IsValid(cent) or Found[cent] then continue end
			
			if cent:GetParent() != ent then continue end
			--print(cent,ent)

			Found[cent] = true
			Children[#Children + 1] = cent
			GetChildrens(cent)
			--print(ent)


		end

	end

	for i,data in pairs(table.Copy(Dupe.Entities)) do
		
		if !tonumber(i) then continue end

		local Ent = Entity(i)
		
		if !IsValid(Ent) then continue end

		GetChildrens(Ent)
	end

	Dupe = duplicator.Copy(TargetEnt).Entities
	local data = duplicator.CopyEnts(Children).Entities
	for i,dta in pairs(data) do

		if Dupe[i] then continue end
		Dupe[i] = dta

	end
	--PrintTable(duplicator.CopyEnts(Children).Entities)

	duplicator.SetLocalPos(vector_origin)
	duplicator.SetLocalAng(angle_zero)
	--接替
	local Count = {}
	for i,data in pairs(table.Copy(Dupe)) do
		--print(i)
		local e = Entity(tonumber(i))
		e.NSPW_PROP_MYPARENT = e:GetParent()
		e.NSPW_PROP_OLDCOLLISIONCHECK = e:GetCustomCollisionCheck()
		e.NSPW_PROP_OLDCOLLISIONGROUP = e:GetCollisionGroup()
		if !e:GetNoDraw() then
			Count[#Count + 1] = i
			Dupe[e] = data
		end
		Dupe[i] = nil
		--print(i)
	end

	--在这里做枪械/近战检测
	wep.DupeData = Dupe
	wep.DupeDataC = TargetEnt

	--end
	--print(#Count)
	--wep:Spawn()



end

local function GenLambdaWep(val,data)

	local PropData = data.PropData

	if !PropData then return end

	local DupeData,DupeDataC = data.DupeData,data.DupeDataC

	--local d = duplicator.Paste(NULL,data.DupeData.Entities,data.DupeData.Constraints)
	--print(d[data.DupeDataC])

	local ht = PropData.IsGun and ( PropData.DoubleHand and "ar2" or "revolver" ) or "melee"
	local anim = PropData.IsGun and ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER or ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE


	table.Merge( _LAMBDAPLAYERSWEAPONS, {

	    ["NSPW_LAMBDAWEAPON_DUPE_"..val] = {
	        model = "",
	        origin = "NSPW STUFF-DUPE",
	        prettyname = "NSPW Dupe Weapon: " .. val,
	        holdtype = ht,

	        islethal = true,
			dropondeath = false,
			nodraw = true,

			ismelee = !PropData.IsGun,
			attacksnd = "",
	    	hitsnd = "",

			attackrange = PropData.IsGun and ( PropData.DoubleHand and 4500 or 2000 ) or 80,
			keepdistance = PropData.IsGun and ( PropData.DoubleHand and 800 or 500 ) or 20,
			rateoffire = PropData.NextFireTime or 0.8,
			clip = PropData.Magsize,
			bulletcount = 0,
	    	tracername = "",
	    	damage = 0,
	    	spread = 0,
	    	muzzleflash = 0,
	    	shelleject = "none",
	    	attackanim = anim,
	    	attacksnd = "",

	    	reloadtime = 3*(PropData.ReloadSpeedMul or 1),
	    	reloadanim = PropData.IsGun and ( PropData.DoubleHand and ACT_HL2MP_GESTURE_RELOAD_AR2 or ACT_HL2MP_GESTURE_RELOAD_PISTOL ) or ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
	    	reloadanimspeed = 1,
	    	reloadsounds = { 
	    	},

			OnDeploy = function(own,wep)

				--print(val)

				if !IsValid(wep.DupeDataC) then


					wep.MarkedAsLambdaWep = true
					duplicator.SetLocalPos(own:GetPos())
					duplicator.SetLocalAng(own:GetAngles())

					local Dupe = duplicator.Paste(NULL,DupeData.Entities,DupeData.Constraints)

					duplicator.SetLocalPos(vector_origin)
					duplicator.SetLocalAng(angle_zero)

					for _,e in pairs(Dupe) do
						own:DeleteOnRemove(e)
					end

					local ent = Dupe[data.DupeDataC]
					NSPW_PickupItem(ent,wep)
					wep:InstallDataTable()
					table.Merge(wep,NSPW_WEAPON)
					debug.setmetatable(wep,EntMeta)
					wep:SetupDataTables(wep)
					--PrintTable(Dupe)



					wep:Initialize()
					wep.HoldType = PropData.IsGun and ( PropData.DoubleHand and "ar2" or "pistol" ) or "melee"

				end

				--wep = wep
				wep:SetOwner(own)
				wep:Deploy()

			end,
			OnHolster = function(own,wep)

				wep:SetOwner(own)
				wep:Holster(wep)

			end,
			OnDeath = function(own,wep)

				wep:SetOwner(own)
				wep:Holster(wep)

				wep.nspw_Death = true

			end,
			OnThink = function(own,wep)

				--print("NSPW RUNNING")
				if !IsValid(own) then return end

				
				wep:SetOwner(own)

				if wep.nspw_Death and own:Alive() then
					wep.nspw_Death = false
					wep:Deploy()
				end

				wep:Think()

			end,
			OnAttack = function(own,wep,target)

				wep:SetOwner(own)

				if own.l_Clip <= 0 then own:ReloadWeapon() return end

				wep.nspw_LambdaTarget = target

				wep:PrimaryAttack()

			end,
			OnReload = function(own,wep)

				wep:SetOwner(own)

				wep:Reload()

			end
	    }

	})

end

local function LoadWeapons()

	for name,PropData in pairs(_NSPW_DATA_PROPDATA) do

		if !istable(PropData) then continue end

		local ht = PropData.IsGun and ( PropData.DoubleHand and "ar2" or "revolver" ) or "melee"
		--print(name,ht)
		local anim = PropData.IsGun and ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER or ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

		table.Merge( _LAMBDAPLAYERSWEAPONS, {

		    ["NSPW_LAMBDAWEAPON_" .. name] = {
		        model = "",
		        origin = "NSPW STUFF",
		        prettyname = "NSPW Weapon: " .. name,
		        holdtype = ht,

		        islethal = true,
				dropondeath = false,
				nodraw = true,

				ismelee = !PropData.IsGun,
				attacksnd = "",
	        	hitsnd = "",

				attackrange = PropData.IsGun and ( PropData.DoubleHand and 4500 or 2000 ) or 80,
				keepdistance = PropData.IsGun and ( PropData.DoubleHand and 800 or 500 ) or 20,
				rateoffire = PropData.NextFireTime or 0.8,
				clip = PropData.Magsize,
				bulletcount = 0,
	        	tracername = "",
	        	damage = 0,
	        	spread = 0,
	        	muzzleflash = 0,
	        	shelleject = "none",
	        	attackanim = anim,
	        	attacksnd = "",

	        	reloadtime = 3*(PropData.ReloadSpeedMul or 1),
	        	reloadanim = PropData.IsGun and ( PropData.DoubleHand and ACT_HL2MP_GESTURE_RELOAD_AR2 or ACT_HL2MP_GESTURE_RELOAD_PISTOL ) or ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
	        	reloadanimspeed = 1,
	        	reloadsounds = { 
	        	},

				OnDeploy = function(own,wep)


					if !IsValid(wep.DupeDataC) then

						wep.MarkedAsLambdaWep = true
						wep:InstallDataTable()
						table.Merge(wep,NSPW_WEAPON)
						debug.setmetatable(wep,EntMeta)
						wep:SetupDataTables(wep)

						local ent = ents.Create("prop_physics")
						ent:SetModel(name)
						ent:Spawn()
						NSPW_PickupItem(ent,wep)


						wep:Initialize()
						wep.HoldType = PropData.IsGun and ( PropData.DoubleHand and "ar2" or "pistol" ) or "melee"

					end

					--wep = wep
					wep:SetOwner(own)
					wep:Deploy()

				end,
				OnHolster = function(own,wep)

					wep:SetOwner(own)
					wep:Holster(wep)

				end,
				OnDeath = function(own,wep)

					wep:SetOwner(own)
					wep:Holster(wep)

					wep.nspw_Death = true

				end,
				OnThink = function(own,wep)

					--print("NSPW RUNNING")
					if !IsValid(own) then return end

					wep:SetOwner(own)

					if wep.nspw_Death and own:Alive() then
						wep.nspw_Death = false
						wep:Deploy()
					end

					wep:Think()

				end,
				OnAttack = function(own,wep,target)

					wep:SetOwner(own)

					if own.l_Clip <= 0 then own:ReloadWeapon() return end

					wep.nspw_LambdaTarget = target

					wep:PrimaryAttack()

				end,
				OnReload = function(own,wep)

					wep:SetOwner(own)

					wep:Reload()

				end
		    }

		})

	end

	for _,name in pairs(file.Find("lambdaplayers/lambda/weapons/nspwstuffs/*.lua","LUA")) do

		local data = include("lambdaplayers/lambda/weapons/nspwstuffs/"..name)

		if !data then continue end

		local val = string.sub(name, 0,#name - 4)

		GenLambdaWep(val,data)

	end


end

--hook.Add("PostInitEntity","NSPW_LAMBDA_SUPPORT_LOADWEP",function()
timer.Simple(0.1,function()
	LoadWeapons()
end)

if istable(_NSPW_DATA_PROPDATA) then LoadWeapons() end

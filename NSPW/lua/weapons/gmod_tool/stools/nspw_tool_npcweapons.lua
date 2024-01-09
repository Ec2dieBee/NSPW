
-- Remove this to add it to the menu
--TOOL.AddToMenu = false

-- Define these!
TOOL.Category = "NSPW Stuffs" -- Name of the category
TOOL.Name = "Npc Weapon Giver" -- Name to display. # means it will be translated ( see below )

--if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.nspw_tool_npcweapons.name", "Weapon Giver" ) -- Add translation
	language.Add( "tool.nspw_tool_npcweapons.desc", "Give U da ability 2 give weaponsus" ) -- Add translation
	language.Add( "tool.nspw_tool_npcweapons.0", "LMB: Give Weapon||RMB:Copy Weapon" ) -- Add translation
end

-- An example clientside convar
TOOL.ClientConVar[ "CLIENTSIDE" ] = "default"
TOOL.ClientConVar[ "issmg" ] = "0"

-- An example serverside convar
TOOL.ServerConVar[ "SERVERSIDE" ] = "default"

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
	["Rope"] = true,
	["NoCollide"] = true,
}

-- This function/hook is called when the player presses their left click
function TOOL:LeftClick( tr )

	if CLIENT then return true end

	local owner = self:GetOwner()
	local ent = tr.Entity
	if !IsValid(ent) or !ent:IsNPC() or !owner.NSPW_TOOLGUN_NPCWEAPONS_DupeData then return end
	--self:PickupWeapon(wep)
	--在下一Tick的下一Tick(大概)调用它,因为它出现在客户端需要亿点点Tick
	--[[timer.Simple(.01,function()

		if !IsValid(tr.Entity) or !IsValid(wep) then return end

		net.Start("NSPW_TransPropTableMessage")
			net.WriteEntity(wep)
			net.WriteEntity(TargetEnt)
			--net.WriteTable(Dupe)
			net.WriteUInt(#Count,16)
			for ent,_ in pairs(Dupe) do
				--print(ent)
				net.WriteEntity(ent)
			end
		net.Broadcast()

	end)]]
	local Dupe = duplicator.Paste(owner, owner.NSPW_TOOLGUN_NPCWEAPONS_DupeData.Entities,owner.NSPW_TOOLGUN_NPCWEAPONS_DupeData.Constraints)
	local TargetEnt = Dupe[owner.NSPW_TOOLGUN_NPCWEAPONS_DupeDataM]

	local Dupe = duplicator.Copy(TargetEnt)

	DebugMessage("[NSP2W捡起检测]Dupe表",Dupe)

	for _,data in pairs(Dupe.Constraints) do
		--防止某人做的流星锤崩服
		if !ConstraintWhiteList[data.Type] then 
			DebugMessage("[NSP2W捡起检测] 发现非白名单约束,开润",data.Type)
			return
		end
	end


	--查询优先级
	local CurPriority = 0
	local PropData = {}
	for i,data in pairs(Dupe.Entities) do

		if !NSPW_DATA_PROPDATA(data.Model) then continue end

		if (NSPW_DATA_PROPDATA(data.Model).Priority or 0) > CurPriority then

			CurPriority = NSPW_DATA_PROPDATA(data.Model).Priority
			TargetEnt = Entity(i)
			--print("城镇交替")
			PropData = NSPW_DATA_PROPDATA(data.Model)

		end

	end


	DebugMessage("[NSP2W捡起检测]检测成功,开始同步数据 优先级实体: ",TargetEnt)

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

	local wep = ent:Give("nspw_melee")

	wep.DupeData = Dupe
	wep.DupeDataC = TargetEnt
	--wep:Spawn()
	wep:Initialize()
	local forcesmg = self:GetClientNumber( "issmg", 0 ) != 0
	local ht = PropData.IsGun and (
			forcesmg and "smg" or (PropData.DoubleHand and 
				(PropData.BulletCount >= 4 and "shotgun" or ("ar2"))
			) 
			or "pistol") 
		or "melee"
	--print(ht)
	wep:SetWeaponHoldType(ht)
	wep.HoldType = ht

	wep:SetHoldType(ht)
	wep:SetStyle(ht)
	--wep:Holster()



	timer.Simple(.02,function()

		if !IsValid(ent) or !IsValid(wep) then return end

		--print("?")

		net.Start("NSPW_TransPropTableMessage")
			net.WriteEntity(wep)
			net.WriteEntity(TargetEnt)
			--net.WriteTable(Dupe)
			net.WriteUInt(#Count,16)
			for ent,_ in pairs(Dupe) do
				--print(ent)
				net.WriteEntity(ent)
			end
		net.Broadcast()

	end)


	return true
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( tr )

	if CLIENT then return true end

	local TargetEnt = tr.Entity

	if !TargetEnt then return end

	local own = self:GetOwner()

	local function WhoIsMyDaddy(child)

		local father = child:GetParent()

		if !IsValid(father) or father == child then return child end
		
		return WhoIsMyDaddy(father)

	end

	TargetEnt = WhoIsMyDaddy(TargetEnt)

	

	--过第一遍检测,检测有没有非白名单约束+查优先级
	local Dupe = duplicator.Copy(TargetEnt)

	DebugMessage("[NSP2W捡起检测]Dupe表",Dupe)

	for _,data in pairs(Dupe.Constraints) do
		--防止某人做的流星锤崩服
		if !ConstraintWhiteList[data.Type] then 
			DebugMessage("[NSP2W捡起检测] 发现非白名单约束,开润",data.Type)
			return
		end
	end


	--查询优先级
	local CurPriority = 0
	local PropData = {}
	for i,data in pairs(Dupe.Entities) do

		if !NSPW_DATA_PROPDATA(data.Model) then continue end

		if (NSPW_DATA_PROPDATA(data.Model).Priority or 0) > CurPriority then

			CurPriority = NSPW_DATA_PROPDATA(data.Model).Priority
			TargetEnt = Entity(i)
			--print("城镇交替")
			PropData = NSPW_DATA_PROPDATA(data.Model)

		end

	end


	DebugMessage("[NSP2W捡起检测]检测成功,开始同步数据 优先级实体: ",TargetEnt)

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

	Dupe = duplicator.Copy(TargetEnt,Children)
	local data = duplicator.CopyEnts(Children)
	for i,dta in pairs(data.Entities) do

		if Dupe.Entities[i] then continue end
		Dupe.Entities[i] = dta

	end
	for i,dta in pairs(data.Constraints) do

		if Dupe.Constraints[i] then continue end
		Dupe.Constraints[i] = dta

	end
	--PrintTable(duplicator.CopyEnts(Children).Entities)

	duplicator.SetLocalPos(vector_origin)
	duplicator.SetLocalAng(angle_zero)
	--接替
	--local Count = {}
	self:GetOwner().NSPW_TOOLGUN_NPCWEAPONS_DupeData = Dupe
	self:GetOwner().NSPW_TOOLGUN_NPCWEAPONS_DupeDataM = TargetEnt:EntIndex()
	--[[for i,data in pairs(table.Copy(Dupe)) do
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
	DebugMessage(Dupe)]]
	--Msg( "ALT FIRE\n" )

	return true
end

-- This function/hook is called when the player presses their reload key
function TOOL:Reload( trace )
end

-- This function/hook is called every frame on client and every tick on the server
function TOOL:Think()
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "CheckBox", { Label = "Use SMG Holdtype", Command = "nspw_tool_npcweapons_issmg" } )

end

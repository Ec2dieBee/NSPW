
-- Remove this to add it to the menu
--TOOL.AddToMenu = false
-- Define these!
local Save

TOOL.Category = "NSPW Stuffs" -- Name of the category
TOOL.Name = "Lambda NSPW Weapon Manager" -- Name to display. # means it will be translated ( see below )

--if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.nspw_tool_lambdaweapons.name", "Lambda NSPW Weapon Manager" ) -- Add translation
	language.Add( "tool.nspw_tool_lambdaweapons.desc", "Use this to make Lambdas use your awsome weapons" ) -- Add translation
	language.Add( "tool.nspw_tool_lambdaweapons.0", "LMB: Copy Weapon || RMB: Receive Data" ) -- Add translation
end

-- An example clientside convar
TOOL.ClientConVar[ "CLIENTSIDE" ] = "default"

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

		if !NSPW_DATA_PROPDATA[data.Model] then continue end

		if (NSPW_DATA_PROPDATA[data.Model].Priority or 0) > CurPriority then

			CurPriority = NSPW_DATA_PROPDATA[data.Model].Priority
			TargetEnt = Entity(i)
			--print("城镇交替")
			PropData = NSPW_DATA_PROPDATA[data.Model]

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
	
	local RPropData = NSPW_DATA_PROPDATA[TargetEnt]

	for ent,_ in pairs(Dupe) do 

		if !IsValid(ent) or ent == TargetEnt then continue end

		local PropData = NSPW_DATA_PROPDATA[ent] or {}
		RPropData.Magsize = RPropData.Magsize + (PropData.Magsize or 0)

		RPropData.ReloadSpeedMul = RPropData.ReloadSpeedMul * (PropData.ReloadSpeedMul or 1)
		RPropData.ReloadSpeedMul = RPropData.ReloadSpeedMul + (PropData.ReloadSpeedMulOffset or 0)

		RPropData.NextFireTime = RPropData.NextFireTime + (PropData.NextFireTime or 0)


	end



	local name = "temp_dupe"

	local Cnt = 1

	local function Repeat()

		if NSPW_DATA_LAMBDADUPES[name] then
			name = "temp_dupe."..Cnt
			Cnt = Cnt + 1
			Repeat()
		end

	end

	Repeat()

	NSPW_DATA_LAMBDADUPES[name] = {
		DupeDataC = TargetEnt:EntIndex(),
		DupeData = Dupe,
		PropData = RPropData,
	}

	Save()

	local tbl = {}

	for i,_ in pairs(NSPW_DATA_LAMBDADUPES) do

		table.insert(tbl,i)

	end

	net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
		net.WriteTable(tbl)
	net.Broadcast()


	return true
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( tr )

	if CLIENT then
		net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
			net.WriteUInt(0,5)
		net.SendToServer()
	end

	return true
end

-- This function/hook is called when the player presses their reload key
function TOOL:Reload( trace )
	-- The SWEP doesn't reload so this does nothing :(
	Msg( "RELOAD\n" )
end

-- This function/hook is called every frame on client and every tick on the server
function TOOL:Think()
end

local EList = {}
local RefreshCurPanel

function TOOL.BuildCPanel( p )

	if !LocalPlayer():IsSuperAdmin() then return end

	net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
		net.WriteUInt(0,5)
	net.SendToServer()

	local List = vgui.Create("DListView")
	List:AddColumn("NULL")
	List:SetSize(0,400*ScrH()/1080)
	RefreshCurPanel=function()
		List:Clear()
		for _,cls in pairs(EList or {}) do
			List:AddLine(cls)
		end
	end

	timer.Simple(0.1,function()
		RefreshCurPanel=function()
			List:Clear()
			for _,cls in pairs(EList or {}) do
				List:AddLine(cls)
			end
		end
	end)

	RefreshCurPanel()

	function List:OnRowRightClick(_,pnl)
		
		Derma_StringRequest("Rename", "Rename to...",pnl:GetColumnText(1),function(str)
			net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
				net.WriteUInt(1,5)
				net.WriteString(pnl:GetColumnText(1))
				net.WriteString(str)
			net.SendToServer()
		end)
		
	end
	function List:DoDoubleClick(_,pnl)
		
		--Derma_Query("Are you sure?", "Not restoreable :", string btn1text, function btn1func=nil, string btn2text=nil, function btn2func=nil, string btn3text=nil, function btn3func=nil, string btn4text=nil, function btn4func=nil)("Rename", "Rename to...",pnl:GetColumnText(1),function(str)
		net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
			net.WriteUInt(2,5)
			net.WriteString(pnl:GetColumnText(1))
		net.SendToServer()
		--end)
		
	end

	p:AddItem(List)

	p:Help("Double Left Click: Delete")
	p:Help("Right Click: Rename")
	p:Help("Rename them manually from .json to .lua,then put them to [someaddonfolders]/lua/lambdaplayers/lambda/weapons/nspwstuffs")
	p:Help("You can found your data in GarrysMod/garrysmod/data/saveestuffs/nspw")

end

if SERVER then
	util.AddNetworkString("NSPW_TransLambdaPlayerWeaponsMessage")

	NSPW_DATA_LAMBDADUPES = NSPW_DATA_LAMBDADUPES or {}


	--是的,NSPW里有5%的代码是抄的SPW,因为我太懒了
	
	Save = function(f)
		if !file.Exists("saveestuffs","DATA") then file.CreateDir("saveestuffs") end
		if !file.Exists("saveestuffs/nspw","DATA") then file.CreateDir("saveestuffs/nspw") end
		
		for _,data in pairs(file.Find("saveestuffs/nspw/*.json","DATA")) do
			local val = string.sub(data, 0,#data - 5) -- .json
			if !NSPW_DATA_LAMBDADUPES[val] then
				file.Delete("saveestuffs/nspw/"..data)
				_LAMBDAPLAYERSWEAPONS["NSPW_LAMBDAWEAPON_DUPE_"..val] = nil
			end
		end

		for name,data in pairs(NSPW_DATA_LAMBDADUPES) do

			local val = string.sub(name, 0,#name - 5)
			file.Write("saveestuffs/nspw/"..name..".json", "return util.JSONToTable([["..util.TableToJSON(data,true).."]])")

			--GenLambdaWep(val,data)

		end

	end

	local function Load()
		for _,data in pairs(file.Find("saveestuffs/nspw/*.json","DATA")) do

			local val = string.sub(data, 0,#data - 4)
			NSPW_DATA_LAMBDADUPES[val] = util.JSONToTable(file.Read("saveestuffs/nspw/"..data))

			--GenLambdaWep(val,data)

			--print("?")
			
		end
	end

	Load()

	net.Receive("NSPW_TransLambdaPlayerWeaponsMessage",function(_,p)
	
		if !p:IsSuperAdmin() then print("有人可能开了,"..p.."不是超管却发送了只有超管才能用的net消息") return end

		local type = net.ReadUInt(5)
		local name = net.ReadString()

		if type == 1 then --重命名
			local raw = net.ReadString()
			local to = raw
			local Cnt = 0
			local function Repeat()

				if NSPW_DATA_LAMBDADUPES[to] then
					to = raw.."."..Cnt
					Cnt = Cnt + 1
					Repeat()
				else

					NSPW_DATA_LAMBDADUPES[to] = NSPW_DATA_LAMBDADUPES[name]
					NSPW_DATA_LAMBDADUPES[name] = nil

				end

			end

			Repeat()
		elseif type == 2 then --删除
			NSPW_DATA_LAMBDADUPES[name] = nil
		end

		local tbl = {}

		for i,_ in pairs(NSPW_DATA_LAMBDADUPES) do

			table.insert(tbl,i)

		end

		net.Start("NSPW_TransLambdaPlayerWeaponsMessage")
			net.WriteTable(tbl)
		net.Broadcast()

		Save()

	end)
else
	net.Receive("NSPW_TransLambdaPlayerWeaponsMessage",function()
		EList = net.ReadTable()
		RefreshCurPanel()
	end)
end


--用途: 加点模组特供支持

local Sup = {}

local Dir = "supports"
NSPW._TEMP.CURRENTFILEDIR = Dir

function Sup:Set(ent,index,var,useglobal)

	if !IsValid(ent) then return end
	
	local Second = NSPW._TEMP.CURRENTFILEDIR .. "_" .. NSPW._TEMP.CURRENTFILENAME
	if useglobal then
		Second = ""
	end
	--print(SET,string.format("NSPW_SUPPORT_%s_%s",Second,index))
	ent[string.format("_NSPW_SUPPORT_%s_%s",Second,index)] = var

end
function Sup:Get(ent,index,useglobal,varreturn)

	if !IsValid(ent) then return end

	local Second = NSPW._TEMP.CURRENTFILEDIR .. "_" .. NSPW._TEMP.CURRENTFILENAME
	if useglobal then
		Second = ""
	end

	--print(string.format("NSPW_SUPPORT_%s_%s",Second,index))

	return ent[string.format("_NSPW_SUPPORT_%s_%s",Second,index)] or varreturn

end

NSPW.SUPPORT = Sup


local File, _ = file.Find("nspw/"..Dir .. "/*", "LUA")
for _,f in pairs(File) do

	NSPW._TEMP.CURRENTFILEDIR = Dir
	if SERVER then
		AddCSLuaFile(Dir .. "/" .. f)
	end
	include(Dir .. "/" .. f)
	--print(f)

end

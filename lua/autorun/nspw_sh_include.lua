--[[

	For these guys who use non-Chinese language and can't understand Chinese: 
	This addon's commits use Chinese memes and Chinese,In Chinese middle school level(maybe,I'm bad at it,68/120)
	So prepare your machine translater,or find a guy who understands Chinese.
	I know there are typos in it,because these words were type by my hands(not machine translate,OMG!)
	also,I'll try to make normal commits understandable,but won't translate them to English,cuz I'm funkin LAZY
	XD
	--Savee14702,author of this shit

	--Also,the authors is one person(me)
	--My old name: 你的好友撒蜜蜂
	--Dont confused with these plz
	--if you see these....


	--TEN SECONDS OF WAITING IN THE PUNISHMENT ROOM.
	--YOU HAVE ONE WARNING.
	--EVERYONE KNOWS WHY YOU ARE STILL ALIVE.

	--From INVSYS,Too lazy 4 other stuffs

]]

--[[
	写一个模块(?): 
	目前模块只允许一个文件夹(并且你要手动include里面的内容)
]]

--do return end


AddCSLuaFile()

print("[NSPW] 正在加载额外的东西...")
print("[NSPW] Loading Extras...")

NSPW = {
	_TEMP = {
		CURRENTFILEDIR = "",
		CURRENTFILENAME = "",
	},
}

local path="nspw"

--实例:我爱你

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	--[[if SERVER and prefix == "sv_" then
		include( directory .. File )
		--print( "[AUTOLOAD] SERVER INCLUDE: " .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			--print( "[AUTOLOAD] SHARED ADDCS: " .. File )
		end
		include( directory .. File )
		--print( "[AUTOLOAD] SHARED INCLUDE: " .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			--print( "[AUTOLOAD] CLIENT ADDCS: " .. File )
		elseif CLIENT then
			include( directory .. File )
			--print( "[AUTOLOAD] CLIENT INCLUDE: " .. File )
		end
	end]]

	if SERVER then
		AddCSLuaFile(directory .. File)
	end
	include(directory .. File)

end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )
	
	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			--NSPW._TEMP.CURRENTFILEDIR = directory
			AddFile( v, directory )
			--print("1111")
		end
	end

	--[[for _, v in ipairs( directories ) do
		--print( "[AUTOLOAD] Directory: " .. v )
		IncludeDir( directory .. v )
	end]]
	--NSPW._TEMP.CURRENTFILEDIR = nil
end

local function FormattedPrint(First,...)

	if ... then

		local Dir = NSPW._TEMP.CURRENTFILEDIR and string.sub(NSPW._TEMP.CURRENTFILEDIR,0,#NSPW._TEMP.CURRENTFILEDIR - 1) or "DEFAULT"

		local Tar = {...}
		Tar = string.Split(Tar[1], "/")
		Tar = Tar[#Tar]
		Tar = string.sub(Tar,0,#Tar - 4)
		--print(Tar)
		print(string.format("%s[%s] 添加了 %s",First,Dir,Tar))
		print(string.format("%s[%s] Included %s",First,Dir,Tar))

		return Tar
	end

end

ProtectedCall(function()
	local Oldinclude = include
	local OldAddCS = AddCSLuaFile

	function include(...)
		NSPW._TEMP.CURRENTFILENAME = FormattedPrint("[NSPW]",...) or "WTF_NIL__"
		Oldinclude(...)
	end
	function AddCSLuaFile(...)
		
		FormattedPrint("[NSPW][CL]",...)
		OldAddCS(...)
	end

	--local JUMBAR = "9E2"

	NSPW._TEMP_LOADING = true

	NSPW._TEMP.CURRENTFILEDIR = ""

	IncludeDir( path )

	--NSPW._TEMP.CURRENTFILEDIR = nil

	NSPW._TEMP_LOADING = false
	
	include = Oldinclude
	AddCSLuaFile = OldAddCS
end)



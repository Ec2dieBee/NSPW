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

--do return end


AddCSLuaFile()

SaveeLib = SaveeLib or {}

local path="saveelib/"

--实例:我爱你

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
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
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		--print( "[AUTOLOAD] Directory: " .. v )
		IncludeDir( directory .. v )
	end
end

IncludeDir( path )



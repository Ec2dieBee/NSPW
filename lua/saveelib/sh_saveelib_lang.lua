--

--HOOK 
--InvSys_PreIncludeLangFile
--Augs :
-- langnam: Language Name
-- Lang: Language Table
-- 注意: 你可以覆盖表,t[i] = xxx
-- Note: You can overwrite the table,t[i] = xxx

--print("LANGUAGE INCLUDED")

local Langs = {}
local path = "saveelib/"
local _, directories = file.Find( path .. "lang/*", "LUA" )
--[[hook.Add("InvSys_PreIncludeLangFile","InvSys_Debug",function(_,t)

	for i,v in pairs(t) do t[i] = "SB" end

end)]]
--hook.Remove("InvSys_PreIncludeLangFile","InvSys_Debug")
for _, dic in ipairs( directories ) do
	--print("1")
	Langs[dic] = {}
	for _ , v in pairs(file.Find( path .. "lang/" .. dic .. "/*", "LUA" )) do
		if string.EndsWith( v, ".lua" ) then
			AddCSLuaFile(path .. "lang/" .. dic .. "/" .. v)
			local langnam = string.sub(v,0,#v-4)
			local Lang = include(path .. "lang/" .. dic .. "/" .. v)
			hook.Run("SaveeLib.Lang_PreIncludeLangFile", langnam,Lang)
			Langs[dic][langnam] = Lang
			print("找到的语言文件: ["..dic.."] "..langnam)
			--print(string.sub(v,0,#v-4))
		end
	end
end


--PrintTable(Langs["en"])


if CLIENT then
	CreateClientConVar("saveelib_cl_language", "en",true,false,"Language Setting")
end
function SaveeLib.Lang_GetLangPharse(path,p,lang)
	if !path then path = "_SAVEELIB_DEFAULT" end
	if CLIENT and !lang then
		lang = GetConVar("saveelib_cl_language"):GetString()
	end
	return lang and (Langs[lang] and Langs[lang][p]) or Langs["en"][p] or "_INVALID_"
end
--local TypeHintEmited = {}
--[[if CLIENT then

	INVSYS_CL_LANG = Langs
	function InvSys_Lang_EmitHint(content,time,type)
		if !type or type== "" then 
			type = "__INVSYS_UNDEFINITION" --特意滚去机翻
		end
		if TypeHintEmited[type] then return end
		TypeHintEmited[type] = true
		notification.AddLegacy( InvSys_Lang_GetLangPharse(content), NOTIFY_HINT, time or 2 )
	end
else
	function InvSys_Lang_EmitHint(p,content,time,type)
		if TypeHintEmited[p] and TypeHintEmited[p][type] then return end
		if !TypeHintEmited[p] then TypeHintEmited[p] = {} end
		TypeHintEmited[p][type] = true
		net.Start("InvSys_SendHint")
			net.WriteString(content)
			net.WriteUInt(time,32)
			net.WriteString(type)
		net.Send(p)
	end
end]]



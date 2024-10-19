--用途: 各种奇异钩子

--初始化
_NSPW_HOOK_NAME_ONPICK = "NSPW_HOOK_ONPICK"
_NSPW_HOOK_NAME_ONDROP = "NSPW_HOOK_ONDROP"
_NSPW_HOOK_NAME_ONTHINK_PROP = "NSPW_HOOK_ONTHINK_PROP"

NSPW.Hook = {}

function NSPW.Hook:CreateConVar(def)
	if !NSPW._TEMP_LOADING then return end
	local CurDir = NSPW._TEMP.CURRENTFILEDIR
	local CurName = NSPW._TEMP.CURRENTFILENAME
	CreateConVar(string.format(
				"nspw_%s_%s_on",
				CurDir,
				CurName
			),def,{FCVAR_ARCHIVE})

end

function NSPW.Hook:Add(HookName,Index,Function)
	local CurDir = NSPW._TEMP.CURRENTFILEDIR
	local CurName = NSPW._TEMP.CURRENTFILENAME
	local NewFunction = function(...)
		--error("DUMB")
		if GetConVar(
			string.format(
				"nspw_%s_%s_on",
				CurDir,
				CurName
			)
		):GetBool() then

			Function(...)

		end
	end
	hook.Add(
		HookName,
		string.format(
			"NSPW_%s_%s",
			CurName,
			Index
		),
		NewFunction
	)
end
function NSPW.Hook:Clear()

	local CurDir = NSPW._TEMP.CURRENTFILEDIR
	--local CurName = NSPW._TEMP.CURRENTFILENAME

	for i,t in pairs(hook.GetTable()) do
		for name,_ in pairs(t) do
			if !isstring(name) then continue end
			if string.StartWith(name, string.format("NSPW_%s_",CurName)) then
				hook.Remove(i,name)
			end
		end
	end

end
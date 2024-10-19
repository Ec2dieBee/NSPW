--print(JUMBAR)

if CLIENT or !NSPW._TEMP_LOADING then return end

--print(NSPW._TEMP.CURRENTFILEDIR)

local S = NSPW.SUPPORT

NSPW.Hook:Clear()

NSPW.Hook:Add(_NSPW_HOOK_NAME_ONPICK,"PICK",function(ply,DupeData)

	for ent,_ in pairs(DupeData) do

		if !IsValid(ent) or !scripted_ents.IsBasedOn(ent:GetClass(),"dronesrewrite_base") then continue end

		if !S:Get(ent,"HasTimer") then
			S:Set(ent,"On",ent.Enabled)
			S:Set(ent,"OldEnabled",ent.SetEnabled)
		end
		ent:SetEnabled(false)
		ent.SetEnabled = function() end
		--print(ent)

	end

end)

--[[NSPW.Hook:Add(_NSPW_HOOK_NAME_ONTHINK_PROP,"THINK",function(ent)

	if !IsValid(ent) or !scripted_ents.IsBasedOn(ent:GetClass(),"dronesrewrite_base") or !ent.Enabled then continue end

	S:Set(ent,"On",ent.Enabled)
	ent:SetEnabled(false)

end)]]

NSPW.Hook:Add(_NSPW_HOOK_NAME_ONDROP,"DROP",function(ply,DupeData)

	for ent,_ in pairs(DupeData) do

		if !IsValid(ent) or !scripted_ents.IsBasedOn(ent:GetClass(),"dronesrewrite_base") then continue end

		if S:Get(ent,"HasTimer") then
			ent.SetEnabled = S:Get(ent,"OldEnabled")
			return
		end

		S:Set(ent,"HasTimer",true)
		timer.Simple(0.65,function()

			S:Set(ent,"HasTimer",nil)
			if !IsValid(ent) or IsValid(ent.NSPW_PROP_RELATEDWEAPON) then return end

			ent.SetEnabled = S:Get(ent,"OldEnabled")
			ent:SetEnabled(S:Get(ent,"On"))

		end)

	end

end)


NSPW.Hook:CreateConVar(1)
--return 1
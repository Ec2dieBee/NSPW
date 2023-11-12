
-- Remove this to add it to the menu
--TOOL.AddToMenu = false
-- Define these!
local Save

TOOL.Category = "NSPW Stuffs" -- Name of the category
TOOL.Name = "Prop Properties Enable/Disable" -- Name to display. # means it will be translated ( see below )

--if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.nspw_tool_propertiesenable.name", "Prop Properties Enable/Disable" ) -- Add translation
	language.Add( "tool.nspw_tool_propertiesenable.desc", "Is a prop a decal or an attachment?" ) -- Add translation
	language.Add( "tool.nspw_tool_propertiesenable.0", "LMB: Enable/Disable prop properties || RMB: Check if a prop's propties are enabled or not" ) -- Add translation
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

	local ent = tr.Entity

	if !IsValid(ent) then

		return

	end

	ent.NSPW_PROP_DISABLEPROPERTIES = !ent.NSPW_PROP_DISABLEPROPERTIES

	duplicator.StoreEntityModifier(ent,"NSPW_MODIFIER_PROPERTIESSTATE",{ent.NSPW_PROP_DISABLEPROPERTIES})

	return true
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( tr )

	local ent = tr.Entity

	if !IsValid(ent) then

		return

	end

	self:GetOwner():ChatPrint( tostring(ent) .. "PROPTIES: " .. (tobool( ent.NSPW_PROP_DISABLEPROPERTIES ) and "DISABLED" or "ENABLED") )

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


function TOOL.BuildCPanel( p )

	

end


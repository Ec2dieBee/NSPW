
-- Remove this to add it to the menu
--TOOL.AddToMenu = false
-- Define these!
--local Save
local ToolName = "nspw_tool_ppm_constraint"
local Name,PName = "tool." .. ToolName,"Constraint"

TOOL.Category = "NSPW Stuffs" -- Name of the category
TOOL.Name = "PPM-" .. PName -- Name to display. # means it will be translated ( see below )

--if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( Name .. ".name", "Properties Modifier[Constraint]" ) -- Add translation
	language.Add( Name .. ".desc", "Should your props get welded on your hand?" ) -- Add translation
	language.Add( Name .. ".0", "LMB: Remove Constraint || RMB: Allow Constraint" ) -- Add translation
end

-- An example clientside convar
TOOL.ClientConVar[ "val" ] = "0"

-- An example serverside convar
--TOOL.ServerConVar[ "SERVERSIDE" ] = "default"


-- This function/hook is called when the player presses their left click

-- TRY SOME FOLD
local BlackList = {

}

function TOOL:LeftClick( tr )

	if CLIENT then return true end

	local ent = tr.Entity

	if !IsValid(ent) then return end

	ent.NSPW_PROP_NOCONSTRAINT = true
	if self:GetClientNumber( "val", 0 ) != 0 then
		ent:SetNWBool("NSPW_NW_PROP_NOCONSTRAINTFREEDRAW", true)
	end

	duplicator.StoreEntityModifier(ent,"NSPW_MODIFIER_NOCONSTRAINT",{ent.NSPW_PROP_NOCONSTRAINT})

	return true
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( tr )

	if CLIENT then return true end

	local ent = tr.Entity

	if !IsValid(ent) then return end

	ent.NSPW_PROP_NOCONSTRAINT = false

	return true
end

-- This function/hook is called when the player presses their reload key
function TOOL:Reload( trace )
end

-- This function/hook is called every frame on client and every tick on the server
function TOOL:Think()
end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "CheckBox", { Label = "FreeMove", Command = "nspw_tool_ppm_constraint_val" } )
	--CPanel:AddControl( "Slider", { Label = PName, Command = "nspw_tool_ppm_constraint_val", Min = 0, Max = 1 } )

end


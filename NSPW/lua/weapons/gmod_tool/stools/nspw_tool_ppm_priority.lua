
-- Remove this to add it to the menu
--TOOL.AddToMenu = false
-- Define these!
--local Save
local ToolName = "nspw_tool_ppm_priority"
local Name,PName = "tool." .. ToolName,"Priority"

TOOL.Category = "NSPW Stuffs" -- Name of the category
TOOL.Name = "PPM-" .. PName -- Name to display. # means it will be translated ( see below )

--if ( true ) then return end -- Don't actually run anything below, remove this to make everything below functional

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( Name .. ".name", "Properties Modifier[Priority]" ) -- Add translation
	language.Add( Name .. ".desc", "How important(sus) your props are!" ) -- Add translation
	language.Add( Name .. ".0", "LMB: Apply Data || RMB: Copy Data || Reload: Reset Data" ) -- Add translation
end

-- An example clientside convar
TOOL.ClientConVar[ "val" ] = "0"

-- An example serverside convar
--TOOL.ServerConVar[ "SERVERSIDE" ] = "default"


-- This function/hook is called when the player presses their left click
function TOOL:LeftClick( tr )

	if CLIENT then return true end

	local ent = tr.Entity

	if !IsValid(ent) then return end

	local val = self:GetClientNumber( "val", 0 )

	if !ent.NSPW_PROP_PROPDATA then ent.NSPW_PROP_PROPDATA = {} end

	ent.NSPW_PROP_PROPDATA[PName] = val

	return true
end

-- This function/hook is called when the player presses their right click
function TOOL:RightClick( tr )

	if CLIENT then return true end

	local ent = tr.Entity

	if !IsValid(ent) then return end

	self:GetOwner():ConCommand( ToolName .. "_val " .. (NSPW_DATA_PROPDATA(ent).Priority or 0) )

	return true
end

-- This function/hook is called when the player presses their reload key
function TOOL:Reload( trace )

	if CLIENT then return true end

	local ent = tr.Entity

	if !IsValid(ent) or !ent.NSPW_PROP_PROPDATA then return end

	ent.NSPW_PROP_PROPDATA[PName] = nil

	return true
end

-- This function/hook is called every frame on client and every tick on the server
function TOOL:Think()
end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Slider", { Label = PName, Command = "nspw_tool_ppm_priority_val", Min = -10, Max = 10 } )

end


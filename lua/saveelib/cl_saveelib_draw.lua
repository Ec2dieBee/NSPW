--是的这个Lib是从INVSYS抄的但是鉴于INVSYS没有横空出世所以I DON'T FUCKING CARE

local sdraw = {}

local function ClampScr(w,h)

	local W,H=ScrW(),ScrH()
	if !w then w=ScrW() end
	if !h then h=ScrH() end
	W=w*W/1920
	H=h*H/1080
	return W,H

end

sdraw.ClampScr = ClampScr

--== 其它什么阴间玩意 ==--
--[[
	填充
	Args: 
		val 要填充的值
		cnt 要填充的数量
]]

function sdraw.QuickFill(val,cnt)

	local tab = {}

	for i=1,cnt do
		tab[i]=val
	end

	return unpack(tab)

end

function sdraw.RemoveShitStuffInTable( t, indent, done ) --直接抄的PrintTable+改造
	local Msg = Msg

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true
	--print(t)
	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		--Msg( string.rep( "\t", indent ) )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
			--Msg( key, ":\n" )
			sdraw.RemoveShitStuffInTable( value, indent + 2, done )
			done[ value ] = nil
			--print(key,value)
		elseif done[ value ] then --我操,内鬼!!!
			t[key] = nil
			--print(key)
		end

	end

end

--== Dermas ==--

--[[
	DFrame生成
	Args: 
		x 屏幕X位置
		y 屏幕Y位置
		sizx X大小
		sizy Y大小
		title 标题(恼)
		drawfunc 要应用的Draw function(为啥不在funcaft里设置?我不到啊)
		funcaft 在创建完之后的使用func(Dframe本身)
		closbut 是否显示关闭按钮(?)
		nopopup 是否不弹出鼠标(NMDWSM)
]]

function sdraw.CreateDFrame(x,y,sizx,sizy,title,drawfunc,funcaft,closbut,nopopup)

	local Frame = vgui.Create("DFrame")

	Frame:SetPos(ClampScr(x or 50,y or 50))

	Frame:SetSize(ClampScr(sizx or 50,sizy or 50))


	if !x and !y then Frame:Center() end

	if drawfunc then
		Frame.Paint = drawfunc 
	end

	
	if !nopopup then Frame:MakePopup() end
	Frame:SetTitle(title or "")
	if closbut != nil then Frame:ShowCloseButton(closbut) end

	if funcaft then funcaft(Frame) end

	return Frame


end

--[[
	DPanel生成
	Args: 
		parent 他爸
		x 屏幕X位置
		y 屏幕Y位置
		sizx X大小
		sizy Y大小
		drawfunc 要应用的Draw function(为啥不在funcaft里设置?我不到啊)
		funcaft 在创建完之后的使用func(DPanel本身)
]]

function sdraw.CreateDPanel(parent,x,y,sizx,sizy,drawfunc,funcaft)

	local Frame = vgui.Create("DPanel",parent)

	Frame:SetPos(ClampScr(x or 0,y or 0))

	Frame:SetSize(ClampScr(sizx or 50,sizy or 50))


	if !x and !y then Frame:Center() end

	if drawfunc then
		Frame.Paint = drawfunc 
	end

	if funcaft then funcaft(Frame) end

	return Frame


end

--[[
	DButton生成
	Args: 
		parent 他爸
		x 屏幕X位置
		y 屏幕Y位置
		sizx X大小
		sizy Y大小
		drawfunc 要应用的Draw function(为啥不在funcaft里设置?我不到啊)
		clickfunc 左键功能  --CHICK START!
		rclickfunc 右键功能
		funcaft 在创建完之后的使用func(DPanel本身)
]]

function sdraw.CreateDButton(parent,x,y,sizx,sizy,drawfunc,clickfunc,rclickfunc,funcaft)

	local Frame = vgui.Create("DButton",parent)

	Frame:SetPos(ClampScr(x or 0,y or 0))

	Frame:SetSize(ClampScr(sizx or 50,sizy or 50))


	if !x and !y then Frame:Center() end

	if drawfunc then
		Frame.Paint = drawfunc 
	end

	Frame.DoClick = clickfunc or function() end
	Frame.DoRightClick = rclickfunc or function() end

	if funcaft then funcaft(Frame) end

	return Frame


end

--[[
	DScrollPanel生成
	Args: 
		parent 他爸
		w 有无横向
		h 有无竖向
		x 屏幕X位置
		y 屏幕Y位置
		sizx X大小
		sizy Y大小
		drawfunc 要应用的Draw function(为啥不在funcaft里设置?我不到啊)
		drawfuncg 滚轴draw
		drawfuncg 滚轴上键draw
		drawfuncg 滚轴下键draw
		funcaft 在创建完之后的使用func(DPanel本身)
]]

function sdraw.CreateDScrollPanel(parent,w,h,x,y,sizx,sizy,drawfunc,drawfuncg,drawfuncgup,drawfuncgdn,funcaft)

	local Frame = vgui.Create("DPanel",parent)

	Frame:SetPos(ClampScr(x or 0,y or 0))

	Frame:SetSize(ClampScr(sizx or 50,sizy or 50))

	local wp,hp

	if !drawfunc then drawfunc = function() end end

	if w then 
		wp = vgui.Create("DScrollPanel",Frame)
		wp:Dock(FILL)
		local g=wp:GetVBar()
		if drawfunc then wp.Paint = drawfunc end
		if drawfuncg then g.btnGrip.Paint = drawfuncg end
		if drawfuncgup then g.btnUp.Paint = drawfuncgup end
		if drawfuncgdn then g.btnDown.Paint = drawfuncgdn end
	end

	if h then 
		hp = vgui.Create("DHorizontalScroller",ispanel(wp) and wp or Frame)
		hp:Dock(FILL)
		--local g=hp:GetVBar()
		--if drawfunc and !wp then hp.Paint = drawfunc end
		--if drawfuncg then g.btnGrip.Paint = drawfuncg end
		--if drawfuncgup then g.btnUp.Paint = drawfuncgup end
		--if drawfuncgdn then g.btnDown.Paint = drawfuncgdn end
	end


	if !x and !y then Frame:Center() end

	if drawfunc then
		Frame.Paint = drawfunc 
	end

	Frame.Pnlw = wp
	Frame.Pnlh = hp

	if funcaft then funcaft(Frame) end

	return Frame


end

--[[
	DPanel Grid生成(用于物品栏)
	Args: 
		parent 他爸
		x 屏幕X位置
		y 屏幕Y位置
		amountx X数量
		amounty Y数量
		gsizx 格子X大小
		gsizy 格子Y大小
		distx 每个格子的X距离
		disty 每个格子的y距离
		drawfunc 要应用的Draw function(为啥不在funcaft里设置?我不到啊)
		funcaft 在创建完之后的使用func(DPanel本身)
		overlay 是否应用DPanelOverlay
		overlaycol DPanelOverlay颜色
		overlaytyp DPanelOverlay类型
		IndexTab Inventory Table
]]

--[[function sdraw.CreateGridIn(parent,x,y,amountx,amounty,gsizx,gsizy,distx,disty,drawfunc,funcaft,overlay,overlaycol,overlaytyp,IndexTab,Tags)

	local Frame = vgui.Create("DPanel",parent)
	local SPnl = vgui.Create("DHorizontalScroller",parent)
	SPnl:SetPos(ClampScr((x or 0),y or 0))
	local px,py=parent:GetSize()
	SPnl:SetSize(px-gsizx/2,py)
	SPnl:AddPanel(Frame)

	Frame.Inv = {}

	Frame:SetPos(ClampScr(x or 0,y or 0))

	Frame:SetSize(ClampScr(amountx*gsizx+(amountx-1)*distx or 50,amounty*gsizy+(amounty-1)*disty))


	if !x and !y then Frame:Center() end

	--[[if drawfunc then
		Frame.Draw = drawfunc 
	end-
	Frame.Paint = function() end

	for cnty=0,amounty-1 do

		Frame.Inv[cnty] = {}

		for cntx=0,amountx-1 do

			local pnl=sdraw.CreateDPanel(Frame,(distx+gsizx)*cntx,(disty+gsizy)*cnty,gsizx,gsizy)
			if overlay then
				local Overlay = vgui.Create( "DPanelOverlay", pnl )
				Overlay:SetType( overlaytyp or 1 )
				Overlay:SetColor( overlaycol or Color( 255, 0, 0 ) ) 
			end
			if drawfunc then pnl.Paint = drawfunc end
			pnl.InvIndex=parent.InvIndex
			if Tags and istable(Tags) then
				for _,t in pairs(Tags) do
					pnl[t] = true
				end
			elseif Tags then
				pnl[Tags] = true
				--print("11112412")
			end
			pnl.Pos=Vector(cntx,cnty)
			function pnl:GetInvTable()
				return IndexTab
			end
			pnl:Receiver("Invsys_Inventory",function(pnl,tbl,drp) 
				tbl[1].InDrop = false
				local Pointer = pnl:GetParent():GetParent():GetParent():GetParent():GetParent():GetParent():GetParent():GetParent().Pointer
				--print(pnl)
				local invtab=pnl:GetInvTable().InvAdd[pnl.InvIndex]
				local siz=tbl[1].Size
				--PrintTable(pnl:GetInvTable().InvAdd)
				local PnlPosResult = sdraw.util_ClampVec(pnl.Pos-sdraw.util_CeilVec((siz+Vector(0,-1,0))/2)+Vector(1,0,0),Vector(0,0,0),invtab.AvailableSlot - siz)
				--print("虫刺!")
				local SpaceResult = sdraw.INV_HasEnoughSpace(tbl[1].Pos,PnlPosResult,siz,pnl.InvIndex,tbl[1].RotateState,nil,pnl:GetInvTable().InvAdd)
				local bpos = string.Explode(",",tbl[1].Pos)
				--print( SpaceResult.Pos.x , bpos[1],SpaceResult.Pos.y , bpos[2])
				--[[if SpaceResult.Pos.x == tonumber(bpos[1]) and SpaceResult.Pos.y == tonumber(bpos[2]) then 
					print("RET")
					return 
				end-
				if drp and SpaceResult then 
					--print(pnl.InvIndex)
					--if SpaceResult then
						
						--INVSYS_PlayerInvTable.InvAdd[tbl[1].InvIndex].Items[tbl[1].Pos] = nil
						local a,b=pnl:GetPos()
						local NPos = sdraw.INV_MoveItemto(tbl[1],pnl,SpaceResult.Pos.x,SpaceResult.Pos.y)
						tbl[1]:SetParent(pnl:GetParent():GetParent():GetParent())
						tbl[1]:SetPos(SpaceResult.Pos.x*gsizx+(SpaceResult.Pos.x-1)*distx-SPnl.OffsetX, SpaceResult.Pos.y*gsizy+(SpaceResult.Pos.y-1)*disty)
						tbl[1].InvIndex = pnl.InvIndex
						--pnl:Remove()
					--end
					Pointer:SetPos(-ScrW()*2,-ScrW()*2)
				elseif SpaceResult then
					Pointer:SetParent(pnl:GetParent():GetParent():GetParent())
					Pointer:SetSize(tbl[1]:GetSize())
					Pointer:SetPos((SpaceResult.Pos.x)*gsizx+(SpaceResult.Pos.x-1)*distx-SPnl.OffsetX, (SpaceResult.Pos.y)*gsizy+(SpaceResult.Pos.y-1)*disty)
				elseif drp and IsValid(tbl[1]) then
					--if !self.OldRotateState or self.OldRotateState != tbl[1].RotateState then
					local cond1,cond2 = (tbl[1].OldRotateState == 1 or tbl[1].OldRotateState == 3) ,
					(tbl[1].RotateState == 1 or tbl[1].RotateState == 3)
					local RS = tbl[1].OldRotateState or tbl[1].RotateState == 4 and 1 or tbl[1].RotateState+1
					if (cond1 and cond2) or (!cond1 and !cond2) then
						RS = tbl[1].RotateState
					end
					tbl[1]:GetInvTable().InvAdd[tbl[1].InvIndex].Items[tbl[1].Pos].RotateState = RS
					tbl[1].RotateState = RS
					tbl[1]:RotatInit()
					local bpos = string.Explode(",",tbl[1].Pos)
					sdraw.INV_MoveItemto(tbl[1],pnl,tonumber(bpos[1]),tonumber(bpos[2]))
					--end
					Pointer:SetPos(-ScrW()*2,-ScrW()*2)
				else
					Pointer:SetPos(-ScrW()*2,-ScrW()*2)
				end
			
			end)
			Frame.Inv[cnty][cntx] = pnl
			--print("GEN")

		end

	end

	if funcaft then funcaft(Frame) end

	return SPnl --Frame


end]]

--== 运算s ==--
function sdraw.util_ClampVec(vec,minvec,maxvec)

	vec.x = math.Clamp(vec.x,minvec.x,maxvec.x)
	vec.y = math.Clamp(vec.y,minvec.y,maxvec.y)
	vec.z = math.Clamp(vec.z,minvec.z,maxvec.z)
	return vec

end
function sdraw.util_FloorVec(vec)

	vec.x = math.floor(vec.x)
	vec.y = math.floor(vec.y)
	vec.z = math.floor(vec.z)
	return vec

end
function sdraw.util_CeilVec(vec)

	vec.x = math.ceil(vec.x)
	vec.y = math.ceil(vec.y)
	vec.z = math.ceil(vec.z)
	return vec

end
function sdraw.util_RoundVec(vec,c)

	vec.x = math.Round(vec.x,c)
	vec.y = math.Round(vec.y,c)
	vec.z = math.Round(vec.z,c)
	return vec

end
function sdraw.util_AbsVec(vec)

	vec.x = math.abs(vec.x)
	vec.y = math.abs(vec.y)
	vec.z = math.abs(vec.z)
	return vec

end
function sdraw.util_MaxVec(...)
	--if !istable(...) then return end
	local t = ...
	if !istable(...) then
		t = {...}
	end
	local vecx,vecy,vecz = {},{},{}
	for _,v in pairs(t) do
		table.insert(vecx,v.x)
		table.insert(vecy,v.y)
		table.insert(vecz,v.z)
	end
	local vec = Vector()
	vec.x = math.max(unpack(vecx))
	vec.y = math.max(unpack(vecy))
	vec.z = math.max(unpack(vecz))
	return vec

end
function sdraw.util_MinVec(...)
	--if !istable(...) then return end
	local t = ...
	if !istable(...) then
		t = {...}
	end
	local vecx,vecy,vecz = {},{},{}
	for _,v in pairs(t) do
		table.insert(vecx,v.x)
		table.insert(vecy,v.y)
		table.insert(vecz,v.z)
	end
	local vec = Vector()
	vec.x = math.min(unpack(vecx))
	vec.y = math.min(unpack(vecy))
	vec.z = math.min(unpack(vecz))
	return vec

end

--== Draw ==--

--draw.DrawText(string text, string font="DermaDefault", number x=0, number y=0, table color=Color( 255, 255, 255, 255 ), number xAlign=TEXT_ALIGN_LEFT)

--draw.SimpleText(string text, string font="DermaDefault", number x=0, number y=0, table color=Color( 255, 255, 255, 255 ), number xAlign=TEXT_ALIGN_LEFT, number yAlign=TEXT_ALIGN_TOP)

function sdraw.SimpleText(txt,fnt,x,y,col,xX,xY)

	local a,b=ClampScr(x,y)
	draw.DrawText(txt, fnt,a,b,col,xX,xY)

end

--draw.RoundedBox(number cornerRadius, number x, number y, number width, number height, table color)

function sdraw.RoundedBox(cr,x,y,w,h,c)

	local a,b=ClampScr(w,h)
	draw.RoundedBox(cr,x,y,a,b,c)

end

return sdraw
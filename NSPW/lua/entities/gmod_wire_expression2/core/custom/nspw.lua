E2Lib.RegisterExtension("nspw", true, "Allow advance controls to player's prop", "Can be used to make SUPER FUNKING ADMIN GUN 5000(Controllable!). Can also fuck up your prop")

__e2setcost(30)

--OLD NSPW Generic

e2function entity getNSPWRelatedWeapon(entity prop)
	if !IsValid(prop) then prop = self.entity end
	if not IsValid(prop) then return NULL end
	return prop.NSPW_PROP_RELATEDWEAPON or NULL
end

e2function void setNSPWShouldAttack(entity wep,number shouldattack)
	if not IsValid(wep) or wep:GetClass() != "nspw_melee" or 
	wep:GetOwner() != 
	self.player then return end

	local _,PropData = wep:GetDupeData()
	if !PropData[self.entity] then return end

	wep.WireIO_ShouldAttack = tobool(shouldattack)
	--print(tobool(shouldattack))
	
end

e2function void setNSPWNextPrimaryAttack(entity wep,number time)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end
	--鉴于这玩意作弊性质严重,所以我们要禁了它默认的攻击
	--print("true")

	local _,PropData = wep:GetDupeData()
	if !PropData[self.entity] then return end

	if wep.WireIO_ShouldAttack then 
		self:throw("Disable attacking first!")
		--print("没活了")
		return 
	end
	wep:SetNextPrimaryFire(CurTime()+math.max(0.05,time))
	
end

e2function void setNSPWPropertiesEnabled(entity ent,number enabled)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(ent) or ent:GetOwner() != self.player then return end
	
	ent.NSPW_PROP_DISABLEPROPERTIES = enabled != 0 and true or false
	
end


--NSPW Generic


__e2setcost(5)

e2function entity nspwGetRelatedWeapon(entity prop)
	if !IsValid(prop) then prop = self.entity end
	if not IsValid(prop) then return NULL end
	return prop.NSPW_PROP_RELATEDWEAPON or NULL
end

e2function number nspwGetWeaponAiming(entity wep)
	if !IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end

	return wep:GetAiming() and 1 or 0
end

__e2setcost(10)
e2function void nspwSetShouldAttack(entity wep,number shouldattack)
	if not IsValid(wep) or wep:GetClass() != "nspw_melee" or 
	wep:GetOwner() != 
	self.player then return end

	local _,PropData = wep:GetDupeData()
	if !PropData[self.entity] then return end

	wep.WireIO_ShouldAttack = tobool(shouldattack)
	--print(tobool(shouldattack))
	
end


e2function void nspwSetNextPrimaryAttack(entity wep,number time)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end
	--鉴于这玩意作弊性质严重,所以我们要禁了它默认的攻击
	--print("true")

	local _,PropData = wep:GetDupeData()
	if !PropData[self.entity] then return end

	if wep.WireIO_ShouldAttack then 
		self:throw("Disable attacking first!")
		--print("没活了")
		return 
	end
	wep:SetNextPrimaryFire(CurTime()+math.max(0.05,time))
	
end

e2function void setNSPWPropertiesEnabled(entity ent,number enabled)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(ent) or ent:GetOwner() != self.player then return end
	
	ent.NSPW_PROP_DISABLEPROPERTIES = enabled != 0 and true or false
	
end

e2function void nspwAddEntity(entity ent)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(ent) or ent:GetOwner() != self.player then return end
	
	if !self.NSPW_EXTRAENT then self.NSPW_EXTRAENT = {} end
	self.NSPW_EXTRAENT[ent] = true
	
end

--不,我懒得指定这玩意该怎么查了
	--print("SMJB")
__e2setcost(1)
e2function void runOnNSPWEvent(number run)

	local wep = self.entity.NSPW_PROP_RELATEDWEAPON
	--print(self.owner)
	--PrintTable(self)
	if not IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end
	local _,PropData = wep:GetDupeData()
	if !PropData[self.entity] then return end
	--print("SMJB")
	wep.WireIO_E2List[self] = (run != 0)
	
end

--论NSPW

e2function number nspwClk()

	return self.data.NSPWClk and 1 or 0
	
end

e2function number nspwAttackClk()

	return self.data.NSPWAttack and 1 or 0
	
end
e2function number nspwBlockClk()

	return self.data.NSPWBlock and 1 or 0
	
end


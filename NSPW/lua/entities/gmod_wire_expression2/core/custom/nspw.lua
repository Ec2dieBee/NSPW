E2Lib.RegisterExtension("nspw", true, "Allow advance controls to player's prop", "Can be used to make SUPER FUNKING ADMIN GUN 5000(Controllable!). Can also fuck up your prop")

__e2setcost(10)

--NSPW Generic

e2function entity getNSPWRelatedWeapon(entity prop)
	if !IsValid(prop) then prop = self.entity end
	if not IsValid(prop) then return NULL end
	return prop.NSPW_PROP_RELATEDWEAPON or NULL
end

--是的,这玩意实际上只禁挥舞

e2function void setNSPWShouldAttack(entity wep,number shouldattack)
	if not IsValid(wep) or wep:GetClass() != "nspw_melee" or 
	wep:GetOwner() != 
	self.player then return end
	wep.WireIO_ShouldAttack = tobool(shouldattack)
	--print(tobool(shouldattack))
	
end

e2function void setNSPWNextPrimaryAttack(entity wep,number time)
	--print(!IsValid(wep) , wep:GetClass() != "nspw_melee")
	if !IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end
	--鉴于这玩意作弊性质严重,所以我们要禁了它默认的攻击
	--print("true")
	if wep.WireIO_ShouldAttack then 
		self:throw("Disable attack first!")
		--print("没活了")
		return 
	end
	wep:SetNextPrimaryFire(CurTime()+math.max(0.05,time))
	
end

--不,我懒得指定这玩意该怎么查了
	--print("SMJB")
e2function void runOnNSPWEvent(number run)

	local wep = self.entity.NSPW_PROP_RELATEDWEAPON
	--print(self.owner)
	--PrintTable(self)
	if not IsValid(wep) or wep:GetClass() != "nspw_melee" or wep:GetOwner() != self.player then return end
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


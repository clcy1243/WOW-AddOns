local tt = 0  --喊话最小间隔，默认2秒
local T,t = 0,0

local function OnIronskin(destName)
	for i=1,40 do
		local buffid = select(11,UnitBuff(destName,i))
		if buffid == 215479 then return 1 end 
	end
	return nil
end

local function keep(self,event,...)	
	--if not UnitPosition("player") then
		local eventtype = select(2, ...)
		local spellid = select(12, ...)
		local spellname = select(13, ...)
		local destName = select(9, ...)   
		if eventtype == "SWING_DAMAGE" and GetInspectSpecialization(destName)==268 then 
			if not OnIronskin(destName) then 
				t = GetTime() 
				local str = destName.."断铁骨被平砍命中，请覆盖铁骨！"
				if t-T>tt then SendChatMessage(str, "SAY") T=t end
			end 
		end
		if eventtype == "SPELL_AURA_APPLIED" and spellid==215479  and destName~=UnitName("player") then 
			local str = destName.."已经获得铁骨，稳如POI！"
			SendChatMessage(str, "SAY")   
				
		end
		if eventtype == "SPELL_AURA_REMOVED" and spellid==215479  and destName~=UnitName("player") then 
			local str = destName.."已经失去铁骨，治疗注意！"
			SendChatMessage(str, "SAY")   
		
		end
		if (eventtype =="SPELL_PERIODIC_DAMAGE"  or  eventtype =="SPELL_DAMAGE") and GetInspectSpecialization(destName)==268 and spellid ~=124255  then 
			if not OnIronskin(destName) then 
				t = GetTime() 
				local str = destName.."断铁骨被"..GetSpellLink(spellid).."命中，请覆盖铁骨！"
				if t-T>tt then SendChatMessage(str, "SAY") T=t end
			end 
		end
	--end
end

KeepIronskin = CreateFrame("frame") 
KeepIronskin:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
KeepIronskin:SetScript("OnEvent",keep) 


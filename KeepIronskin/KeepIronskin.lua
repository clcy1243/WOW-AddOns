--------设置-----------
local tt = 2  --喊话最小间隔，默认2秒
local ISBAPPLIED = false --铁骨上身时是否报告，false：不报告，true：报告
local minPurified = 30 --未出池伤害最小比例
local whitelist = { --白名单，受到这些伤害时不会报告
[209858]=true, --死疽
[124255]=true, --醉拳
}
--------core-----------
local T,t = 0,0
local ISB = GetSpellLink(215479)
local data = {}

local function CreateTable()
	t = {
	["DOT"] = 0,
	["POOL"] = 0,
	}
	return t
end 


local function OnIronskin(dstName)
	for i=1,40 do
		local buffid = select(11,UnitBuff(dstName,i))
		if buffid == 215479 then return 1 end 
	end
	return nil
end

local function report(str,b)
	if b then t = GetTime() if t-T >tt then T=t else return end end 
	
	SendChatMessage(str,"SAY") 
		
end

local function keep(self,event,timestamp,eventtype,hideCaster,srcGUID, srcName, srcFlags,srcRFlags,dstGUID,dstName, dstFlags,dstRFlags,...)	
	local spellid = select(1, ...)
	if UnitPosition("player") then return end --仅在副本中工作
		
	--活血报告
	if eventtype == "SPELL_ABSORBED"  then --醉拳池更新
		local a,b,c,d,e,f,g = select(5, ...)
		if a ==115069 then
			if not data[dstName] then  data[dstName]=CreateTable() end --建档
			data[dstName].POOL = data[dstName].POOL + d 
		end
		if d ==115069 then 
			if not data[dstName] then  data[dstName]=CreateTable() end --建档
			data[dstName].POOL = data[dstName].POOL + g 
		end
	end
	if eventtype =="SPELL_PERIODIC_DAMAGE"  and spellid ==124255 then
		local k = select(4, ...) --醉拳打脸
		local a = select(9, ...) --醉拳吸收
		data[dstName].DOT = data[dstName].DOT + k
		data[dstName].DOT = data[dstName].DOT + a 
	end
	if eventtype == "SPELL_AURA_REMOVED" and (spellid==124273 or spellid==124274 or spellid==124275) then 
		local p =(1 - data[dstName].DOT/data[dstName].POOL) --未出池伤害
		local p1 = math.floor(p*1000)/10
		if p1<minPurified then 
			report(dstName.."未出池伤害："..p1.."%,请增加活血！",false) 
		end 
		data[dstName]=CreateTable()
	end	
		
	if not data[dstName] then return end --以下仅酒仙工作
	if not InCombatLockdown() then return end --以下仅在战斗中工作
			
	--铁骨报告
	if eventtype == "SWING_DAMAGE" and (not OnIronskin(dstName)) then 
		report(dstName.."断铁骨被平砍命中，请覆盖"..ISB,true) 
	end
	if eventtype == "SPELL_DAMAGE" and (not OnIronskin(dstName)) and (not whitelist[spellid])then 
		report(dstName.."断铁骨被"..GetSpellLink(spellid).."命中，请覆盖"..ISB,true) 
	end
	if eventtype == "SPELL_PERIODIC_DAMAGE" and (not OnIronskin(dstName)) and (not whitelist[spellid]) then 
		report(dstName.."断铁骨被"..GetSpellLink(spellid).."命中，请覆盖"..ISB,true) 
	end
	if eventtype == "SPELL_AURA_REMOVED" and spellid==215479  then 
		report(dstName.."已经失去"..ISB.."，治疗注意！",false) 
	end	
	if eventtype == "SPELL_AURA_APPLIED" and spellid==215479 and ISBAPPLIED then 
		report(dstName.."已经获得"..ISB.."，稳如POI！",false) 
	end			
	
		
		
end

KeepIronskin = CreateFrame("frame") 
KeepIronskin:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
KeepIronskin:SetScript("OnEvent",keep) 


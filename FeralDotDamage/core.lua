local AddOn, ns = ...
local L = AleaUI_GUI.GetLocale("FeralDotDamage")

local is70300 = false

local versionStr, internalVersion, dateofpatch, uiVersion = GetBuildInfo(); internalVersion = tonumber(internalVersion)

ns.version = GetAddOnMetadata(AddOn, "Version")
ns.wowbuild = internalVersion
ns.uibuild	= tonumber(uiVersion)

if ns.uibuild >= 70300 then
	is70300 = true
end

local rakeDamage = 0.80
local rakeDamagePog = 0.2
local shadowmeldDebug = false
local movingFrame = CreateFrame("Frame", AddOn.."MainFrame", UIParent)
movingFrame.elements = {}
ns.movingFrame = movingFrame

local order_spell = {}

local build = select(2, GetBuildInfo())
local versionStr, internalVersion, dateofpatch, uiVersion = GetBuildInfo()
internalVersion = tonumber(internalVersion)

ns.eventFrame = CreateFrame("Frame")
ns.eventFrame:SetScript("OnEvent", function(self, event, ...)
	ns[event](ns, event, ...)
end)
ns.RegisterEvent = function(self, ...)
	ns.eventFrame:RegisterEvent(...)
end
ns.UnregisterEvent = function(self, ...)
	ns.eventFrame:UnregisterEvent(...)
end
ns.UnregisterAllEvents = function(self, ...)
	ns.eventFrame:UnregisterAllEvents(...)
end

_G[AddOn] = ns

ns.SharedMedia = LibStub("LibSharedMedia-3.0")
ns.SharedMedia:Register("border", "WHITE8x8", [[Interface\Buttons\WHITE8x8]])
ns.SharedMedia:Register("statusbar", "WHITE8x8", [[Interface\Buttons\WHITE8x8]])

local tringleTexture = "Interface\\AddOns\\FeralDotDamage\\triangle"  --triangle.tga

local RegisterSound = function(path, name)
	ns.SharedMedia:Register("sound", name, path)
end

RegisterSound("Sound\\Spells\\SoulstoneResurrection_Base.ogg","Soulstone");
RegisterSound("Sound\\Spells\\EnlargeCast.ogg","Enlarge");
RegisterSound("Sound\\Spells\\FluteRun.ogg","Flute");
RegisterSound("Sound\\Spells\\ShadowWard.ogg","Shadow Ward");
RegisterSound("Sound\\Spells\\ShadowWordSilence.ogg","Silence");
RegisterSound("Sound\\Spells\\ShadowWordPain_Chest.ogg","Shadow Word Pain");
RegisterSound("Sound\\Spells\\ShadowWordFumble.ogg","Fumble");
RegisterSound("Sound\\Spells\\AntiHoly.ogg","Anti Holy");
RegisterSound("Sound\\Spells\\Bonk1.ogg","Bonk1");
RegisterSound("Sound\\Spells\\Bonk2.ogg","Bonk2");
RegisterSound("Sound\\Spells\\Bonk3.ogg","Bonk3");
RegisterSound("Sound\\Spells\\consume_magic_impact.ogg","Consume Magic");
RegisterSound("Sound\\Spells\\Creature_SpellPortalLarge_All_Colors.ogg","Spell Portal");
RegisterSound("Sound\\Spells\\Ingvar_ResurrectionGroundVisual.ogg","Resurrection Ground");
RegisterSound("Sound\\Spells\\Resurrection.ogg","Resurrection");
RegisterSound("Sound\\Spells\\Rogue_shadowdance_state.ogg","Shadow Dance");
RegisterSound("Sound\\Spells\\ShaysBell.ogg","Shay's Bell");
RegisterSound("Sound\\Spells\\SimonGame_Visual_BadPress.ogg","Simon Error");
RegisterSound("Sound\\Spells\\SimonGame_Visual_GameFailedLarge.ogg","Simon Failed Large");
RegisterSound("Sound\\Spells\\SimonGame_Visual_GameFailedSmall.ogg","Simon Failed Small");
RegisterSound("Sound\\Spells\\SimonGame_Visual_GameStart.ogg","Simon Start");
RegisterSound("Sound\\Spells\\SimonGame_Visual_GameTick.ogg","Simon Tick");
RegisterSound("Sound\\Spells\\SimonGame_Visual_LevelStart.ogg","Simon Level Start");

local imprived_rake_gained = false
local moonfire_talent = false
local show_moonfire_icon = false

local savage_roar_talent = false
local show_savage_roar_icon = false

local CLEAR_CAST_FIND = false
local trottle1 = 0.1

local SR_COMBO_POINTS = 0

ns.disable_addon = false
ns.partial_disable_addon = false
ns.only_in_cantForm = false

local debugging = false

local hookrake = false
--155625

ns.tigrinoe_spid = 5217
ns.tigrinoe_name = GetSpellInfo(ns.tigrinoe_spid)
local tigrinoe_spid = ns.tigrinoe_spid
local tigrinoe_name = ns.tigrinoe_name


ns.dikiyrev_spid = 52610
ns.dikiyrev_name = GetSpellInfo(ns.dikiyrev_spid)
local dikiyrev_spid = ns.dikiyrev_spid
local dikiyrev_name = ns.dikiyrev_name

ns.dikiyrev_glyph_spid = 174544
ns.dikiyrev_glyph_name = GetSpellInfo(ns.dikiyrev_glyph_spid)
local dikiyrev_glyph_spid = ns.dikiyrev_glyph_spid
local dikiyrev_glyph_name = ns.dikiyrev_glyph_name

ns.krovaviekogti_spid = 145152
ns.krovaviekogti_name = GetSpellInfo(ns.krovaviekogti_spid)
local krovaviekogti_spid = ns.krovaviekogti_spid 
local krovaviekogti_name = ns.krovaviekogti_name

ns.pererogdenie_spid = 102543
ns.pererogdenie_name = GetSpellInfo(ns.pererogdenie_spid)
local pererogdenie_spid = ns.pererogdenie_spid
local pererogdenie_name = ns.pererogdenie_name

ns.glybokayrana_spid = 155722
ns.glybokayrana_name = GetSpellInfo(ns.glybokayrana_spid)
local glybokayrana_spid = ns.glybokayrana_spid
local glybokayrana_name = ns.glybokayrana_name

ns.razorvat_spid = 1079 
local razorvat_spid = ns.razorvat_spid
local razorvat_name, _, razorvat_texture  = GetSpellInfo(ns.razorvat_spid)
ns.razorvat_name, ns.razorvat_texture = razorvat_name, razorvat_texture

ns.vzbuchka_spid = 106830
ns.vzbuchka_name = GetSpellInfo(ns.vzbuchka_spid)
local vzbuchka_spid = ns.vzbuchka_spid
local vzbuchka_name = ns.vzbuchka_name

ns.catform_spid = 768
ns.catform_name = GetSpellInfo(ns.catform_spid)
local catform_spid = ns.catform_spid
local catform_name = ns.catform_name

ns.cathumanform_spid = 171745
ns.cathumanform_name = GetSpellInfo(ns.cathumanform_spid)
local cathumanform_spid = ns.cathumanform_spid
local cathumanform_name = ns.cathumanform_name

ns.bearform_spid = 5487
ns.bearform_name = GetSpellInfo(ns.bearform_spid)
local bearform_spid = ns.bearform_spid
local bearform_name = ns.bearform_name

ns.moonfire_spid = 155625 -- 155625 for Cat, 164812 for Human
ns.moonfire_name = GetSpellInfo(ns.moonfire_spid)
local moonfire_spid = ns.moonfire_spid
local moonfire_name = ns.moonfire_name

ns.stealth_spid = 5215
ns.stealth_name = GetSpellInfo(ns.stealth_spid)
local stealth_spid = ns.stealth_spid
local stealth_name = ns.stealth_name

ns.incarnation_spid = 102543
ns.incarnation_name = GetSpellInfo(ns.incarnation_spid)
local incarnation_spid = ns.incarnation_spid
local incarnation_name = ns.incarnation_name

ns.fb_id = 22568
local fb_id = ns.fb_id
local fb_name, _, fb_texture = GetSpellInfo(ns.fb_id)
ns.fb_name, ns.fb_texture = fb_name, fb_texture

ns.clearcast_id = 135700
ns.clearcast_name = GetSpellInfo(ns.clearcast_id)
local clearcast_id = ns.clearcast_id
local clearcast_name = ns.clearcast_name

ns.customAshamaneBiteTexture = 'Interface\\Icons\\ability_druid_rake'

local OnUpdateFrames = CreateFrame("Frame")
OnUpdateFrames:SetScript("OnUpdate", function(self, elapsed)
	
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	if self.elapsed < 0.05 then return end
	ns:UpdateVisible()
end)

local GLOBAL_SCALE = 1
local GLOBAL_FONT_SIZE = 24

local dot_store = {}

local hideauraTime = 0
local hideauraTime2 = 0
local hideauraTime3 = 0
local detectrakeBonus = false

ns.dot_store = dot_store

local dots_info = {
	
	[glybokayrana_spid] 	= { 3, 15, 19.5 , 	glybokayrana_name,	4.5}, -- tick period, default duration, pandemia duration
	[razorvat_spid] 		= { 2, 24, 31.2 , 	razorvat_name,		7.2},
	[vzbuchka_spid] 		= { 3, 15, 15*1.3 , vzbuchka_name,		15*0.3},
	[dikiyrev_spid] 		= { 0, 0, 0 ,	 	dikiyrev_name,		12.6},
	[dikiyrev_glyph_spid] 	= { 0, 0, 0 , 		dikiyrev_name,		12.6},
	[moonfire_spid] 		= { 2, 14, 18.2 , 	moonfire_name, 		4.2},
	[339]					= { 0, 30, 30,		( GetSpellInfo(339) ), 0 },
	[102359]				= { 0, 20, 20, 		( GetSpellInfo(102359) ), 0 },
	[210705]				= { 2, 24, 24,  	( GetSpellInfo(210705) ), 0 },
}

local function GetAuras()
	local tigrinie_neistvo = UnitAura("player", tigrinoe_name) 	 -- 15%
	local dikiy_rev		   = UnitAura("player", dikiyrev_name) 	 -- 40%
	local krovavie_kogti   = UnitAura("player", krovaviekogti_name) or ( hideauraTime2 > GetTime() ) -- 30%
	local imprake		   = 
								UnitAura("player", stealth_name) or 
								( not incarnationFix and UnitAura("player", incarnation_name) ) or 
								UnitAura("player", ( GetSpellInfo(58984) )) or 
								( detectrakeBonus and hideauraTime3 > GetTime() ) or 
								( hideauraTime > GetTime() )-- 100%

	return tigrinie_neistvo, dikiy_rev, krovavie_kogti, imprake
end


function ns:UpdateDamageMods(guid, spellid, dstName)
	local tigrinie_neistvo, dikiy_rev, krovavie_kogti, imp_rake = GetAuras()
	
	self:RegisterDot(guid, spellid)

	dot_store[guid..spellid][9]  = tigrinie_neistvo and true or false
	dot_store[guid..spellid][10] = dikiy_rev and true or false
	dot_store[guid..spellid][11] = krovavie_kogti and true or false
	
	if spellid == glybokayrana_spid and imprived_rake_gained then
		dot_store[guid..spellid][12] = imp_rake and true or false
	else
		dot_store[guid..spellid][12] = false
	end

	dot_store[guid..spellid][18] = dstName
	
	
--	print("T", "UpdateDamageMods", guid, spellid, dstName)
end

function ns:SyncTickTimer(guid, spellid)
	
--	dot_store[guid..spellid]
	
end


function ns:GetDebugColor(guid, spellid)

	local tigrinie_neistvo = dot_store[guid..spellid] and dot_store[guid..spellid][9] or false
	local dikiy_rev = dot_store[guid..spellid] and dot_store[guid..spellid][10] or false
	local krovavie_kogti = dot_store[guid..spellid] and dot_store[guid..spellid][11] or false
	local impr_rake = dot_store[guid..spellid] and dot_store[guid..spellid][12] or false
	
	return tigrinie_neistvo, dikiy_rev, krovavie_kogti, impr_rake
end

--local form_real = 0
local function GetForm(update) -- 0 - human ; 1 - bear; 2 - cat
	--[==[
	if update then
	
		local catform = UnitAura("player", catform_name, nil, "PLAYER")	or UnitAura("player", cathumanform_name, nil, "PLAYER")
		if catform then 
			form_real = 2 
			return form_real
		end

		local bearform = UnitAura("player", bearform_name, nil, "PLAYER")		
		if bearform then 
			form_real = 1 
			return form_real
		end

		form_real = 0
	end

	return form_real
	]==]
	local form = GetShapeshiftFormID()
	if form == CAT_FORM or form == BEAR_FORM then
		return form
	end
	
	return 0
end

function ns:GetDotBuffValue(guid, spellid)
	--[==[
	if spellid == moonfire_spid then
		return 1, 1	
	end
	]==]
	local cur_tigrinie_neistvo, cur_dikiy_rev, cur_krovavie_kogti, cur_imp_rake = GetAuras()

	local tigrinie_neistvo = dot_store[guid..spellid] and dot_store[guid..spellid][9] or false
	local dikiy_rev = dot_store[guid..spellid] and dot_store[guid..spellid][10] or false
	local krovavie_kogti = dot_store[guid..spellid] and dot_store[guid..spellid][11] or false
	local impr_rake = dot_store[guid..spellid] and dot_store[guid..spellid][12] or false
	
	local total_cur = 1
	local total = 1
	
	if cur_tigrinie_neistvo then total_cur = total_cur * 1.15 end
	if cur_dikiy_rev and not is70300 then total_cur = total_cur * 1.25 end -- 1.4 for WoD
	
	if spellid ~= moonfire_spid then
		if cur_krovavie_kogti then total_cur = total_cur * ( is70300 and 1.2 or 1.5 ) end
	end
	
	if imprived_rake_gained and cur_imp_rake and spellid == glybokayrana_spid then total_cur = total_cur * 2 end
	
	if tigrinie_neistvo then total = total * 1.15 end
	if dikiy_rev and not is70300 then total = total * 1.25 end -- 1.4 for WoD
	
	if spellid ~= moonfire_spid then
		if krovavie_kogti then total = total * ( is70300 and 1.2 or 1.5 ) end
	end
	
	if imprived_rake_gained and impr_rake and spellid == glybokayrana_spid then total = total * 2 end
	
	if ns.db.profile.count_cp_to_power and spellid == razorvat_spid and dot_store[guid..spellid] and dot_store[guid..spellid][17] then		
		total_cur = total_cur*0.2*UnitPower("player", 4)
		total = total*0.2*dot_store[guid..spellid][17]
	end
	
	return total_cur, total 
end

local function OnUpdate(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	
	if self.elapsed < 0.05 then return end
	self.elapsed = 0
	
	local gettime = GetTime()
	
	for guidspellid, data in pairs(dot_store) do
	
		if data then
			data[6] = data[5] - gettime
			if data[6] <= 0 then
				
				if ( data[2] - gettime ) < data[4] and ( data[2] - gettime ) > 0 then
					data[5] = gettime + ( data[2] - gettime )
					data[15] = ( data[2] - gettime )
					data[16] = data[15]/data[4]
				else
					data[5] = gettime + data[4]
					data[15] = data[4]
					data[16] = 1
				end
				data[6] = data[5] - gettime
				data[3] = data[3] - 1
			end
			data[6] = data[5] - gettime
		end
	end
end

local onupdate = CreateFrame("Frame")
onupdate:SetScript("OnUpdate", OnUpdate)

function ns:RegisterDot(guid, spellid, starttime, endtime, cp, destName)
	
	if not dot_store[guid..spellid] then
		
		dot_store[guid..spellid] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil }
		dot_store[guid..spellid][1] = starttime or GetTime()												-- starttime
		dot_store[guid..spellid][2]	= endtime or dot_store[guid..spellid][1] + dots_info[spellid][2]		-- endtime
		dot_store[guid..spellid][3] = dots_info[spellid][2]/dots_info[spellid][1]							-- ticks amount
		dot_store[guid..spellid][4] = dots_info[spellid][1]													-- ticks time
		dot_store[guid..spellid][5] = dot_store[guid..spellid][1] + dots_info[spellid][1]					-- time to next tick
		dot_store[guid..spellid][6] = dots_info[spellid][1]													-- displayed duration
		dot_store[guid..spellid][7] = true																	-- show
		dot_store[guid..spellid][8] = dots_info[spellid][2]													-- default amount
		
		dot_store[guid..spellid][13] = guid																	-- guid
		dot_store[guid..spellid][14] = spellid																-- spellid
		dot_store[guid..spellid][15] = dots_info[spellid][1]												-- tick duration
		dot_store[guid..spellid][16] = 1																	-- tick partiall coeff
		dot_store[guid..spellid][17] = cp																	-- tick partiall coeff
		dot_store[guid..spellid][18] = destName
		
		if spellid == 210705 then
			if dot_store[guid..razorvat_spid] then
				dot_store[guid..spellid][1] = dot_store[guid..razorvat_spid][1]
				dot_store[guid..spellid][2] = dot_store[guid..razorvat_spid][2]
				dot_store[guid..spellid][8] = dot_store[guid..razorvat_spid][8] 
			end
		end
		
		self:UpdateDamageMods(guid, spellid, destName)
		
		self:UpdateMultiDot()
	end
end

function ns:RefreshRegisterDot(guid, spellid, cp, dstName)
	
	if dot_store[guid..spellid] then
		local starttime = GetTime()
		local endtime = starttime + dots_info[spellid][3]		
		local pandemia = 0
		
		if dots_info[spellid][5] > 0 then
			if dot_store[guid..spellid][2] > starttime then
				pandemia = dot_store[guid..spellid][2] - starttime
			end
			
			if pandemia > dots_info[spellid][2]*0.3 then
				pandemia = dots_info[spellid][2]*0.3
			end
		end
	
		dot_store[guid..spellid][1]	= starttime
		dot_store[guid..spellid][2]	= dot_store[guid..spellid][1] + dots_info[spellid][2] + pandemia
		
		local duration = ( dot_store[guid..spellid][2] - dot_store[guid..spellid][1] )
		
		dot_store[guid..spellid][3] = floor(duration/dots_info[spellid][1]) + 1								-- ticks amount
		
		dot_store[guid..spellid][17] = cp	
		
		if spellid == 210705 then
			if dot_store[guid..razorvat_spid] then
				dot_store[guid..spellid][1] = dot_store[guid..razorvat_spid][1]
				dot_store[guid..spellid][2] = dot_store[guid..razorvat_spid][2]
				dot_store[guid..spellid][8] = dot_store[guid..razorvat_spid][8] 
			end
		end
		
		
		self:UpdateDamageMods(guid, spellid, dstName)
		
		self:UpdateMultiDot()
	end
end

function ns:UnregisterDot(guid, spellid)	
	if dot_store[guid..spellid] then
		dot_store[guid..spellid] = nil
		
		self:UpdateMultiDot()
	end
end

local unitList = { "target", "focus", "boss1", "boss2", "boss3", "boss4", "boss5" }

function ns:IsAshamaneBiteAvailible(guid)

--	print('IsAshamaneBiteAvailible:1', guid)
	
	if not ns.ashamaneBite then
		return false
	end
	
--	print('IsAshamaneBiteAvailible:2', dot_store[guid..'210705'], dot_store[guid..'210705'] and ( dot_store[guid..'210705'][2] > GetTime() ) )
	
	if dot_store[guid..'210705'] then
		if dot_store[guid..'210705'][2] > GetTime() then
			return true
		end
	end
	
	local unit = nil
	
	for i=1, 7 do
		if UnitGUID(unitList[i]) == guid then 
			unit = unitList[i]
			break
		end
	end
	
	if not unit then
		for i=1, 30 do
			if UnitGUID('nameplate'..i) == guid then 
				unit = 'nameplate'..i
				break
			end
		end
	end
	
--	print('IsAshamaneBiteAvailible:3', unit)
	
	if unit then
		local name, _, _, _, _, duration, expires = UnitDebuff(unit, (GetSpellInfo(210705)), nil, 'PLAYER')
		
--		print('IsAshamaneBiteAvailible:4', name, duration, expires)
		if name then
			ns:RegisterDot(guid, 210705, expires-duration, expires)
			
			return true
		end
	end
	
	return false
end

function ns:GetMaxCurrentTime(guid, spellid)
	local maxtime, current = 0, 0
	
	if dot_store[guid..spellid] then
		local data = dot_store[guid..spellid]
		
		maxtime = data[15]
		current = data[6]
	end
	
	return maxtime, current
end

-- CLEU ---
local cp_bycast = 0

local spellAnonce = {}

local placeHolder = {
	[77764] = 77764,
	[77761] = 77764,
}

-- 77764 	Тревожный рев
-- 77761	Тревожный рев
do
	local SendChatMessage = SendChatMessage
	local IsInRaid, IsInGroup = IsInRaid, IsInGroup
	local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
	local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
	
	function ns.ChatMessage(msg, chat, target)		
		if chat == "RAID_WARNING" then
			SendChatMessage(msg, chat)
		elseif chat == "PARTY" then
			if IsInGroup(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage(msg, "PARTY")
			end
		elseif chat == "GUILD" then
			SendChatMessage(msg, chat)
		elseif chat == "RAID" then		
			if IsInRaid(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage(msg, "RAID")
			end
		elseif chat == "WHISPER" and target then		
			SendChatMessage(msg, chat, nil, target)
		elseif chat == "SAY" or chat == "YELL" then 
			SendChatMessage(msg, chat)
		elseif chat == 'INSTANCE' then
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
				SendChatMessage(msg, "INSTANCE_CHAT")
			end
		elseif chat == 'AUTO' then
			local chatType = "SAY"
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
				chatType = "INSTANCE_CHAT"
			elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
				chatType = "RAID"
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				chatType = "PARTY"
			end
			
			if chatType == "PRINT" then
				print(msg)
			else
				SendChatMessage(msg, chatType)
			end
		end
	end
end

local numToChat = {	
	'AUTO', 
	'PARTY', 
	'RAID', 
	'WHISPER', 
	'YELL', 
	'SAY',
	'INSTANCE',
}

function ns:DoAnonce(event, spellID, target, source, extraSpellID, text)

	local spellIDph = placeHolder[spellID] or spellID
	
	if ns.db.profile.anonse.spells[spellIDph] and ns.db.profile.anonse.spells[spellIDph].on then
		
		if spellIDph == 93985 and not ns.db.profile.anonse.spells[spellIDph].iffailed and not extraSpellID then 
			return
		end
		
		local msg = ns.db.profile.anonse.spells[spellIDph].text
		
		msg = gsub(msg, "%%spell", GetSpellLink(spellID) or "")
		msg = gsub(msg, "%%extraspell", extraSpellID and GetSpellLink(extraSpellID) or L["провалено"])
		msg = gsub(msg, "%%target", target or UNKNOWN)
		msg = gsub(msg, "%%source", source or UNKNOWN)

		self.ChatMessage(msg, numToChat[ns.db.profile.anonse.spells[spellIDph].chat], ns.db.profile.anonse.spells[spellIDph].target)
	end
end

local kickqueue = CreateFrame("Frame")
kickqueue.elapsed = 0
kickqueue:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	
	if self.elapsed < 0.2 then return end
	self.elapsed = 0
	self:Hide()
	
	ns:DoAnonce(event, self.spellID, self.target, self.source, self.extraSpell, self.text)	
end)

local function DelayCastKick(spellID, target, source)
	kickqueue.elapsed = 0
	kickqueue.spellID = spellID
	kickqueue.target = target
	kickqueue.source = source
	kickqueue.kicked = false
	kickqueue.extraSpell = nil
	kickqueue:Show()
end

local function SetCastKicked(extraSpell)
	kickqueue.kicked = true
	kickqueue.extraSpell = extraSpell
	kickqueue.elapsed = 1
end

local missType = {
	["ABSORB"] = false,
	["BLOCK"] = false,
	["DEFLECT"] = false,
	["DODGE"] = false,
	["EVADE"] = false,
	["IMMUNE"] = true,
	["MISS"] = true,
	["PARRY"] = true,
	["REFLECT"] = false,
	["RESIST"] = false,
}

local function GetRakeDamage(critical)
	local tigrinie_neistvo = UnitAura("player", tigrinoe_name) 	 -- 15%
	local dikiy_rev		   = UnitAura("player", dikiyrev_name) 	 -- 30%, 40% for WoD
	local krovavie_kogti   = UnitAura("player", krovaviekogti_name) or ( hideauraTime2 > GetTime() ) -- 30%
	
	local versality = 1 + ( GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) * 0.01 )
	local mastery = 1 + ( GetMastery()*2 * 0.01 ) -- 3.13 for WoD
	local dmg = rakeDamage*UnitAttackPower('player')
	local crit = 1
	local dmg_buff = 1
	local artifact = 1 
	
	if ns.rakeBonusDamage > 0 then
		artifact = ns.rakeBonusDamage * 1.07
	end
	
	dmg_buff = dmg_buff * artifact
	
	if critical then
		crit = 2
	end
	
	if tigrinie_neistvo then 
		dmg_buff = dmg_buff * 1.15
	end
	if dikiy_rev and not is70300 then 
		dmg_buff = dmg_buff * 1.25 -- 1.4 for WoD
	end
	if krovavie_kogti then 
		dmg_buff = dmg_buff * 1.5
	end
	
	local tdmg = ceil(dmg*versality*mastery*2*crit*dmg_buff)
	local pogresh = tdmg*rakeDamagePog
	return tdmg, tdmg+pogresh, tdmg-pogresh
end

local soundTrottle = 0

local legendaryRingProc = {
	[187620] = true,
	[187616] = true,
	[187619] = true,
}

do
	local string_match = string.match
	function ns.Erase(name)
		if not name then return name end
		local rname = string_match(name, "(.+)-") or name
		return rname
	end
end

function ns:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	
	local timestamp, eventType, hideCaster,
			srcGUID, srcName, srcFlags, srcFlags2,
			dstGUID, dstName, dstFlags, dstFlags2,
			spellID, spellName, spellSchool, auraType, amount, extraSchool, extraType, blocked,absorbed,critical,glancing,crushing, isOffHand = ...
			
	--[==[
	if ns.db.profile.others.anonceDDLMG and eventType == 'SPELL_AURA_APPLIED' and legendaryRingProc[spellID] and srcGUID == dstGUID then	
		local _, _, _, _, _, duration, endTime = UnitAura(dstName, spellName)			
		if duration and duration > 0 and endTime and endTime > 0 then			
			ns.ChatMessage(format("%s %s %s", 'FDD >',  L['использует кольцо нанесения урона'], ns.Erase(dstName) ))
		end
		return
	end
	
	if ns.db.profile.others.anonceHEALLMG and eventType == 'SPELL_AURA_APPLIED' and srcGUID == dstGUID and spellID == 187618 then
		local _, _, _, _, _, duration, endTime = UnitAura(dstName, spellName)
		
		if duration and duration > 0 and endTime and endTime > 0 then	
			ns.ChatMessage(format("%s %s %s", 'FDD >',  L['использует кольцо исцеления'], ns.Erase(dstName) ))
		end
	end
	]==]
	--[==[
	if srcGUID ~= self.myGUID then
		if srcName == UnitName('player') and srcGUID and srcGUID:find('Player-') then
			print('Wrong player guid: '..tostring(srcGUID or 'nil')..' and '..tostring(self.myGUID or 'nil'))
		end
	end
	]==]
	if srcGUID ~= UnitGUID('player') then
		return
	end
	
	--[==[
	if eventType == "SPELL_DAMAGE" then
		if spellID == 1822 then	
			local tdmg, pogresh1, pogresh2 = GetRakeDamage(critical)
			
			local realDamage = select(15, ...)
			
			if ( realDamage == tdmg ) or ( pogresh1 > realDamage and realDamage > pogresh2) then	
				if shadowmeldDebug then
					print("UPPED DOT DETECTED")
				end
				detectrakeBonus = true
				
		--		error("BUFF DOT DETECTED")
			else
				if shadowmeldDebug then
					print("FAILED TO DETECT", ( realDamage == tdmg ), ( pogresh1 > realDamage ), ( realDamage > pogresh2) )
					print("FAILED TO DETECT", realDamage, tdmg, pogresh1, pogresh2 )
					print("FAILED TO DETECT", glancing, crushing) 
				end
				detectrakeBonus = false
				
		--		error("BUFF DOT DETECTION FAILED "..tostring(( realDamage == tdmg )).." - "..tostring(( pogresh1 > realDamage )).." - "..tostring(( realDamage > pogresh2)).." - "..realDamage.." - "..tdmg.." - "..pogresh1 )
			end
			if shadowmeldDebug then
				print("T0", tdmg, pogresh, critical)
				print("T", GetTime(), "DOT DO DAMAGE", select(15, ...) , ( select(21, ...) and "crit" or ''), ( select(25, ...) and "MS" or ''))
			end
		end	
	end
	
	if eventType == "SPELL_PERIODIC_DAMAGE" then
		if spellID == glybokayrana_spid then	
	--		print("T", GetTime(), eventType, "DOT DO DAMAGE", select(15, ...) , ( select(21, ...) and "crit" or ''), ( select(25, ...) and "MS" or ''))
		end	
	end
	]==]

	if eventType == "SPELL_AURA_APPLIED" then	
		if spellID == glybokayrana_spid or spellID == vzbuchka_spid then
			ns:RegisterDot(dstGUID, spellID, nil, nil, nil, dstName)
			
			if spellID == glybokayrana_spid then
		--		print("T", GetTime(), "DOT APPLY")
				
				detectrakeBonus = false
			end
		elseif spellID == razorvat_spid then
			ns:RegisterDot(dstGUID, spellID, nil, nil, cp_bycast, dstName)
		elseif moonfire_spid == spellID then
			ns:RegisterDot(dstGUID, spellID, nil, nil, nil, dstName)
		elseif spellID == 339 or spellID == 102359 then

			ns:RegisterDot(dstGUID, spellID, nil, nil, nil, dstName)
		elseif spellID == 210705 then
			ns:RegisterDot(dstGUID, spellID, nil, nil, nil, dstName)
		elseif dikiyrev_spid == spellID then
			SR_COMBO_POINTS = UnitPower('player', 4)
		end
	elseif eventType == "SPELL_CAST_SUCCESS" then
		if spellID == 106839 then
			DelayCastKick(93985, dstName, srcName)
		elseif spellID ~= 20484 then
			ns:DoAnonce(eventType, spellID, dstName, srcName)
		end
	elseif eventType == "SPELL_INTERRUPT" then
		local extraSpellID, extraSpellName, extraSchool = select(15, ...)
		SetCastKicked(extraSpellID)		
	elseif eventType == "SPELL_RESURRECT" and spellID == 20484 then	
		ns:DoAnonce(eventType, spellID, dstName, srcName)
		
	elseif eventType == "SPELL_AURA_REFRESH" then		
		if spellID == glybokayrana_spid or spellID == vzbuchka_spid then
			ns:RefreshRegisterDot(dstGUID, spellID,nil, dstName)
		--	print("T6", eventType, spellID, spellName, cp_bycast)
			
			if spellID == glybokayrana_spid then
			--	print("T", GetTime(), "DOT REFRESH")
				
				detectrakeBonus = false
			end
		elseif spellID == razorvat_spid then
			ns:RefreshRegisterDot(dstGUID, spellID, cp_bycast, dstName)
		--		print("T6", eventType, spellID, spellName, cp_bycast)
		elseif moonfire_spid == spellID then
			ns:RefreshRegisterDot(dstGUID, spellID,nil, dstName)
		elseif spellID == 339 or spellID == 102359 then		
			ns:RefreshRegisterDot(dstGUID, spellID, nil, dstName)
		elseif spellID == 210705 then
			ns:RefreshRegisterDot(dstGUID, spellID, nil, dstName)
		end
	elseif eventType == "SPELL_AURA_REMOVED" then
		if spellID == glybokayrana_spid or spellID == razorvat_spid or spellID == vzbuchka_spid then
			ns:UnregisterDot(dstGUID, spellID)
			
			if spellID == glybokayrana_spid then
			--	print("T", GetTime(), "DOT END")
			end
			
		elseif moonfire_spid == spellID then
			ns:UnregisterDot(dstGUID, spellID)
		elseif spellID == 339 or spellID == 102359 then
			ns:UnregisterDot(dstGUID, spellID)
		elseif spellID == 210705 then
			ns:UnregisterDot(dstGUID, spellID)
		elseif spellID == stealth_spid or spellID == 102547 then		
			hideauraTime = GetTime()+trottle1
		elseif spellID == krovaviekogti_spid then
			hideauraTime2 = GetTime()+trottle1
		elseif spellID == 58984 then
			hideauraTime3 = GetTime()+trottle1
		end
	elseif spellID ~= 163505 and ns.db.profile.others.playSound and eventType == "SPELL_MISSED" and missType[auraType] then
		if  ( GetTime() > soundTrottle ) then
			soundTrottle = GetTime() + 1			
			local willplay, handler = PlaySoundFile(ns.SharedMedia:Fetch("sound", ns.db.profile.others.playSoundFile), "MASTER")	
		end
	end
end

-- UCS --
--[==[
function ns:UNIT_SPELLCAST_SUCCEEDED(event, unitID, spell, rank, lineID, spellID)
	if true then return end
	if unitID ~= "player" then return end

	if UnitGUID("target") then
		if spellID == 1822 then
			ns:RefreshRegisterDot(UnitGUID("target"), glybokayrana_spid,nil, UnitName("target"))
			print("T", spell, unitID, spellID)
			ns:UpdateVisible("target")
		elseif spellID == vzbuchka_spid then
			ns:RefreshRegisterDot(UnitGUID("target"), vzbuchka_spid,nil, UnitName("target"))
			print("T", spell, unitID, spellID)
			ns:UpdateVisible("target")
		elseif spellID == razorvat_spid then
			ns:RefreshRegisterDot(UnitGUID("target"), razorvat_spid, cp_bycast, UnitName("target"))
			print("T", spell, unitID, spellID)
			ns:UpdateVisible("target")
		end
	end
end
]==]
-- UA ---

function ns:UNIT_AURA(event, unit)
	
	if unit ~= "target" and unit ~= "player" then return end
	
	ns:UpdateVisible(unit)
end

-- MainFrame Visability

function ns:ToggleMainFrameVisability(a)

	if a == 'Show' then
		self.movingFrame.energybarParent:Show()
		self.movingFrame.manabarParent:Show()
		self.movingFrame.healthbarParent:Show()
		self.movingFrame:Show()
		ns:UNIT_POWER_FREQUENT(event, 'player')
	elseif a == 'Hide' then
		self.movingFrame.energybarParent:Hide()
		self.movingFrame.manabarParent:Hide()
		self.movingFrame.healthbarParent:Hide()
		self.movingFrame:Hide()
	elseif a == 'Bear' then
		self.movingFrame.energybarParent:Show()
		self.movingFrame.manabarParent:Show()
		self.movingFrame.healthbarParent:Show()
		self.movingFrame:Hide()
		ns:UNIT_POWER_FREQUENT(event, 'player')
	end
	
--	print('T', 'ToggleMainFrameVisability', a)
end

function ns:UpdateMainFrameVisability()
	
--	print('T', 'UpdateMainFrameVisability', GetForm(), GetForm() == BEAR_FORM)
	if ns.powerWhileGuardianDruid then
		ns:ToggleMainFrameVisability("Bear")
		ns:ToggleCooldownBar("Hide")
		return false
	end
	
	if ns.disable_addon then
		ns:ToggleMainFrameVisability("Hide")
		ns:ToggleCooldownBar("Hide")
		return false
	end
	
	
	if ns.db.profile.show_in_combat then
		if not UnitAffectingCombat("player") then
			ns:ToggleMainFrameVisability("Hide")
			ns:ToggleCooldownBar("Hide")
			return false
		end
	end
	
	if ns.db.profile.show_on_target then
		if not UnitExists("target") then
			ns:ToggleMainFrameVisability("Hide")
			ns:ToggleCooldownBar("Hide")
			return false
		end
	end
	
	if ns.db.profile.show_only_catform or ns.only_in_cantForm then
		if GetForm() ~= CAT_FORM then
			ns:ToggleMainFrameVisability("Hide")
			ns:ToggleCooldownBar("Hide")
			ns:UpdateMultiDot()
			return false
		end
	end
	
	ns:ToggleMainFrameVisability("Show")
	if ns.only_in_cantForm then
		ns:ToggleCooldownBar("Hide")
	else
		ns:ToggleCooldownBar("Show")
	end
	
	ns:UpdateMultiDot()
	
	return true
end


-- TargetChange --

function ns:PLAYER_TARGET_CHANGED(event, unit)
	if ns:UpdateMainFrameVisability() then	
		ns:UpdateVisible("target")
		ns:UpdateMultiDot()
	end
end

function ns:PLAYER_FOCUS_CHANGED(event, unit)
	
	
--	ns:UpdateVisible("focus")
end

local combopoits_str = {	
	"|cffffff00"..RANGE_INDICATOR.."|r",
	"|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r",
	"|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r",
	"|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r|cffffff00"..RANGE_INDICATOR.."|r",
}

local function updateGlow(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + ( elapsed * self.dir )
	if self.elapsed > 1 then
		self.dir = -1.7
		self.elapsed = 1
	elseif self.elapsed <= 0 then
		self.dir = 1.7
		self.elapsed = 0
	end

	self:SetAlpha(self.elapsed)
end

local function updateGlowEnergy(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + ( elapsed * self.dir )
	if self.elapsed > 1 then
		self.dir = -1.7
	elseif self.elapsed <= 0 then
		self.dir = 1.7
	end
	
	if self.endTime-GetTime() < 3 then
		ns.movingFrame.energybar.glowIndicatorText:SetText(format("%.1f ", self.endTime-GetTime()))
	else
		ns.movingFrame.energybar.glowIndicatorText:SetText(format("%.0f ", self.endTime-GetTime()))
	end
	
	if ns.db.profile.energybar.showglow then
		if ns.db.profile.energybar.animglow then
			ns.movingFrame.energybar.glowIndicator:SetAlpha(self.elapsed)
		else
			ns.movingFrame.energybar.glowIndicator:SetAlpha(1)
		end
	else
		ns.movingFrame.energybar.glowIndicator:SetAlpha(0)
	end
end

local clearCastAnim = CreateFrame("Frame")
clearCastAnim.elapsed = 0
clearCastAnim.dir = -1.7
clearCastAnim.endTime = 0
clearCastAnim.work = true
clearCastAnim.Start = function(self, endTime, duration)
	self.endTime = endTime
	if self.work then return end
	ns:UNIT_POWER_FREQUENT(event, "player")
	self.work = true
	self:Show()
	ns.movingFrame.energybar.glowIndicatorText:Show()
end
clearCastAnim.Reset = function(self)
	if not self.work then return end
	ns:UNIT_POWER_FREQUENT(event, "player")
	self.work = false
	ns.movingFrame.energybar.glowIndicator:SetAlpha(0)
	self.elapsed = 0
	self.dir = -1.7
	self:Hide()	
	ns.movingFrame.energybar.glowIndicatorText:Hide()
end
clearCastAnim:SetScript("OnUpdate", updateGlowEnergy)
clearCastAnim:Hide()

function ns:UpdateVisible(unit)
	OnUpdateFrames.elapsed = 0
	
	for i=1, #order_spell do
		local frame = movingFrame.elements[i]
	
		if frame and frame.widgetType then
			
			frame.shown = false

			
			if frame.spellID == fb_id then
				local combopoints = UnitPower("player", 4)
				local haveProc = false
				
				if ( ns.db.profile.icons.enable4T21 ) then
					if UnitBuff('player', (GetSpellInfo(252752))) then
						haveProc = true
						
						if not frame._enable4T2Highlight then
							frame._enable4T2Highlight = true
							
							FeralDotDamage.ShowOverlayGlow(frame)
						end
					elseif frame._enable4T2Highlight then
						frame._enable4T2Highlight = false
						
						FeralDotDamage.HideOverlayGlow(frame)
					end
				else	
					if frame._enable4T2Highlight then
						frame._enable4T2Highlight = false
						
						FeralDotDamage.HideOverlayGlow(frame)
					end
				end
				
				if combopoints > 0 or haveProc then
					frame.guid = guid
					frame.shown = true

					frame:ToggleIconDarkness(true)
					
					frame:SetAlpha(1)
		
					frame:ToggleComboPoints(combopoints)
					
					frame:SetIcon(nil, false)
					
					frame.glow:Hide()
					frame.glow.elapsed = 0
					
					--[==[
					local energy = UnitPower("player", 3)
					
					if energy >= 50 or haveProc then
						frame.icon:SetVertexColor(1, 1, 1, 1)
					elseif energy > 35 then
						frame.icon:SetVertexColor(1, 1, 0, 1)
					else 
						frame.icon:SetVertexColor(1, 0.6, 0.6, 1)
					end
					]==]
				end
			else
				local ind = 1

				while ( true ) do
					local guid = UnitGUID("target")
					local name, _, icon, _, _, duration, expirationTime, _, _, _, spellId = UnitAura("target", ind, "PLAYER|HARMFUL")
					
					if not name then
						break;
					end
					
					if duration and duration > 0 and expirationTime and expirationTime > GetTime() then				
						if spellId == 210705 then
							ns:RegisterDot(guid, 210705, expirationTime-duration, expirationTime)
						end
						
						if spellId == frame.spellID then
							local spellid = frame.spellID
							
							ns:RegisterDot(guid, spellid, expirationTime-duration, expirationTime)
							
							local cp = 0
							
							if dot_store[guid..spellid] then

								dot_store[guid..spellid][1] = expirationTime-duration or GetTime()												-- starttime
								dot_store[guid..spellid][2]	= expirationTime or dot_store[guid..spellid][1] + dots_info[spellid][2]		-- endtime
								
								cp = dot_store[guid..spellid][17]
							end
							
							frame.guid = guid
							frame.shown = true

							frame:ToggleIconDarkness(true)

							frame:ToggleTicks(true)
							
							frame:SetAlpha(1)
				
							frame:ToggleComboPoints(cp)
							
							if frame.spellID == vzbuchka_spid then
								local name1, _, icon1, _, _, duration1, expirationTime1, _, _, _, spellId1 = UnitBuff("player", (GetSpellInfo(210664)))
								
							--	print('T', name1, duration1, (expirationTime1 and  expirationTime1-GetTime() or -1 ))
								
								if name1 and not ns.db.profile.icons.disableIconSwap then
									if ns.brutalSlash then
										frame:SetIcon(GetSpellTexture(202028), false)
									else
										frame:SetIcon(GetSpellTexture(106785), false)
									end						
									frame:SetTimer(expirationTime-duration, duration)
								else				
									frame:SetIcon(GetSpellTexture(vzbuchka_spid), false)						
									frame:SetTimer(expirationTime-duration, duration)
								end
							else
								frame:SetIcon(nil, false)
								frame:SetTimer(expirationTime-duration, duration)
							end
						end
					end
					
					ind = ind + 1
				end
				
				ind = 1
				
				while ( true ) do
					local name, _, icon, _, _, duration, expirationTime, _, _, _, spellId = UnitAura("player", ind, "PLAYER|HELPFUL")
					
					if not name then
						break;
					end
					
					if duration and duration > 0 and expirationTime and expirationTime > GetTime() then		
						if name == frame.spellName then

							local guid = UnitGUID("player")
							local spellid = frame.spellID
							
							frame.shown = true
							frame.guid = guid
							
							frame:ToggleTicks(false)
							
							frame:SetIcon(nil, false)
							frame:SetTimer(expirationTime-duration, duration)
							
							frame:ToggleIconDarkness(true)
							
							frame:SetAlpha(1)
							
							frame:ToggleComboPoints(false)
						end
					end
					
					ind = ind + 1
				end
			end
			
			local clearCast, _, _, _, _, duration, expirationTime = UnitAura("player", clearcast_name, nil, "PLAYER|HELPFUL")
			
			CLEAR_CAST_FIND = clearCast
			if clearCast then
				clearCastAnim:Start(expirationTime)
			else
				clearCastAnim:Reset()
			end

			-- 135700

			if not frame.shown then
				frame:RestoreTexture()	
				
				frame:ToggleTicks(false)
				
				frame.icon:SetDesaturated(ns.db.profile.icons.desaturated)
				frame.icon:SetVertexColor(1, 1, 1, 1)

				frame:ClearTimer()
				
				frame:ToggleIconDarkness(false)

				frame.glow:Hide()
				frame.glow.elapsed = 0
				
				frame:SetAlpha(ns.db.profile.icons.alpha_outof_combat or 0.8)
		
				frame:ToggleComboPoints(false)
				
				frame.guid = nil
				
				if frame.spellID == vzbuchka_spid then
					frame.icon:SetTexture(GetSpellTexture(vzbuchka_spid))
				end
			end
		end
	end
end

local TOTAL_WIDTH = 200

local idin = 0
local IconCounter = 0
local StatusBarCounter = 0

local function UpdatePowerTextColor(self)
	local parent = self
	local guid = parent.guid
	local spellid = parent.spellID
	local data = dot_store[guid..spellid]
	
	if not data then 
		parent.power1:SetText("")
		parent.power2:SetText("")			
		return 
	end
	
	local v1, v2 = ns:GetDotBuffValue(guid, spellid) -- total cur, total
	-- v1 то что уже есть v2 то что будет
	--v2 = v2  --* data[16]
	
	local current_t = blank
	local current_d = 0
	local current_d1 = 0
	
	if v1 and v2 then
		
		if v1 > v2 and (v1 - v2 ) > ( ns.db.profile.dotpowerspike*0.01) then 
			current_t = 1
		elseif v2 > v1 then
			current_t = -1
		else
			current_t = 0
		end
		
		if ns.db.profile.relative_numbers then
			current_d = v1*100/v2
			current_d1 = v2*100
		else
			current_d = v1*100
			current_d1 = v2*100
		end
	end

	parent.icon:SetVertexColor(1, 1, 1, 1)
	
	if current_t == 0 then			
		if ns.db.profile.icons.icon_color_values then
			parent.icon:SetVertexColor(ns.db.profile.icons.same_color[1], ns.db.profile.icons.same_color[2], ns.db.profile.icons.same_color[3], ns.db.profile.icons.same_color[4])
		end
	elseif current_t == 1 then
		if ns.db.profile.icons.icon_color_values then
			parent.icon:SetVertexColor(ns.db.profile.icons.better_color[1], ns.db.profile.icons.better_color[2], ns.db.profile.icons.better_color[3], ns.db.profile.icons.better_color[4])
		end		
	elseif current_t == -1 then
		if ns.db.profile.icons.icon_color_values then
			parent.icon:SetVertexColor(ns.db.profile.icons.worse_color[1], ns.db.profile.icons.worse_color[2], ns.db.profile.icons.worse_color[3], ns.db.profile.icons.worse_color[4])
		end	
	end
		
	if ns.db.profile.icons.revert_text_coloring then
		parent.power1:SetTextColor(1, 1, 1, 1)
		if current_t == 0 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power2:SetTextColor(ns.db.profile.icons.same_color[1], ns.db.profile.icons.same_color[2], ns.db.profile.icons.same_color[3], ns.db.profile.icons.same_color[4])
			end
		elseif current_t == 1 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power2:SetTextColor(ns.db.profile.icons.better_color[1], ns.db.profile.icons.better_color[2], ns.db.profile.icons.better_color[3], ns.db.profile.icons.better_color[4])
			end
		elseif current_t == -1 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power2:SetTextColor(ns.db.profile.icons.worse_color[1], ns.db.profile.icons.worse_color[2], ns.db.profile.icons.worse_color[3], ns.db.profile.icons.worse_color[4])
			end
		end
	else
		parent.power2:SetTextColor(1, 1, 1, 1)
		
		if current_t == 0 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power1:SetTextColor(ns.db.profile.icons.same_color[1], ns.db.profile.icons.same_color[2], ns.db.profile.icons.same_color[3], ns.db.profile.icons.same_color[4])
			end
		elseif current_t == 1 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power1:SetTextColor(ns.db.profile.icons.better_color[1], ns.db.profile.icons.better_color[2], ns.db.profile.icons.better_color[3], ns.db.profile.icons.better_color[4])
			end
		elseif current_t == -1 then			
			if ns.db.profile.icons.text_color_values then		
				parent.power1:SetTextColor(ns.db.profile.icons.worse_color[1], ns.db.profile.icons.worse_color[2], ns.db.profile.icons.worse_color[3], ns.db.profile.icons.worse_color[4])
			end
		end
	end
	
	parent.power1:SetFormattedText("%.0f", current_d)
	parent.power2:SetFormattedText("%.0f", current_d1)
end

local function UpdateIconPowerColor(self)
	
	local parent = self
	local guid = parent.guid
	local spellid = parent.spellID
	local data = dot_store[guid..spellid]
	
	parent.power1:SetText("")
	parent.power2:SetText("")	
		
	if not data then 
		parent.tringleBottomLeft:Hide()
		parent.tringleBottomRight:Hide()
		parent.tringleTopRight:Hide()	
		parent.tringleTopLeft:Hide()	
		
		parent.tringleBottomLeftBg:Hide()
		parent.tringleBottomRightBg:Hide()
		parent.tringleTopRightBg:Hide()	
		parent.tringleTopLeftBg:Hide()	
		return 
	end
	
	local tigrinie_neistvo = dot_store[guid..spellid][9] or false
	local dikiy_rev = dot_store[guid..spellid][10] or false
	local krovavie_kogti = dot_store[guid..spellid][11] or false
	local impr_rake = dot_store[guid..spellid][12] or false
	
	if impr_rake then
		parent.tringleTopRight:Show()
		parent.tringleTopRight:SetVertexColor(196/255, 0, 171/255, 1)
		parent.tringleTopRightBg:Show()
	else
		parent.tringleTopRight:Hide()
		parent.tringleTopRightBg:Hide()
	end
	
	if tigrinie_neistvo then
		parent.tringleBottomRight:Show()
		parent.tringleBottomRight:SetVertexColor(255/255, 128/255, 0)
		parent.tringleBottomRightBg:Show()
	else
		parent.tringleBottomRight:Hide()
		parent.tringleBottomRightBg:Hide()
	end
	
	if krovavie_kogti then
		parent.tringleBottomLeft:Show()
		parent.tringleBottomLeft:SetVertexColor(0.8, 0.2, 0.2)
		parent.tringleBottomLeftBg:Show()
	else
		parent.tringleBottomLeft:Hide()
		parent.tringleBottomLeftBg:Hide()
	end
	
	if not is70300 and dikiy_rev then
		parent.tringleTopLeft:Show()
		parent.tringleTopLeft:SetVertexColor(1, 1, 0)
		parent.tringleTopLeftBg:Show()	
	else
		parent.tringleTopLeft:Hide()
		parent.tringleTopLeftBg:Hide()	
	end
end

local function IconOnUpdateHandler(self, elapsed)
	local parent = self.parent
	local guid = parent.guid
	local spellid = parent.spellID
	
	local maxtime, current = ns:GetMaxCurrentTime(guid, spellid)
	local curperhp = 0
	
	if spellid == razorvat_spid then
		
		local haveFBIcon = false
		--[==[
		for i=1, #order_spell do
			if order_spell[i] == fb_id then
				haveFBIcon = true
				break
			end
		end
		]==]
			
		curperhp = UnitHealth("target")*100/UnitHealthMax("target")
		
		if curperhp < 25 and parent.shown and not ns.db.profile.icons.disableIconSwap and not haveFBIcon then
			parent.icon:SetTexture(fb_texture)
		elseif parent.shown and not ns.db.profile.icons.disableIconSwap and ns:IsAshamaneBiteAvailible(guid) then		
			parent.icon:SetTexture(ns.customAshamaneBiteTexture)
		else
			parent.icon:SetTexture(razorvat_texture)
		end
	end
	
	parent.statusbar:SetMinMaxValues(0, maxtime)
	parent.statusbar:SetValue(current)
	
	local data = dot_store[guid..spellid]
	
	local numb = ((self._start + self._duration) - GetTime())
	
	if numb > 3 then
		parent.timer:SetText(format(" %.0f ", ceil(numb)))
	else	
		if ns.db.profile.icons.time_format == 2 then
			parent.timer:SetText(format(" %.1f ", ( numb >= 0 and numb or 0.0)))
		else
			parent.timer:SetText(format(" %.0f ",  ceil(( numb >= 0 and numb or 0.0))))
		end
	end
	
	if spellid == dikiyrev_spid then	
		local baseDur = ( is70300 and 12 or 8 ) + ((SR_COMBO_POINTS-1) * ( is70300 and 6 or 4 ) )
		if numb < baseDur*0.3 then			
			if not parent.glow:IsShown() then
				parent.glow.elapsed = 0
				parent.glow:SetAlpha(0)
				parent.glow.dir = 1.7
				parent.glow:Show()
			end
		else
			parent.glow.elapsed = 0
			parent.glow.dir = 1.7
			parent.glow:SetAlpha(0)
			parent.glow:Hide()	
		end
	elseif dots_info[spellid] and numb < dots_info[spellid][5] then
		if not parent.glow:IsShown() then
			parent.glow.elapsed = 0
			parent.glow.dir = 1.7
			parent.glow:SetAlpha(0)
			parent.glow:Show()
		end
	else
		parent.glow.elapsed = 0
		parent.glow.dir = 1.7
		parent.glow:SetAlpha(0)
		parent.glow:Hide()			
	end
	
	parent:UpdatePowerData()
end

local function StatusBarOnUpdateHandler(self, elapsed)
	local parent = self.parent
	local guid = parent.guid
	local spellid = parent.spellID
	
	local curperhp = 0
	
	if spellid == razorvat_spid then
		curperhp = UnitHealth("target")*100/UnitHealthMax("target")

		if curperhp < 25 and parent.shown then
			parent.icon:SetTexture(fb_texture)
		elseif parent.shown and ns:IsAshamaneBiteAvailible(guid) then		
			parent.icon:SetTexture(ns.customAshamaneBiteTexture)
		else
			parent.icon:SetTexture(razorvat_texture)
		end
	end

	local data = guid and dot_store[guid..spellid]
	
	local numb = ((self._start + self._duration) - GetTime())
	
	if numb > 3 then
		parent.timer:SetText(format(" %.0f ", ceil(numb)))
	else	
		if ns.db.profile.icons.time_format == 2 then
			parent.timer:SetText(format(" %.1f ", ( numb >= 0 and numb or 0.0)))
		else
			parent.timer:SetText(format(" %.0f ",  ceil(( numb >= 0 and numb or 0.0))))
		end
	end
	
	parent:SetValue(numb)

	if spellid == dikiyrev_spid then	
		local baseDur = ( is70300 and 12 or 8 ) + ((SR_COMBO_POINTS-1) * ( is70300 and 6 or 4 ) )
		if numb < baseDur*0.3 then			
			if not parent.glow:IsShown() then
				parent.glow.elapsed = 0
				parent.glow:SetAlpha(0)
				parent.glow.dir = 1.7
				parent.glow:Show()
			end
		else
			parent.glow.elapsed = 0
			parent.glow.dir = 1.7
			parent.glow:SetAlpha(0)
			parent.glow:Hide()	
		end
	elseif dots_info[spellid] and numb < dots_info[spellid][5] then
		if not parent.glow:IsShown() then
			parent.glow.elapsed = 0
			parent.glow:SetAlpha(0)
			parent.glow.dir = 1.7
			parent.glow:Show()
		end
	else
		parent.glow.elapsed = 0
		parent.glow.dir = 1.7
		parent.glow:SetAlpha(0)
		parent.glow:Hide()			
	end

	parent:UpdatePowerData()
end

local statusBarFrameList = {}
function ns:AddBar(index)

	if not statusBarFrameList[index] then
		
		StatusBarCounter = StatusBarCounter + 1
		
		local f = CreateFrame('StatusBar', ns.movingFrame:GetName()..'StatusBar'..StatusBarCounter, ns.movingFrame)
		f.widgetType = "StatusBar"

		local OnUpdate = CreateFrame('Frame', nil, f)
		OnUpdate.parent = f
		OnUpdate:Hide()
		OnUpdate:SetScript("OnUpdate", StatusBarOnUpdateHandler)
		
		f.OnUpdate = OnUpdate
		
		f.backdrop = CreateFrame("Frame", nil, f)
		f.backdrop:SetFrameStrata("LOW")
		
		f.bg = f.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
		f.bg:SetColorTexture(0,0,0,1)
		
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeSize = 2,
		})
		f.glow:SetBackdropBorderColor(1, 1, 0, 1)
		f.glow:SetPoint("TOPLEFT", 1, -1)
		f.glow:SetPoint("BOTTOMRIGHT", -1, 1)	
		f.glow.dir = -1.7
		
		f.icon = f:CreateTexture()
		f.icon:SetPoint('TOPRIGHT', f, 'TOPLEFT', -1, 0)
		f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		f.icon:SetDrawLayer("BACKGROUND")
		
		f.icon.backdrop = CreateFrame("Frame", nil, f)
		f.icon.backdrop:SetFrameStrata("LOW")
		
		f.icon.bg = f.icon.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
		f.icon.bg:SetPoint("TOPLEFT", f.icon, "TOPLEFT", -1, 1)
		f.icon.bg:SetPoint("BOTTOMRIGHT", f.icon, "BOTTOMRIGHT", 1, -1)
		f.icon.bg:SetColorTexture(0,0,0,1)
		
		f.RestoreTexture = function(self)
			if self.spellID ~= razorvat_spid then return end
			self.icon:SetTexture(razorvat_texture)		
		end
		
		local textParent = CreateFrame('Frame', nil, f)
		textParent:SetFrameLevel(f:GetFrameLevel()+1)
		textParent:Show()
		
		local power1 = textParent:CreateFontString(nil, "OVERLAY")
		power1:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		power1:SetPoint("RIGHT", f, "CENTER", 0, 0)
		power1:SetJustifyH("RIGHT")
		power1:SetJustifyV("TOP")
		power1:SetText("Power1")
		
		local power2 = textParent:CreateFontString(nil, "OVERLAY")
		power2:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		power2:SetPoint("LEFT", f, "CENTER", 0, 0)
		power2:SetJustifyH("LEFT")
		power2:SetJustifyV("TOP")
		power2:SetText("Power2")
		
		local timer = textParent:CreateFontString(nil, "OVERLAY")
		timer:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		timer:SetPoint("RIGHT", f, "RIGHT", 0, 0)
		timer:SetJustifyH("RIGHT")
		timer:SetJustifyV("TOP")
		timer:SetText("Timer")
		
		f.power1 = power1
		f.power2 = power2
		f.timer = timer
		
		f.Disable = function(self)
			self:Hide()
			self.disabled = true
		end

		f.Enable = function(self, spellID)
			self.spellID = spellID
			
			local spellName, _, spellIcon = GetSpellInfo(spellID)
				
			self.spellName = spellName
			self.icon:SetTexture(spellIcon)
			self.disabled = false
			self:Show()
		end

		f.SetTimer = function(self, startTime, duration)
			if not self.OnUpdate:IsShown() then
				self.OnUpdate:Show()
			end
	
			self.OnUpdate._start = startTime
			self.OnUpdate._duration = duration
			
			self.power1:Show()
			self.power2:Show()
			self.timer:Show()
			
			self:SetMinMaxValues(0, duration)
			self:SetValue(0)
		end

		f.ClearTimer = function(self)
			self.OnUpdate:Hide()
			self.OnUpdate._start = 0
			self.OnUpdate._duration = 0
			
			self.power1:Hide()
			self.power2:Hide()
			self.timer:Hide()
			
			self:SetMinMaxValues(0, 1)
			self:SetValue(1)
		end

		f.SetIcon = function(self, icon, desaturated)
			if icon then
				self.icon:SetTexture(icon)
			end
			self.icon:SetDesaturated(desaturated)
		end

		f.ToggleTicks = function(self, enable)
			if ns.db.profile.show_ticks and enable then
			--	self.statusbar:Show()
			else
			--	self.statusbar:Hide()
			end
		end

		f.ToggleComboPoints = function(self, cp)
			if ns.db.profile.icons.showcp and cp and cp < 5 and cp > 0 then
			--	self.cprip:SetText(combopoits_str[cp])
			--	self.cprip:Show()
			else
			--	self.cprip:Hide()
			end
		end

		f.ToggleIconDarkness = function(self, enable)
		--	self.icon2:SetShown(enable)
		end
		
		f.UpdatePowerData = function(self)			
			if true then
				UpdatePowerTextColor(self)
			else
			
			end
		end

		statusBarFrameList[index] = f
	end
	
	return statusBarFrameList[index]
end

local iconFrameList = {}
function ns:AddIcon(index)

	if not iconFrameList[index] then
		
		IconCounter = IconCounter+1
		local f = CreateFrame("Frame", ns.movingFrame:GetName().."Icon"..IconCounter, ns.movingFrame)
		f.widgetType = "Icon"
	--	print('T', IconCounter, f:GetName(), 'CreateIcon')
		--[==[
		f:SetSize(TOTAL_WIDTH/3, TOTAL_WIDTH/3)
		f.spellID = spellid
		
		local spellName, _, spellIcon = GetSpellInfo(spellid)
		f.spellName = spellName
		

		self:AddMoving(f)
		]==]
		local icon = f:CreateTexture(nil, "BACKGROUND")
		icon:SetAllPoints()
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	--	icon:SetTexture(spellIcon)

		f.icon2 = f:CreateTexture(nil, "BACKGROUND", nil, 1)
		f.icon2:SetAllPoints()
		f.icon2:SetColorTexture(0, 0, 0, 1)
		
		f.backdrop = CreateFrame("Frame", nil, f)
		f.backdrop:SetFrameStrata("LOW")
		
		f.bg = f.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
		f.bg:SetColorTexture(0,0,0,1)
		
		f.triangleParent = CreateFrame("Frame", nil, f)
		f.triangleParent:SetFrameLevel(f:GetFrameLevel()+2)
		
		f.tringleTopRight = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 4)
		f.tringleTopRight:SetSize(8, 8)
		f.tringleTopRight:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, 0)
		f.tringleTopRight:SetTexture(tringleTexture)
		f.tringleTopRight:SetVertexColor(1, 0, 0, 1)
		f.tringleTopRight:SetTexCoord(0, 1, 1, 0)
		f.tringleTopRight:Hide()
		
			f.tringleTopRightBg = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 3)
			f.tringleTopRightBg:SetSize(9, 9)
			f.tringleTopRightBg:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, 0)
			f.tringleTopRightBg:SetTexture(tringleTexture)
			f.tringleTopRightBg:SetVertexColor(0, 0, 0, 1)
			f.tringleTopRightBg:SetTexCoord(0, 1, 1, 0)
			f.tringleTopRightBg:Hide()
		
		f.tringleBottomRight = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 4)
		f.tringleBottomRight:SetSize(8, 8)
		f.tringleBottomRight:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
		f.tringleBottomRight:SetTexture(tringleTexture)
		f.tringleBottomRight:SetVertexColor(1, 1, 0, 1)
		f.tringleBottomRight:Hide()
		
			f.tringleBottomRightBg = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 3)
			f.tringleBottomRightBg:SetSize(9, 9)
			f.tringleBottomRightBg:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
			f.tringleBottomRightBg:SetTexture(tringleTexture)
			f.tringleBottomRightBg:SetVertexColor(0, 0, 0, 1)
			f.tringleBottomRightBg:Hide()
		
		f.tringleBottomLeft = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 4)
		f.tringleBottomLeft:SetSize(8, 8)
		f.tringleBottomLeft:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 0, 0)
		f.tringleBottomLeft:SetTexture(tringleTexture)
		f.tringleBottomLeft:SetVertexColor(1, 1, 1, 1)
		f.tringleBottomLeft:SetTexCoord(1, 0, 0, 1)
		f.tringleBottomLeft:Hide()
			
			f.tringleBottomLeftBg = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 3)
			f.tringleBottomLeftBg:SetSize(9, 9)
			f.tringleBottomLeftBg:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 0, 0)
			f.tringleBottomLeftBg:SetTexture(tringleTexture)
			f.tringleBottomLeftBg:SetVertexColor(0, 0, 0, 1)
			f.tringleBottomLeftBg:SetTexCoord(1, 0, 0, 1)
			f.tringleBottomLeftBg:Hide()
		
		f.tringleTopLeft = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 4)
		f.tringleTopLeft:SetSize(8, 8)
		f.tringleTopLeft:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
		f.tringleTopLeft:SetTexture(tringleTexture)
		f.tringleTopLeft:SetVertexColor(1, 1, 0, 1)
		f.tringleTopLeft:SetTexCoord(1, 0, 1, 0)
		f.tringleTopLeft:Hide()
			
			f.tringleTopLeftBg = f.triangleParent:CreateTexture(nil, "BACKGROUND", nil, 3)
			f.tringleTopLeftBg:SetSize(9, 9)
			f.tringleTopLeftBg:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
			f.tringleTopLeftBg:SetTexture(tringleTexture)
			f.tringleTopLeftBg:SetVertexColor(0, 0, 0, 1)
			f.tringleTopLeftBg:SetTexCoord(1, 0, 1, 0)
			f.tringleTopLeftBg:Hide()
		
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetFrameLevel(f:GetFrameLevel()+1)
		f.glow:SetBackdrop({
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeSize = 3,
		})
		f.glow:SetBackdropBorderColor(1, 1, 0, 1)
		f.glow:SetPoint("TOPLEFT", 1, -1)
		f.glow:SetPoint("BOTTOMRIGHT", -1, 1)	
		f.glow.dir = -1.7
		
		f.RestoreTexture = function(self)
			if self.spellID ~= razorvat_spid then return end
			self.icon:SetTexture(razorvat_texture)		
		end
		
		local cd = CreateFrame("Cooldown", f:GetName().."Cooldown", f, "CooldownFrameTemplate")
		cd.parent = f
		cd:SetAllPoints()
		cd.noCooldownCount = true
		cd:SetHideCountdownNumbers(true)
		cd:SetReverse(true)
		cd:SetScript("OnUpdate", IconOnUpdateHandler)

		local power = cd:CreateFontString(nil, "OVERLAY")
		power:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		power:SetPoint("TOPLEFT", cd, "TOPLEFT", -20, 0)
		power:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 20, 0)
		power:SetJustifyH("CENTER")
		power:SetJustifyV("BOTTOM")
		power:SetText("Power")
		
		local power2 = cd:CreateFontString(nil, "OVERLAY")
		power2:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		power2:SetPoint("TOPLEFT", cd, "TOPLEFT", -20, 0)
		power2:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 20, 0)
		power2:SetJustifyH("CENTER")
		power2:SetJustifyV("BOTTOM")
		power2:SetText("Power")

		local cprip = cd:CreateFontString(nil, "OVERLAY")
		cprip:SetFont("Fonts\\ARIALN.TTF", 18, "OUTLINE")
		cprip:SetPoint("TOPLEFT", cd, "TOPLEFT", -20, 5)
		cprip:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 20, 0)
		cprip:SetJustifyH("CENTER")
		cprip:SetJustifyV("TOP")
		cprip:SetText("Power")
		
		local timer = cd:CreateFontString(nil, "OVERLAY")
		timer:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
		timer:SetPoint("TOPLEFT", cd, "TOPLEFT", -10, 0)
		timer:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 10, 0)
		timer:SetJustifyH("CENTER")
		timer:SetJustifyV("BOTTOM")
		timer:SetText("Power")
		
		local statusbar = CreateFrame("StatusBar", f:GetName().."StatusBar", cd)
		statusbar:SetSize(5, 9)
		statusbar:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -4)
		statusbar:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -4)
		statusbar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
		statusbar:SetMinMaxValues(0,3)
		statusbar:SetValue(2)
		
		statusbar.backdrop = CreateFrame("Frame", nil, statusbar)
		statusbar.backdrop:SetFrameStrata("LOW")
		
		statusbar.bg = statusbar.backdrop:CreateTexture(nil, "BACKGROUND")
		statusbar.bg:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -1, 1)
		statusbar.bg:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 1, -1)
		statusbar.bg:SetColorTexture(0,0,0,1)
		
		f.icon = icon
		f.cooldown = cd
		f.power1 = power
		f.power2 = power2
		f.timer = timer
		f.cprip = cprip
		f.statusbar = statusbar
		
		f.Disable = function(self)
			self:Hide()
			self.disabled = true
		end

		f.Enable = function(self, spellID)
			self.spellID = spellID
			
			local spellName, _, spellIcon = GetSpellInfo(spellID)
				
			self.spellName = spellName
			self.icon:SetTexture(spellIcon)
			self.disabled = false
			self:Show()
		end

		f.SetTimer = function(self, startTime, duration)
			if not self.cooldown:IsShown() then
				self.cooldown:Show()
				self:UpdatePowerData()
			end
			self.cooldown:SetCooldown(startTime, duration)
			self.cooldown._start = startTime
			self.cooldown._duration = duration
		end

		f.ClearTimer = function(self)
			self.cooldown:Hide()
			self.cooldown._start = 0
			self.cooldown._duration = 0
			
			self.tringleBottomLeft:Hide()
			self.tringleBottomRight:Hide()
			self.tringleTopRight:Hide()	
			self.tringleTopLeft:Hide()	
			
			self.tringleBottomLeftBg:Hide()
			self.tringleBottomRightBg:Hide()
			self.tringleTopRightBg:Hide()	
			self.tringleTopLeftBg:Hide()	
			
			self.power1:SetText("")
			self.power2:SetText("")	
		end

		f.SetIcon = function(self, icon, desaturated)
			if icon then
				self.icon:SetTexture(icon)
			end
			self.icon:SetDesaturated(desaturated)
		end

		f.ToggleTicks = function(self, enable)
			if ns.db.profile.show_ticks and enable then
				self.statusbar:Show()
			else
				self.statusbar:Hide()
			end
		end

		f.ToggleComboPoints = function(self, cp)
			if ns.db.profile.icons.showcp and cp and cp < 5 and cp > 0 then
				self.cprip:SetText(combopoits_str[cp])
				self.cprip:Show()
			else
				self.cprip:Hide()
			end
		end

		f.ToggleIconDarkness = function(self, enable)
			self.icon2:SetShown(enable)
		end
		
		f.UpdatePowerData = function(self, hide)	
			if ns.db.profile.icons.powerType == 1 then
				UpdatePowerTextColor(self)
				
				self.tringleBottomLeft:Hide()
				self.tringleBottomRight:Hide()
				self.tringleTopRight:Hide()	
				self.tringleTopLeft:Hide()	
				
				self.tringleBottomLeftBg:Hide()
				self.tringleBottomRightBg:Hide()
				self.tringleTopRightBg:Hide()	
				self.tringleTopLeftBg:Hide()	
			else
				UpdateIconPowerColor(self)
			end
		end
		
		iconFrameList[index] = f
	end
	
	return iconFrameList[index]
end

function ns:AddElement(index)	
--	print('T', 'AddElement', index, ns.db.profile.widgetType, ns:AddIcon(index), ns:AddBar(index))

	return ns.db.profile.widgetType == 1 and ns:AddIcon(index) or ns:AddBar(index)
end

local unlockFrameList = {}

function ns:UnlockFrames()
	
	if ns.db.profile.locked then
	
		for frame in pairs(unlockFrameList) do
			frame:EnableMouse(false)
		end
	else
		for frame in pairs(unlockFrameList) do
			frame:EnableMouse(true)
		end
	end
end

function ns:AddMoving(frame)
	if true then return end
	
	unlockFrameList[frame] = true
	
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self) ns.movingFrame:StartMoving() end)
	frame:SetScript("OnDragStop", function(self) 
		ns.movingFrame:StopMovingOrSizing()
		local x, y = ns.movingFrame:GetCenter()
		local ux, uy = ns.movingFrame:GetParent():GetCenter()

		ns.db.profile.pos = { floor(x - ux + 0.5),floor(y - uy + 0.5) }
	end)
	
end

function ns:UpdateSortings()
	
	table.sort(ns.db.profile.ordering_spells.sort, function(x, y)
  
      if x.on == y.on then
         if x.sort == y.sort then
            return x.name > y.name
         else
            return x.sort < y.sort
         end
      else
         return x.on
      end
      
      return true
	end)
	
	wipe(order_spell)
	
	local framecount = 0
	
	show_moonfire_icon = false
	show_savage_roar_icon = false
	
	for i, data in ipairs(ns.db.profile.ordering_spells.sort) do
		
		ns.db.profile.ordering_spells.spellidtoid[data.name] = i
	
		if data.name == moonfire_spid then		
			if moonfire_talent and data.on then
				show_moonfire_icon = true
				framecount = framecount + 1			
				order_spell[framecount] = data.name			
			end
		elseif data.name == dikiyrev_spid then
			if savage_roar_talent and data.on then
				show_savage_roar_icon = true
				framecount = framecount + 1			
				order_spell[framecount] = data.name		
			end
		elseif data.on then
			framecount = framecount + 1
			order_spell[framecount] = data.name
		end
	end
	
end

do
	local checker = CreateFrame('Frame')
	checker:Hide()

	local hideevery = 10
	local timeout = 28
	
	local lastCP = -1

	local function OnUpdate(self, elapsed)
		local combopoints = UnitPower("player", 4)
		
		if combopoints == 0 then return end
		if ns.disable_addon then return end

		if self.timeOut then			
			if GetTime() < self.start + timeout then
	
				ns.movingFrame.cp[combopoints]:SetMinMaxValues(0, timeout)				
				ns.movingFrame.cp[combopoints]:SetValue(math.max(0, (self.start + timeout - GetTime())))
				
		--		print('T1', UnitPower("player", 4), math.max(0, (self.start + timeout - GetTime())))
				ns.movingFrame.cp[combopoints].ignoreUpdate = true
			else
		--		print('T3', UnitPower("player", 4), math.max(0, (self.start + timeout - GetTime())))
				
				if self.cpAmount ~= combopoints then
					self.timeOut = false
				else
					ns.movingFrame.cp[combopoints]:SetMinMaxValues(0, timeout)				
					ns.movingFrame.cp[combopoints]:SetValue(0)
					ns.movingFrame.cp[combopoints].ignoreUpdate = true
				end
			end
		else
	
			if lastCP ~= combopoints then
				lastCP = combopoints
				
		--		print('T2', UnitPower("player", 4), math.max(0, (self.start + timeout - GetTime())))
				
				self.cpfade = hideevery
			end
			
			if combopoints > 0 then
				self.cpfade = self.cpfade - elapsed
				
				ns.movingFrame.cp[combopoints]:SetMinMaxValues(0, hideevery)
				ns.movingFrame.cp[combopoints]:SetValue(math.max(0, self.cpfade))
				
				ns.movingFrame.cp[combopoints].ignoreUpdate = true
			else
				self:Hide()
			end
		end
		
	end
	
	checker:SetScript('OnUpdate', OnUpdate)
	checker:SetScript('OnEvent', function(self, event)
		if ns.disable_addon then return end
		
		if event == 'PLAYER_REGEN_DISABLED' then
			self:Hide()

			for i=1, 5 do
				ns.movingFrame.cp[i].ignoreUpdate = false
			end

			ns:UNIT_POWER_FREQUENT(nil, 'player')
		else
			self.start = GetTime()
			self.cpfade = 0
			self.cpAmount = UnitPower("player", 4)
			self.timeOut = true
			self:Show()			
		end
	end)
	
	function ns:EnableComboChecker()
		checker:RegisterEvent('PLAYER_REGEN_ENABLED')
		checker:RegisterEvent('PLAYER_REGEN_DISABLED')
		
		if InCombatLockdown() then
			checker:Show()
		else
			checker:Hide()
		end
	end
end

local energyBreakPoints = { 25, 35, 40, 50 }

function ns:InitFrames()
	movingFrame:SetScale(1)
	movingFrame:SetSize(1, 1)
	movingFrame.icons = CreateFrame("Frame", nil, movingFrame)
	
	movingFrame:ClearAllPoints()
	movingFrame:SetPoint("CENTER", UIParent, "CENTER", ns.db.profile.pos[1], ns.db.profile.pos[2])
	
	self:AddMoving(movingFrame)

	local backdrop = CreateFrame("Frame", nil, movingFrame)
	backdrop:SetFrameStrata("LOW")
	movingFrame.backdrop = backdrop
	
	local bg = movingFrame.backdrop:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", movingFrame.backdrop, "TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", movingFrame.backdrop, "BOTTOMRIGHT", 1, -1)
	bg:SetColorTexture(0, 0, 0, 0)
	movingFrame.bg = bg
	
	self:UpdateSortings()
	
	for i, spellid in pairs(order_spell) do
		movingFrame.elements[i] = ns:AddElement(i)
	end

	movingFrame.cp = CreateFrame("Frame", nil, movingFrame)

	for i=1, 5 do
		
		movingFrame.cp[i] = CreateFrame("StatusBar", nil, movingFrame)
		movingFrame.cp[i]:SetSize((TOTAL_WIDTH-(3*5))/5, 14)
		
	--	self:AddMoving(movingFrame.cp[i])
		
		movingFrame.cp[i].texture = movingFrame.cp[i]:CreateTexture(nil, "ARTWORK", nil, 1)
		movingFrame.cp[i].texture:SetAllPoints()
		
		movingFrame.cp[i]:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
		
		if i == 1 or  i == 2 then
		--	movingFrame.cp[i].texture:SetColorTexture(1, 1, 0, 1)
			movingFrame.cp[i]:SetStatusBarColor(1, 1, 0, 1)
		elseif i == 3 or i == 4 then
		--	movingFrame.cp[i].texture:SetColorTexture(255/255, 171/255, 0, 1)
			movingFrame.cp[i]:SetStatusBarColor(1, 1, 0, 1)
		else	
		--	movingFrame.cp[i].texture:SetColorTexture(255/255, 107/255, 0, 1)
			movingFrame.cp[i]:SetStatusBarColor(1, 1, 0, 1)
		end
		
		movingFrame.cp[i].backdrop = CreateFrame("Frame", nil, movingFrame.cp[i])
		movingFrame.cp[i].backdrop:SetFrameStrata("LOW")
	
		movingFrame.cp[i].bg = movingFrame.cp[i].backdrop:CreateTexture(nil, "BACKGROUND", nil, -1)
		movingFrame.cp[i].bg:SetPoint("TOPLEFT", movingFrame.cp[i], "TOPLEFT", -1, 1)
		movingFrame.cp[i].bg:SetPoint("BOTTOMRIGHT", movingFrame.cp[i], "BOTTOMRIGHT", 1, -1)
		movingFrame.cp[i].bg:SetColorTexture(0,0,0,1)
		
		movingFrame.cp[i].bg2 = movingFrame.cp[i]:CreateTexture(nil, "BACKGROUND", nil, 1)
		movingFrame.cp[i].bg2:SetAllPoints()
		movingFrame.cp[i].bg2:SetColorTexture(1,0,0,1)
	
	end
	
	movingFrame.energybarParent = CreateFrame('Frame', nil, UIParent)
	
	local energybar = CreateFrame("StatusBar", movingFrame:GetName().."StatusBarEnergy", movingFrame.energybarParent)
	energybar:SetSize(100, 9)
	energybar:SetPoint("CENTER", movingFrame, "CENTER", 0, 0)
	
--	self:AddMoving(energybar)
	
	energybar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	energybar:SetMinMaxValues(0,100)
	energybar:SetValue(50)
	
	energybar.backdrop = CreateFrame("Frame", nil, energybar)
	
	energybar.bg = energybar:CreateTexture(nil, "BACKGROUND", nil, 0)
	energybar.bg:SetPoint("TOPLEFT", energybar, "TOPLEFT", -1, 1)
	energybar.bg:SetPoint("BOTTOMRIGHT", energybar, "BOTTOMRIGHT", 1, -1)
	energybar.bg:SetColorTexture(0,0,0,1)
	
	energybar.bg2 = energybar:CreateTexture(nil, "BACKGROUND", nil, 1)
	energybar.bg2:SetAllPoints()
	energybar.bg2:SetColorTexture(1,0,0,1)
	
	energybar.breakp = {}
	
	for i=1, #energyBreakPoints do
	
		energybar.breakp[i] = energybar:CreateTexture(nil, "OVERLAY", nil, 1)
		energybar.breakp[i].parent = energybar
		energybar.breakp[i].val = energyBreakPoints[i]
		energybar.breakp[i]:SetSize(1,1)
		energybar.breakp[i]:SetPoint("TOP", energybar, "TOP", 0, 0)
		energybar.breakp[i]:SetPoint("BOTTOM", energybar, "BOTTOM", 0, -0)
		energybar.breakp[i]:SetColorTexture(0, 0, 0, 0.9)
		energybar.breakp[i]:Hide()
		energybar.breakp[i].Update = function(self)
			local width = self.parent:GetWidth()
			local minEnergy, maxEnergy = self.parent:GetMinMaxValues()
			local pos = floor(width*self.val*0.01*(100/maxEnergy))
			local color = "threshold_color"
			if self.parent:GetValue() < self.val then
				color = "threshold_color2"
			end
			
			self:SetColorTexture(ns.db.profile.energybar[color][1], ns.db.profile.energybar[color][2], ns.db.profile.energybar[color][3], ns.db.profile.energybar[color][4])
			self:SetWidth(ns.db.profile.energybar.threshold_width)
			
			self:SetPoint("LEFT", self.parent, "LEFT", pos, 0)
		end
	end
	
	energybar.glowIndicator = CreateFrame("Frame", nil, energybar)
	energybar.glowIndicator:SetFrameStrata("LOW")
	energybar.glowIndicator:SetBackdrop( {	
 		edgeFile = "Interface\\AddOns\\FeralDotDamage\\glow", edgeSize = 3,
 		insets = {left = 5, right = 5, top = 5, bottom = 5},
 	})		
	energybar.glowIndicator:SetBackdropBorderColor(0, 1, 0, 1)
	energybar.glowIndicator:SetScale(3.5)
	energybar.glowIndicator:SetPoint("TOPLEFT", energybar, "TOPLEFT", -3, 3)
	energybar.glowIndicator:SetPoint("BOTTOMRIGHT", energybar, "BOTTOMRIGHT", 3, -3)
	energybar.glowIndicator:SetAlpha(0)
	
	energybar.glowIndicatorText = energybar.backdrop:CreateFontString(nil, "OVERLAY")
	energybar.glowIndicatorText:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
	energybar.glowIndicatorText:SetPoint("RIGHT", energybar, "RIGHT", 0, 0)
--	energybar.glowIndicatorText:SetWidth(20)
	energybar.glowIndicatorText:SetJustifyH("CENTER")
	energybar.glowIndicatorText:SetJustifyV("CENTER")
	energybar.glowIndicatorText:SetText("")
	energybar.glowIndicatorText:Hide()
	
	
	energybar.spark = energybar:CreateTexture(nil, "OVERLAY", nil, 3)
	energybar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	energybar.spark:SetAlpha(1)
	energybar.spark:SetWidth(16)		
	energybar.spark:SetHeight(1)
	energybar.spark:Hide()
	energybar.spark:SetBlendMode('ADD')
	energybar.spark:SetPoint("LEFT",energybar:GetStatusBarTexture(),"RIGHT",-8,0)
	energybar.spark:SetPoint("TOP", energybar, "TOP",0,10)
	energybar.spark:SetPoint("BOTTOM", energybar, "BOTTOM",0,-10)
	
	local eamount = energybar.backdrop:CreateFontString(nil, "OVERLAY")
	eamount:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
	eamount:SetPoint("TOPLEFT", energybar, "TOPLEFT", -20, 0)
	eamount:SetPoint("BOTTOMRIGHT", energybar, "BOTTOMRIGHT", 20, 0)
	eamount:SetJustifyH("CENTER")
	eamount:SetJustifyV("BOTTOM")
	eamount:SetText("EAmount")
	energybar.text = eamount
	
	movingFrame.energybar = energybar
	
	
	movingFrame.manabarParent = CreateFrame('Frame', nil, UIParent)
	
	local manabar = CreateFrame("StatusBar", movingFrame:GetName().."StatusBarMana", movingFrame.manabarParent)
	manabar:SetSize(100, 9)
	manabar:SetPoint("CENTER", movingFrame, "CENTER", 0, 0)
	manabar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	manabar:SetMinMaxValues(0,100)
	manabar:SetValue(50)
	manabar:SetStatusBarColor(0.2, 0.2, 1, 1)
	
	manabar.bg2 = manabar:CreateTexture(nil, "BACKGROUND", nil, 1)
	manabar.bg2:SetAllPoints()
	manabar.bg2:SetColorTexture(1,0,0,1)
	
--	self:AddMoving(manabar)
	
	manabar.backdrop = CreateFrame("Frame", nil, manabar)

	manabar.bg = manabar:CreateTexture(nil, "BACKGROUND", nil, 0)
	manabar.bg:SetPoint("TOPLEFT", manabar, "TOPLEFT", -1, 1)
	manabar.bg:SetPoint("BOTTOMRIGHT", manabar, "BOTTOMRIGHT", 1, -1)
	manabar.bg:SetColorTexture(0,0,0,1)
	
	local mamount = manabar.backdrop:CreateFontString(nil, "OVERLAY")
	mamount:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
	mamount:SetPoint("TOPLEFT", manabar, "TOPLEFT", -20, 0)
	mamount:SetPoint("BOTTOMRIGHT", manabar, "BOTTOMRIGHT", 20, 0)
	mamount:SetJustifyH("CENTER")
	mamount:SetJustifyV("BOTTOM")
	mamount:SetText("MAmount")
	manabar.text = mamount
	
	movingFrame.manabar = manabar
	
	movingFrame.healthbarParent = CreateFrame('Frame', nil, UIParent)
	
	local healthbar = CreateFrame("StatusBar", movingFrame:GetName().."StatusBarMana", movingFrame.healthbarParent)
	healthbar:SetSize(100, 9)
	healthbar:SetPoint("CENTER", movingFrame, "CENTER", 0, 0)
	healthbar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	healthbar:SetMinMaxValues(0,100)
	healthbar:SetValue(50)
	healthbar:SetStatusBarColor(0.2, 0.2, 1, 1)
	
	healthbar.bg2 = healthbar:CreateTexture(nil, "BACKGROUND", nil, 1)
	healthbar.bg2:SetAllPoints()
	healthbar.bg2:SetColorTexture(1,0,0,1)
	
--	self:AddMoving(manabar)
	
	healthbar.backdrop = CreateFrame("Frame", nil, healthbar)

	healthbar.bg = healthbar:CreateTexture(nil, "BACKGROUND", nil, 0)
	healthbar.bg:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -1, 1)
	healthbar.bg:SetPoint("BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 1, -1)
	healthbar.bg:SetColorTexture(0,0,0,1)
	
	local hpamount = healthbar.backdrop:CreateFontString(nil, "OVERLAY")
	hpamount:SetFont(STANDARD_TEXT_FONT, GLOBAL_FONT_SIZE, "OUTLINE")
	hpamount:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -20, 0)
	hpamount:SetPoint("BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 20, 0)
	hpamount:SetJustifyH("CENTER")
	hpamount:SetJustifyV("BOTTOM")
	hpamount:SetText("")
	healthbar.text = hpamount
	
	movingFrame.healthbar = healthbar
	
	self:UpdateFramesStyle()
	
	self:UpdateVisible("target")
	self:EnableComboChecker()
end

--[[

]]

function ns:UpdateOrders()
	-- option.
	
	-- self.db.profile.ordering_spell
	
	self:UpdateSortings()
	
--	print('T', 'UpdateOrders')
	
	for i=1, #self.movingFrame.elements do
		self.movingFrame.elements[i]:Disable()
	end
	
	table.wipe(self.movingFrame.elements)
	
	for i, spellid in pairs(order_spell) do	
		self.movingFrame.elements[i] = ns:AddElement(i)
		self.movingFrame.elements[i]:Enable(spellid)
	end
	
	self:UpdateFramesStyle()
end

local positionCodes = {
	["TOP;CENTER"] 		= { 'TOP', 'TOP' }, --L["Сверху"],
	["TOP;LEFT"] 		= { 'TOPLEFT', 'TOPLEFT'	}, --L["Слева вверху"],
	["TOP;RIGHT"] 		= { 'TOPRIGHT', 'TOPRIGHT'	}, --L["Справа вверху"],
	["CENTER;CENTER"] 	= { 'CENTER', 'CENTER'}, --L["Центр"],
	["BOTTOM;CENTER"] 	= { 'BOTTOM', 'BOTTOM'}, --L["Снизу"],
	["BOTTOM;LEFT"] 	= { 'BOTTOMLEFT', 'BOTTOMLEFT' }, --L["Слева внизу"],
	["BOTTOM;RIGHT"] 	= { 'BOTTOMRIGHT', 'BOTTOMRIGHT'}, --L["Справа внизу"],
	["CENTER;LEFT"] 	= { 'LEFT', 'LEFT' }, --L["По центру слева"],
	["CENTER;RIGHT"] 	= { 'RIGHT', 'RIGHT' }, --L["По центру справа"],
}
function ns:UnpackPositionString(str)	
	local justifyV, justifyH = strsplit(";", str)
	return justifyV, justifyH, positionCodes[str][1], positionCodes[str][2]
end

function ns:UpdateElementsStyle()
	local f = self.movingFrame
	
	if ns.db.profile.widgetType == 1 then
		local partial_1 = #order_spell%2  -- если 0 то середина между иконками 1 то середина иконки
		local numIconStep = floor(#order_spell*0.5)
		
		if ns.db.profile.icons.isvertical == 2 then -- 1 Горизонт 2 - Вертикально	
			f.icons:SetSize(1, ns.db.profile.icons.width)
			ns:Mover(f.icons, "IconsBar",  min(30, ns.db.profile.icons.max_width), ns.db.profile.icons.width)
		else
			f.icons:SetSize(ns.db.profile.icons.width, 1)
			ns:Mover(f.icons, "IconsBar", ns.db.profile.icons.width, min(30, ns.db.profile.icons.max_width))
		end

		local numicons = #order_spell
		if ns.db.profile.icons.ignore_mmonfire and show_moonfire_icon then
			numicons = numicons - 1
		end
		if ns.db.profile.icons.ignore_savageroar and show_savage_roar_icon then
			numicons = numicons - 1
		end
			
		local iconGap = ns.db.profile.icons.gap
		
		local width = ns.db.profile.icons.width-(ns.db.profile.icons.gap*(numicons-1))
		
		local swidth = width/numicons
		
		if swidth > ns.db.profile.icons.max_width then
			swidth = ns.db.profile.icons.max_width 
		end
		
		local iconOffset = 0
		
		if partial_1 == 1 then
			-- Середина иконки			
			iconOffset = ( numIconStep * ( swidth + iconGap ) ) --+  ( swidth * 0.5 )
		else
			-- Середина отступа				
			iconOffset = ( numIconStep * swidth ) + (( numIconStep - 1 ) * iconGap) + ( iconGap * 0.5 ) - ( swidth * 0.5 )
		end
			
		
	--	print('T', #order_spell, numicons, partial_frame, numIconStep)
	--	print('T2', 'Step', numIconStep*swidth + swidth * iconGap)
	
		for i, spellid in pairs(order_spell) do
			f.elements[i] = ns:AddElement(i)
			
			f.elements[i]:SetWidth(swidth)
			f.elements[i]:SetHeight(swidth)
			f.elements[i]:ClearAllPoints()
			
			if ns.db.profile.icons.isvertical == 2 then -- 1 Горизонт 2 - Вертикально			
				if i == 1 then
					if ns.db.profile.icons.anchoring == 1 then
						f.elements[i]:SetPoint("LEFT", f.icons, "LEFT", 0, iconOffset)
					else
						f.elements[i]:SetPoint("RIGHT", f.icons, "RIGHT", 0, iconOffset)
					end
				else
					f.elements[i]:SetPoint("TOP", f.elements[i-1], "BOTTOM", 0, -ns.db.profile.icons.gap)
				end		
			else		
				if i == 1 then
					if ns.db.profile.icons.anchoring == 1 then
						f.elements[i]:SetPoint("BOTTOM", f.icons, "BOTTOM", -iconOffset, 0)
					else
						f.elements[i]:SetPoint("TOP", f.icons, "TOP", -iconOffset, 0)
					end
				else
					f.elements[i]:SetPoint("LEFT", f.elements[i-1], "RIGHT", ns.db.profile.icons.gap, 0)
				end
			end
			
			backdrop 	= f.elements[i].backdrop
			bg 			= f.elements[i].bg
			
			backdrop:SetBackdrop({
				edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.icons.border.texture),
				edgeSize = ns.db.profile.icons.border.size,
			})
			backdrop:SetBackdropBorderColor(ns.db.profile.icons.border.color[1], ns.db.profile.icons.border.color[2], ns.db.profile.icons.border.color[3], ns.db.profile.icons.border.color[4])
			backdrop:SetPoint("TOPLEFT", -ns.db.profile.icons.border.inset, ns.db.profile.icons.border.inset)
			backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.icons.border.inset, -ns.db.profile.icons.border.inset)
			
			bg:SetPoint("TOPLEFT", -ns.db.profile.icons.border.bg_inset, ns.db.profile.icons.border.bg_inset)
			bg:SetPoint("BOTTOMRIGHT", ns.db.profile.icons.border.bg_inset, -ns.db.profile.icons.border.bg_inset)
			bg:SetColorTexture(ns.db.profile.icons.border.background[1], ns.db.profile.icons.border.background[2], ns.db.profile.icons.border.background[3], ns.db.profile.icons.border.background[4])
		
			backdrop 	= f.elements[i].statusbar.backdrop
			bg 			= f.elements[i].statusbar.bg
			
			backdrop:SetBackdrop({
				edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.icons.border_tick.texture),
				edgeSize = ns.db.profile.icons.border_tick.size,
			})
			backdrop:SetBackdropBorderColor(ns.db.profile.icons.border_tick.color[1], ns.db.profile.icons.border_tick.color[2], ns.db.profile.icons.border_tick.color[3], ns.db.profile.icons.border_tick.color[4])
			backdrop:SetPoint("TOPLEFT", -ns.db.profile.icons.border_tick.inset, ns.db.profile.icons.border_tick.inset)
			backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.icons.border_tick.inset, -ns.db.profile.icons.border_tick.inset)
			
			bg:SetPoint("TOPLEFT", -ns.db.profile.icons.border_tick.bg_inset, ns.db.profile.icons.border_tick.bg_inset)
			bg:SetPoint("BOTTOMRIGHT", ns.db.profile.icons.border_tick.bg_inset, -ns.db.profile.icons.border_tick.bg_inset)
			bg:SetColorTexture(ns.db.profile.icons.border_tick.background[1], ns.db.profile.icons.border_tick.background[2], ns.db.profile.icons.border_tick.background[3], ns.db.profile.icons.border_tick.background[4])
			
			f.elements[i].statusbar:ClearAllPoints()

			if ( ns.db.profile.icons.tick_position == 'LEFT' or ns.db.profile.icons.tick_position == 'RIGHT' ) then -- 1 Горизонт 2 - Вертикально		
				f.elements[i].statusbar:SetWidth(ns.db.profile.icons.height_t)
				f.elements[i].statusbar:SetHeight(f.elements[i]:GetWidth()) --ns.db.profile.icons.width)
				f.elements[i].statusbar:SetOrientation('VERTICAL')
				
				if ns.db.profile.icons.tick_position == 'LEFT' then
					f.elements[i].statusbar:SetPoint("RIGHT", f.elements[i], "LEFT", ns.db.profile.icons.gap_v, 0)
				else
					f.elements[i].statusbar:SetPoint("LEFT", f.elements[i], "RIGHT", ns.db.profile.icons.gap_v, 0)
				end
			else
				f.elements[i].statusbar:SetWidth(f.elements[i]:GetWidth())
				f.elements[i].statusbar:SetHeight(ns.db.profile.icons.height_t)
				f.elements[i].statusbar:SetOrientation('HORIZONTAL')
			
				if ns.db.profile.icons.tick_position == 'TOP' then
					f.elements[i].statusbar:SetPoint("BOTTOM", f.elements[i], "TOP", 0, ns.db.profile.icons.gap_v)
				else
					f.elements[i].statusbar:SetPoint("TOP", f.elements[i], "BOTTOM", 0, ns.db.profile.icons.gap_v)
				end
			end
			
			
			f.elements[i].statusbar:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.icons.statusbar))
			f.elements[i].statusbar:SetStatusBarColor(ns.db.profile.icons.color_tick[1],ns.db.profile.icons.color_tick[2],ns.db.profile.icons.color_tick[3], ns.db.profile.icons.color_tick[4])
			
			if not ns.db.profile.icons.hide_overlay then		
				f.elements[i].cooldown:SetSwipeColor(0, 0, 0, 0)
				f.elements[i].cooldown:SetDrawEdge(false)
			else
				f.elements[i].cooldown:SetSwipeColor(0, 0, 0, 0.6)
				f.elements[i].cooldown:SetDrawEdge(false)
			end

			f.elements[i].cooldown:SetHideCountdownNumbers(ns.db.profile.icons.timertext)		
		end
		
		for i=1, #f.elements do
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.fonts.power.text_point) -- = "BOTTOM;CENTER",
		
			f.elements[i].power1:SetFont(ns.SharedMedia:Fetch("font",  ns.db.profile.icons.fonts.font),  ns.db.profile.icons.fonts.power.fontsize,  ns.db.profile.icons.fonts.fontflag)
			f.elements[i].power1:SetJustifyH(justifyH)
			f.elements[i].power1:SetJustifyV(justifyV)
			f.elements[i].power1:SetShadowColor(
				ns.db.profile.icons.fonts.power.shadow_color[1],
				ns.db.profile.icons.fonts.power.shadow_color[2],
				ns.db.profile.icons.fonts.power.shadow_color[3],
				ns.db.profile.icons.fonts.power.shadow_color[4])
			f.elements[i].power1:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
			f.elements[i].power1:ClearAllPoints()
			
			if ns.db.profile.icons.isvertical == 2 then -- 1 Горизонт 2 - Вертикально			
				f.elements[i].power1:SetPoint(pointFrom, f.elements[i], pointTo, ns.db.profile.icons.text_pos[1], ns.db.profile.icons.text_pos[2])
			else
				f.elements[i].power1:SetPoint(pointFrom, f.elements[i], pointTo, ns.db.profile.icons.text_pos[1], ns.db.profile.icons.text_pos[2])
			end
			
			if ns.db.profile.icons.text_show_buffs then
				f.elements[i].power1:Show()
			else
				f.elements[i].power1:Hide()
			end
			
			f.elements[i].icon2:SetColorTexture(0, 0, 0, ns.db.profile.icons.icon_dark)
					
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.text_point)
			
			f.elements[i].power2:ClearAllPoints()
			
			if ns.db.profile.icons.isvertical == 2 then -- 1 Горизонт 2 - Вертикально	
				f.elements[i].power2:SetPoint(pointFrom, f.elements[i], pointTo, ns.db.profile.icons.power2_pos[1], ns.db.profile.icons.power2_pos[2])		
			else		
				f.elements[i].power2:SetPoint(pointFrom, f.elements[i], pointTo, ns.db.profile.icons.power2_pos[1], ns.db.profile.icons.power2_pos[2])
			end		
			f.elements[i].power2:SetFont(ns.SharedMedia:Fetch("font",  ns.db.profile.icons.fonts.font),  ns.db.profile.icons.fonts.power.fontsize,  ns.db.profile.icons.fonts.fontflag)
			f.elements[i].power2:SetJustifyH(justifyH)
			f.elements[i].power2:SetJustifyV(justifyV)
			f.elements[i].power2:SetShadowColor(
				ns.db.profile.icons.fonts.power.shadow_color[1],
				ns.db.profile.icons.fonts.power.shadow_color[2],
				ns.db.profile.icons.fonts.power.shadow_color[3],
				ns.db.profile.icons.fonts.power.shadow_color[4])
			f.elements[i].power2:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
		
			if ns.db.profile.icons.text_show_current then
				f.elements[i].power2:Show()
			else
				f.elements[i].power2:Hide()
			end
			
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.fonts.timer.text_point) -- = "BOTTOM;CENTER",
			
			f.elements[i].timer:ClearAllPoints()
			f.elements[i].timer:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.icons.fonts.font), ns.db.profile.icons.fonts.timer.fontsize, ns.db.profile.icons.fonts.fontflag)
			f.elements[i].timer:SetJustifyH(justifyH)
			f.elements[i].timer:SetJustifyV(justifyV)
			f.elements[i].timer:SetShadowColor(
				ns.db.profile.icons.fonts.timer.shadow_color[1],
				ns.db.profile.icons.fonts.timer.shadow_color[2],
				ns.db.profile.icons.fonts.timer.shadow_color[3],
				ns.db.profile.icons.fonts.timer.shadow_color[4])
			f.elements[i].timer:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
			f.elements[i].timer:SetTextColor(
				ns.db.profile.icons.fonts.timer.color[1],
				ns.db.profile.icons.fonts.timer.color[2],
				ns.db.profile.icons.fonts.timer.color[3],1)
			f.elements[i].timer:SetPoint(pointFrom, f.elements[i].cooldown, pointTo, ns.db.profile.icons.fonts.timer.spacing_h, ns.db.profile.icons.fonts.timer.spacing_v)

			if ns.db.profile.icons.timertext then
				f.elements[i].timer:Show()
			else
				f.elements[i].timer:Hide()		
			end
			
			f.elements[i].glow:SetBackdrop({
				edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeSize = ns.db.profile.icons.glowsize,
			})
			f.elements[i].glow:SetBackdropBorderColor(ns.db.profile.icons.glowcolor[1], ns.db.profile.icons.glowcolor[2], ns.db.profile.icons.glowcolor[3], 1)
			
			if ns.db.profile.icons.fadingglow then
				f.elements[i].glow:SetScript("OnUpdate", updateGlow)
			else
				f.elements[i].glow:SetScript("OnUpdate", nil)
				f.elements[i].glow:SetAlpha(1)
			end		
		end
		
		if ns.db.profile.show_ticks then
			for i, spellid in pairs(order_spell) do
				f.elements[i]:ToggleTicks(true)
			end
		else	
			for i, spellid in pairs(order_spell) do
				f.elements[i]:ToggleTicks(false)
			end
		end
	else
	
		f.icons:SetSize(ns.db.profile.bars.width, ns.db.profile.bars.height)
		ns:Mover(f.icons, "IconsBar", ns.db.profile.bars.width, ns.db.profile.bars.height)
			
			
		for i, spellid in pairs(order_spell) do
			f.elements[i] = ns:AddElement(i)
			
			f.elements[i]:SetSize(ns.db.profile.bars.width-ns.db.profile.bars.height, ns.db.profile.bars.height)
			f.elements[i]:Show()
			f.elements[i]:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.bars.texture))
			f.elements[i]:SetStatusBarColor(ns.db.profile.bars.color[1],ns.db.profile.bars.color[2],ns.db.profile.bars.color[3], ns.db.profile.bars.color[4])
			
			f.elements[i].icon:SetSize(ns.db.profile.bars.height, ns.db.profile.bars.height)
			
			f.elements[i].glow:SetBackdrop({
				edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeSize = ns.db.profile.icons.glowsize,
			})
			f.elements[i].glow:SetBackdropBorderColor(ns.db.profile.icons.glowcolor[1], ns.db.profile.icons.glowcolor[2], ns.db.profile.icons.glowcolor[3], 1)
			
			if ns.db.profile.icons.fadingglow then
				f.elements[i].glow:SetScript("OnUpdate", updateGlow)
			else
				f.elements[i].glow:SetScript("OnUpdate", nil)
				f.elements[i].glow:SetAlpha(1)
			end	
			
			
			if i == 1 then
				f.elements[i]:ClearAllPoints()
				if ns.db.profile.bars.growUp then
					f.elements[i]:SetPoint("TOP", f.icons, "TOP", ns.db.profile.bars.height*0.5, 0)
				else
					f.elements[i]:SetPoint("BOTTOM", f.icons, "BOTTOM", ns.db.profile.bars.height*0.5, 0)
				end
			else
				f.elements[i]:ClearAllPoints()
				if ns.db.profile.bars.growUp then
					f.elements[i]:SetPoint("BOTTOM", f.elements[i-1], "TOP", 0, ns.db.profile.bars.gap)
				else
					f.elements[i]:SetPoint("TOP", f.elements[i-1], "BOTTOM", 0, -ns.db.profile.bars.gap)
				end
			end	
			
			
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.fonts.power.text_point) -- = "BOTTOM;CENTER",
		
			f.elements[i].power1:SetFont(ns.SharedMedia:Fetch("font",  ns.db.profile.icons.fonts.font),  ns.db.profile.icons.fonts.power.fontsize,  ns.db.profile.icons.fonts.fontflag)
			f.elements[i].power1:SetJustifyH(justifyH)
			f.elements[i].power1:SetJustifyV(justifyV)
			f.elements[i].power1:SetShadowColor(
				ns.db.profile.icons.fonts.power.shadow_color[1],
				ns.db.profile.icons.fonts.power.shadow_color[2],
				ns.db.profile.icons.fonts.power.shadow_color[3],
				ns.db.profile.icons.fonts.power.shadow_color[4])
			f.elements[i].power1:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
			
			
			if ns.db.profile.icons.text_show_buffs then
				f.elements[i].power1:Show()
			else
				f.elements[i].power1:Hide()
			end
			
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.text_point)
		
			f.elements[i].power2:SetFont(ns.SharedMedia:Fetch("font",  ns.db.profile.icons.fonts.font),  ns.db.profile.icons.fonts.power.fontsize,  ns.db.profile.icons.fonts.fontflag)
			f.elements[i].power2:SetJustifyH(justifyH)
			f.elements[i].power2:SetJustifyV(justifyV)
			f.elements[i].power2:SetShadowColor(
				ns.db.profile.icons.fonts.power.shadow_color[1],
				ns.db.profile.icons.fonts.power.shadow_color[2],
				ns.db.profile.icons.fonts.power.shadow_color[3],
				ns.db.profile.icons.fonts.power.shadow_color[4])
			f.elements[i].power2:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
		
			if ns.db.profile.icons.text_show_current then
				f.elements[i].power2:Show()
			else
				f.elements[i].power2:Hide()
			end
			
			local justifyV, justifyH, pointFrom, pointTo = ns:UnpackPositionString(ns.db.profile.icons.fonts.timer.text_point) -- = "BOTTOM;CENTER",
			
			f.elements[i].timer:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.icons.fonts.font), ns.db.profile.icons.fonts.timer.fontsize, ns.db.profile.icons.fonts.fontflag)
			f.elements[i].timer:SetJustifyH(justifyH)
			f.elements[i].timer:SetJustifyV(justifyV)
			f.elements[i].timer:SetShadowColor(
				ns.db.profile.icons.fonts.timer.shadow_color[1],
				ns.db.profile.icons.fonts.timer.shadow_color[2],
				ns.db.profile.icons.fonts.timer.shadow_color[3],
				ns.db.profile.icons.fonts.timer.shadow_color[4])
			f.elements[i].timer:SetShadowOffset(ns.db.profile.icons.fonts.shadow_pos[1],ns.db.profile.icons.fonts.shadow_pos[2])
			f.elements[i].timer:SetTextColor(
				ns.db.profile.icons.fonts.timer.color[1],
				ns.db.profile.icons.fonts.timer.color[2],
				ns.db.profile.icons.fonts.timer.color[3],1)
	
			if ns.db.profile.icons.timertext then
				f.elements[i].timer:Show()
			else
				f.elements[i].timer:Hide()		
			end
		end
	end
end

function ns:UpdateFramesStyle()
	local f = self.movingFrame
	
--	print('T', 'UpdateFramesStyle')
	
--	f:ClearAllPoints()
--	f:SetPoint("CENTER", UIParent, "CENTER", ns.db.profile.pos[1], ns.db.profile.pos[2])
	
	f:SetWidth(ns.db.profile.width)
	f:SetHeight(ns.db.profile.height)
	
	ns:Mover(f, "FrameBackground")
	
	local opt = ns.db.profile.border
	local backdrop = f.backdrop
	local bg = f.bg
	
	backdrop:SetBackdrop({
		edgeFile = ns.SharedMedia:Fetch("border", opt.texture),
		edgeSize = opt.size,
	})
	backdrop:SetBackdropBorderColor(opt.color[1], opt.color[2], opt.color[3], opt.color[4])
	backdrop:SetPoint("TOPLEFT", -opt.inset, opt.inset)
	backdrop:SetPoint("BOTTOMRIGHT", opt.inset, -opt.inset)
	
	bg:SetPoint("TOPLEFT", f, "TOPLEFT", -opt.bg_inset, opt.bg_inset)
	bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", opt.bg_inset, -opt.bg_inset)
	bg:SetColorTexture(opt.background[1], opt.background[2], opt.background[3], opt.background[4])

	local text = f.manabar.text 
	text:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.font), ns.db.profile.fontsize, ns.db.profile.fontflag)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("BOTTOM")
	text:SetShadowColor(ns.db.profile.shadow_color[1],ns.db.profile.shadow_color[2],ns.db.profile.shadow_color[3],ns.db.profile.shadow_color[4])
	text:SetShadowOffset(ns.db.profile.shadow_pos[1],ns.db.profile.shadow_pos[2])
	
	text = f.energybar.text
	text:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.font), ns.db.profile.fontsize, ns.db.profile.fontflag)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("BOTTOM")
	text:SetShadowColor(ns.db.profile.shadow_color[1],ns.db.profile.shadow_color[2],ns.db.profile.shadow_color[3],ns.db.profile.shadow_color[4])
	text:SetShadowOffset(ns.db.profile.shadow_pos[1],ns.db.profile.shadow_pos[2])
	
	text = f.healthbar.text
	text:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.font), ns.db.profile.fontsize, ns.db.profile.fontflag)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("BOTTOM")
	text:SetShadowColor(ns.db.profile.shadow_color[1],ns.db.profile.shadow_color[2],ns.db.profile.shadow_color[3],ns.db.profile.shadow_color[4])
	text:SetShadowOffset(ns.db.profile.shadow_pos[1],ns.db.profile.shadow_pos[2])
	
	f.energybar.glowIndicatorText:SetFont(ns.SharedMedia:Fetch("font", ns.db.profile.font), ns.db.profile.fontsize, ns.db.profile.fontflag)
	f.energybar.glowIndicatorText:SetJustifyH("CENTER")
	f.energybar.glowIndicatorText:SetJustifyV("BOTTOM")
	f.energybar.glowIndicatorText:SetShadowColor(ns.db.profile.shadow_color[1],ns.db.profile.shadow_color[2],ns.db.profile.shadow_color[3],ns.db.profile.shadow_color[4])
	f.energybar.glowIndicatorText:SetShadowOffset(ns.db.profile.shadow_pos[1],ns.db.profile.shadow_pos[2])

	ns:UpdateElementsStyle()
	
	------------------------------------
	-- MANA BAR ------------------------
	------------------------------------
	backdrop 	= f.manabar.backdrop
	bg 			= f.manabar.bg
	
	f.manabar:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.manabar.statusbar))
	f.manabar:SetWidth(ns.db.profile.manabar.width)
	f.manabar:SetHeight(ns.db.profile.manabar.height)
--	f.manabar:SetPoint("CENTER", f, "CENTER", ns.db.profile.manabar.gap_h, ns.db.profile.manabar.gap_v)
	
	ns:Mover(f.manabar, "ManaBar")
	
	backdrop:SetBackdrop({
		edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.manabar.border.texture),
		edgeSize = ns.db.profile.manabar.border.size,
	})
	backdrop:SetBackdropBorderColor(ns.db.profile.manabar.border.color[1], ns.db.profile.manabar.border.color[2], ns.db.profile.manabar.border.color[3], ns.db.profile.manabar.border.color[4])
	backdrop:SetPoint("TOPLEFT", -ns.db.profile.manabar.border.inset, ns.db.profile.manabar.border.inset)
	backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.manabar.border.inset, -ns.db.profile.manabar.border.inset)
	
	f.manabar.bg2:SetTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.manabar.statusbar))
	f.manabar.bg2:SetVertexColor(ns.db.profile.manabar.border.background[1], ns.db.profile.manabar.border.background[2], ns.db.profile.manabar.border.background[3], ns.db.profile.manabar.border.background[4])
	
	bg:SetPoint("TOPLEFT", -ns.db.profile.manabar.border.bg_inset, ns.db.profile.manabar.border.bg_inset)
	bg:SetPoint("BOTTOMRIGHT", ns.db.profile.manabar.border.bg_inset, -ns.db.profile.manabar.border.bg_inset)
	bg:SetColorTexture(ns.db.profile.manabar.border.background[1], ns.db.profile.manabar.border.background[2], ns.db.profile.manabar.border.background[3], ns.db.profile.manabar.border.background[4])
	
	------------------------------------
	-- HEALTH BAR ----------------------
	------------------------------------
	
	backdrop 	= f.healthbar.backdrop
	bg 			= f.healthbar.bg
	
	f.healthbar:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.healthbar.statusbar))
	f.healthbar:SetStatusBarColor(ns.db.profile.healthbar.color[1],ns.db.profile.healthbar.color[2],ns.db.profile.healthbar.color[3],ns.db.profile.healthbar.color[4])
	f.healthbar:SetWidth(ns.db.profile.healthbar.width)
	f.healthbar:SetHeight(ns.db.profile.healthbar.height)
	
	ns:Mover(f.healthbar, "HealthBar")
	
	backdrop:SetBackdrop({
		edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.healthbar.border.texture),
		edgeSize = ns.db.profile.healthbar.border.size,
	})
	backdrop:SetBackdropBorderColor(ns.db.profile.healthbar.border.color[1], ns.db.profile.healthbar.border.color[2], ns.db.profile.healthbar.border.color[3], ns.db.profile.healthbar.border.color[4])
	backdrop:SetPoint("TOPLEFT", -ns.db.profile.healthbar.border.inset, ns.db.profile.healthbar.border.inset)
	backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.healthbar.border.inset, -ns.db.profile.healthbar.border.inset)
	
	f.healthbar.bg2:SetTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.healthbar.statusbar))
	f.healthbar.bg2:SetVertexColor(ns.db.profile.healthbar.border.background[1], ns.db.profile.healthbar.border.background[2], ns.db.profile.healthbar.border.background[3], ns.db.profile.healthbar.border.background[4])
	
	bg:SetPoint("TOPLEFT", -ns.db.profile.healthbar.border.bg_inset, ns.db.profile.healthbar.border.bg_inset)
	bg:SetPoint("BOTTOMRIGHT", ns.db.profile.healthbar.border.bg_inset, -ns.db.profile.healthbar.border.bg_inset)
	bg:SetColorTexture(ns.db.profile.healthbar.border.background[1], ns.db.profile.healthbar.border.background[2], ns.db.profile.healthbar.border.background[3], ns.db.profile.healthbar.border.background[4])
	
	
	------------------------------------
	-- ENERGY BAR -----------------------
	------------------------------------
	
	f.energybar:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.energybar.statusbar))
	f.energybar:SetWidth(ns.db.profile.energybar.width)
	f.energybar:SetHeight(ns.db.profile.energybar.height)

--	f.energybar:SetPoint("CENTER", f, "CENTER", ns.db.profile.energybar.gap_h, ns.db.profile.energybar.gap_v)
	
	ns:Mover(f.energybar, "EnergyBar")
	
	backdrop 	= f.energybar.backdrop
	bg 			= f.energybar.bg
	
	backdrop:SetBackdrop({
		edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.energybar.border.texture),
		edgeSize = ns.db.profile.energybar.border.size,
	})
	backdrop:SetBackdropBorderColor(ns.db.profile.energybar.border.color[1], ns.db.profile.energybar.border.color[2], ns.db.profile.energybar.border.color[3], ns.db.profile.energybar.border.color[4])
	backdrop:SetPoint("TOPLEFT", -ns.db.profile.energybar.border.inset, ns.db.profile.energybar.border.inset)
	backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.energybar.border.inset, -ns.db.profile.energybar.border.inset)
	
	f.energybar.bg2:SetTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.energybar.statusbar))
	f.energybar.bg2:SetVertexColor(ns.db.profile.energybar.border.background[1], ns.db.profile.energybar.border.background[2], ns.db.profile.energybar.border.background[3], ns.db.profile.energybar.border.background[4])
	
	bg:SetPoint("TOPLEFT", -ns.db.profile.energybar.border.bg_inset, ns.db.profile.energybar.border.bg_inset)
	bg:SetPoint("BOTTOMRIGHT", ns.db.profile.energybar.border.bg_inset, -ns.db.profile.energybar.border.bg_inset)
	bg:SetColorTexture(ns.db.profile.energybar.border.background[1], ns.db.profile.energybar.border.background[2], ns.db.profile.energybar.border.background[3], ns.db.profile.energybar.border.background[4])
	
	f.energybar.glowIndicator:SetBackdropBorderColor(ns.db.profile.energybar.glowclearcast[1],ns.db.profile.energybar.glowclearcast[2],ns.db.profile.energybar.glowclearcast[3], 1)
	
	if form == CAT_FORM and ns.db.profile.energybar.show_spell_threshold then
		for i=1, #f.energybar.breakp do
			f.energybar.breakp[i]:Show()
			f.energybar.breakp[i]:Update()
		end
	else
		
		for i=1, #f.energybar.breakp do
			f.energybar.breakp[i]:Hide()
		end
	end
	
	------------------------------------
	-- COMBO POINTS --------------------
	------------------------------------
	opt	= ns.db.profile.combo_points
	
	ns:Mover(f.cp, "CombopointBar")
	
	for i=1, 5 do
		
		local cp = f.cp[i]
		
		local width = ns.db.profile.combo_points.width-(ns.db.profile.combo_points.gap*4)

		f.cp[i]:SetWidth(width/5)
		f.cp[i]:SetHeight(ns.db.profile.combo_points.height)
		
		f.cp:SetSize(ns.db.profile.combo_points.width, ns.db.profile.combo_points.height)
		
		if i== 3 then
			cp:SetPoint("CENTER", f.cp, "CENTER", 0, 0)
		elseif i == 1 then
			cp:SetPoint("RIGHT", f.cp[2], "LEFT", -ns.db.profile.combo_points.gap, 0)
		elseif i == 2 then
			cp:SetPoint("RIGHT", f.cp[3], "LEFT", -ns.db.profile.combo_points.gap, 0)
		elseif i == 4 then
			cp:SetPoint("LEFT", f.cp[3], "RIGHT", ns.db.profile.combo_points.gap, 0)
		elseif i == 5 then
			cp:SetPoint("LEFT", f.cp[4], "RIGHT", ns.db.profile.combo_points.gap, 0)
		end
		
		backdrop 	= cp.backdrop
		bg 			= cp.bg

		cp:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.combo_points.statusbar))
		cp:SetStatusBarColor(ns.db.profile.combo_points.color[i][1],ns.db.profile.combo_points.color[i][2],ns.db.profile.combo_points.color[i][3],ns.db.profile.combo_points.color[i][4])
		
	--	cp.texture:SetTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.combo_points.statusbar))
	--	cp.texture:SetVertexColor(ns.db.profile.combo_points.color[i][1],ns.db.profile.combo_points.color[i][2],ns.db.profile.combo_points.color[i][3],ns.db.profile.combo_points.color[i][4])

		
		backdrop:SetBackdrop({
			edgeFile = ns.SharedMedia:Fetch("border", ns.db.profile.combo_points.border.texture),
			edgeSize = ns.db.profile.combo_points.border.size,
		})
		backdrop:SetBackdropBorderColor(ns.db.profile.combo_points.border.color[1], ns.db.profile.combo_points.border.color[2], ns.db.profile.combo_points.border.color[3], ns.db.profile.combo_points.border.color[4])
		backdrop:SetPoint("TOPLEFT", -ns.db.profile.combo_points.border.inset, ns.db.profile.combo_points.border.inset)
		backdrop:SetPoint("BOTTOMRIGHT", ns.db.profile.combo_points.border.inset, -ns.db.profile.combo_points.border.inset)
		
		cp.bg2:SetTexture(ns.SharedMedia:Fetch("statusbar", ns.db.profile.combo_points.statusbar))
		cp.bg2:SetVertexColor(ns.db.profile.combo_points.border.background[1], ns.db.profile.combo_points.border.background[2], ns.db.profile.combo_points.border.background[3], ns.db.profile.combo_points.border.background[4])
	
		bg:SetPoint("TOPLEFT", -ns.db.profile.combo_points.border.bg_inset, ns.db.profile.combo_points.border.bg_inset)
		bg:SetPoint("BOTTOMRIGHT", ns.db.profile.combo_points.border.bg_inset, -ns.db.profile.combo_points.border.bg_inset)
		bg:SetColorTexture(ns.db.profile.combo_points.border.background[1], ns.db.profile.combo_points.border.background[2], ns.db.profile.combo_points.border.background[3], ns.db.profile.combo_points.border.background[4])
	
	end
	
	-------------------------------
	-- ORDERING -------------------
	-------------------------------
		
	local prev = f
	
	if ns.db.profile.combo_points.show then
		for i=1, 5 do
			f.cp[i]:Show()
		end
	else
		for i=1, 5 do
			f.cp[i]:Hide()
		end	
	end
	
	if ns.db.profile.energybar.show then
		f.energybar:Show()		
	else
		f.energybar:Hide()
	end
	
	if ns.db.profile.manabar.show then
	--	f.manabar:Show()
	else
		f.manabar:Hide()
	end
	
	if ns.db.profile.healthbar.show then
		f.healthbar:Show()
	else
		f.healthbar:Hide()
	end
	
	if ns.db.profile.healthbar.show_text then
		f.healthbar.text:Show()
	else
		f.healthbar.text:Hide()
	end

	if ns.db.profile.energybar.show_text then
		f.energybar.text:Show()
	else
		f.energybar.text:Hide()
	end
		
	if ns.db.profile.manabar.show_text then
		f.manabar.text:Show()
	else
		f.manabar.text:Hide()
	end
	--[[
	if ns.db.profile.energybar.show_spark then
		f.energybar.spark:Show()
	else
		f.energybar.spark:Hide()
	end
	]]
	
	if ns:UpdateMainFrameVisability() then	
		ns:MultitargetFontUpdate()
		
		ns:UNIT_POWER_FREQUENT(_, 'player')
		self:UpdateVisible("target")
	end
end

function ns:UNIT_POWER_FREQUENT(event, unit)
	if unit ~= "player" then return end
	
	local manabar   = self.movingFrame.manabar;
	local energybar = self.movingFrame.energybar; 
	
	manabar:Hide()
	energybar:Hide()

	local form = GetForm()
	
--	print('T', 'UNIT_POWER_FREQUENT', form, ( form == BEAR_FORM  ) )
	
	if form == CAT_FORM and ns.db.profile.energybar.show_spell_threshold then
		for i=1, #self.movingFrame.energybar.breakp do
			self.movingFrame.energybar.breakp[i]:Show()
		end
	else
		for i=1, #self.movingFrame.energybar.breakp do
			self.movingFrame.energybar.breakp[i]:Hide()
		end
	end
	
	local mana = UnitPower("player", 0)
	local maxmana = UnitPowerMax("player", 0)
	
	local energy = UnitPower("player", 3)
	local energyMax = UnitPowerMax('player', 3)
	
	local rage = UnitPower("player", 1)
	
	local combopoints = UnitPower("player", 4)
	
	if combopoints > 0 then
		cp_bycast = combopoints
	end
	
	if mana ~= maxmana and form ~= 0 then
		manabar:SetMinMaxValues(0, maxmana)
		manabar:SetValue(mana)
		manabar.text:SetText(mana)
		if ns.db.profile.manabar.show then
			manabar:Show()
		end
	end
	
	for i=1, combopoints do
		if self.movingFrame.cp[i].ignoreUpdate ~= true then
			self.movingFrame.cp[i]:SetMinMaxValues(0, 10)
			self.movingFrame.cp[i]:SetValue(10)
		end
	end
	for i=combopoints+1, 5 do
		self.movingFrame.cp[i].ignoreUpdate = false
		self.movingFrame.cp[i]:SetMinMaxValues(0, 10)
		self.movingFrame.cp[i]:SetValue(0)
	end

	if form == CAT_FORM then
	
		if CLEAR_CAST_FIND and ns.db.profile.energybar.clearcastbar then
			energybar:SetStatusBarColor(ns.db.profile.energybar.glowclearcast[1],ns.db.profile.energybar.glowclearcast[2],ns.db.profile.energybar.glowclearcast[3], 1)
		else
			energybar:SetStatusBarColor(ns.db.profile.energybar.color.energy[1],  ns.db.profile.energybar.color.energy[2], ns.db.profile.energybar.color.energy[3], 1)
		end
		
		energybar:SetMinMaxValues(0, energyMax)
		energybar:SetValue(energy)
		energybar.text:SetText(energy)
		if ns.db.profile.energybar.show then
			energybar:Show()
		end
		
		if ns.db.profile.energybar.show_spark then
			if energy < energyMax then
				energybar.spark:Show()
			else
				energybar.spark:Hide()
			end
		end
	
		if ns.db.profile.energybar.show_spell_threshold then
			for i=1, #self.movingFrame.energybar.breakp do
				energybar.breakp[i]:Update()
			end
		end
	elseif form == BEAR_FORM then
		energybar:SetStatusBarColor(ns.db.profile.energybar.color.rage[1],  ns.db.profile.energybar.color.rage[2], ns.db.profile.energybar.color.rage[3], 1)
		energybar:SetMinMaxValues(0, 100)
		energybar:SetValue(rage)
		energybar.text:SetText(rage)
		if ns.db.profile.energybar.show then
			energybar:Show()
		end
		
		if ns.db.profile.energybar.show_spark then
			if energy < 100 then
				energybar.spark:Show()
			else
				energybar.spark:Hide()
			end
		end
		
	elseif form == 0 then

		energybar:SetStatusBarColor(ns.db.profile.manabar.color[1], ns.db.profile.manabar.color[2],ns.db.profile.manabar.color[3], 1)
		energybar:SetMinMaxValues(0, maxmana)
		energybar:SetValue(mana)
		energybar.text:SetText(mana)
		if ns.db.profile.energybar.show then
			energybar:Show()
		end
		
		if ns.db.profile.energybar.show_spark then
			if mana < maxmana then
				energybar.spark:Show()
			else
				energybar.spark:Hide()
			end
		end
		
		manabar:Hide()
	end
end

function ns:UPDATE_SHAPESHIFT_FORM()
	
--	local form = GetForm(true)
	
	self.myGUID = UnitGUID("player")
--	print('UPDATE_SHAPESHIFT_FORM', self.myGUID)
	
	self:UNIT_POWER_FREQUENT(event, "player")
	
	ns:UpdateMainFrameVisability()
end

function ns:PLAYER_ENTERING_WORLD()
	self:UPDATE_SHAPESHIFT_FORM()
end

function ns:PLAYER_REGEN_ENABLED()
	local alpha = ns.db.profile.icons.alpha_outof_combat or 0.8
	
	ns:UpdateMainFrameVisability()
	
	if not UnitAffectingCombat("player") then	
		for i=1, #ns.movingFrame.elements do	
			ns.movingFrame.elements[i]:SetAlpha(alpha)	
		end
	end
end
ns.PLAYER_REGEN_DISABLED = ns.PLAYER_REGEN_ENABLED

function ns:UNIT_HEALTH_FREQUENT(event, unit)
	if unit ~= 'player' then return end
	
	local hp = UnitHealth('player')
	local maxhp = UnitHealthMax('player')
	
	ns.movingFrame.healthbar:SetMinMaxValues(0, maxhp)
	ns.movingFrame.healthbar:SetValue(hp)
	ns.movingFrame.healthbar.text:SetText(format('%d%%', hp/maxhp*100))
end

local function ShowHideUI()
	if AleaUI_GUI:IsOpened(AddOn) then
		AleaUI_GUI:Close(AddOn)
	else
		AleaUI_GUI:Open(AddOn)
	end
end

ns:RegisterEvent("PLAYER_LOGIN")

function ns:PLAYER_LOGIN()
	
	self.myClass = select(2, UnitClass("player"))
	self.myGUID = UnitGUID("player")
	
	ns:DefaultOptions()
	self.GUI = ns:OptionsTable()

	self:InitFrames()
	self:UnlockFrames()

	AleaUI_GUI:RegisterMainFrame(AddOn, ns.GUI)
	AleaUI_GUI.SlashCommand(AddOn, "/fdd", ShowHideUI)
	AleaUI_GUI.MinimapButton(AddOn, { OnClick = ShowHideUI, texture = "Interface\\Icons\\ability_druid_catform" }, ns.db.profile.minimap)
	
	self:UpdateMultiDotBorders()
	self:MultitargetFontUpdate()
	self:UpdateCooldownOrders()
	
	self:UpdateAuraWidgets()

	self:InitSwitchTalents()
	self:UNIT_POWER_FREQUENT(_, "player")
	
	self:PLAYER_REGEN_ENABLED()
	self:UPDATE_SHAPESHIFT_FORM()
	self:UpdateBuffCheckStatus()
	self:UpdateBuffCheckOverlay()
	
	self:UpdateRangeIndicator()
	
	ALEAUI_OnProfileEvent("FeralDotDamageDB","PROFILE_CHANGED", function()	
		ns:OnProfileChange()
	end)
	ALEAUI_OnProfileEvent("FeralDotDamageDB","PROFILE_RESET", function()	
		ns:OnProfileChange()
	end)
end

function ns:OnProfileChange()
	
	self:DefaultOptions()
	self.GUI = self:OptionsTable()
	
	self:UnlockFrames()
	
	AleaUI_GUI:RegisterMainFrame(AddOn, self.GUI)

--	self:UpdateFramesStyle()

	self:UpdateMultiDotBorders()
	self:MultitargetFontUpdate()
	self:UpdateCooldownOrders()
	
	self:UpdateAuraWidgets()
	
	self:InitSwitchTalents()
	self:UNIT_POWER_FREQUENT(_, "player")
	
	self:UpdateRangeIndicator()
	
	self:PLAYER_REGEN_ENABLED()
	self:UPDATE_SHAPESHIFT_FORM()
	self:UpdateBuffCheckStatus()
	self:UpdateBuffCheckOverlay()
end

do
	-- Artifact Parser
	local function PrepareForScan()
		local ArtifactFrame = _G.ArtifactFrame
		
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
	--		print('PrepareForScan', 'Success')
			
			_G.UIParent:UnregisterEvent("ARTIFACT_UPDATE")
			if ArtifactFrame then
				ArtifactFrame:UnregisterEvent("ARTIFACT_UPDATE")
			end
		end
	end

	local function RestoreStateAfterScan()
		local ArtifactFrame = _G.ArtifactFrame
			
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			C_ArtifactUI.Clear()
			
	--		print('RestoreStateAfterScan', 'Success')
			
			if ArtifactFrame then
				ArtifactFrame:RegisterEvent("ARTIFACT_UPDATE")
			end
			_G.UIParent:RegisterEvent("ARTIFACT_UPDATE")
		end
	end

	local lastUpdate = -1
	local init = true
	local percs = {}
	
	function ns:ResetArifactPercInfo()
		lastUpdate = -1
	end
	
	function ns:GetAtrifactPercInfo(reqSpellID)

		if not HasArtifactEquipped() then
		
			wipe(percs)
			lastUpdate = -1
			
			return false
		end
		
		if init or lastUpdate < GetTime() then
			lastUpdate = GetTime() + 2
			init = false

			PrepareForScan()
			SocketInventoryItem(INVSLOT_MAINHAND)
			
			local powers = C_ArtifactUI.GetPowers();
			
		--	print('T', powers)
			
			if powers then
				wipe(percs)
				for i, powerID in ipairs(powers) do
				
					local powerInfo = C_ArtifactUI.GetPowerInfo(powerID);
					
					local spellID, cost, currentRank, maxRank, bonusRanks
					
					if powerInfo and type(powerInfo) == 'table' then
						spellID = powerInfo.spellID;
						currentRank = powerInfo.currentRank;
					else
						spellID, cost, currentRank, maxRank, bonusRanks = C_ArtifactUI.GetPowerInfo(powerID);	
					end

					percs[spellID] = currentRank
				end
			end
			
			RestoreStateAfterScan()
		end

		return percs[reqSpellID]
	end
end

do
	local IsSpellKnown = IsSpellKnown
	local GetTalentInfo = GetTalentInfo
	local MAX_TALENT_TIERS = MAX_TALENT_TIERS
	local GetInventoryItemID = GetInventoryItemID
	
	local feraldd_spec = 103
	local guardian_spec = 104
	
	local function IsTalentKnown(spellID)
		for i=1, MAX_TALENT_TIERS do
			for a=1, 3 do
				local talentID, name, texture, selected, availible, spellID_talent = GetTalentInfo(i, a, GetActiveSpecGroup())

				if selected then
					if spellID == spellID_talent then
						return true
					end
				end
			end
		end
		
		return false
	end

	ns.IsTalentKnown = IsTalentKnown

	local itemCheckList = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 18, 17 }
	
	
	local function IsItemEqupped(item)
		
		for i=1, #itemCheckList do
			local itemID = GetInventoryItemID('player', itemCheckList[i])
			
			if itemID == item then
				return true
			end
		end
		
		return false
	end
	
	ns.IsItemEqupped = IsItemEqupped
	
	local initUpdate = true
	function ns:UpdateTalentsAndPercs(event)	
		initUpdate = true
		
		imprived_rake_gained = true --IsSpellKnown(157276)
		moonfire_talent 	 = IsTalentKnown(155580)-- IsSpellKnown(155580)
		savage_roar_talent 	 = IsTalentKnown(52610)
		ns.rakeBonusDamage	 = ns:GetAtrifactPercInfo(210593)
		ns.ashamaneBite		 = ns:GetAtrifactPercInfo(210702) == 1 and true or false
		ns.brutalSlash		 = IsTalentKnown(202028)
		ns.moonkinForm		 = IsTalentKnown(197488)
	
	--	print('T', 'ashamaneBite', ns.ashamaneBite)
	--	print('T', 'rakeBonusDamage', ns.rakeBonusDamage)
		
	--	print('T', 'savage_roar_talent', savage_roar_talent)
	--	print('T', self, event, moonfire_talent, IsTalentKnown(155580))
	--	print('T', IsSpellKnown(52610))
	--	print('T', IsTalentKnown(155672))
	
	--	[vzbuchka_spid] 		= { 3, 18, 18*1.3 , vzbuchka_name,		18*0.3},
		
	--	print('T', (GetSpellInfo(202032)), IsTalentKnown(202032))
		
		if IsTalentKnown(202032) then
			local modValue = is70300 and 0.80 or 0.67
			
			dots_info[glybokayrana_spid] 	= { 3*modValue, 15*modValue, 15*1.3*modValue , 	glybokayrana_name,	15*0.3*modValue} -- tick period, default duration, pandemia duration
			dots_info[razorvat_spid] 		= { 2*modValue, 24*modValue, 24*1.3*modValue   , 	razorvat_name,	24*0.3*modValue}
			dots_info[vzbuchka_spid] 		= { 3*modValue, 15*modValue, 15*1.3*modValue , 	vzbuchka_name,		15*0.3*modValue}
		else		
			dots_info[glybokayrana_spid] 	= { 3, 15, 15*1.3 , 	glybokayrana_name,	15*0.3} -- tick period, default duration, pandemia duration
			dots_info[razorvat_spid] 		= { 2, 24, 24*1.3   , 	razorvat_name,		24*0.3}
			dots_info[vzbuchka_spid] 		= { 3, 15, 15*1.3 , 	vzbuchka_name,	15*0.3}
		end
		
		ns:UpdateOrders()
		ns:UpdateCooldownOrders()
		ns:UpdateBuffCheckStatus()
		ns:UpdateBuffCheckOverlay()
		
		local currentSpec = GetSpecialization()
		local currentSpecID = currentSpec and GetSpecializationInfo(currentSpec)
		
		
		
		ns:RegisterEvent("UNIT_POWER_FREQUENT")
		ns:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		ns:RegisterEvent("UNIT_HEALTH_FREQUENT")
		
		ns.powerWhileGuardianDruid = ns.db.profile.show_for_guardian_spec and currentSpecID == guardian_spec or false
		
	--	print('T', 'powerWhileGuardianDruid', ns.powerWhileGuardianDruid)
		
		local isCatImpForm = ns.db.profile.show_for_non_feral_spec and ( feraldd_spec ~= currentSpecID ) and ( IsTalentKnown(197490) or IsTalentKnown(202157) or IsTalentKnown(202155) ) or false

		if isCatImpForm then
			ns.disable_addon = false
			ns.partial_disable_addon = true
			ns.only_in_cantForm = true

			ns:RegisterEvent("PLAYER_FOCUS_CHANGED")
			ns:RegisterEvent("PLAYER_TARGET_CHANGED")
			ns:RegisterEvent("PLAYER_REGEN_ENABLED")
			ns:RegisterEvent("PLAYER_REGEN_DISABLED")
			ns:RegisterEvent("UNIT_AURA")
			ns:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			ns:RegisterEvent('PLAYER_ENTERING_WORLD')
		
		elseif feraldd_spec ~= currentSpecID then
			ns.disable_addon = true
			ns.only_in_cantForm = false
			ns.partial_disable_addon = false
	
			ns:UnregisterEvent("PLAYER_FOCUS_CHANGED")
			ns:UnregisterEvent("PLAYER_TARGET_CHANGED")
			ns:UnregisterEvent("PLAYER_REGEN_ENABLED")
			ns:UnregisterEvent("PLAYER_REGEN_DISABLED")
			ns:UnregisterEvent("UNIT_AURA")
			ns:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			ns:UnregisterEvent('PLAYER_ENTERING_WORLD')
		else
			ns.disable_addon = false
			ns.only_in_cantForm = false
			ns.partial_disable_addon = false
	
			ns:RegisterEvent("PLAYER_FOCUS_CHANGED")
			ns:RegisterEvent("PLAYER_TARGET_CHANGED")
			ns:RegisterEvent("PLAYER_REGEN_ENABLED")
			ns:RegisterEvent("PLAYER_REGEN_DISABLED")
			ns:RegisterEvent("UNIT_AURA")
			ns:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			ns:RegisterEvent('PLAYER_ENTERING_WORLD')
		end
		
		ns:UNIT_HEALTH_FREQUENT(nil, 'player')
		ns:PLAYER_REGEN_ENABLED()
		ns:UpdateFramesStyle()
	end
	local function CTimer_AfterUpdate()
		ns:UpdateTalentsAndPercs()
	end
	
	local eventframe = CreateFrame("Frame")
	eventframe:SetScript("OnEvent", function(self, event, unit)
		--[==[
		if event == "ARTIFACT_UPDATE" or event == "UNIT_INVENTORY_CHANGED" then
			ns:ResetArifactPercInfo()
		end

		if event == 'INSPECT_READY' then
			if unit == UnitGUID('player') then
				ns.UpdateTalentsAndPercs(self, event)
			end
		else		
			C_Timer.After(0.1, function() ns:UpdateTalentsAndPercs() end)
		end
		]==]
		
		if event == 'ARTIFACT_UPDATE' then
			if not unit then
				if initUpdate then
					initUpdate = false
					C_Timer.After(0.5, CTimer_AfterUpdate)
				end
			end
		else
			if initUpdate then
				initUpdate = false
				C_Timer.After(0.5, CTimer_AfterUpdate)
			end
		end
	end)
	
	
	function ns:InitSwitchTalents()
		eventframe:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		eventframe:RegisterEvent("PLAYER_TALENT_UPDATE")
		eventframe:RegisterEvent("PLAYER_LEVEL_UP")
		eventframe:RegisterEvent("PLAYER_LOGIN")
	--	eventframe:RegisterEvent("INSPECT_READY")
	--	eventframe:RegisterEvent("ARTIFACT_XP_UPDATE")
	--	eventframe:RegisterEvent("ARTIFACT_UPDATE")
		eventframe:RegisterEvent("ARTIFACT_CLOSE")
		eventframe:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", 'player')


		if initUpdate then
			initUpdate = false
			C_Timer.After(0.5, CTimer_AfterUpdate)
		end
	end
end

do

	local table_concat = table.concat
	
	local lastTimeCheck = 0
	local header = '|cFFFFFF00'..AddOn..' '..L['Проверка баффов']..':|r'
	
	local buffList = {
		['110'] = {
			flask = 188033,
			food = 188534,
			rune = 224001,
			runeItem = 0,
		},
		['100'] = {
			flask = 156064,
			food = 188534,
			rune = 175456,
			runeItem = 118630,		
		},
	
	}

	local function GetBuff(typo)			
		local dir = ( UnitLevel('player') == 110 ) and '110' or '100'
		
		return ( GetSpellInfo(buffList[dir][typo]) )
	end
	
	local function GetBuffLink(typo)
		local dir = ( UnitLevel('player') == 110 ) and '110' or '100'
		
		local link
		
		if typo == 'rune' then
			local name, linkItem = GetItemInfo(buffList[dir]['runeItem'])
			
			link = linkItem or GetSpellLink(buffList[dir][typo])
		else
			link = GetSpellLink(buffList[dir][typo])
		end
		
		return link
	end
	
	local function GetBuffTexture(typo)
		local dir = ( UnitLevel('player') == 110 ) and '110' or '100'
		
		return ( GetSpellTexture(buffList[dir][typo]) )
	end
	
	local function GetAuraIcon()
	
		local f = CreateFrame('Frame')
		f:SetSize(26, 26)
		f.icon = f:CreateTexture()
		f.icon:SetDrawLayer('ARTWORK', 1)
		f.icon:SetAllPoints()
		f.icon:SetTexture(GetSpellTexture(aginFlask_id))
		f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)	
		
		f.cooldown = CreateFrame('Cooldown', nil, f, "CooldownFrameTemplate")
		f.cooldown:SetAllPoints()
		f.cooldown:SetDrawEdge(true)
		f.cooldown:SetSwipeColor(0, 0, 0, 0.6)	
		f.cooldown:SetBlingTexture("")	
		
		f.text = f:CreateFontString()
		f.text:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
		f.text:SetPoint('LEFT', f, 'RIGHT', 2, 0)
		f.text:SetTextColor(1, 1, 1)
		f.text:Hide()
		
		return f
	end
	
	local buffFrame = CreateFrame('Frame', nil, UIParent)
	buffFrame:SetSize(110, 133)
	buffFrame:SetPoint('LEFT', UIParent, 'LEFT', 300, 0)
	
	buffFrame:Hide()
	--[[
	buffFrame.bg = buffFrame:CreateTexture()
	buffFrame.bg:SetAllPoints()
	buffFrame.bg:SetTexture(0, 0, 0, 0.5)
	]]
	buffFrame.flask = GetAuraIcon()
	buffFrame.flask:SetParent(buffFrame)
	buffFrame.flask.icon:SetTexture(GetBuffTexture('flask'))
	
	buffFrame.rune = GetAuraIcon()
	buffFrame.rune:SetParent(buffFrame)
	buffFrame.rune.icon:SetTexture(GetBuffTexture('rune'))
	
	buffFrame.food = GetAuraIcon()
	buffFrame.food:SetParent(buffFrame)
	buffFrame.food.icon:SetTexture(GetBuffTexture('food'))

	local setDesaturated = false
	
	
	buffFrame.Handler = function(self, event)
		
		if not IsInRaid() and not IsInGroup() then 
			self:Hide()
			return 
		end
		if not InCombatLockdown() then 
		--	self:Hide()
		--	return 
		end
		
		local show = false
		
		if ns.disable_addon then return end

		local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('flask'))			
		if name and ns.db.profile.others.flashCheck then
			self.flask.cooldown:SetCooldown(expires-duration, duration)
			self.flask.icon:SetDesaturated(false)
			if expires - GetTime() < 60*10 then

				self.flask:Show() 
				FeralDotDamage.ShowOverlayGlow(self.flask)	

				if show == false then show = true end
			else
				self.flask:Hide() 
				FeralDotDamage.HideOverlayGlow(self.flask)
			end
		else
			self.flask:Show() 
			FeralDotDamage.ShowOverlayGlow(self.flask)

			self.flask.icon:SetDesaturated(setDesaturated)
			self.flask.cooldown:SetCooldown(0, 0)
			self.flask.cooldown:Clear()
			if show == false then show = true end
		end
		
		self.flask.icon:SetTexture(GetBuffTexture('flask'))
		
		local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('rune'))			
		if name and ns.db.profile.others.runeCheck then
			self.rune.cooldown:SetCooldown(expires-duration, duration)
			self.rune.icon:SetDesaturated(false)
			if expires - GetTime() < 60*10 then
				self.rune:Show() 
				FeralDotDamage.ShowOverlayGlow(self.rune)

				if show == false then show = true end
			else
				self.rune:Hide()
				FeralDotDamage.HideOverlayGlow(self.rune)
			end
		else
			self.rune.icon:SetDesaturated(setDesaturated)
			self.rune.cooldown:SetCooldown(0, 0)
			self.rune.cooldown:Clear()
			self.rune:Show() 
			FeralDotDamage.ShowOverlayGlow(self.rune)
			
			if show == false then show = true end
		end

		self.rune.icon:SetTexture(GetBuffTexture('rune'))
		
		local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('food'))			
		if name and ns.db.profile.others.foodCheck then
			self.food.cooldown:SetCooldown(expires-duration, duration)
			self.food.icon:SetDesaturated(false)
			if expires - GetTime() < 60*10 then

				self.food:Show()
				FeralDotDamage.ShowOverlayGlow(self.food)
				
				
				if show == false then show = true end
			else
				FeralDotDamage.HideOverlayGlow(self.food)
				self.food:Hide()
			end
		else
			self.food.icon:SetDesaturated(setDesaturated)
			self.food.cooldown:SetCooldown(0, 0)
			self.food.cooldown:Clear()
			self.food:Show()
			FeralDotDamage.ShowOverlayGlow(self.food)
			
			if show == false then show = true end
		end
		
		self.food.icon:SetTexture(GetBuffTexture('food'))
		
		if show then
			self:Show()
		else
			self:Hide()
		end
		
	end
	
	buffFrame:SetScript('OnEvent', buffFrame.Handler)
	
	
	local function CheckBuffs()
		local msg1 = nil
		local msg2 = nil
		local msg3 = nil

		if ns.disable_addon then return end
		if ns.partial_disable_addon then return end
		
		if ns.db.profile.others.flashCheck then
			
			local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('flask'))
			
			if name then
				if expires - GetTime() < 60*10 then
					msg1 = L['Скоро закончится!']
				end
			else			
				msg1 = L['Отутствует']
			end
			
		end
		
		if ns.db.profile.others.runeCheck then
			
			local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('rune'))
			
			if name then
				if expires - GetTime() < 60*10 then
					msg2 = L['Скоро закончится!']
				end
			else			
				msg2 = L['Отутствует']
			end
			
		end
		
		if ns.db.profile.others.foodCheck then
			
			local name, rank, icon, count, dispelType, duration, expires = UnitBuff('player', GetBuff('food'))
			
			if name then
				if expires - GetTime() < 60*10 then
					msg3 = L['Скоро закончится!']
				end
			else			
				msg3 = L['Отутствует']
			end
			
		end

		if msg1 or msg2 or msg3 or ( msg4 and msg4:len() > 0 ) then
			DEFAULT_CHAT_FRAME:AddMessage('------------')
			DEFAULT_CHAT_FRAME:AddMessage(header)
			
			if  ( GetTime() > lastTimeCheck ) then
				lastTimeCheck = GetTime() + 20		
				local willplay, handler = PlaySoundFile(ns.SharedMedia:Fetch("sound", ns.db.profile.others.checkBuffsSoundFile), "MASTER")	
			end
		
		end
	
		if msg1 then			
			DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFF00'..GetBuffLink('flask')..'|r|cFFFF0000: '..msg1)
		end
		if msg2 then	
			DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFF00'.. GetBuffLink('rune')..'|r|cFFFF0000: '..msg2)
		end
		if msg3 then
			DEFAULT_CHAT_FRAME:AddMessage('|cFFFFFF00'..L['Еда']..'|r|cFFFF0000: '..msg3)
		end

		if msg1 or msg2 or msg3 then		
			DEFAULT_CHAT_FRAME:AddMessage('------------')
		end
	end
	
	local eventframe = CreateFrame("Frame")
	eventframe:SetScript("OnEvent", CheckBuffs)
	
	
	function ns:UpdateBuffCheckOverlay()
		
			
		ns:Mover(buffFrame, "BuffCheckFrames")
		
		local icon2size = ns.db.profile.others.overlay_minorIconSize or 18
		local iconsize = ns.db.profile.others.overlay_mainIconSize or 26
		
	--	print('T', 'UpdateBuffCheckOverlay')
		
		if ns.db.profile.others.horizontal_overlay then
			
			buffFrame:SetSize(110, 133)
			
			buffFrame.flask:ClearAllPoints()
			buffFrame.flask:SetSize(iconsize, iconsize)
			buffFrame.flask:SetPoint('TOP', buffFrame, 'TOP', 0, 0)
			if buffFrame.flask:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.flask)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.flask)
			end
			buffFrame.rune:ClearAllPoints()
			buffFrame.rune:SetSize(iconsize, iconsize)
			buffFrame.rune:SetPoint('LEFT', buffFrame.flask, 'RIGHT', 5, 0)
			if buffFrame.rune:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.rune)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.rune)
			end
			
			buffFrame.food:ClearAllPoints()
			buffFrame.food:SetSize(iconsize, iconsize)
			buffFrame.food:SetPoint('RIGHT', buffFrame.flask, 'LEFT', -5, 0)
			if buffFrame.food:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.food)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.food)
			end
			
		else
		
			buffFrame:SetSize(110, 133)
			
			buffFrame.flask:ClearAllPoints()
			buffFrame.flask:SetSize(iconsize, iconsize)
			buffFrame.flask:SetPoint('LEFT', buffFrame, 'LEFT', 0, 0)		
			if buffFrame.flask:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.flask)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.flask)
			end
			
			buffFrame.rune:ClearAllPoints()
			buffFrame.rune:SetSize(iconsize, iconsize)
			buffFrame.rune:SetPoint('TOP', buffFrame.flask, 'BOTTOM', 0, -5)
			if buffFrame.rune:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.rune)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.rune)
			end
			
			buffFrame.food:ClearAllPoints()
			buffFrame.food:SetSize(iconsize, iconsize)
			buffFrame.food:SetPoint('BOTTOM', buffFrame.flask, 'TOP', 0, 5)
			if buffFrame.food:IsShown() then
				FeralDotDamage.ShowOverlayGlow(buffFrame.food)
			else
				FeralDotDamage.HideOverlayGlow(buffFrame.food)
			end

		end
		
		if ns.db.profile.others.overlay then
			buffFrame:RegisterUnitEvent('UNIT_AURA', 'player')
		
			local events = ns.db.profile.others.checkOnEvent or 5
		
			if events == 5 or events == 3 then	
				buffFrame:RegisterEvent('ENCOUNTER_START')
			end
			if events == 1 or events == 4 or events == 5 then
				buffFrame:RegisterEvent('READY_CHECK')
			end
			if events == 2 or events == 4 then
				buffFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
			end
			
		else
			buffFrame:UnregisterAllEvents()
			buffFrame:Hide()
		end
	end
	
	
	function ns:UpdateBuffCheckStatus()
		eventframe:UnregisterAllEvents()

		if(not ns.db.profile.others.flashCheck and 
		   not ns.db.profile.others.runeCheck and
		   not ns.db.profile.others.foodCheck ) or not ns.db.profile.others.buffCheck then
		   
		   return
		end
		   
		local events = ns.db.profile.others.checkOnEvent or 5
		
		if events == 5 or events == 3 then	
			eventframe:RegisterEvent('ENCOUNTER_START')
		end
		if events == 1 or events == 4 or events == 5 then
			eventframe:RegisterEvent('READY_CHECK')
		end
		if events == 2 or events == 4 then
			eventframe:RegisterEvent('PLAYER_REGEN_DISABLED')
		end
		
		
	end
end

do

	local movers = {}
	
	local buttons_name = { "◄", "▲", "▼", "►" }
	local buttons_move = { { -1, 0 } , { 0, 1 }, { 0, -1} , { 1, 0} }

	local function round(num)
		return floor(num+0.5)
	end
	
	local format = string.format
	local split = string.split

	local defaultposition = format('%s\031%s\031%s\031%d\031%d', "CENTER", "UIParent", "CENTER", 0, 0)
	
	local function GetPoint(obj)
		local point, anchor, secondaryPoint, x, y = obj:GetPoint()
		if not anchor then anchor = UIParent end

		return format('%s\031%s\031%s\031%d\031%d', point, anchor:GetName(), secondaryPoint, round(x), round(y))
	end

	
	local function SetFrameOptsCustom(name, point, anchor, secondaryPoint, x, y)
		if not ns.db.profile.Frames then ns.db.profile.Frames = {} end
		if not ns.db.profile.Frames[name] then ns.db.profile.Frames[name] = {} end
		if not ns.db.profile.Frames[name].point then ns.db.profile.Frames[name].point = defaultposition end	
		if not anchor then anchor = UIParent end
		
		ns.db.profile.Frames[name].point = format('%s\031%s\031%s\031%d\031%d', point, anchor.GetName and anchor:GetName() or anchor, secondaryPoint, round(x), round(y))
	end
	
	
	ns.SetFrameOptsCustom = SetFrameOptsCustom
	
	local function GetFrameOpts(name)
		
		if not ns.db.profile.Frames then ns.db.profile.Frames = {} end
		if not ns.db.profile.Frames[name] then ns.db.profile.Frames[name] = {} end
		if not ns.db.profile.Frames[name].point then ns.db.profile.Frames[name].point = defaultposition end
		
		local point, anchor, secondaryPoint, x, y = split('\031', ns.db.profile.Frames[name].point)
		
		local aachor = _G[anchor] or UIParent
		
		return point, aachor, secondaryPoint, x, y
	end
	
	local function SetFrameOpts(name, obj)
		if not ns.db.profile.Frames then ns.db.profile.Frames = {} end
		if not ns.db.profile.Frames[name] then ns.db.profile.Frames[name] = {} end
		if not ns.db.profile.Frames[name].point then ns.db.profile.Frames[name].point = defaultposition end
		ns.db.profile.Frames[name].point = GetPoint(obj)
	end

	
	local function createbutton(parent, name)
		if not parent.buttons then parent.buttons = {} end
		
		local f = CreateFrame("Button", nil , parent)
		f:SetFrameLevel(parent:GetFrameLevel() + 1)
		f.parent = parent
		f:SetText(name)
		f:SetWidth(20) --ширина
		f:SetHeight(20) --высота
		f:SetNormalFontObject("GameFontNormalSmall")
		f:SetHighlightFontObject("GameFontHighlightSmall")
		f:SetFrameStrata("HIGH")
		f:SetBackdrop({
				bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeSize = 1,
				insets = {top = 0, left = 0, bottom = 0, right = 0},
					})
		f:SetBackdropColor(0,0,0,1)
		f:SetBackdropBorderColor(.3,.3,.3,1)
		
		f:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(1,1,1,1) --цвет краев
			end)
			f:SetScript("OnLeave", function(self)
				self:SetBackdropBorderColor(.3,.3,.3,1) --цвет краев
			end)
			
		local t = f:GetFontString()
		t:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
		t:SetJustifyH("CENTER")
		t:SetJustifyV("CENTER")
		f.text = t
		
		f:SetScript("OnClick", function(self)
					
			if self.owner.opt then
				local point, anchor, secondaryPoint, x, y = GetFrameOpts(self.owner.opt)		
				SetFrameOptsCustom(self.owner.opt, point, anchor, secondaryPoint, x + buttons_move[self.i][1], y + buttons_move[self.i][2])
				self.owner.frame:ClearAllPoints()
				self.owner.frame:SetPoint(GetFrameOpts(self.owner.opt))	
			end
			
			for k,v in pairs(self.owner.editboxes) do
				v:UpdateText()					
			end
		end)
				
		return f
	end

	
	local function createeditboxe(parent)
		if not parent.editboxes then parent.editboxes = {} end
		local textbox = CreateFrame("EditBox", nil, parent)
		textbox:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
		textbox:SetFrameLevel(parent:GetFrameLevel() + 1)
		textbox:SetAutoFocus(false)
		textbox:SetWidth(50)
		textbox:SetHeight(20)
		textbox:SetJustifyH("LEFT")
		textbox:SetJustifyV("CENTER")
		textbox:SetFrameStrata("HIGH")
		textbox:SetBackdrop({
				bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeSize = 1,
				insets = {top = 0, left = 0, bottom = 0, right = 0},
					})
		textbox:SetBackdropColor(0,0,0,1)
		textbox:SetBackdropBorderColor(1,1,1,0.5)
		
		textbox.ok = createbutton(textbox, "OK")
		textbox.ok.editbox = textbox
		textbox.ok.text:SetFont("Fonts\\ARIALN.TTF", 10, "OUTLINE")
		textbox.ok:SetSize(15,15)
		textbox.ok:SetPoint("RIGHT", textbox, "RIGHT", -2, 0)
		textbox.ok:Hide()
		
		textbox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)
		textbox:SetScript("OnEnterPressed", function(self)
			self.ChangePosition(self.ok)
		end)
		
		textbox:SetScript("OnShow", function(self) self:UpdateText() end)
		
		textbox.ChangePosition = function(self)
			local num = tonumber(self.editbox:GetText())				
			if num then
				if self.editbox.owner.opt then
					
					
					local point, anchor, secondaryPoint, x, y = GetFrameOpts(self.editbox.owner.opt)	

					if self.editbox.i == 1 then
						x = num
					else
						y = num
					end
		
					SetFrameOptsCustom(self.editbox.owner.opt, point, anchor, secondaryPoint, x, y)
					
					self.editbox.owner.frame:ClearAllPoints()
					self.editbox.owner.frame:SetPoint(GetFrameOpts(self.editbox.owner.opt))

				end
			else
				self.editbox:UpdateText()
			end
			self:SetScript("OnClick", nil)
			self:Hide()
			
			self.editbox:ClearFocus()
		end
		
		textbox.UpdateText = function(self)
			if self.owner.opt then
				local point, anchor, secondaryPoint, x, y = GetFrameOpts(self.owner.opt)	
				
				if self.i == 1 then						
					self:SetText(x)
				else
					self:SetText(y)
				end
				
			end
		end
				
				
		return textbox
	end
	
	local mover_buttons = CreateFrame("Frame", nil, UIParent)
	mover_buttons:SetPoint("CENTER")
	mover_buttons:EnableMouse(true)
	mover_buttons:SetClampedToScreen(true)
	mover_buttons:SetSize(150,50)
	mover_buttons.buttons = {}
	mover_buttons.editboxes = {}
	mover_buttons:Hide()
	mover_buttons:SetFrameStrata("HIGH")
	
	for i=1,4 do				
		mover_buttons.buttons[i] = createbutton(mover_buttons, buttons_name[i])
		mover_buttons.buttons[i].i = i
		mover_buttons.buttons[i].owner = mover_buttons
			
		if i == 1 then
			mover_buttons.buttons[i]:SetPoint("TOPRIGHT", mover_buttons, "TOP", 0, -3)
		elseif i == 2 then
			mover_buttons.buttons[i]:SetPoint("TOPRIGHT", mover_buttons, "TOP", -21, -3)
		elseif i == 3 then
			mover_buttons.buttons[i]:SetPoint("TOPLEFT", mover_buttons, "TOP", 0, -3)
		elseif i == 4 then
			mover_buttons.buttons[i]:SetPoint("TOPLEFT", mover_buttons, "TOP", 21, -3)
		end				
	end
	for i=1,2 do				
		mover_buttons.editboxes[i] = createeditboxe(mover_buttons)
		mover_buttons.editboxes[i].i = i
		mover_buttons.editboxes[i].owner = mover_buttons
		
		if i == 1 then
			mover_buttons.editboxes[i]:SetPoint("TOPRIGHT", mover_buttons, "TOP", -1, -30)
		else
			mover_buttons.editboxes[i]:SetPoint("TOPLEFT", mover_buttons, "TOP", 1, -30)
		end
		
		mover_buttons.editboxes[i]:SetScript("OnTextChanged", function(self, user)
			if user then
				self.ok:Show()
				
				self.ok:SetScript("OnClick", self.ChangePosition)
			end
		end)
		
		mover_buttons.editboxes[i]:UpdateText()
	end
	
	local function SetMoverButtons(self)

		if not mover_buttons:IsMouseOver() then
			mover_buttons.mover = self
			mover_buttons.frame = self.parent
			mover_buttons.opt = self.opt
			
			mover_buttons:ClearAllPoints()
			mover_buttons:SetParent(self)
			mover_buttons:SetPoint("TOP", self, "BOTTOM")
			mover_buttons:Show()
			
			for k,v in pairs(mover_buttons.editboxes) do
				v:UpdateText()					
			end
		end
	end

	local function MoverOnUpdate(self)
		local x, y = self.parent:GetCenter()
		local ux, uy = UIParent:GetCenter()
		local screenWidth, screenHeight = UIParent:GetRight(),UIParent:GetTop()
		
		
		local LEFT = screenWidth / 4
		local TOP = screenHeight / 4
		
		local xpos, ypos = 0, 0
		local point1, point2 =  "CENTER", ""
		local point3, point4 =  "CENTER", ""
	
		--[[
						|
						|
						|
						|
						|
						|
		  ----------------------------- OX
						|
						|
						|
						|
						|
						OY
		
		]]
	--	print("T1", LEFT, TOP)
		
		local rX, rY = round(x-ux), round(y-uy)
		
	--	print("T2", "rX", rX, "rY", rY)
	
		if rX < -LEFT then
			point1, point3 = "LEFT", "LEFT"			
		elseif rX > LEFT then
			point1, point3 = "RIGHT", "RIGHT"			
		end
		
		if rY < -TOP then
			point2, point4 = "BOTTOM", "BOTTOM"
			
			if point1 == "CENTER" then point1 = '' end
			if point3 == "CENTER" then point3 = '' end
			
		elseif rY > TOP then
			point2, point4 = "TOP", "TOP"
			
			if point1 == "CENTER" then point1 = '' end
			if point3 == "CENTER" then point3 = '' end
			
		end
		
		if point1 == "CENTER" then
			xpos, ypos = rX, rY
		else
			
			if point1 == "LEFT" then
				xpos = self.parent:GetLeft() - UIParent:GetLeft()
			elseif point1 == "RIGHT" then
				xpos = self.parent:GetRight() - UIParent:GetRight()
			else
				xpos = rX
			end
			
			if point2 == "TOP" then
				ypos = self.parent:GetTop() - UIParent:GetTop()
			elseif point2 == "BOTTOM" then
				ypos = self.parent:GetBottom() - UIParent:GetBottom()
			else
				ypos = rY
			end
		end
		
	--	print(point2..point1, engine.ParentFrame, point4..point3, xpos, ypos)
		
		SetFrameOptsCustom(self.opt,  point2..point1, UIParent, point4..point3, xpos, ypos)	
	end
	
	
	function ns:Mover(frame, opt, width, height, point)
	
		frame:ClearAllPoints()
		frame:SetPoint(GetFrameOpts(opt))
		
		if movers[frame] then 
			movers[frame].opt = opt
			movers[frame].parent = frame
			movers[frame].t:SetText(opt)
			
			local _width, _height = frame:GetSize()
			
			if width or height or point then		
				movers[frame]:SetPoint(point or "TOPLEFT", frame,0,0)
				movers[frame]:SetSize(width or _width, height or _height)			
			else	
				movers[frame]:SetPoint("TOPLEFT", frame, "TOPLEFT",0,0)
				movers[frame]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",0,0)		
			end

			return 
		end

		local _width, _height = frame:GetSize()
		
		local mover = CreateFrame("Frame", nil, UIParent)
		mover.opt = opt
		mover.parent = frame
		mover:SetSize(10,10)
		mover:SetFrameStrata("HIGH")
		mover:SetFrameLevel(frame:GetFrameLevel()+1)
		mover.buttons = {}
	
		if width or height or point then		
			mover:SetPoint(point or "TOPLEFT", frame,0,0)
			mover:SetSize(width or _width, height or _height)			
		else	
			mover:SetPoint("TOPLEFT", frame, "TOPLEFT",0,0)
			mover:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",0,0)		
		end
		
		mover.t = mover:CreateFontString(nil, "OVERLAY", "GameFontNormal");

		mover.t:SetPoint("CENTER", mover, "CENTER", 0, 0)	
		mover.t:SetTextColor(1,1,1)
		mover.t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
		mover.t:SetAlpha(1)
		mover.t:SetJustifyH("LEFT")
		mover.t:SetText(opt)
		
		mover:SetClampedToScreen(true)
		mover:EnableMouse(true)
		mover:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground",})	
		mover:SetBackdropColor(0, 0, 0, 0.7)
		mover:SetMovable(false)
		mover:RegisterForDrag("LeftButton")
		mover:Hide()
		mover:SetScript("OnDragStart", function(self) 
			self.parent:StartMoving(); 		
			self:SetScript("OnUpdate", MoverOnUpdate)
		end)
		mover:SetScript("OnDragStop", function(self) 
			self.parent:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)

			for k,v in pairs(mover_buttons.editboxes) do
				v:UpdateText()					
			end
		end)
		
		mover:SetScript("OnEnter", SetMoverButtons)
		
		movers[frame] = mover
		
		return movers[frame]
	end
	
	
	SlashCmdList["FERALDOTDAMAGEMOVEFRAMES"] = function()
		
		for k,v in pairs(movers) do
			
			if v and v:IsShown() then
				v:Hide()
				v.parent:SetMovable(false)
			else
				v:Show()
				v.parent:SetMovable(true)
			end
		end
	end
	
	function ns:UnlockAllMovers()	
		for k,v in pairs(movers) do
			
			if v and v:IsShown() then
				v:Hide()
				v.parent:SetMovable(false)
			else
				v:Show()
				v.parent:SetMovable(true)
			end
		end
	end
	
	function ns:UnlockMover(opt)
		
		for k,v in pairs(movers) do		
			if v.opt == opt then
				if v and v:IsShown() then
					v:Hide()
					v.parent:SetMovable(false)
				else
					v:Show()
					v.parent:SetMovable(true)
				end
				break
			end
		end
	end
	
	SLASH_FERALDOTDAMAGEMOVEFRAMES1 = "/fddmovers"

end

--------автоинвайт-------------------------------

do
	local keyword = { ["инв"] = true, ["inv"] = true, }
	local InviteUnit = InviteUnit
	local GetNumGuildMembers = GetNumGuildMembers
	local GetGuildRosterInfo = GetGuildRosterInfo
	local BNInviteFriend = BNInviteFriend
	local BNSendWhisper = BNSendWhisper
	local GetNumGroupMembers = GetNumGroupMembers
	local UnitFactionGroup = UnitFactionGroup
	local strsplit = strsplit
	
	local Custom_BNGetToonInfo = BNGetToonInfo or BNGetGameAccountInfo
	
	
	local function ConvertToRaidOrNot()		
		if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then return end
		
		
		if GetNumGroupMembers() > 4 then
			ConvertToRaid()
		else
			ConvertToParty()
		end
		
	--	print("T4", "ConvertToRaidOrNot", IsInRaid(), IsInGroup(), GetNumGroupMembers())
	end

	local trottleInviteUnit = {}
	
	local function StripServer(nameserver)	
		local name, server = strsplit("-", nameserver)		
		local player, plserver = UnitFullName("player")		
		
	--	print("T", server, plserver, nameserver)
		
		if plserver == server then
			return name
		end
		return nameserver
	end
	
	local function InviteTrottle(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		
		if self.elapsed < 0.3 then return end
			self.elapsed = 0

		local i2 = 0
		
		for name, invtype in pairs(trottleInviteUnit) do
			if invtype == "normal" then			
				InviteUnit(name)
				trottleInviteUnit[name] = false
				
			--	print("Invite unit by normal")
				
				ConvertToRaidOrNot()	

				i2 = i2 + 1
				
				break; 
			elseif invtype == "btnet" then
				BNInviteFriend(name)
				trottleInviteUnit[name] = false
				
			--	print("Invite unit by brnet")		
				
				ConvertToRaidOrNot()
				
				i2 = i2 + 1
				
				break;
			end
		end
		
		if i2 == 0 then 
			self:Hide() 
			
		--	print("Stop trottle")
		end
	end
	
	local trottle =  CreateFrame("Frame")
	trottle.elapsed = 0
	trottle:SetScript("OnUpdate", InviteTrottle)
	
	local function AddToInvite(name, invtype)	
		if invtype == "normal" then	
			trottleInviteUnit[StripServer(name)] = invtype
		else
			trottleInviteUnit[name] = invtype
		end
		
	--	print("T2", trottle:IsShown(), name, invtype)
		
		if not trottle:IsShown() then
			trottle.elapsed = 0
			trottle:Show()
		end
	end
	
	local function NotInRaid(name)
		
		if UnitInRaid(StripServer(name)) then return false end
		if UnitInParty(StripServer(name)) then return false end
	
		return true
	end
	
	
	function ns:InviteWhisper(event, msg, author, ...)
	
		if not ns.db.profile.others.AutoInv then return end

		if keyword[msg] and NotInRaid(author) then
			if ns.db.profile.others.AutoInvGuildOnly then
				for i = 1, GetNumGuildMembers() do
					local name = GetGuildRosterInfo(i)
					if name == author then						
				
						if GetNumGroupMembers() == 40 then
							SendChatMessage("Я не могу Вас пригласить так как рейд полон", "WHISPER", nil, author)
						else						
							AddToInvite(author, "normal")
						end
						break
					end
				end
			else
				if GetNumGroupMembers() == 40 then					
					SendChatMessage("Я не могу Вас пригласить так как рейд полон", "WHISPER", nil, author)
				else
					AddToInvite(author, "normal")
				end
			end
		end
	end

	function ns:BNInviteWhisper(event, msg, author, ...)
		local arg9 = select(9, ...)	
		local arg10 = select(11, ...)
	
		if not ns.db then return end
		if not ns.db.profile.others.AutoInv then return end
		--BNInviteFriend(286)
		
		local _, toonName, client, realmName, realmID, faction, _, _, _, _, level,_,_,_, _, _ = Custom_BNGetToonInfo(arg10)

		if keyword[msg] and NotInRaid(toonName) and client == BNET_CLIENT_WOW then
			if ns.db.profile.others.AutoInvGuildOnly then
				
				local toonName2 = format("%s-%s", toonName, gsub(realmName," ", ''))
				
				for i = 1, GetNumGuildMembers() do
					local name = GetGuildRosterInfo(i)
					
					if name == toonName2 then
						if GetNumGroupMembers() == 40 then
							BNSendWhisper(arg10, "Я не могу Вас пригласить так как рейд полон")
						else
							AddToInvite(arg10, "btnet")
						end
						break
					end
				end
			else
				if client == BNET_CLIENT_WOW then
					if faction == UnitFactionGroup("player") then
						if GetNumGroupMembers() == 40 then
							BNSendWhisper(arg10, "Я не могу Вас пригласить так как рейд полон")
						else
							AddToInvite(arg10, "btnet")
						end
					else
						BNSendWhisper(arg10, "Я не могу Вас пригласить так как вы принадлежите к другой фракции")
					end
				else
					-- "Нет клиента вов"
					--	BNSendWhisper(arg10, "Вы должны иметь")
				end
			end
		end
	end
	
	local events = CreateFrame("Frame")	
	events:RegisterEvent("CHAT_MSG_WHISPER")
	events:RegisterEvent("CHAT_MSG_BN_WHISPER")
	events:SetScript("OnEvent", function(self, event, ...)	
		if event == "CHAT_MSG_BN_WHISPER" then
			ns:BNInviteWhisper(event, ...)
		elseif event == "CHAT_MSG_WHISPER" then
			ns:InviteWhisper(event, ...)
		end
	end)
end

do
	-- Copy from LibButtonGlow-1.0
	
	local unusedOverlays = {}
	local numOverlays = 0

	local tinsert, tremove, tostring = table.insert, table.remove, tostring

	local function OverlayGlowAnimOutFinished(animGroup)
		local overlay = animGroup:GetParent()
		local frame = overlay:GetParent()
		overlay:Hide()
		tinsert(unusedOverlays, overlay)
		frame.__FDDoverlay = nil
	end

	local function OverlayGlow_OnHide(self)
		if self.animOut:IsPlaying() then
			self.animOut:Stop()
			OverlayGlowAnimOutFinished(self.animOut)
		end
	end

	local function CreateScaleAnim(group, target, order, duration, x, y, delay)
		local scale = group:CreateAnimation("Scale")
		scale:SetTarget(target:GetName())
		scale:SetOrder(order)
		scale:SetDuration(duration)
		scale:SetScale(x, y)

		if delay then
			scale:SetStartDelay(delay)
		end
	end

	local function CreateAlphaAnim(group, target, order, duration, fromAlpha, toAlpha, delay)
		local alpha = group:CreateAnimation("Alpha")
		alpha:SetTarget(target:GetName())
		alpha:SetOrder(order)
		alpha:SetDuration(duration)
		alpha:SetFromAlpha(fromAlpha)
		alpha:SetToAlpha(toAlpha)

		if delay then
			alpha:SetStartDelay(delay)
		end
	end

	local function AnimIn_OnPlay(group)
		local frame = group:GetParent()
		local frameWidth, frameHeight = frame:GetSize()
		frame.spark:SetSize(frameWidth, frameHeight)
		frame.spark:SetAlpha(0.3)
		frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2)
		frame.innerGlow:SetAlpha(1.0)
		frame.innerGlowOver:SetAlpha(1.0)
		frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2)
		frame.outerGlow:SetAlpha(1.0)
		frame.outerGlowOver:SetAlpha(1.0)
		frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
		frame.ants:SetAlpha(0)
		frame:Show()
	end

	local function AnimIn_OnFinished(group)
		local frame = group:GetParent()
		local frameWidth, frameHeight = frame:GetSize()
		frame.spark:SetAlpha(0)
		frame.innerGlow:SetAlpha(0)
		frame.innerGlow:SetSize(frameWidth, frameHeight)
		frame.innerGlowOver:SetAlpha(0.0)
		frame.outerGlow:SetSize(frameWidth, frameHeight)
		frame.outerGlowOver:SetAlpha(0.0)
		frame.outerGlowOver:SetSize(frameWidth, frameHeight)
		frame.ants:SetAlpha(1.0)
	end

	local function CreateOverlayGlow()
		numOverlays = numOverlays + 1

		-- create frame and textures
		local name = "FDDGlowOverlay" .. tostring(numOverlays)
		local overlay = CreateFrame("Frame", name, UIParent)

		-- spark
		overlay.spark = overlay:CreateTexture(name .. "Spark", "BACKGROUND")
		overlay.spark:SetPoint("CENTER")
		overlay.spark:SetAlpha(0)
		overlay.spark:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		overlay.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)

		-- inner glow
		overlay.innerGlow = overlay:CreateTexture(name .. "InnerGlow", "ARTWORK")
		overlay.innerGlow:SetPoint("CENTER")
		overlay.innerGlow:SetAlpha(0)
		overlay.innerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		overlay.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

		-- inner glow over
		overlay.innerGlowOver = overlay:CreateTexture(name .. "InnerGlowOver", "ARTWORK")
		overlay.innerGlowOver:SetPoint("TOPLEFT", overlay.innerGlow, "TOPLEFT")
		overlay.innerGlowOver:SetPoint("BOTTOMRIGHT", overlay.innerGlow, "BOTTOMRIGHT")
		overlay.innerGlowOver:SetAlpha(0)
		overlay.innerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		overlay.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

		-- outer glow
		overlay.outerGlow = overlay:CreateTexture(name .. "OuterGlow", "ARTWORK")
		overlay.outerGlow:SetPoint("CENTER")
		overlay.outerGlow:SetAlpha(0)
		overlay.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		overlay.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

		-- outer glow over
		overlay.outerGlowOver = overlay:CreateTexture(name .. "OuterGlowOver", "ARTWORK")
		overlay.outerGlowOver:SetPoint("TOPLEFT", overlay.outerGlow, "TOPLEFT")
		overlay.outerGlowOver:SetPoint("BOTTOMRIGHT", overlay.outerGlow, "BOTTOMRIGHT")
		overlay.outerGlowOver:SetAlpha(0)
		overlay.outerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
		overlay.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

		-- ants
		overlay.ants = overlay:CreateTexture(name .. "Ants", "OVERLAY")
		overlay.ants:SetPoint("CENTER")
		overlay.ants:SetAlpha(0)
		overlay.ants:SetTexture([[Interface\SpellActivationOverlay\IconAlertAnts]])

		-- setup antimations
		overlay.animIn = overlay:CreateAnimationGroup()
		CreateScaleAnim(overlay.animIn, overlay.spark,          1, 0.2, 1.5, 1.5)
		CreateAlphaAnim(overlay.animIn, overlay.spark,          1, 0.2, 0, 1)
		CreateScaleAnim(overlay.animIn, overlay.innerGlow,      1, 0.3, 2, 2)
		CreateScaleAnim(overlay.animIn, overlay.innerGlowOver,  1, 0.3, 2, 2)
		CreateAlphaAnim(overlay.animIn, overlay.innerGlowOver,  1, 0.3, 1, 0)
		CreateScaleAnim(overlay.animIn, overlay.outerGlow,      1, 0.3, 0.5, 0.5)
		CreateScaleAnim(overlay.animIn, overlay.outerGlowOver,  1, 0.3, 0.5, 0.5)
		CreateAlphaAnim(overlay.animIn, overlay.outerGlowOver,  1, 0.3, 1, 0)
		CreateScaleAnim(overlay.animIn, overlay.spark,          1, 0.2, 2/3, 2/3, 0.2)
		CreateAlphaAnim(overlay.animIn, overlay.spark,          1, 0.2, 1, 0, 0.2)
		CreateAlphaAnim(overlay.animIn, overlay.innerGlow,      1, 0.2, 1, 0, 0.3)
		CreateAlphaAnim(overlay.animIn, overlay.ants,           1, 0.2, 0, 1, 0.3)
		overlay.animIn:SetScript("OnPlay", AnimIn_OnPlay)
		overlay.animIn:SetScript("OnFinished", AnimIn_OnFinished)

		overlay.animOut = overlay:CreateAnimationGroup()
		CreateAlphaAnim(overlay.animOut, overlay.outerGlowOver, 1, 0.2, 0, 1)
		CreateAlphaAnim(overlay.animOut, overlay.ants,          1, 0.2, 1, 0)
		CreateAlphaAnim(overlay.animOut, overlay.outerGlowOver, 2, 0.2, 1, 0)
		CreateAlphaAnim(overlay.animOut, overlay.outerGlow,     2, 0.2, 1, 0)
		overlay.animOut:SetScript("OnFinished", OverlayGlowAnimOutFinished)

		-- scripts
		overlay:SetScript("OnUpdate", ActionButton_OverlayGlowOnUpdate)
		overlay:SetScript("OnHide", OverlayGlow_OnHide)
		
		return overlay
	end

	local function GetOverlayGlow()
		local overlay = tremove(unusedOverlays)
		if not overlay then
			overlay = CreateOverlayGlow()
		end
		return overlay
	end
	
	local glow_spacing = 0.4
	
	function FeralDotDamage.ShowOverlayGlow(frame)
		if frame.__FDDoverlay then
			if frame.__FDDoverlay.animOut:IsPlaying() then
				frame.__FDDoverlay.animOut:Stop()
				frame.__FDDoverlay.animIn:Play()
			end
		else
			local overlay = GetOverlayGlow()
			local frameWidth, frameHeight = frame:GetSize()
			overlay:SetParent(frame)
			overlay:SetFrameLevel(frame:GetFrameLevel() + 5)
			overlay:ClearAllPoints()
		
			overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
			overlay:SetPoint("TOPLEFT", frame, "TOPLEFT", -frameWidth * glow_spacing, frameHeight * glow_spacing)
			overlay:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", frameWidth * glow_spacing, -frameHeight * glow_spacing)
	
	
			overlay.animIn:Play()
			frame.__FDDoverlay = overlay

			if Masque and Masque.UpdateSpellAlert and (not frame.overlay or not issecurevariable(frame, "overlay")) then
				local old_overlay = frame.overlay
				frame.overlay = overlay
				Masque:UpdateSpellAlert(frame)

				frame.overlay = old_overlay
			end
		end
	end

	function FeralDotDamage.HideOverlayGlow(frame)
		if frame.__FDDoverlay then
			if frame.__FDDoverlay.animIn:IsPlaying() then
				frame.__FDDoverlay.animIn:Stop()
			end
			if frame:IsVisible() then
				frame.__FDDoverlay.animOut:Play()
			else
				OverlayGlowAnimOutFinished(frame.__FDDoverlay.animOut)
			end
		end
	end
end

do
	local ItemHasRange = ItemHasRange
	local IsItemInRange = IsItemInRange
	
	local Harm_Items_Table = {
		{ 37727, 5 },
		{ 34368, 8 },
		{ 32321, 10 },
		{ 33069, 15 },
		{ 10645, 20 },
		{ 31463, 25 },
		{ 34191, 30 },
		{ 18904, 35 },
		{ 28767, 40 },
		{ 23836, 45 },
		{ 37887, 60 },
		{ 35278, 80 },
	}

	local Help_Items_Table = {
		{37727, 5},
		{34368, 8},
		{33278, 8},	
		{32321, 10},
		{1251, 15},
		{21519, 20},
		{31463, 25},
		{34191, 30},
		{18904, 35},
		{34471, 40},
		{32698, 45},
		{37887, 60},
		{35278, 80},
	}

	local function CheckItemRange(id, unit)
		if ItemHasRange(id) and ( IsItemInRange(id, unit) == 1 or IsItemInRange(id, unit) == true ) then
			return true
		end
	end

	local MAX_RANGE = 90
	local MIN_RANGE = 0

	local function GetRange(unit)
		local _range = MAX_RANGE
		local _range2 = MIN_RANGE
		
		local attack = false

		if UnitCanAttack('player', unit) then
			attack = true
			
			for i=1, #Harm_Items_Table do
				local data = Harm_Items_Table[i]
				
				if CheckItemRange(data[1], unit) then
					_range = data[2]
					_range2 = Harm_Items_Table[i-1] and Harm_Items_Table[i-1][2] or MIN_RANGE
					break
				end
			end
		else
			attack = false
			for i=1, #Help_Items_Table do
				local data = Help_Items_Table[i]
				if  CheckItemRange(data[1], unit) then
					_range = data[2]
					_range2 = Help_Items_Table[i-1] and Help_Items_Table[i-1][2] or MIN_RANGE			
					break
				end
			end
		end
		
		return _range, attack, _range2
	end

	local rangeIndicator = CreateFrame('Frame', nil, UIParent)
	rangeIndicator:SetSize(20, 20)
	rangeIndicator:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)

	rangeIndicator.text = rangeIndicator:CreateFontString()
	rangeIndicator.text:SetDrawLayer('OVERLAY')
	rangeIndicator.text:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
	rangeIndicator.text:SetPoint('CENTER', rangeIndicator, 'CENTER', 0, 0)
	rangeIndicator.elapsed = 0
	rangeIndicator:SetScript('OnUpdate', function(self, elapsed)
		self.elapsed = self.elapsed + elapsed		
		if self.elapsed < 0.5 then return end
		self.elapsed = 0
		
		local r, enemy, r2 = GetRange('target')
		local text = ''
		local minRange = ns.moonkinForm and 8 or 5
		
		local cr, cg, cb = 255, 0, 0
		
--		print('T', r, r2, ( minRange >= r2 ), ( minRange >= r ) )
		if IsSpellInRange((GetSpellInfo(5221)), "target") == 1 then
			cr, cg, cb = 0, 255, 0
		end
		
		if enemy then
			if r == MAX_RANGE then		
				text = format("|cff%02x%02x%02x%s|r", cr, cg, cb, ">80")
			else
				text = format("|cff%02x%02x%02x%d-%d|r", cr, cg, cb, r2, r)
			end
		else
			if r == MAX_RANGE then
				text = format("|cff%02x%02x%02x%s|r", cr, cg, cb, ">80")
			else
				text = format("|cff%02x%02x%02x%d-%d|r", cr, cg, cb, r2, r)
			end
		end
		
		
		rangeIndicator.text:SetText(text)
	end)
	
	function ns:UpdateRangeIndicator()
		ns:Mover(rangeIndicator, "rangeIndicator")
		rangeIndicator.text:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
		
		if ns.db.profile.rangeIndicator then
			rangeIndicator:Show()
		else
			rangeIndicator:Hide()
		end
	end

end

local function GetGCD()
	local startTime, duration = GetSpellCooldown(61304);
	
	return duration or 0
end

ns.GetGCD = GetGCD

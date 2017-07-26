local Defensive_Spells = {
	{ -- [1]
	[97462] = "阳光", -- 集结
	--[64843] = "糖糖", -- 赞美诗
	[31821] = "熊", -- 光环
	},
	
	{ -- [2]
	[740] = "陆伯言", -- 宁静
	},
	
	{ -- [3]
	[98008] = "泡泡", -- 链接
	[108280] = "泡泡", -- 奶潮
	[207399] = "泡泡", -- 复生
	},
	
	{ -- [4]
	[207399] = "天气", -- 复生
	[108280] = "天气", -- 奶潮
	},
	
	{ -- [5]
	},
	
	{ -- [6]
	[97462] = "阳光", -- 集结
	[31821] = "熊", -- 光环
	},
	
	{ -- [7]
	},
	
	{ -- [8]
	[98008] = "泡泡", -- 链接
	[108280] = "泡泡", -- 奶潮
	},
	
	{ -- [9]
	},
	
	{ -- [10]
	},
	
	{ -- [11]
	},
	
	{ -- [12]
	},
	
	{ -- [13]
	},
	
	{ -- [14]
	},
	
	{ -- [15]
	},
	
	{ -- [16]
	},
	
	{ -- [17]
	},
	
	{ -- [18]
	},
	
	{ -- [19]
	},
	
	{ -- [20]
	},
}

local Defaults = {
	hide = false,
	scale = 1,
	Show_Name = false,
	Show_Raid = true,
	Defensive_Spell = true,
	voice = true,
	backdrop = true,
}

local font = GameFontHighlight:GetFont()
local fontsize_big = 50
local fontsize_small = 20
local HydraShot = 230139 --187464(暗影愈合 测试用)
local HydraShot_name = GetSpellInfo(230139)
local HydraShot_group = {}
local HydraShot_index = 1
local HydraShot_lock = false
local DeliciousBufferfish_name = GetSpellInfo(239362) -- (239375)
local Available = 0

local LgTiger = CreateFrame("Frame", "LgTiger_MainFrame", UIParent)
LgTiger:SetPoint("CENTER", UIParent, "CENTER")
LgTiger:SetSize(fontsize_big+5, fontsize_big+5)
	
LgTiger:RegisterForDrag("LeftButton")
LgTiger:SetScript("OnDragStart", function(self) self:StartMoving() end)
LgTiger:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
LgTiger:SetClampedToScreen(true)
LgTiger:SetMovable(true)
LgTiger:SetUserPlaced(true)
LgTiger:EnableMouse(true)

LgTiger.My_shot_Tex = LgTiger:CreateTexture(nil, "ARTWORK")
LgTiger.My_shot_Tex:SetSize(fontsize_big+5, fontsize_big+5)
LgTiger.My_shot_Tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
SetRaidTargetIconTexture(LgTiger.My_shot_Tex, 0)
LgTiger.My_shot_Tex:SetPoint("CENTER")

LgTiger.My_shot_Tex2 = LgTiger:CreateTexture(nil, "BORDER")
LgTiger.My_shot_Tex2:SetSize(fontsize_big+30, fontsize_big+30)
LgTiger.My_shot_Tex2:SetTexture("Spells\\Reticle_128")
LgTiger.My_shot_Tex2:SetBlendMode("ADD")
LgTiger.My_shot_Tex2:SetVertexColor(1, 0, 0)
LgTiger.My_shot_Tex2:SetPoint("CENTER")
LgTiger.My_shot_Tex2:Hide()

LgTiger.My_shot_fontstring = LgTiger:CreateFontString(nil, "ARTWORK")
LgTiger.My_shot_fontstring:SetFont(font, fontsize_big, "OUTLINE")
LgTiger.My_shot_fontstring:SetText("无")
LgTiger.My_shot_fontstring:SetJustifyH("LEFT")
LgTiger.My_shot_fontstring:SetPoint("LEFT", LgTiger.My_shot_Tex, "RIGHT", 5, 0)

LgTiger.bg = LgTiger:CreateTexture(nil, "BACKGROUND")
LgTiger.bg:SetColorTexture(0, 0, 0, 0.5)

LgTiger.Defensive_Spell = CreateFrame("Frame", "LgTiger_RaidcdFrame", LgTiger)
LgTiger.Defensive_Spell:SetPoint("BOTTOM", UIParent, "CENTER", 0, 30)
LgTiger.Defensive_Spell:SetSize(200, fontsize_big+5)

LgTiger.Defensive_Spell:RegisterForDrag("LeftButton")
LgTiger.Defensive_Spell:SetScript("OnDragStart", function(self) self:StartMoving() end)
LgTiger.Defensive_Spell:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
LgTiger.Defensive_Spell:SetClampedToScreen(true)
LgTiger.Defensive_Spell:SetMovable(true)
LgTiger.Defensive_Spell:SetUserPlaced(true)
LgTiger.Defensive_Spell:EnableMouse(true)

LgTiger.Defensive_Spell.fontstring = LgTiger.Defensive_Spell:CreateFontString(nil, "ARTWORK")
LgTiger.Defensive_Spell.fontstring:SetFont(font, fontsize_small, "OUTLINE")
LgTiger.Defensive_Spell.fontstring:SetJustifyH("CENTER")
LgTiger.Defensive_Spell.fontstring:SetPoint("CENTER")

local text = ""
for spellid, player in pairs(Defensive_Spells[1]) do
	text = text.."|T"..select(3, GetSpellInfo(spellid))..":12:12:0:0:64:64:4:60:4:60|t"..player.." "
end
LgTiger.Defensive_Spell.fontstring:SetText(HydraShot_name.."[1]："..text)

LgTiger.Defensive_Spell.bg = LgTiger.Defensive_Spell:CreateTexture(nil, "BACKGROUND")
LgTiger.Defensive_Spell.bg:SetColorTexture(0, 0, 0, 0.5)
LgTiger.Defensive_Spell.bg:SetAllPoints(LgTiger.Defensive_Spell.fontstring)
		
LgTiger.Raid = CreateFrame("Frame", "LgTiger_RaidFrame", LgTiger)
LgTiger.Raid:SetSize(fontsize_small+5,(fontsize_small+10)*4-5)
LgTiger.Raid:SetPoint("TOPLEFT", UIParent, "CENTER", -100, -30)

LgTiger.Raid:RegisterForDrag("LeftButton")
LgTiger.Raid:SetScript("OnDragStart", function(self) self:StartMoving() end)
LgTiger.Raid:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
LgTiger.Raid:SetClampedToScreen(true)
LgTiger.Raid:SetMovable(true)
LgTiger.Raid:SetUserPlaced(true)
LgTiger.Raid:EnableMouse(true)

LgTiger.Raid.bg = LgTiger.Raid:CreateTexture(nil, "BACKGROUND")
LgTiger.Raid.bg:SetColorTexture(0, 0, 0, 0.5)
LgTiger.Raid.bg:SetAllPoints(LgTiger.Raid)

for i = 1, 4 do
	LgTiger.Raid["shot"..i] = CreateFrame("Frame", "LgTiger_RaidFrame_Show"..i, LgTiger.Raid)
	LgTiger.Raid["shot"..i]:SetSize(fontsize_small+5, fontsize_small+5)
	LgTiger.Raid["shot"..i]:SetPoint("TOPLEFT", LgTiger.Raid, "TOPLEFT", 0, -(fontsize_small+10)*(i-1))	
	LgTiger.Raid["shot"..i].text = ""	

	LgTiger.Raid["shot"..i].Tex = LgTiger.Raid["shot"..i]:CreateTexture(nil, "ARTWORK")
	LgTiger.Raid["shot"..i].Tex:SetSize(fontsize_small+5, fontsize_small+5)	
	LgTiger.Raid["shot"..i].Tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	SetRaidTargetIconTexture(LgTiger.Raid["shot"..i].Tex, i)
	LgTiger.Raid["shot"..i].Tex:SetPoint("LEFT")
	
	LgTiger.Raid["shot"..i].Text = LgTiger.Raid["shot"..i]:CreateFontString(nil, "ARTWORK")
	LgTiger.Raid["shot"..i].Text:SetFont(font, fontsize_small, "OUTLINE")	
	LgTiger.Raid["shot"..i].Text:SetJustifyH("LEFT")
	LgTiger.Raid["shot"..i].Text:SetPoint("LEFT", LgTiger.Raid["shot"..i].Tex, "RIGHT", 5, 0)
end

local function Init()
	if LgTiger_CDB.hide then
		LgTiger:Hide()
	else
		LgTiger:Show()
	end
	
	LgTiger:SetScale(LgTiger_CDB.scale)
	
	if not LgTiger_CDB.Show_Name then
		LgTiger.My_shot_fontstring:Hide()
		LgTiger.bg:SetAllPoints(LgTiger.My_shot_Tex)
	else
		LgTiger.My_shot_fontstring:Show()
		LgTiger.bg:SetPoint("TOPLEFT", LgTiger.My_shot_Tex, "TOPLEFT")
		LgTiger.bg:SetPoint("BOTTOMRIGHT", LgTiger.My_shot_fontstring, "BOTTOMRIGHT")
	end
	
	if not LgTiger_CDB.Defensive_Spell then
		LgTiger.Defensive_Spell.fontstring:Hide()
	else
		LgTiger.Defensive_Spell.fontstring:Show()
	end
	
	if not LgTiger_CDB.Show_Raid then
		LgTiger.Raid:Hide()
	else
		LgTiger.Raid:Show()
	end
	
	if not LgTiger_CDB.backdrop then
		LgTiger.bg:Hide()
		LgTiger.Defensive_Spell.bg:Hide()
		LgTiger.Raid.bg:Hide()
	else
		LgTiger.bg:Show()
		if LgTiger_CDB.Defensive_Spell then
			LgTiger.Defensive_Spell.bg:Show()
		else
			LgTiger.Defensive_Spell.bg:Hide()
		end
		if LgTiger_CDB.Show_Raid then
			LgTiger.Raid.bg:Show()
		else
			LgTiger.Raid.bg:Hide()
		end	
	end
end

LgTiger:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
LgTiger:RegisterEvent("ENCOUNTER_START")
LgTiger:RegisterEvent("ENCOUNTER_END")
LgTiger:RegisterEvent("ADDON_LOADED")

local timer = 0
local tar = 1

SendRaidTarget = CreateFrame("Frame")
SendRaidTarget:Hide()
SendRaidTarget:SetScript("OnUpdate", function(self, t)
	timer = timer + t
	if timer > 0.5 then
		SendChatMessage("{rt"..tar.."}{rt"..tar.."}{rt"..tar.."}","YELL")
		timer = 0
	end
end)
									
LgTiger:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon ~= "LgTiger" then return end
		
		if LgTiger_CDB == nil then
			LgTiger_CDB = {}
		end
		
		for a, b in pairs(Defaults) do
			if LgTiger_CDB[a] == nil then
				LgTiger_CDB[a] = b
			end
		end
		
		Init()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, event_type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = ...
		if event_type == "SPELL_AURA_APPLIED" and spellID == HydraShot then
			if not HydraShot_lock then
				C_Timer.After(0.5, function()
					C_Timer.After(8, function()
						HydraShot_index = HydraShot_index + 1
						local text = ""
						for spellid, player in pairs(Defensive_Spells[HydraShot_index]) do
							text = text.."|T"..select(3, GetSpellInfo(spellid))..":12:12:0:0:64:64:4:60:4:60|t"..player.." "
						end
						LgTiger.Defensive_Spell.fontstring:SetText(HydraShot_name.."["..HydraShot_index.."]："..text)
						SetRaidTargetIconTexture(LgTiger.My_shot_Tex, 0)
						LgTiger.My_shot_Tex2:Hide()
					end)
					
					HydraShot_lock = false
					--print("解锁")
					
					HydraShot_group = {}
					Available = 0
					SetRaidTargetIconTexture(LgTiger.My_shot_Tex, 0)
					LgTiger.My_shot_Tex2:Hide()
					LgTiger.My_shot_fontstring:SetText("无")
					for i = 1, 4 do
						LgTiger.Raid["shot"..i].text = ""
					end
					
					local index = 0
					for i = 1, 20 do
						local unit = "raid"..i
						local name = GetUnitName(unit, false)
						if name then
							if UnitDebuff(unit, HydraShot_name) then
								index = index + 1
								--print("分担"..index.."号"..name.."的伤害")
								if UnitIsUnit(unit, "player") then
									SetRaidTargetIconTexture(LgTiger.My_shot_Tex, index)
									LgTiger.My_shot_Tex2:Show()
									if LgTiger_CDB.voice then
										PlaySoundFile("Interface\\AddOns\\LgTiger\\voice\\onyou.ogg", "Master")
									end
									LgTiger.My_shot_fontstring:SetText("|cffFF0000你!|r")
									tar = index
									SendRaidTarget:Show()
									C_Timer.After(6, function()
										SendRaidTarget:Hide()
									end)
								end
								HydraShot_group[index] = ("|c%s%s|r"):format(RAID_CLASS_COLORS[select(2, UnitClass(unit))]["colorStr"], name)
								SetRaidTarget(unit, index)
								LgTiger.Raid["shot"..index].text = ("|c%s%s|r"):format(RAID_CLASS_COLORS[select(2, UnitClass(unit))]["colorStr"], name).." → "
							--elseif not UnitIsDead(unit) and not UnitDebuff(unit, DeliciousBufferfish_name) then -- 测试用
							elseif not UnitIsDead(unit) and UnitIsConnected(unit) and not UnitDebuff(unit, DeliciousBufferfish_name) then
								Available = Available + 1
							end
						end			
					end
					
					local j = 0
					local k = 1
					local group_num, group_num2 = math.floor(Available/index),  math.fmod(Available,index)
					--print("一共"..Available.."人，分为"..index.."个队伍，每队"..group_num.."人，余数"..group_num2)
					for i = 1, 20 do
						local unit = "raid"..i
						local name = GetUnitName(unit, false)
						
						--if name and not UnitDebuff(unit, HydraShot_name) and not UnitIsDead(unit) and not UnitDebuff(unit, DeliciousBufferfish_name) then -- 测试用
						if name and not UnitDebuff(unit, HydraShot_name) and not UnitIsDead(unit) and UnitIsConnected(unit) and not UnitDebuff(unit, DeliciousBufferfish_name) then
							--print("正在分配"..name.."的位置")
							
							if j + 1 <= group_num + (group_num2 > 0 and 1 or 0) then
								j = j + 1
							else
								if group_num2 > 0 then
									group_num2 = group_num2 - 1
								end			
								k = k + 1
								j = 1
							end
							
							--print("还有"..group_num2.."个多的人")
							--print("把他分给分担组"..k)

							LgTiger.Raid["shot"..k].text = LgTiger.Raid["shot"..k].text..("|c%s%s|r"):format(RAID_CLASS_COLORS[select(2, UnitClass(unit))]["colorStr"], name)..(j < (group_num + (group_num2 > 0 and 1 or 0)) and "," or "")
							
							if UnitIsUnit(unit, "player") then
								SetRaidTargetIconTexture(LgTiger.My_shot_Tex, k)
								if LgTiger_CDB.voice then
									PlaySoundFile("Interface\\AddOns\\LgTiger\\voice\\"..k..".ogg", "Master")
								end
								LgTiger.My_shot_fontstring:SetText(HydraShot_group[k])
							end
						end
					end
					
					for i = 1, 4 do
						LgTiger.Raid["shot"..i].Text:SetText(LgTiger.Raid["shot"..i].text)
					end

				end)
				HydraShot_lock = true
				--print("锁定")
			end
		end
	else
		--print(event)
		HydraShot_index = 1
		LgTiger.Defensive_Spell.fontstring:SetText(HydraShot_name.."[1]："..text)
	end
end)

local L = {}
local Client = GetLocale()

L["尺寸注意"] = "Scale must between 0.5~2."
L["隐藏"] = "Visiblity "
L["尺寸"] = "Scale "
L["对象"] = "Show player who you share dmg with "
L["团队"] = "Show raid share arrangement "
L["技能"] = "Show raid defensive spell for HydraShot"
L["背景"] = "Show backdrop "
L["声音"] = "Voice(Chinese) "
L["默认"] = "Reset to default settings "
L["编辑文件"] = "Edit raid defensive spell for HydraShot in LgTiger.lua"

if Client == "zhCN" then
	L["尺寸注意"] = "尺寸缩放倍数须介于0.5~2之间。"
	L["隐藏"] = "隐藏 "
	L["尺寸"] = "尺寸 "
	L["对象"] = "显示或隐藏分担对象 "
	L["团队"] = "显示或隐藏团队分配 "
	L["技能"] = "显示或隐藏团队技能 "
	L["背景"] = "显示或隐藏黑色背景 "
	L["声音"] = "声音提示 "
	L["默认"] = "还原默认设置 "
	L["编辑文件"] = "团队技能安排需要编辑文件。"
end

if Client == "zhTW" then
	L["尺寸注意"] = "尺寸縮放倍數須介於0.5~2之間。"
	L["隐藏"] = "隱藏 "
	L["尺寸"] = "尺寸 "
	L["对象"] = "顯示或隱藏分擔對象 "
	L["团队"] = "顯示或隱藏團隊分配 "
	L["技能"] = "顯示或隱藏團隊技能 "
	L["背景"] = "顯示或隱藏黑色背景 "
	L["声音"] = "聲音提示 "
	L["默认"] = "還原默認設置 "
	L["编辑文件"] = "團隊技能安排需要編輯文件。"
end

local color = "|cffFFBBFF"
local on = "|cff76EE00On|r"
local off = "|cffFF3030Off|r"

SLASH_LGTIGHER1 = "/lgtger"
SLASH_LGTIGHER2 = "/lgt"
SlashCmdList["LGTIGHER"] = function(arg)
	if arg == "hide" then
		if LgTiger_CDB.hide then
			LgTiger_CDB.hide = false
		else
			LgTiger_CDB.hide = true
		end
		Init()
	elseif string.find(arg, "scale %d") then
		local arg1, arg2 = string.split(" ", arg)
		local num = tonumber(arg2)
		if num and num >= 0.5 and num <= 2 then
			LgTiger_CDB.scale = num
			Init()
		else
			print(L["尺寸注意"])
		end
	elseif arg == "name" then
		if LgTiger_CDB.Show_Name then
			LgTiger_CDB.Show_Name = false
		else
			LgTiger_CDB.Show_Name = true
		end
		Init()
	elseif arg == "raid" then
		if LgTiger_CDB.Show_Raid then
			LgTiger_CDB.Show_Raid = false
		else
			LgTiger_CDB.Show_Raid = true
		end
		Init()
	elseif arg == "raidcd" then
		if LgTiger_CDB.Defensive_Spell then
			LgTiger_CDB.Defensive_Spell = false
		else
			LgTiger_CDB.Defensive_Spell = true
		end
		Init()
	elseif arg == "backdrop" then
		if LgTiger_CDB.backdrop then
			LgTiger_CDB.backdrop = false
		else
			LgTiger_CDB.backdrop = true
		end
		Init()
	elseif arg == "voice" then
		if LgTiger_CDB.voice then
			LgTiger_CDB.voice = false
		else
			LgTiger_CDB.voice = true
		end
	elseif arg == "default" then
		for a, b in pairs(Defaults) do
			LgTiger_CDB[a] = b
		end
		LgTiger:ClearAllPoints()
		LgTiger:SetPoint("CENTER", UIParent, "CENTER")
		LgTiger.Defensive_Spell:ClearAllPoints()
		LgTiger.Defensive_Spell:SetPoint("BOTTOM", UIParent, "CENTER", 0, 30)
		LgTiger.Raid:ClearAllPoints()
		LgTiger.Raid:SetPoint("TOPLEFT", UIParent, "CENTER", -100, -30)
		Init()
	else
		print(color.."LgTiger by Paopao001|r")
		print(L["隐藏"]..(LgTiger_CDB.hide and on or off)..color.." /lgt hide|r")
		print(L["尺寸"].."|cff87CEFF"..(LgTiger_CDB.scale).."|r"..color.." /lgt scale x (0.5~2)|r")
		print(L["对象"]..(LgTiger_CDB.Show_Name and on or off)..color.." /lgt name|r")
		print(L["团队"]..(LgTiger_CDB.Show_Raid and on or off)..color.." /lgt raid|r")
		print(L["技能"]..(LgTiger_CDB.Defensive_Spell and on or off)..color.." /lgt raidcd|r")
		print(L["背景"]..(LgTiger_CDB.backdrop and on or off)..color.." /lgt backdrop|r")
		print(L["声音"]..(LgTiger_CDB.voice and on or off)..color.." /lgt voice|r")
		print(L["默认"]..color.." /lgt default|r")
		print(L["编辑文件"])
	end
end
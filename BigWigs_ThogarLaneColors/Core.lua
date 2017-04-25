
-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("ThogarBarColors")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local lane_pattern = nil

local icons = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7.blp:0|t",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp:0|t",
}

local colors = {
	{1.0, 0.92, 0},
	{0.98, 0.57, 0},
	{0.83, 0.22, 0.9},
	{0.04, 0.95, 0},
	{0.7, 0.82, 0.875},
	{0, 0.71, 1},
	{1.0, 0.24, 0.168},
	{0.98, 0.98, 0.98},
}

-------------------------------------------------------------------------------
-- Locale
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thogar Lane Colors", "enUS", true)
L["Thogar Lane Colors"] = true
L["Fancies up the train bars for the Operator Thogar encounter."] = true
L["Add icon to text"] = true
L["Color bars"] = true
L["Set the marks your raid uses. 1 is the boss, 4 is the entrance."] = true
L["Lane %d"] = true
L["|cffffd200Note: The \"Random trains\" bar in Mythic isn't modified, it'll use the bar color set for the \"Train warnings\" option.|r"] = true

L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Thogar Lane Colors")

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	enabled = true,
	icon = true,
	color = true,
	markers = { 2, 3, 4, 5 }
}

local values = {
	RAID_TARGET_1,
	RAID_TARGET_2,
	RAID_TARGET_3,
	RAID_TARGET_4,
	RAID_TARGET_5,
	RAID_TARGET_6,
	RAID_TARGET_7,
	RAID_TARGET_8,
}

local disabled = function() return not plugin.db.profile.enabled end

local options = {
	name = L["Thogar Lane Colors"],
	type = "group",
	get = function(info)
		if info.arg then
			return plugin.db.profile.markers[info.arg]
		else
			return plugin.db.profile[info[#info]]
		end
	end,
	set = function(info, value)
		if info.arg then
			plugin.db.profile.markers[info.arg] = value
		else
			plugin.db.profile[info[#info]] = value
		end
	end,
	args = {
		heading = {
			type = "description",
			name = L["Fancies up the train bars for the Operator Thogar encounter."].."\n",
			fontSize = "medium",
			order = 1,
		},
		enabled = {
			type = "toggle",
			name = ENABLE,
			order = 2,
		},
		icon = {
			type = "toggle",
			name = L["Add icon to text"],
			disabled = disabled,
			order = 3,
		},
		color = {
			type = "toggle",
			name = L["Color bars"],
			disabled = disabled,
			order = 3,
		},
		separator = {
			type = "description",
			name = "\n"..L["Set the marks your raid uses. 1 is the boss, 4 is the entrance."],
			order = 4,
		},
		lane1 = {
			type = "select",
			name = L["Lane %d"]:format(1),
			values = values,
			itemControl = "DDI-RaidIcon",
			disabled = disabled,
			arg = 1,
			order = 5,
		},
		lane2 = {
			type = "select",
			name = L["Lane %d"]:format(2),
			values = values,
			itemControl = "DDI-RaidIcon",
			disabled = disabled,
			arg = 2,
			order = 5,
		},
		lane3 = {
			type = "select",
			name = L["Lane %d"]:format(3),
			values = values,
			itemControl = "DDI-RaidIcon",
			disabled = disabled,
			arg = 3,
			order = 5,
		},
		lane4 = {
			type = "select",
			name = L["Lane %d"]:format(4),
			values = values,
			itemControl = "DDI-RaidIcon",
			disabled = disabled,
			arg = 4,
			order = 5,
		},
		note = {
			type = "description",
			name = "\n"..L["|cffffd200Note: The \"Random trains\" bar in Mythic isn't modified, it'll use the bar color set for the \"Train warnings\" option.|r"],
			fontSize = "medium",
			order = 6,
		},
	},
}

plugin.subPanelOptions = {
	key = "Big Wigs: Thogar Lane Colors",
	name = L["Thogar Lane Colors"],
	options = options,
}

SLASH_BigWigs_ThogarLaneColors1 = "/bwthogar"
SlashCmdList.BigWigs_ThogarLaneColors = function()
	BigWigsOptions:Open()
	-- didn't see a way to do something like this with ACD, so going the brute force route
	-- buttons aren't available right after calling :Open for the first time, so check on the next frame
	C_Timer.After(0, function()
		local i, button = 1, _G["AceGUI30TreeButton1"]
		while button do
			if button.text:GetText() == L["Thogar Lane Colors"] then
				button:Click()
				break
			end
			i = i + 1
			button = _G["AceGUI30TreeButton"..i]
		end
	end)
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnBossEnable")
	self:RegisterMessage("BigWigs_OnBossDisable")

	-- make sure we didn't get enabled after the boss mod
	local module = BigWigs:GetBossModule("Operator Thogar", true)
	if module and module:IsEnabled() then
		self:BigWigs_OnBossEnable(nil, module)
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEnable(_, module)
	if module.journalId == 1147 and self.db.profile.enabled and module:CheckOption("trains", "BAR") then
		if not lane_pattern then
			local L = module:GetLocale() --L.lane = "Lane %s: %s"
			lane_pattern = L.lane:gsub("%%s", "(.-)")
		end
		self:RegisterMessage("BigWigs_BarCreated")
		self:RegisterMessage("BigWigs_BarEmphasized")
	end
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module.journalId == 1147 then
		self:UnregisterMessage("BigWigs_BarCreated")
		self:UnregisterMessage("BigWigs_BarEmphasized")
	end
end

function plugin:BigWigs_BarEmphasized(_, _, bar)
	local color = bar:Get("bigwigs:trains:color")
	if color then
		bar:SetColor(unpack(color))
		bar:Set("bigwigs:trains:color", nil)
	end
end

function plugin:BigWigs_BarCreated(_, _, bar, module, key, text)
	if key == "trains" then
		local lane = tonumber((text:match(lane_pattern)))
		if lane then
			local db = plugin.db.profile
			if db.icon then
				bar:SetLabel(("%s %s"):format(icons[db.markers[lane]], text))
			end
			if db.color then
				local color = colors[db.markers[lane]]
				bar:SetColor(unpack(color))
				bar:Set("bigwigs:trains:color", color)
			end
		end
	end
end


local _, ns = ...
local t = ns.TidyPlates_Threat

local function Create(self, name)
	local db = self.db.profile.settings
	local config = {}

	config.hitbox = {
		width = 124,
		height = 30,
	}
	config.frame = {
		emptyTexture = t.Art.."Empty",
		width = 124,
		height = 30,
		x = db.frame.x,
		y = db.frame.y,
		anchor = "CENTER",
	}
	config.threatborder = {
		texture = t.Art.."Empty",
		elitetexture = t.Art.."Empty",
		width = 256,
		height = 64,
		x = 0,
		y = 0,
		anchor = "CENTER",
	}
	config.healthborder = {
		texture = t.Art.."Empty",
		glowtexture = t.Art.."Empty",
		elitetexture = t.Art.."Empty",
		width = 256,
		height = 64,
		x = 0,
		y = 0,
		anchor = "CENTER",
	}
	config.castborder = {
		texture = t.Art.."Empty",
		width = 256,
		height = 64,
		x = 0,
		y = -15,
		anchor = "CENTER",
	}
	config.castnostop = {
		texture = t.Art.."Empty",
		width = 256,
		height = 64,
		x = 0,
		y = -15,
		anchor = "CENTER",
	}
	config.eliteicon = {
		texture = t.Art.."Empty",
		width = db.eliteicon.scale,
		height = db.eliteicon.scale,
		x = db.eliteicon.x,
		y = db.eliteicon.y,
		anchor = db.eliteicon.anchor,
		show = false,
	}
	config.highlight = {
		texture = t.Art.."Empty",
		width = 256,
		height = 64,
		x = 0,
		y = 0,
		anchor = "CENTER",
		show = false,
	}
	config.target = {
		texture = "",
		width = 0,
		height = 0,
		x = 0,
		y = 0,
		anchor = "CENTER",
		show = false,
	}

	--[[Bar Textures]]--
	config.healthbar = {
		texture = t.Art.."Empty",
		width = 120,
		height = 10,
		x = 0,
		y = 0,
		anchor = "CENTER",
		orientation = "HORIZONTAL",
	}
	config.castbar = {
		texture = t.Art.."Empty",
		width = 120,
		height = 10,
		x = 0,
		y = -15,
		anchor = "CENTER",
		orientation = "HORIZONTAL",
	}

	--[[TEXT]]--
	local DB = self.db.profile.textOnly
	config.name = {
		typeface = t.Media:Fetch('font', DB.name.typeface),
		size = DB.name.size,
		width = DB.name.width,
		height = DB.name.height,
		x = DB.name.x,
		y = DB.name.y,
		align = DB.name.align,
		anchor = "CENTER",
		vertical = DB.name.vertical,
		shadow = DB.name.shadow,
		flags = DB.name.flags,
		show = true,
	}
	config.level = {
		typeface = t.Media:Fetch('font', db.level.typeface),
		size = db.level.size,
		width = db.level.width,
		height = db.level.height,
		x = db.level.x,
		y = db.level.y,
		align = db.level.align,
		anchor = "CENTER",
		vertical = db.level.vertical,
		shadow = db.level.shadow,
		show = false,
	}
	config.customtext = {
		typeface = t.Media:Fetch('font', DB.customtext.typeface),
		size = DB.customtext.size,
		width = DB.customtext.width,
		height = DB.customtext.height,
		x = DB.customtext.x,
		y = DB.customtext.y,
		align = DB.customtext.align,
		anchor = "CENTER",
		vertical = DB.customtext.vertical,
		shadow = DB.customtext.shadow,
		flags = DB.customtext.flags,
		show = true,
	}
	config.spelltext = {
		typeface = t.Media:Fetch('font', db.spelltext.typeface),
		size = db.spelltext.size,
		width = db.spelltext.width,
		height = db.spelltext.height,
		x = db.spelltext.x,
		y = db.spelltext.y,
		align = db.spelltext.align,
		anchor = "CENTER",
		vertical = db.spelltext.vertical,
		shadow = db.spelltext.shadow,
		show = false,
	}

	--[[ICONS]]--
	config.skullicon = {
		width = db.skullicon.scale,
		height = db.skullicon.scale,
		x = db.skullicon.x,
		y = db.skullicon.y,
		anchor = db.skullicon.anchor,
		show = false,
	}
	config.customart = {
		width = db.customart.scale,
		height = db.customart.scale,
		x = db.customart.x,
		y = db.customart.y,
		anchor = db.customart.anchor,
		show = true,
	}
	config.spellicon = {
		width = db.spellicon.scale,
		height = db.spellicon.scale,
		x = db.spellicon.x,
		y = db.spellicon.y,
		anchor = db.spellicon.anchor,
		show = false,
	}
	config.raidicon = {
		texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
		width = db.raidicon.scale,
		height = db.raidicon.scale,
		x = db.raidicon.x,
		y = db.raidicon.y,
		anchor = db.raidicon.anchor,
		show = true,
	}

	--[[OPTIONS]]--
	config.threatcolor = {
		LOW = { r = 0, g = 0, b = 0, a = 0 },
		MEDIUM = { r = 0, g = 0, b = 0, a = 0 },
		HIGH = { r = 0, g = 0, b = 0, a = 0 },
	}

	return config
end

t.RegisterTheme("text", Create)

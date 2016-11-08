--[[
AdiBags_Garrison - Adds Garrison group in your bags, using AdiBags inventory manager.
Copyright 2016 Kiber_ (4thekiber@gmail.com)
All rights reserved.
--]]

local addonName, addon = ...
local AdiBags = LibStub('AceAddon-3.0'):GetAddon('AdiBags')

local L = addon.L
local BIext = addon.BIext
local MatchIDs
local Tooltip

local function MatchIDs_Init(self)
  local Result = {}
  
  IDs = {
    116395, -- Comprehensive Outpost Construction Guide
    116394, -- Outpost Building Assembly Notes
  }
  AddToSet(Result, IDs)

  if self.db.profile.flagFollowers then
    IDs = {
      ------- Armor
      120301, -- Armor Enhancement Token
      114745, -- Braced Armor Enhancement
      114808, -- Fortified Armor Enhancement
      114822, -- Heavily Reinforced Armor Enhancement
      114807, -- War Ravaged Armor Set
      114806, -- Blackrock Armor Set
      114746, -- Goredrenched Armor Set
      ------- Weapon
      120302, -- Weapon Enhancement Token
      114128, -- Balanced Weapon Enhancement
      114129, -- Striking Weapon Enhancement
      114131, -- Power Overrun Weapon Enhancement
      114616, -- War Ravaged Weaponry
      114081, -- Blackrock Weaponry
      114622, -- Goredrenched Weaponry
      ------- Armor & Weapon 
      120313, -- Sanketsu
      128314, -- Frozen Arms of a Hero
      ------- Abilities & Traits
      118354, -- Follower Re-training Certificate
      122272, -- Follower Ability Retraining Manual
      122273, -- Follower Trait Retraining Guide
      123858, -- Follower Retraining Scroll Case
      118475, -- Hearthstone Strategy Guide
      118474, -- Supreme Manual of Dance
      122584, -- Winning with Wildlings
      122583, -- Grease Monkey Guide
      122582, -- Guide to Arakkoa Relations
      122580, -- Ogre Buddy Handbook
      ------- Other enhancements
      120311, -- The Blademaster's Necklace
      122298, -- Bodyguard Miniaturization Device
      ------- Contracts
      116915, -- Inactive Apexis Guardian
      114245, -- Abu'Gar's Favorite Lure
      114243, -- Abu'Gar's Finest Reel
      114242, -- Abu'Gar's Vitality
      119161, -- Contract: Karg Bloodfury
      119162, -- Contract: Cleric Maluuf
      119165, -- Contract: Professor Felblast
      119166, -- Contract: Cacklebone
      119167, -- Contract: Vindicator Heluun
      119248, -- Contract: Dawnseeker Rukaryx
      119233, -- Contract: Kaz the Shrieker
      119240, -- Contract: Lokra
      119242, -- Contract: Magister Serena
      119243, -- Contract: Magister Krelas
      119244, -- Contract: Hulda Shadowblade
      119245, -- Contract: Dark Ranger Velonara
      119252, -- Contract: Rangari Erdanii
      119253, -- Contract: Spirit of Bony Xuk
      119254, -- Contract: Pitfighter Vaandaam
      119255, -- Contract: Bruto
      119256, -- Contract: Glirin
      119257, -- Contract: Penny Clobberbottom
      119267, -- Contract: Ziri'ak
      119288, -- Contract: Daleera Moonfang
      119291, -- Contract: Artificer Andren
      119292, -- Contract: Vindicator Onaala
      119296, -- Contract: Rangari Chel
      119298, -- Contract: Ranger Kaalya
      119418, -- Contract: Morketh Bladehowl
      119420, -- Contract: Miall
      122135, -- Contract: Greatmother Geyah
      122136, -- Contract: Kal'gor the Honorable
      122137, -- Contract: Bruma Swiftstone
      122138, -- Contract: Ulna Thresher
      112737, -- Contract: Ka'la of the Frostwolves
      112848, -- Contract: Daleera Moonfang
      114825, -- Contract: Ulna Thresher
      114826, -- Contract: Bruma Swiftstone
      119164, -- Contract: Arakkoa Outcasts Follower
      119168, -- Contract: Vol'jin's Spear Follower
      119169, -- Contract: Wrynn's Vanguard Follower
      119821, -- Contract: Dawnseeker Rukaryx
      128439, -- Contract: Pallas
      128440, -- Contract: Dowser Goodwell
      128441, -- Contract: Solar Priest Vayx
      128445, -- Contract: Dowser Bigspark
    }
    AddToSet(Result, IDs)
  end

  if self.db.profile.flagWorkOrders then
    IDs = {
      114119, -- Crate of Salvage
      114116, -- Bag of Salvaged Goods
      114120, -- Big Crate of Salvage
      114781, -- Timber
      116053, -- Draenic Seeds
      115508, -- Draenic Stone
      113991, -- Iron Trap
      115009, -- Improved Iron Trap
      115010, -- Deadly Iron Trap
      119813, -- Furry Caged Beast
      119814, -- Leathery Caged Beast
      119810, -- Meaty Caged Beast
      119819, -- Caged Mighty Clefthoof
      119817, -- Caged Mighty Riverbeast
      119815, -- Caged Mighty Wolf
      117397, -- Nat's Lucky Coin
      128373, -- Rush Order: Shipyard
      122307, -- Rush Order: Barn
      122487, -- Rush Order: Gladiator's Sanctum
      122490, -- Rush Order: Dwarven Bunker
      122491, -- Rush Order: War Mill
      122496, -- Rush Order: Garden Shipment
      122497, -- Rush Order: Garden Shipment
      122500, -- Rush Order: Gnomish Gearworks
      122501, -- Rush Order: Goblin Workshop
      122502, -- Rush Order: Mine Shipment
      122503, -- Rush Order: Mine Shipment
      122576, -- Rush Order: Alchemy Lab
      122590, -- Rush Order: Enchanter's Study
      122591, -- Rush Order: Engineering Works
      122592, -- Rush Order: Gem Boutique
      122593, -- Rush Order: Scribe's Quarters
      122594, -- Rush Order: Tailoring Emporium
      122595, -- Rush Order: The Forge
      122596, -- Rush Order: The Tannery
    }
    AddToSet(Result, IDs)
  end

  if self.db.profile.flagIronHorde then
    IDs = {
      113681, -- Iron Horde Scraps
      113823, -- Crusted Iron Horde Pauldrons
      113822, -- Ravaged Iron Horde Belt
      113821, -- Battered Iron Horde Helmet
    }
    AddToSet(Result, IDs)
  end

  if self.db.profile.flagMiningConsumables then
    IDs = {
      118897, -- Miner's Coffee
      118903, -- Preserved Mining Pick
    }
    AddToSet(Result, IDs)
  end
  
  if self.db.profile.flagBlueprints then
    IDs = {
      118215, -- Book of Garrison Blueprints
      111812, -- Garrison Blueprint: Alchemy Lab, Level 1
      111929, -- Garrison Blueprint: Alchemy Lab, Level 2
      111930, -- Garrison Blueprint: Alchemy Lab, Level 3
      111968, -- Garrison Blueprint: Barn, Level 2
      111969, -- Garrison Blueprint: Barn, Level 3
      111956, -- Garrison Blueprint: Barracks, Level 1
      111970, -- Garrison Blueprint: Barracks, Level 2
      111971, -- Garrison Blueprint: Barracks, Level 3
      111966, -- Garrison Blueprint: Dwarven Bunker, Level 2
      111967, -- Garrison Blueprint: Dwarven Bunker, Level 3
      111817, -- Garrison Blueprint: Enchanter's Study, Level 1
      111972, -- Garrison Blueprint: Enchanter's Study, Level 2
      111973, -- Garrison Blueprint: Enchanter's Study, Level 3
      109258, -- Garrison Blueprint: Engineering Works, Level 1
      109256, -- Garrison Blueprint: Engineering Works, Level 2
      109257, -- Garrison Blueprint: Engineering Works, Level 3
      109578, -- Garrison Blueprint: Fishing Shack
      111927, -- Garrison Blueprint: Fishing Shack, Level 2
      111928, -- Garrison Blueprint: Fishing Shack, Level 3
      116248, -- Garrison Blueprint: Frostwall Mines, Level 2
      116249, -- Garrison Blueprint: Frostwall Mines, Level 3
      116431, -- Garrison Blueprint: Frostwall Tavern, Level 2
      116432, -- Garrison Blueprint: Frostwall Tavern, Level 3
      111814, -- Garrison Blueprint: Gem Boutique, Level 1
      111974, -- Garrison Blueprint: Gem Boutique, Level 2
      111975, -- Garrison Blueprint: Gem Boutique, Level 3
      111980, -- Garrison Blueprint: Gladiator's Sanctum, Level 2
      111981, -- Garrison Blueprint: Gladiator's Sanctum, Level 3
      111984, -- Garrison Blueprint: Gnomish Gearworks, Level 2
      111985, -- Garrison Blueprint: Gnomish Gearworks, Level 3
      116200, -- Garrison Blueprint: Goblin Workshop, Level 2
      116201, -- Garrison Blueprint: Goblin Workshop, Level 3
      109577, -- Garrison Blueprint: Herb Garden, Level 2
      111997, -- Garrison Blueprint: Herb Garden, Level 3
      109254, -- Garrison Blueprint: Lumber Mill, Level 2
      109255, -- Garrison Blueprint: Lumber Mill, Level 3
      109576, -- Garrison Blueprint: Lunarfall Excavation, Level 2
      111996, -- Garrison Blueprint: Lunarfall Excavation, Level 3
      107694, -- Garrison Blueprint: Lunarfall Inn, Level 2
      109065, -- Garrison Blueprint: Lunarfall Inn, Level 3
      109062, -- Garrison Blueprint: Mage Tower, Level 2
      109063, -- Garrison Blueprint: Mage Tower, Level 3
      111998, -- Garrison Blueprint: Menagerie, Level 2
      111999, -- Garrison Blueprint: Menagerie, Level 3
      111957, -- Garrison Blueprint: Salvage Yard, Level 1
      111976, -- Garrison Blueprint: Salvage Yard, Level 2
      111977, -- Garrison Blueprint: Salvage Yard, Level 3
      111815, -- Garrison Blueprint: Scribe's Quarters, Level 1
      111978, -- Garrison Blueprint: Scribe's Quarters, Level 2
      111979, -- Garrison Blueprint: Scribe's Quarters, Level 3
      116196, -- Garrison Blueprint: Spirit Lodge, Level 2
      116197, -- Garrison Blueprint: Spirit Lodge, Level 3
      112002, -- Garrison Blueprint: Stables, Level 2
      112003, -- Garrison Blueprint: Stables, Level 3
      111982, -- Garrison Blueprint: Storehouse, Level 2
      111983, -- Garrison Blueprint: Storehouse, Level 3
      111816, -- Garrison Blueprint: Tailoring Emporium, Level 1
      111992, -- Garrison Blueprint: Tailoring Emporium, Level 2
      111993, -- Garrison Blueprint: Tailoring Emporium, Level 3
      111813, -- Garrison Blueprint: The Forge, Level 1
      111990, -- Garrison Blueprint: The Forge, Level 2
      111991, -- Garrison Blueprint: The Forge, Level 3
      111818, -- Garrison Blueprint: The Tannery, Level 1
      111988, -- Garrison Blueprint: The Tannery, Level 2
      111989, -- Garrison Blueprint: The Tannery, Level 3
      111986, -- Garrison Blueprint: Trading Post, Level 2
      111987, -- Garrison Blueprint: Trading Post, Level 3
      116185, -- Garrison Blueprint: War Mill, Level 2
      116186, -- Garrison Blueprint: War Mill, Level 3
      127267, -- Ship Blueprint: Carrier
      127268, -- Ship Blueprint: Transport
      127269, -- Ship Blueprint: Battleship (horde)
      127270, -- Ship Blueprint: Submarine
      127268, -- Ship Blueprint: Transport
      126900, -- Ship Blueprint: Destroyer
      128492, -- Ship Blueprint: Battleship (alliance)
      ------- Blueprints dropped by rare mobs in Tanaan Jungle
      126950, -- Equipment Blueprint: Bilge Pump
      128258, -- Equipment Blueprint: Felsmoke Launchers
      128232, -- Equipment Blueprint: High Intensity Fog Lights
      128255, -- Equipment Blueprint: Ice Cutter
      128231, -- Equipment Blueprint: Trained Shark Tank
      128252, -- Equipment Blueprint: True Iron Rudder
      128257, -- Equipment Blueprint: Ghostly Spyglass
      ------- Other blueprints
      128256, -- Equipment Blueprint: Gyroscopic Internal Stabilizer
      128250, -- Equipment Blueprint: Unsinkable
      128251, -- Equipment Blueprint: Tuskarr Fishing Net
      128260, -- Equipment Blueprint: Blast Furnace
      128490, -- Blueprint: Oil Rig
      128444, -- Blueprint: Oil Rig
    }
    AddToSet(Result, IDs)
  end
  
  return Result
end

local function Tooltip_Init()
  local Result, leftside = CreateFrame("GameTooltip"), {}
  for i = 1,6 do
    local L,R = Result:CreateFontString(), Result:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    Result:AddFontStrings(L,R)
    leftside[i] = L
  end
  Result.leftside = leftside
  return Result
end

local function unescape(String)
  local Result = tostring(String)
  Result = gsub(Result, "|c........", "") -- Remove color start.
  Result = gsub(Result, "|r", "") -- Remove color end.
  Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
  Result = gsub(Result, "|T.-|t", "") -- Remove textures.
  Result = gsub(Result, "{.-}", "") -- Remove raid target icons.
  return Result
end

function AddToSet(Set, List)
  for _, v in ipairs(List) do
    Set[v] = true
  end
end

local setFilter = AdiBags:RegisterFilter("Garrison", 92, 'ABEvent-1.0')
setFilter.uiName = L["Garrison"]
setFilter.uiDesc = L["Garrison items group."]

function setFilter:OnInitialize()
  self.db = AdiBags.db:RegisterNamespace("Garrison", {
    profile = {
	   flagWorkOrders = true, 
      flagFollowers = true,
		flagShipyard = true, 
      flagIronHorde = true,
      flagMiningConsumables = true,
      flagBlueprints = true
    },
    char = {  },
  })
end

function setFilter:Update()
  MatchIDs = nil
  self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
  AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
  AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
  MatchIDs = MatchIDs or MatchIDs_Init(self)
  if MatchIDs[slotData.itemId] then
    return L["Garrison"]
  elseif self.db.profile.flagShipyard then
    Tooltip = Tooltip or Tooltip_Init()
    Tooltip:SetOwner(UIParent,"ANCHOR_NONE")
    Tooltip:ClearLines()
    if slotData.bag == BANK_CONTAINER then
      Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
    else
      Tooltip:SetBagItem(slotData.bag, slotData.slot)
    end
    for i = 1,6 do
      local t = unescape(Tooltip.leftside[i]:GetText())
      if t == BIext['Naval Equipment'] then
        return L["Garrison"]
      end
    end
    Tooltip:Hide()
  end
end

function setFilter:GetOptions()
  return {
    flagWorkOrders = {
      name  = L["Basic Work Orders"],
      desc  = L["Show materials, like seeds, stone, timber, caged beasts and others, in this group."],
      type  = 'toggle',
      width = 'double',
      order = 10,
    },
    flagFollowers = {
      name  = L["Follower items"],
      desc  = L["Show follower enhancements and contracts in this group."],
      type  = 'toggle',
      width = 'double',
      order = 20,
    },
    flagShipyard = {
      name  = L["Naval Equipment"],
      desc  = L["Show ships enhancements in this group."],
      type  = 'toggle',
      width = 'double',
      order = 30,
    },
    flagIronHorde = {
      name  = L["Iron Horde"],
      desc  = L["Show Dwarven Bunker / War Mill items, like Iron Horde Scraps, in this group."],
      type  = 'toggle',
      width = 'double',
      order = 40,
    },
    flagMiningConsumables = {
      name  = L["Mining Coffee & Pick"],
      desc  = L["Show Miner's Coffee and Preserved Mining Pick in this group."],
      type  = 'toggle',
      width = 'double',
      order = 50,
    },
    flagBlueprints = {
      name  = L["Blueprints"],
      desc  = L["Show the plans needed to build in garrison in this group."],
      type  = 'toggle',
      width = 'double',
      order = 60,
    },
  }, AdiBags:GetOptionHandler(self, false, function() return self:Update() end)
end

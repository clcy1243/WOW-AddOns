local BestInSlot = LibStub("AceAddon-3.0"):GetAddon("BestInSlot")
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local filter = AdiBags:RegisterFilter("BestInSlot", 83)
filter.uiName = "BestInSlot"
filter.uiDesc = "Items that are considered BestInSlot will be moved to this category"

local function hasEntries(tbl)
  for k,v in pairs(tbl) do
    return true
  end
  return false
end

function filter:Filter(slotData)
  local bisTable = BestInSlot:IsItemBestInSlot(slotData.itemId)
  if bisTable and hasEntries(bisTable) then
    return "BestInSlot"
  end
end
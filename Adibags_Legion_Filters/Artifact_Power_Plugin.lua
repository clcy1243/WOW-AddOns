local AddonName, AddonTable = ...
local L = AddonTable.L

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
--AdiBags plugin for showing values on Artifact Power Token Icons
local mod = AdiBags:NewModule(L["Artifact Power Values"], 'ABEvent-1.0')
local texts = {}
local function CreateText(button)
   local text = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
   text:SetPoint("TOPLEFT", button, 3, -1)
   text:Hide()
   texts[button] = text
   return text
end
function mod:OnEnable()
   self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
   self:SendMessage('AdiBags_UpdateAllButtons')
end
function mod:OnDisable()
   for _, text in pairs(texts) do
      text:Hide()
   end
end

function mod:UpdateButton(event, button)
   local itemId = button.itemId
   local text = texts[button]
   
   if AddonTable.ItemTables.ArtifactItems[itemId] then
      text = text or CreateText(button)
      local color = BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT]
      text:SetTextColor(color.r,color.g,color.b,1)

      local itemLink = button:GetItemLink()
      local bonus1,upgrade = select(15,strsplit(":",itemLink))  --The Artifact Knowledge for a token can be stored in 2 places.
      local level = tonumber(upgrade) or tonumber(bonus1) --upgrade orverrides bonus1
      if not level then
         DebugPrint(itemLink:gsub("\124", "\124\124") .. " unable to get artifact knowledge level") 
         text:SetText("?")
         return text:Show()
      end
      level = math.min(level,25) --TODO: Change Artifact Knowledge cap to a constant
      if not AddonTable.ItemTables.ArtifactItems[itemId] then print(itemLink,itemId,level) return end
      local value = AddonTable.ItemTables.ArtifactItems[itemId][level]
      if not value then --data table is missing a value
         DebugPrint("Unable to find Artifact Power for :"..itemLink:gsub("\124", "\124\124").." level:"..level)
         value = "???"
      end
      text:SetText(value)
      return text:Show()
   elseif AddonTable.ItemTables.AncientManaItems[itemId] then
      text = text or CreateText(button)
      local color = {r=.75, g=.75, b=1.00}
      text:SetTextColor(color.r,color.g,color.b,1)
      local value = AddonTable.ItemTables.AncientManaItems[itemId]
      if not value then --data table is missing a value
         DebugPrint("Unable to find AncientMana for :"..itemId)
         value = "???"
      end
      text:SetText(value)
      return text:Show()
   else
      if text then
         text:Hide()
      end
      return
   end
end
AdiBags:SendMessage('AdiBags_UpdateAllButtons')
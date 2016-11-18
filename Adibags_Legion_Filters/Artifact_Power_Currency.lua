local AddonName, AddonTable = ...
local L = AddonTable.L

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local CurrencyModule = AdiBags:GetModule("CurrencyFrame")
local APICON = "\124TInterface\\Artifacts\\ArtifactRunes.BLP:0:0:2:-2:512:512:168:232:248:312:255:255:255\124t"

local mod = AdiBags:NewModule(L["Artifact Power Currency"], 'ABEvent-1.0', "AceHook-3.0")

local hooked = false
local updateNeeded = false
local shouldUpdate = false

--returns the total Artifact Power from all items in the player's bags (0-4)
local function CalculateArtifactPower()
   local totalPower = 0
   for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
      for slot = 0, GetContainerNumSlots(bag) do
         local itemId = GetContainerItemID(bag,slot)
         if itemId then
            if AddonTable.ItemTables.ArtifactItems[itemId] then --Item is an artifact power item
               local itemLink = GetContainerItemLink(bag,slot)
               local bonus1,upgrade = select(15,strsplit(":",itemLink))  --The Artifact Knowledge for a token can be stored in 2 places.
               local level = tonumber(upgrade) or tonumber(bonus1) --upgrade orverrides bonus1

               local value = AddonTable.ItemTables.ArtifactItems[itemId][level]
               totalPower = totalPower + value
            end
         end
      end
   end
   return BreakUpLargeNumbers(totalPower)
end

function mod:AddArtifactPower(module,...)
   if not CurrencyModule.widget then return end
   local widget, fs = CurrencyModule.widget, CurrencyModule.fontstring
   self.hooks[CurrencyModule]["Update"](CurrencyModule,...) --Call original Update Function
   -- print("Currency Updated")
   --Add our text at the end and update the width
   fs:SetText(fs:GetText()..CalculateArtifactPower()..APICON)
   widget:SetSize(
      fs:GetStringWidth(),
      ceil(fs:GetStringHeight()) + 3
   )
end

function mod:BAG_UPDATE_DELAYED()
   -- print("BAG_UPDATE_DELAYED " .. tostring(shouldUpdate))
   if shouldUpdate then
      mod:AddArtifactPower()
   else
      updateNeeded = true --We didnt update, but we will need to later
   end
end


function mod:OnEnable()
   mod:RawHook(CurrencyModule,"Update","AddArtifactPower")
   hooked = true
   mod:AddArtifactPower(CurrencyModule)
   self:RegisterEvent("BAG_UPDATE_DELAYED")
   self:RegisterMessage("AdiBags_BagOpened")
   self:RegisterMessage("AdiBags_BagClosed")
end

function mod:AdiBags_BagOpened(message,bagName,bag)
   if bagName == "Backpack" then
      shouldUpdate = true
      if updateNeeded then
         mod:AddArtifactPower()
         updateNeeded = false
      end
   end
end
function mod:AdiBags_BagClosed(message,bagName,bag)
   if bagName == "Backpack" then
      shouldUpdate = false
   end
end


function mod:OnDisable()
   if hooked then
      local originalFunc = self.hooks[CurrencyModule]["Update"]
      self:Unhook(CurrencyModule,"Update")
      hooked = false
      originalFunc(CurrencyModule)
   end
   self:UnregisterAllEvents()
end
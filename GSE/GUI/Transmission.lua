local GSE = GSE

local Statics = GSE.Static




local GSold = false
local L = GSE.L
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local AceGUI = LibStub("AceGUI-3.0")
local Completing = LibStub("AceGUI-3.0-Completing-EditBox")
local libS = LibStub:GetLibrary("AceSerializer-3.0")
local libC = LibStub:GetLibrary("LibCompress")
local libCE = libC:GetAddonEncodeTable()
local LibQTip = LibStub('LibQTip-1.0')
local LibSharedMedia = LibStub('LibSharedMedia-3.0')

local dataobj = ldb:NewDataObject(L["GSE"] .." ".. L["GnomeSequencer-Enhanced"], {type = "data source", text = "/gse"})

local transauthor = GetUnitName("player", true) .. '@' .. GetRealmName()
local transauthorlen = string.len(transauthor)

local transmissionFrame = AceGUI:Create("Frame")
GSE.GUITransmissionFrame = transmissionFrame


Completing:Register ("ExampleAll", AUTOCOMPLETE_LIST.WHISPER)


GSE.PrintDebugMessage("GSE Version " .. GSE.VersionString, Statics.SourceTransmission)


local function GSSendMessage(tab, channel, target)
  local _, instanceType = IsInInstance()
  GSE.PrintDebugMessage(tab.Command, Statics.SourceTransmission)
  if tab.Command == "GS-E_TRANSMITSEQUENCE" then
    GSE.PrintDebugMessage(tab.SequenceName, Statics.SourceTransmission)
    GSE.PrintDebugMessage(GSE.isEmpty(tab.Sequence))
    GSE.PrintDebugMessage(GSE.ExportSequence(tab.Sequence,tab.SequenceName), Statics.SourceTransmission)
  end
  local transmission = GSE.EncodeMessage(tab)
  GSE.PrintDebugMessage("Transmission: \n" .. transmission, Statics.SourceTransmission)
  if GSE.isEmpty(channel) then
    if IsInRaid() then
      channel = (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID"
    else
      channel = (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY"
    end
  end
  GSE:SendCommMessage(Statics.CommPrefix, transmission, channel, target)

end

local function performVersionCheck(version)
  if(tonumber(version) ~= nil and tonumber(version) > tonumber(GSE.VersionString)) then
    if not GSold then
      GSE.Print(L["GSE is out of date. You can download the newest version from https://mods.curse.com/addons/wow/gnomesequencer-enhanced."], Statics.SourceTransmission)
      GSold = true
      if((tonumber(version) - tonumber(GSE.VersionString)) >= 5) then
        StaticPopup_Show('GSE_UPDATE_AVAILABLE')
      end
    end
  end
end

function GSE.EncodeMessage(Sequence)

  local one = libS:Serialize(Sequence)
  GSE.PrintDebugMessage ("Compress Stage 1: " .. one, Statics.SourceTransmission)
  local two = libC:Compress(one)
  GSE.PrintDebugMessage ("Compress Stage 2: " .. two, Statics.SourceTransmission)
  local final = libCE:Encode(two)
  GSE.PrintDebugMessage ("Compress Stage Result: " .. final, Statics.SourceTransmission)
  return final
end

function GSE.DecodeMessage(data)
  -- Decode the compressed data
  local one = libCE:Decode(data)

  --Decompress the decoded data
  local two, message = libC:Decompress(one)
  if(not two) then
    GSE.PrintDebugMessage ("YourAddon: error decompressing: " .. message, Statics.SourceTransmission)
    return
  end

  -- Deserialize the decompressed data
  local success, final = libS:Deserialize(two)
  if (not success) then
    GSE.PrintDebugMessage ("YourAddon: error deserializing " .. final, Statics.SourceTransmission)
    return
  end

  GSE.PrintDebugMessage ("Data Finalised", Statics.SourceTransmission)
  return success, final
end

function GSE.TransmitSequence(key, channel, target)
  local t = {}
  t.Command = "GS-E_TRANSMITSEQUENCE"
  local elements = GSE.split(key, ",")
  local classid = tonumber(elements[1])
  local SequenceName = elements[2]
  GSE.PrintDebugMessage("Sending Seqence [" .. classid .. "][" .. SequenceName .. "]", Statics.SourceTransmission )
  t.ClassID = classid
  t.SequenceName = SequenceName
  t.Sequence = GSELibrary[classid][SequenceName]
  GSSendMessage(t, channel, target)
  GSE.GUITransmissionFrame:SetStatusText(SequenceName .. L[" sent"])
end

local function ReceiveSequence(classid, SequenceName, Sequence, sender)
  local version = GSGetNextSequenceVersion(SequenceName)
  GSE.AddSequenceToCollection(SequenceName, Sequence, classid)
  GSE.Print(L["Received Sequence "] .. SequenceName .. L[" from "] .. sender )
end


function GSE:OnCommReceived(prefix, message, distribution, sender)
  GSE.PrintDebugMessage("GSE:onCommReceived", Statics.SourceTransmission)
  GSE.PrintDebugMessage(prefix .. " " .. message .. " " .. distribution .. " " .. sender, Statics.SourceTransmission)
  local success, t = GSE.DecodeMessage(message)
  if success then
    if t.Command == "GS-E_VERSIONCHK" then
      if not GSold then
        performVersionCheck(t.Version)
      end
    elseif t.Command == "GS-E_TRANSMITSEQUENCE" then
      if sender ~= GetUnitName("player", true) then
        ReceiveSequence(t.ClassID, t.SequenceName, t.Sequence, sender)
      else
        GSE.PrintDebugMessage("Ignoring Sequence from me.", Statics.SourceTransmission)
        GSE.PrintDebugMessage(GSE.ExportSequence(t.Sequence, t.SequenceName), Statics.SourceTransmission)
      end
    end
  end
end


local function sendVersionCheck()
  if not GSold then
    local _, instanceType = IsInInstance()
    local t = {}
    t.Command = "GS-E_VERSIONCHK"
    t.Version = GSE.VersionString
    GSSendMessage(t)
  end
end

function GSE:GROUP_ROSTER_UPDATE(...)
  sendVersionCheck()
end


GSE:RegisterComm("GSE")
GSE:RegisterEvent("GROUP_ROSTER_UPDATE")
local baseFont = CreateFont("baseFont")

-- CHeck for ElvUI
if GSE.isEmpty(ElvUI) then
  baseFont:SetFont(GameTooltipText:GetFont(), 10)
elseif LibSharedMedia:IsValid('font', ElvUI[1].db.general.font) then
  baseFont:SetFont(LibSharedMedia:Fetch('font', ElvUI[1].db.general.font), 10)
else
  baseFont:SetFont(GameTooltipText:GetFont(), 10)
end

function dataobj:OnEnter()
  -- Acquire a tooltip with 3 columns, respectively aligned to left, center and right
  --local tooltip = LibQTip:Acquire("GSSE", 3, "LEFT", "CENTER", "RIGHT")
  local tooltip = LibQTip:Acquire("GSSE", 1,"CENTER")
  self.tooltip = tooltip

  tooltip:Clear()
  tooltip:SetFont(baseFont)
  --tooltip:SetHeaderFont(red17font)
  tooltip:AddLine(L["GS-E: Left Click to open the Sequence Editor"])
  tooltip:AddLine(L["GS-E: Middle Click to open the Transmission Interface"])
  tooltip:AddLine(L["GS-E: Right Click to open the Sequence Debugger"])

  -- Use smart anchoring code to anchor the tooltip to our frame
  tooltip:SmartAnchorTo(self)

  -- Show it, et voil� !
  tooltip:Show()
end

function dataobj:OnLeave()
  -- Release the tooltip
  LibQTip:Release(self.tooltip)
  self.tooltip = nil
end

-- function dataobj:OnTooltipShow()
--
-- end

function dataobj:OnClick(button)
  if button == "LeftButton" then
    GSE.GUIShowViewer()
  elseif button == "MiddleButton" then
    GSE.GUIShowTransmissionGui()
  elseif button == "RightButton" then
    GSDebugFrame:Show()
  end
end

local transSequencevalue = ""

transmissionFrame:SetTitle(L["Send To"])
transmissionFrame:SetCallback("OnClose", function(widget) transmissionFrame:Hide() end)
transmissionFrame:SetLayout("List")
transmissionFrame:SetWidth(290)
transmissionFrame:SetHeight(190)
transmissionFrame:Hide()


local SequenceListbox = AceGUI:Create("Dropdown")
--SequenceListbox:SetLabel(L["Load Sequence"])
SequenceListbox:SetWidth(250)
SequenceListbox:SetCallback("OnValueChanged", function (obj,event,key) transSequencevalue = key end)
transmissionFrame.SequenceListbox = SequenceListbox
transmissionFrame:AddChild(SequenceListbox)

local playereditbox = AceGUI:Create("EditBoxExampleAll")
playereditbox:SetLabel(L["Send To"])
playereditbox:SetWidth(250)
playereditbox:DisableButton(true)
transmissionFrame:AddChild(playereditbox)

local sendbutton = AceGUI:Create("Button")
sendbutton:SetText(L["Send"])
sendbutton:SetWidth(250)
sendbutton:SetCallback("OnClick", function() GSE.TransmitSequence(transSequencevalue, "WHISPER", playereditbox:GetText()) end)
transmissionFrame:AddChild(sendbutton)

function GSE.GUIShowTransmissionGui(inckey)
  if GSE.GUIViewFrame:IsVisible() then
    local point, relativeTo, relativePoint, xOfs, yOfs = GSE.GUIViewFrame:GetPoint()
    --	GSE.GUITransmissionFrame:SetPoint("CENTRE" , (left/2)+(width/2), bottom )
    GSE.GUITransmissionFrame:SetPoint(point, xOfs + 500, yOfs + 155)

  end
  if GSE.GUIEditFrame:IsVisible() then
    local point, relativeTo, relativePoint, xOfs, yOfs = GSE.GUIEditFrame:GetPoint()
    --	GSE.GUITransmissionFrame:SetPoint("CENTRE" , (left/2)+(width/2), bottom )
    GSE.GUITransmissionFrame:SetPoint(point, xOfs + 500, yOfs + 155)

  end

  local names = GSE.GetSequenceNames()
  GSE.GUITransmissionFrame.SequenceListbox:SetList(names)
  if not GSE.isEmpty(inckey) then
    GSE.GUITransmissionFrame.SequenceListbox:SetValue(inckey)
    transSequencevalue = inckey
  end
  transmissionFrame:Show()
  GSE.GUITransmissionFrame:SetStatusText(L["Ready to Send"])
end

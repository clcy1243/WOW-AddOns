local AceGUI = LibStub("AceGUI-3.0")

local C_LFGList_ReportSearchResult = C_LFGList.ReportSearchResult
local ChatFrame_SendTell = ChatFrame_SendTell
local EasyMenu = EasyMenu

local LFGListSearchReporter =
{
	func = function(self, ...)C_LFGList_ReportSearchResult(...)end,
	notCheckable = true,
}
LFGListSearchReporter.__index = LFGListSearchReporter

function LFGListSearchReporter:new(o)
	setmetatable(o,self)
	return o
end

local LFG_LIST_SEARCH_ENTRY_MENU

local function GetSearchEntryMenu(resultID)
	LFGListSearchReporter.arg1 = resultID;
	if LFG_LIST_SEARCH_ENTRY_MENU == nil then
		LFG_LIST_SEARCH_ENTRY_MENU =
		{
			LFGListSearchReporter:new(
			{
				text = WHISPER_LEADER,
				func = function(_, id)
					local leaderName = select(13,C_LFGList.GetSearchResultInfo(id))
					if leaderName then
						ChatFrame_SendTell(leaderName)
					end
				end,
			}),
			{
				text = LFG_LIST_REPORT_GROUP_FOR,
				hasArrow = true,
				notCheckable = true,
				menuList =
				{
					LFGListSearchReporter:new({text = LFG_LIST_BAD_NAME,arg2 = "lfglistname"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_DESCRIPTION,arg2 = "lfglistcomment"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,arg2 = "lfglistvoicechat"}),
					LFGListSearchReporter:new({text = LFG_LIST_BAD_LEADER_NAME,arg2 = "badplayername"}),
				},
			},
			{
				text = CANCEL,
				notCheckable = true,
			},
		}
	end
	return LFG_LIST_SEARCH_ENTRY_MENU;
end

local function AlignImage(self)
	local img = self.image:GetTexture()
	self.text:ClearAllPoints()
	if not img then
		self.text:SetPoint("LEFT", self.checkbg, "RIGHT")
		self.text:SetPoint("RIGHT")
	else
		self.text:SetPoint("LEFT", self.image,"RIGHT", 1, 0)
		self.text:SetPoint("RIGHT")
	end
end

AceGUI:RegisterWidgetType("LookingForGroup_search_result_checkbox", function()
	local check = AceGUI:Create("CheckBox")
	local frame = check.frame
	frame:RegisterForClicks("LeftButtonDown","RightButtonDown")
	frame:SetScript("OnMouseUp",function(self,button)
		local obj = self.obj
		local user = obj:GetUserDataTable()
		if button == "LeftButton" then
			if not obj.disabled then
--				obj:ToggleChecked()
				if obj.checked then
					PlaySound("igMainMenuOptionCheckBoxOn")
				else -- for both nil and false (tristate)
					PlaySound("igMainMenuOptionCheckBoxOff")
				end
				
				obj:Fire("OnValueChanged", obj.checked)
				AlignImage(obj)
			end
		else
			local val = user.val
			EasyMenu(GetSearchEntryMenu(val), LFGListFrameDropDown, self , 20, 0, "MENU")				
		end
	end)
	check.width = "fill"
	return AceGUI:RegisterAsWidget(check)
end, 1)

--变量
local id = 1;
local _G = _G;
local rl = "";

--设置面板
UnitFramesPlus_OptionsFrame = CreateFrame("Frame", "UnitFramesPlus_OptionsFrame", UIParent);
UnitFramesPlus_OptionsFrame.name = "UnitFramesPlus";
InterfaceOptions_AddCategory(UnitFramesPlus_OptionsFrame);
UnitFramesPlus_OptionsFrame:SetScript("OnShow", function()
    UnitFramesPlus_OptionPanel_OnShow();
end)

--快速焦点快捷键下拉菜单
local QuickFocusDropDown = {"alt", "shift", "ctrl"};
local function QuickFocus_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusQuickDropDown, self:GetID());
    UnitFramesPlus_FocusQuickClear(QuickFocusDropDown[UnitFramesPlusDB["focus"]["button"]]);
    UnitFramesPlusDB["focus"]["button"] = self:GetID();
    UnitFramesPlus_FocusQuick();
end
local function QuickFocus_Init()
    local info, text, func;
    for id = 1, 3, 1 do
        info = {
            text = QuickFocusDropDown[id];
            func = QuickFocus_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

--边框类型下拉菜单
local PlayerDragonBorderTypeDropDown = {UFP_OP_Player_Elite, UFP_OP_Player_RareElite, UFP_OP_Player_Rare};
local function PlayerDragonBorderType_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType, self:GetID());
    UnitFramesPlusDB["player"]["bordertype"] = self:GetID();
    UnitFramesPlus_PlayerDragon();
end
local function PlayerDragonBorderType_Init()
    local info, text, func;
    for id = 1, 3, 1 do
        info = {
            text = PlayerDragonBorderTypeDropDown[id];
            func = PlayerDragonBorderType_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

--玩家生命值/法力值/百分比下拉菜单
local PlayerHPMPPctDropDown = {UFP_OP_Player_NumCur, UFP_OP_Player_NumMax, UFP_OP_Player_NumLoss, UFP_OP_Player_Pct, UFP_OP_Player_None};
local function PlayerHPMPPctPartOne_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne, self:GetID());
    UnitFramesPlusDB["player"]["hpmppartone"] = self:GetID();
    UnitFramesPlus_PlayerHPValueDisplayUpdate();
    UnitFramesPlus_PlayerMPValueDisplayUpdate();
end
local function PlayerHPMPPctPartOne_Init()
    local info, text, func;
    for id = 1, 4, 1 do
        info = {
            text = PlayerHPMPPctDropDown[id];
            func = PlayerHPMPPctPartOne_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end
local function PlayerHPMPPctPartTwo_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo, self:GetID());
    UnitFramesPlusDB["player"]["hpmpparttwo"] = self:GetID();
    UnitFramesPlus_PlayerHPValueDisplayUpdate();
    UnitFramesPlus_PlayerMPValueDisplayUpdate();
end
local function PlayerHPMPPctPartTwo_Init()
    local info, text, func;
    for id = 1, 5, 1 do
        info = {
            text = PlayerHPMPPctDropDown[id];
            func = PlayerHPMPPctPartTwo_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

--目标生命值/法力值/百分比下拉菜单
local TargetHPMPPctDropDown = {UFP_OP_Player_NumCur, UFP_OP_Player_NumMax, UFP_OP_Player_NumLoss, UFP_OP_Player_Pct, UFP_OP_Player_None};
local function TargetHPMPPctPartOne_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne, self:GetID());
    UnitFramesPlusDB["target"]["hpmppartone"] = self:GetID();
    UnitFramesPlus_TargetHPValueDisplayUpdate();
    UnitFramesPlus_TargetMPValueDisplayUpdate();
end
local function TargetHPMPPctPartOne_Init()
    local info, text, func;
    for id = 1, 4, 1 do
        info = {
            text = TargetHPMPPctDropDown[id];
            func = TargetHPMPPctPartOne_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end
local function TargetHPMPPctPartTwo_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo, self:GetID());
    UnitFramesPlusDB["target"]["hpmpparttwo"] = self:GetID();
    UnitFramesPlus_TargetHPValueDisplayUpdate();
    UnitFramesPlus_TargetMPValueDisplayUpdate();
    UnitFramesPlus_TargetPosition();
end
local function TargetHPMPPctPartTwo_Init()
    local info, text, func;
    for id = 1, 5, 1 do
        info = {
            text = TargetHPMPPctDropDown[id];
            func = TargetHPMPPctPartTwo_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

--焦点生命值/法力值/百分比下拉菜单
local FocusHPMPPctDropDown = {UFP_OP_Player_NumCur, UFP_OP_Player_NumMax, UFP_OP_Player_NumLoss, UFP_OP_Player_Pct, UFP_OP_Player_None};
local function FocusHPMPPctPartOne_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne, self:GetID());
    UnitFramesPlusDB["focus"]["hpmppartone"] = self:GetID();
    UnitFramesPlus_FocusHPValueDisplayUpdate();
    UnitFramesPlus_FocusMPValueDisplayUpdate();
end
local function FocusHPMPPctPartOne_Init()
    local info, text, func;
    for id = 1, 4, 1 do
        info = {
            text = FocusHPMPPctDropDown[id];
            func = FocusHPMPPctPartOne_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end
local function FocusHPMPPctPartTwo_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo, self:GetID());
    UnitFramesPlusDB["focus"]["hpmpparttwo"] = self:GetID();
    UnitFramesPlus_FocusHPValueDisplayUpdate();
    UnitFramesPlus_FocusMPValueDisplayUpdate();
end
local function FocusHPMPPctPartTwo_Init()
    local info, text, func;
    for id = 1, 5, 1 do
        info = {
            text = FocusHPMPPctDropDown[id];
            func = FocusHPMPPctPartTwo_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

--Party Buff过滤
local PartyBuffFilterTypeDropDown = {
    UFP_OP_FilterAll, 
    UFP_OP_FilterCancel1, 
    UFP_OP_FilterCancel2, 
    UFP_OP_FilterCaster1, 
    _G[UFP_OP_FilterCaster1..", "..UFP_OP_FilterCancel1],
    _G[UFP_OP_FilterCaster1..", "..UFP_OP_FilterCancel2],
    UFP_OP_FilterCaster2, 
    _G[UFP_OP_FilterCaster2..", "..UFP_OP_FilterCancel1],
    _G[UFP_OP_FilterCaster2..", "..UFP_OP_FilterCancel2]
};
local function PartyBuffFilterType_OnClick(self)
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PartyBuffFilterType, self:GetID());
    UnitFramesPlusDB["party"]["filtertype"] = self:GetID();
end
local function PartyBuffFilterType_Init()
    local info, text, func;
    for id = 1, 9, 1 do
        info = {
            text = PartyBuffFilterTypeDropDown[id];
            func = PartyBuffFilterType_OnClick;
        };
        UIDropDownMenu_AddButton(info);
    end
end

StaticPopupDialogs["UFP_MOUSESHOW"] = {
    text = UFP_OP_Mouseshow_info,
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    OnAccept = function()
        InterfaceOptionsFrame:Hide();
        GameMenuButtonUIOptions:Click();
        InterfaceOptionsFrameCategoriesButton3:Click();
    end,
    timeout = 0,
    hideOnEscape = 1,
    exclusive = 1,
    whileDead = 1,
    preferredIndex = 3,
}

StaticPopupDialogs["UFP_RELOADUI"] = {
    text = UFP_OP_Reload_info,
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    OnAccept = function()
        if rl == "origin" then
            UnitFramesPlusDB["party"]["origin"] = 1 - UnitFramesPlusDB["party"]["origin"];
            if tonumber(GetCVar("useCompactPartyFrames")) == UnitFramesPlusDB["party"]["origin"] then
                CompactUnitFrameProfilesRaidStylePartyFrames:Click();
            end
        end
        ReloadUI();
    end,
    timeout = 0,
    hideOnEscape = 1,
    exclusive = 1,
    whileDead = 1,
    preferredIndex = 3,
}

do
    --插件介绍
    local info = UnitFramesPlus_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    info:SetPoint("TOPLEFT", 16, -16);
    info:SetText("UnitFramesPlus v"..GetAddOnMetadata("UnitFramesPlus", "Version"));

    local infotext = UnitFramesPlus_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    infotext:SetPoint("TOPLEFT", info, "TOPLEFT", 0, -40);
    infotext:SetTextColor(1, 1, 1);
    infotext:SetText(UFP_OP_InfoText);

    local infotext2 = UnitFramesPlus_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    infotext2:SetPoint("TOPLEFT", infotext, "TOPLEFT", 0, -30);
    infotext2:SetTextColor(1, 1, 1);
    infotext2:SetText(UFP_OP_InfoText2);

    local infotext3 = UnitFramesPlus_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    infotext3:SetPoint("TOPLEFT", infotext2, "TOPLEFT", 0, -40);
    infotext3:SetTextColor(1, 1, 1);
    infotext3:SetText(UFP_OP_InfoText3);

    --全局设置菜单
    local UnitFramesPlus_Global_Options = CreateFrame("Frame", "UnitFramesPlus_Global_Options", UIParent);
    UnitFramesPlus_Global_Options.name = UFP_OP_Global_Options;
    UnitFramesPlus_Global_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Global_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Global_Options);

    --玩家设置菜单
    local UnitFramesPlus_Player_Options = CreateFrame("Frame", "UnitFramesPlus_Player_Options", UIParent);
    UnitFramesPlus_Player_Options.name = "├"..UFP_OP_Player_Options;
    UnitFramesPlus_Player_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Player_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Player_Options);

    --玩家宠物设置菜单
    local UnitFramesPlus_Pet_Options = CreateFrame("Frame", "UnitFramesPlus_Pet_Options", UIParent);
    UnitFramesPlus_Pet_Options.name = "├─"..UFP_OP_Pet_Options;
    UnitFramesPlus_Pet_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Pet_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Pet_Options);

    --目标设置菜单
    local UnitFramesPlus_Target_Options = CreateFrame("Frame", "UnitFramesPlus_Target_Options", UIParent);
    UnitFramesPlus_Target_Options.name = "├"..UFP_OP_Target_Options;
    UnitFramesPlus_Target_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Target_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Target_Options);

    --目标的目标设置菜单
    local UnitFramesPlus_TargetTarget_Options = CreateFrame("Frame", "UnitFramesPlus_TargetTarget_Options", UIParent);
    UnitFramesPlus_TargetTarget_Options.name = "├─"..UFP_OP_ToT_Options;
    UnitFramesPlus_TargetTarget_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_TargetTarget_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_TargetTarget_Options);

    --焦点设置菜单
    local UnitFramesPlus_Focus_Options = CreateFrame("Frame", "UnitFramesPlus_Focus_Options", UIParent);
    UnitFramesPlus_Focus_Options.name = "├"..UFP_OP_Focus_Options;
    UnitFramesPlus_Focus_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Focus_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Focus_Options);

    --焦点目标设置菜单
    local UnitFramesPlus_FocusTarget_Options = CreateFrame("Frame", "UnitFramesPlus_FocusTarget_Options", UIParent);
    UnitFramesPlus_FocusTarget_Options.name = "├─"..UFP_OP_FocusTarget_Options;
    UnitFramesPlus_FocusTarget_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_FocusTarget_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_FocusTarget_Options);

    --队友设置菜单
    local UnitFramesPlus_Party_Options = CreateFrame("Frame", "UnitFramesPlus_Party_Options", UIParent);
    UnitFramesPlus_Party_Options.name = "├"..UFP_OP_Party_Options;
    UnitFramesPlus_Party_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Party_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Party_Options);

    --队友目标设置菜单
    local UnitFramesPlus_PartyTarget_Options = CreateFrame("Frame", "UnitFramesPlus_PartyTarget_Options", UIParent);
    UnitFramesPlus_PartyTarget_Options.name = "├─"..UFP_OP_PartyTarget_Options;
    UnitFramesPlus_PartyTarget_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_PartyTarget_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_PartyTarget_Options);

    --其他设置菜单
    local UnitFramesPlus_Extra_Options = CreateFrame("Frame", "UnitFramesPlus_Extra_Options", UIParent);
    UnitFramesPlus_Extra_Options.name = "└"..UFP_OP_Ext_Options;
    UnitFramesPlus_Extra_Options.parent = "UnitFramesPlus";
    UnitFramesPlus_Extra_Options:Hide();
    InterfaceOptions_AddCategory(UnitFramesPlus_Extra_Options);

    --全局设定
    local globalconfig = UnitFramesPlus_Global_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    globalconfig:SetPoint("TOPLEFT", 16, -16);
    globalconfig:SetText(UFP_OP_Global_Options);

    --恢复默认设置
    local UnitFramesPlus_OptionsFrame_Reset = CreateFrame("Button", "UnitFramesPlus_OptionsFrame_Reset", UnitFramesPlus_Global_Options, "OptionsButtonTemplate");
    UnitFramesPlus_OptionsFrame_Reset:SetPoint("TOPLEFT", globalconfig, "TOPLEFT", 2, -40);
    UnitFramesPlus_OptionsFrame_Reset:SetWidth(154);
    UnitFramesPlus_OptionsFrame_Reset:SetHeight(25);
    UnitFramesPlus_OptionsFrame_ResetText:SetText(UFP_OP_Reset);
    UnitFramesPlus_OptionsFrame_Reset:SetScript("OnClick", function(self)
        UnitFramesPlusVar["reset"] = 1;
        StaticPopup_Show("UFP_RELOADUI");
    end)

    --地图设置按钮
    local UnitFramesPlus_OptionsFrame_MinimapButton = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_MinimapButton", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_MinimapButton:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_Reset, "TOPLEFT", -2, -35);
    UnitFramesPlus_OptionsFrame_MinimapButton:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_MinimapButtonText:SetText(UFP_OP_MinimapButton_Show);
    UnitFramesPlus_OptionsFrame_MinimapButton:SetScript("OnClick", function(self)
        UnitFramesPlusDB["minimap"]["button"] = 1 - UnitFramesPlusDB["minimap"]["button"];
        UnitFramesPlus_MinimapButton();
        self:SetChecked(UnitFramesPlusDB["minimap"]["button"]==1);
    end)

    --系统状态条显示
    local UnitFramesPlus_OptionsFrame_SYSOnBar = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_SYSOnBar", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_SYSOnBar:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_MinimapButton, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_SYSOnBar:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_SYSOnBarText:SetText(UFP_OP_SYS_OnBar);
    UnitFramesPlus_OptionsFrame_SYSOnBar:SetScript("OnClick", function(self)
        --InterfaceOptionsFrame_OpenToCategory(InterfaceOptionsStatusTextPanel);
        InterfaceOptionsFrame:Hide();
        GameMenuButtonUIOptions:Click();
        InterfaceOptionsFrameCategoriesButton3:Click();
        self:SetChecked(false);
    end)

    --系统状态条显示为万亿
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        local UnitFramesPlus_OptionsFrame_SYSOnBar_Unit = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_SYSOnBar_Unit", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
        UnitFramesPlus_OptionsFrame_SYSOnBar_Unit:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_SYSOnBar, "TOPLEFT", 180, 0);
        UnitFramesPlus_OptionsFrame_SYSOnBar_Unit:SetHitRectInsets(0, -100, 0, 0);
        UnitFramesPlus_OptionsFrame_SYSOnBar_UnitText:SetText(UFP_OP_SYS_OnBar_Unit);
        UnitFramesPlus_OptionsFrame_SYSOnBar_Unit:SetScript("OnClick", function(self)
            UnitFramesPlusDB["global"]["textunit"] = 1 - UnitFramesPlusDB["global"]["textunit"];
            InterfaceOptionsStatusTextDisplayDropDown_OnClick(InterfaceOptionsDisplayPanelDisplayDropDown);
            self:SetChecked(UnitFramesPlusDB["global"]["textunit"]==1);
        end)
    end

    --全局鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_GlobalMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalMouseShow", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_SYSOnBar, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["global"]["mouseshow"] = 1 - UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlusDB["player"]["mouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_PlayerBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_PlayerMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        UnitFramesPlusDB["pet"]["mouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_PetBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_PetMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        UnitFramesPlusDB["target"]["mouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_TargetBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_TargetMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        UnitFramesPlusDB["focus"]["mouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_FocusBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_FocusMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        UnitFramesPlusDB["party"]["mouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_PartyBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_PartyMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        UnitFramesPlusDB["extra"]["pvpmouseshow"] = UnitFramesPlusDB["global"]["mouseshow"];
        UnitFramesPlus_ArenaEnemyBarTextMouseShow();
        UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
        self:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
    end)

    --全局头像类型开关
    local UnitFramesPlus_OptionsFrame_GlobalPortraitType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalPortraitType", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeText:SetText(UFP_OP_Portrait);
    UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["portrait"] = 1 - UnitFramesPlusDB["global"]["portrait"];
        if UnitFramesPlusDB["global"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            if UnitFramesPlusDB["global"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
                UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
            elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        end

        UnitFramesPlusDB["player"]["portrait"] = UnitFramesPlusDB["global"]["portrait"];
        UnitFramesPlus_OptionsFrame_PlayerPortraitType:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
        UnitFramesPlusDB["player"]["portraittype"] = UnitFramesPlusDB["global"]["portraittype"];
        UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetValue(UnitFramesPlusDB["global"]["portraittype"]);
        UnitFramesPlusDB["player"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_PlayerPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlus_PlayerPortrait();
        if UnitFramesPlusDB["player"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider);
            if UnitFramesPlusDB["player"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
                UnitFramesPlus_OptionsFrame_PlayerPortrait3DBGText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
        end

        UnitFramesPlusDB["target"]["portrait"] = UnitFramesPlusDB["global"]["portrait"];
        UnitFramesPlus_OptionsFrame_TargetPortraitType:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
        UnitFramesPlusDB["target"]["portraittype"] = UnitFramesPlusDB["global"]["portraittype"];
        UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetValue(UnitFramesPlusDB["global"]["portraittype"]);
        UnitFramesPlusDB["target"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_TargetPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlusDB["target"]["portraitnpcno"] = UnitFramesPlusDB["global"]["portraitnpcno"];
        UnitFramesPlus_TargetPortraitDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
        UnitFramesPlus_TargetPortrait();
        if UnitFramesPlusDB["target"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider);
            if UnitFramesPlusDB["target"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
                UnitFramesPlus_OptionsFrame_TargetPortrait3DBGText:SetTextColor(1, 1, 1);
            elseif UnitFramesPlusDB["target"]["portraittype"] == 2 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_TargetPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
        end

        UnitFramesPlusDB["focus"]["portrait"] = UnitFramesPlusDB["global"]["portrait"];
        UnitFramesPlus_OptionsFrame_FocusPortraitType:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
        UnitFramesPlusDB["focus"]["portraittype"] = UnitFramesPlusDB["global"]["portraittype"];
        UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetValue(UnitFramesPlusDB["global"]["portraittype"]);
        UnitFramesPlusDB["focus"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_FocusPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlusDB["focus"]["portraitnpcno"] = UnitFramesPlusDB["global"]["portraitnpcno"];
        UnitFramesPlus_FocusPortraitDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
        UnitFramesPlus_FocusPortrait();
        if UnitFramesPlusDB["focus"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider);
            if UnitFramesPlusDB["focus"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
                UnitFramesPlus_OptionsFrame_FocusPortrait3DBGText:SetTextColor(1, 1, 1);
            elseif UnitFramesPlusDB["focus"]["portraittype"] == 2 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_FocusPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
        end

        UnitFramesPlusDB["party"]["portrait"] = UnitFramesPlusDB["global"]["portrait"];
        UnitFramesPlusDB["party"]["portraittype"] = UnitFramesPlusDB["global"]["portraittype"];
        UnitFramesPlusDB["party"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        if UnitFramesPlusDB["party"]["origin"] == 1 then
            UnitFramesPlus_OptionsFrame_PartyPortraitType:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
            UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetValue(UnitFramesPlusDB["global"]["portraittype"]);
            for id = 1, 4, 1 do
                UnitFramesPlus_PartyPortrait3DBGDisplayUpdate(id);
            end
            UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
            UnitFramesPlus_PartyPortrait();
            if UnitFramesPlusDB["party"]["portrait"] == 1 then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
                if UnitFramesPlusDB["party"]["portraittype"] == 1 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
                    UnitFramesPlus_OptionsFrame_PartyPortrait3DBGText:SetTextColor(1, 1, 1);
                end
            else
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
                BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
            end
        end

        self:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
    end)

    --全局头像类型
    local UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider", UnitFramesPlus_Global_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalPortraitType, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSliderLow:SetText(UFP_OP_3D);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSliderHigh:SetText(UFP_OP_CLASS);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["global"]["portraittype"] = value;
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        elseif value == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNoText:SetTextColor(1, 1, 1);
        end

        UnitFramesPlusDB["player"]["portraittype"] = value;
        UnitFramesPlus_PlayerPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
            UnitFramesPlus_OptionsFrame_PlayerPortrait3DBGText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
        end
        UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetValue(value);

        UnitFramesPlusDB["target"]["portraittype"] = value;
        UnitFramesPlus_TargetPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            UnitFramesPlus_OptionsFrame_TargetPortrait3DBGText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
        elseif value == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_TargetPortraitNPCNoText:SetTextColor(1, 1, 1);
        end
        UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetValue(value);

        UnitFramesPlusDB["focus"]["portraittype"] = value;
        UnitFramesPlus_FocusPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            UnitFramesPlus_OptionsFrame_FocusPortrait3DBGText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
        elseif value == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_FocusPortraitNPCNoText:SetTextColor(1, 1, 1);
        end
        UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetValue(value);

        UnitFramesPlusDB["party"]["portraittype"] = value;
        if UnitFramesPlusDB["party"]["origin"] == 1 then
            UnitFramesPlus_PartyPortrait();
            if value == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
                UnitFramesPlus_OptionsFrame_PartyPortrait3DBGText:SetTextColor(1, 1, 1);
            else
                BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
            end
            UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetValue(value);
        end
    end)

    --全局3D头像背景
    local UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalPortraitType, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetText(UFP_OP_Portrait_3DBG);
    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["portrait3dbg"] = 1 - UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlusDB["player"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_PlayerPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlusDB["target"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_TargetPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlusDB["focus"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        UnitFramesPlus_FocusPortrait3DBGDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        UnitFramesPlusDB["party"]["portrait3dbg"] = UnitFramesPlusDB["global"]["portrait3dbg"];
        if UnitFramesPlusDB["party"]["origin"] == 1 then
            for id = 1, 4, 1 do
                UnitFramesPlus_PartyPortrait3DBGDisplayUpdate(id);
            end
            UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
        end
        self:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
    end)

    --全局目标为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["portraitnpcno"] = 1 - UnitFramesPlusDB["global"]["portraitnpcno"];
        UnitFramesPlusDB["target"]["portraitnpcno"] = UnitFramesPlusDB["global"]["portraitnpcno"];
        UnitFramesPlus_TargetPortraitDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
        UnitFramesPlusDB["focus"]["portraitnpcno"] = UnitFramesPlusDB["global"]["portraitnpcno"];
        UnitFramesPlus_FocusPortraitDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
        self:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
    end)

    --全局Shift拖动头像
    local UnitFramesPlus_OptionsFrame_GlobalShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalShiftDrag", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["movable"] = 1 - UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlusDB["player"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_PlayerShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        UnitFramesPlusDB["target"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_TargetShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        UnitFramesPlusDB["targettarget"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        UnitFramesPlusDB["focus"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_FocusShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        UnitFramesPlusDB["focustarget"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        UnitFramesPlusDB["party"]["movable"] = UnitFramesPlusDB["global"]["movable"];
        UnitFramesPlus_OptionsFrame_PartyShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
        self:SetChecked(UnitFramesPlusDB["player"]["movable"]==1);
    end)

    --全局头像内战斗信息
    local UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalShiftDrag, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["indicator"] = 1 - UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlusDB["player"]["indicator"] = UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlus_PlayerPortraitIndicator();
        UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
        UnitFramesPlusDB["pet"]["indicator"] = UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlus_PetPortraitIndicator();
        UnitFramesPlus_OptionsFrame_PetPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
        UnitFramesPlusDB["target"]["indicator"] = UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlus_TargetPortraitIndicator();
        UnitFramesPlus_OptionsFrame_TargetPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
        UnitFramesPlusDB["focus"]["indicator"] = UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlus_FocusPortraitIndicator();
        UnitFramesPlus_OptionsFrame_FocusPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
        UnitFramesPlusDB["party"]["indicator"] = UnitFramesPlusDB["global"]["indicator"];
        UnitFramesPlus_PartyPortraitIndicator();
        UnitFramesPlus_OptionsFrame_PartyPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
        self:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
    end)

    --全局生命条染色
    local UnitFramesPlus_OptionsFrame_GlobalColorHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_GlobalColorHP", UnitFramesPlus_Global_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_GlobalColorHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_GlobalColorHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_GlobalColorHPText:SetText(UFP_OP_ColorHP);
    UnitFramesPlus_OptionsFrame_GlobalColorHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["global"]["colorhp"] = 1 - UnitFramesPlusDB["global"]["colorhp"];
        UnitFramesPlusDB["player"]["colorhp"] = UnitFramesPlusDB["global"]["colorhp"];
        BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
        UnitFramesPlus_PlayerColorHPBar();
        UnitFramesPlus_PlayerColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_PlayerColorHP:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
        UnitFramesPlusDB["target"]["colorhp"] = UnitFramesPlusDB["global"]["colorhp"];
        UnitFramesPlus_TargetColorHPBar();
        UnitFramesPlus_TargetColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetColorHP:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
        UnitFramesPlusDB["focus"]["colorhp"] = UnitFramesPlusDB["global"]["colorhp"];
        UnitFramesPlus_FocusColorHPBar();
        UnitFramesPlus_FocusColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusColorHP:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
        UnitFramesPlusDB["party"]["colorhp"] = UnitFramesPlusDB["global"]["colorhp"];
        UnitFramesPlus_PartyColorHPBar();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyColorHPBarDisplayUpdate(id);
        end
        UnitFramesPlus_OptionsFrame_PartyColorHP:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
        if UnitFramesPlusDB["global"]["colorhp"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetColorHPSlider);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusColorHPSlider);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetColorHPSlider);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusColorHPSlider);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
        end
        self:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
    end)

    --全局生命条染色类型
    local UnitFramesPlus_OptionsFrame_GlobalColorHPSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_GlobalColorHPSlider", UnitFramesPlus_Global_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_GlobalColorHP, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSliderLow:SetText(UFP_OP_ColorHP_Class);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSliderHigh:SetText(UFP_OP_ColorHP_HPPct);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["global"]["colortype"] = value;
        UnitFramesPlusDB["player"]["colortype"] = value;
        UnitFramesPlus_PlayerColorHPBar();
        UnitFramesPlus_PlayerColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetValue(value);
        UnitFramesPlusDB["target"]["colortype"] = value;
        UnitFramesPlus_TargetColorHPBar();
        UnitFramesPlus_TargetColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetValue(value);
        UnitFramesPlusDB["focus"]["colortype"] = value;
        UnitFramesPlus_FocusColorHPBar();
        UnitFramesPlus_FocusColorHPBarDisplayUpdate();
        UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetValue(value);
        UnitFramesPlusDB["party"]["colortype"] = value;
        UnitFramesPlus_PartyColorHPBar();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyColorHPBarDisplayUpdate(id);
        end
        UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetValue(value);
    end)

    --玩家设定
    local playerconfig = UnitFramesPlus_Player_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    playerconfig:SetPoint("TOPLEFT", 16, -16);
    playerconfig:SetText(UFP_OP_Player_Options);

    --玩家精英头像
    local UnitFramesPlus_OptionsFrame_PlayerDragonBorder = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerDragonBorder", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerDragonBorder:SetPoint("TOPLEFT", playerconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorder:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorderText:SetText(UFP_OP_Player_Dragon);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorder:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["dragonborder"] = 1 - UnitFramesPlusDB["player"]["dragonborder"];
        if UnitFramesPlusDB["player"]["dragonborder"] == 1 then
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType);
        else
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType);
        end
        UnitFramesPlus_PlayerDragon();
        self:SetChecked(UnitFramesPlusDB["player"]["dragonborder"]==1);
    end)

    --玩家扩展框类型
    local UnitFramesPlus_OptionsFrame_PlayerDragonBorderType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerDragonBorderType", UnitFramesPlus_Player_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_PlayerDragonBorderType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerDragonBorder, "TOPLEFT", 165, 0);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorderType:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType, PlayerDragonBorderType_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType, UnitFramesPlusDB["player"]["bordertype"]);

    --玩家扩展框
    local UnitFramesPlus_OptionsFrame_PlayerExtrabar = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerExtrabar", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerExtrabar:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerDragonBorder, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerExtrabar:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerExtrabarText:SetText(UFP_OP_Player_Extrabar);
    UnitFramesPlus_OptionsFrame_PlayerExtrabar:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["extrabar"] = 1 - UnitFramesPlusDB["player"]["extrabar"];
        if UnitFramesPlusDB["player"]["extrabar"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerHPMPPct);
            UnitFramesPlusDB["player"]["hpmp"] = 1;
            UnitFramesPlus_OptionsFrame_PlayerHPMPPct:SetChecked(UnitFramesPlusDB["player"]["hpmp"]==1);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerHPMPUnit);
            UnitFramesPlus_OptionsFrame_PlayerHPMPUnitText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerCoordinate);
            UnitFramesPlus_OptionsFrame_PlayerCoordinateText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerHPMPPct);
            UnitFramesPlus_OptionsFrame_PlayerHPMPPctText:SetTextColor(1, 1, 1);
        end
        UnitFramesPlus_PlayerExtrabar();
        self:SetChecked(UnitFramesPlusDB["player"]["extrabar"]==1);
    end)

    --玩家坐标
    local UnitFramesPlus_OptionsFrame_PlayerCoordinate = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerCoordinate", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerCoordinate:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerExtrabar, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerCoordinate:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerCoordinateText:SetText(UFP_OP_Player_Coordinate);
    UnitFramesPlus_OptionsFrame_PlayerCoordinate:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["coord"] = 1 - UnitFramesPlusDB["player"]["coord"];
        UnitFramesPlus_PlayerCoordinate();
        UnitFramesPlus_PlayerCoordinateDisplayUpdate();
        UnitFramesPlus_PlayerHPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["player"]["coord"]==1);
    end)

    --玩家不显示扩展框时的生命值和法力值(百分比)
    local UnitFramesPlus_OptionsFrame_PlayerHPMPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerHPMPPct", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerHPMPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerCoordinate, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctText:SetText(UFP_OP_HPMP);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["hpmp"] = 1 - UnitFramesPlusDB["player"]["hpmp"];
        if UnitFramesPlusDB["player"]["hpmp"] == 1 then
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerHPMPUnit);
            UnitFramesPlus_OptionsFrame_PlayerHPMPUnitText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerCoordinate);
            UnitFramesPlus_OptionsFrame_PlayerCoordinateText:SetTextColor(1, 1, 1);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider);
            end
        else
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne);
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerHPMPUnit);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerCoordinate);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider);
            end
        end
        UnitFramesPlus_PlayerHPMPPct();
        self:SetChecked(UnitFramesPlusDB["player"]["hpmp"]==1);
    end)

    --玩家生命值/法力值/百分比第一部分
    local UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne", UnitFramesPlus_Player_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerHPMPPct, "TOPLEFT", 165, 0);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne, PlayerHPMPPctPartOne_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne, UnitFramesPlusDB["player"]["hpmppartone"]);

    --玩家斜线
    local splitline = UnitFramesPlus_Player_Options:CreateFontString(nil, "ARTWORK", "TextStatusBarText");
    splitline:SetPoint("LEFT", UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne, "RIGHT", -5, 0);
    splitline:SetText("/");

    --玩家生命值/法力值/百分比第二部分
    local UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo", UnitFramesPlus_Player_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo:SetPoint("LEFT", splitline, "RIGHT", -11, 0);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo, PlayerHPMPPctPartTwo_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo, UnitFramesPlusDB["player"]["hpmpparttwo"]);

    --玩家生命值、法力值单位
    local UnitFramesPlus_OptionsFrame_PlayerHPMPUnit = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerHPMPUnit", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerHPMPUnit:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerHPMPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerHPMPUnit:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerHPMPUnitText:SetText(UFP_OP_Player_Unit);
    UnitFramesPlus_OptionsFrame_PlayerHPMPUnit:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["hpmpunit"] = 1 - UnitFramesPlusDB["player"]["hpmpunit"];
        if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
            if UnitFramesPlusDB["player"]["hpmpunit"] == 1 then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider);
            else
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider);
            end
        end
        UnitFramesPlus_PlayerHPValueDisplayUpdate();
        UnitFramesPlus_PlayerMPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["player"]["hpmpunit"]==1);
    end)

    --玩家生命值、法力值单位
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        local UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider", UnitFramesPlus_Player_Options, "OptionsSliderTemplate");
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetWidth(95);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetHeight(16);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerHPMPUnit, "TOPLEFT", 183, 0);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSliderLow:SetText(UFP_OP_Player_UnitK);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSliderHigh:SetText(UFP_OP_Player_UnitW);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetMinMaxValues(1,2);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetValueStep(1);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetObeyStepOnDrag(true);
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetScript("OnValueChanged", function(self, value)
            UnitFramesPlusDB["player"]["unittype"] = value;
            UnitFramesPlus_PlayerHPValueDisplayUpdate();
            UnitFramesPlus_PlayerMPValueDisplayUpdate();
        end)
    end

    --玩家头像自动隐藏
    local UnitFramesPlus_OptionsFrame_PlayerFrameAutohide = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerFrameAutohide", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerFrameAutohide:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerHPMPUnit, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerFrameAutohide:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerFrameAutohideText:SetText(UFP_OP_Player_Autohide);
    UnitFramesPlus_OptionsFrame_PlayerFrameAutohide:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["autohide"] = 1 - UnitFramesPlusDB["player"]["autohide"];
        UnitFramesPlus_PlayerFrameAutohide();
        UnitFramesPlus_PlayerFrameAutohideDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["player"]["autohide"]==1);
    end)

    --玩家头像缩放
    local UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider", UnitFramesPlus_Player_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerFrameAutohide, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["player"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["player"]["scale"] = value/100;
        UnitFramesPlus_PlayerFrameScale(UnitFramesPlusDB["player"]["scale"]);
        UnitFramesPlus_OptionsFrame_PlayerFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["player"]["scale"]*100).."%");
    end)

    --玩家鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_PlayerMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerMouseShow", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider, "TOPLEFT", -30, -35);
    UnitFramesPlus_OptionsFrame_PlayerMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_PlayerMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["player"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["player"]["mouseshow"] = 1 - UnitFramesPlusDB["player"]["mouseshow"];
        if UnitFramesPlusDB["player"]["mouseshow"] == 1 then
            if UnitFramesPlusDB["pet"]["mouseshow"] == 1 
            and UnitFramesPlusDB["target"]["mouseshow"] == 1 
            and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
            and UnitFramesPlusDB["party"]["mouseshow"] == 1 
            and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_PlayerBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["player"]["mouseshow"]==1);
    end)

    --玩家头像类型开关
    local UnitFramesPlus_OptionsFrame_PlayerPortraitType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerPortraitType", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerPortraitType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerPortraitType:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeText:SetText(UFP_OP_Portrait);
    UnitFramesPlus_OptionsFrame_PlayerPortraitType:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["portrait"] = 1 - UnitFramesPlusDB["player"]["portrait"];
        UnitFramesPlus_PlayerPortrait();
        if UnitFramesPlusDB["player"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider);
            if UnitFramesPlusDB["player"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
                UnitFramesPlus_OptionsFrame_PlayerPortrait3DBGText:SetTextColor(1, 1, 1);
            end
            if UnitFramesPlusDB["target"]["portrait"] == 1 
            and UnitFramesPlusDB["focus"]["portrait"] == 1 
            and UnitFramesPlusDB["party"]["portrait"] == 1 then
                UnitFramesPlusDB["global"]["portrait"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
                if UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
                elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
                end
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
            UnitFramesPlusDB["global"]["portrait"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["player"]["portrait"]==1);
    end)

    --玩家头像类型
    local UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider", UnitFramesPlus_Player_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerPortraitType, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSliderLow:SetText(UFP_OP_3D);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSliderHigh:SetText(UFP_OP_CLASS);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["player"]["portraittype"] = value;
        UnitFramesPlus_PlayerPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
            UnitFramesPlus_OptionsFrame_PlayerPortrait3DBGText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
        end
    end)

    --玩家3D头像背景
    local UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerPortraitType, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerPortrait3DBGText:SetText(UFP_OP_Portrait_3DBG);
    UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["portrait3dbg"] = 1 - UnitFramesPlusDB["player"]["portrait3dbg"];
        UnitFramesPlus_PlayerPortrait3DBGDisplayUpdate();
        if UnitFramesPlusDB["player"]["portrait3dbg"] == 1 then
            if UnitFramesPlusDB["target"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["focus"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["party"]["portrait3dbg"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    UnitFramesPlusDB["global"]["portrait3dbg"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portrait3dbg"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["player"]["portrait3dbg"]==1);
    end)

    --玩家Shift拖动头像
    local UnitFramesPlus_OptionsFrame_PlayerShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerShiftDrag", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_PlayerShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["movable"] = 1 - UnitFramesPlusDB["player"]["movable"];
        if UnitFramesPlusDB["player"]["movable"] == 1 then
            if UnitFramesPlusDB["target"]["movable"] == 1 
            and UnitFramesPlusDB["targettarget"]["movable"] == 1 
            and UnitFramesPlusDB["focus"]["movable"] == 1 
            and UnitFramesPlusDB["focustarget"]["movable"] == 1 
            and UnitFramesPlusDB["party"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["player"]["movable"]==1);
    end)

    --玩家头像内战斗信息
    local UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerShiftDrag, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["indicator"] = 1 - UnitFramesPlusDB["player"]["indicator"];
        UnitFramesPlus_PlayerPortraitIndicator();
        if UnitFramesPlusDB["player"]["indicator"] == 1 then
            if UnitFramesPlusDB["pet"]["indicator"] == 1 
            and UnitFramesPlusDB["target"]["indicator"] == 1
            and UnitFramesPlusDB["focus"]["indicator"] == 1 
            and UnitFramesPlusDB["party"]["indicator"] == 1 then
                UnitFramesPlusDB["global"]["indicator"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["indicator"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["player"]["indicator"]==1);
    end)

    --玩家生命条染色
    local UnitFramesPlus_OptionsFrame_PlayerColorHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PlayerColorHP", UnitFramesPlus_Player_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PlayerColorHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PlayerColorHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PlayerColorHPText:SetText(UFP_OP_ColorHP);
    UnitFramesPlus_OptionsFrame_PlayerColorHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["player"]["colorhp"] = 1 - UnitFramesPlusDB["player"]["colorhp"];
        if UnitFramesPlusDB["player"]["colorhp"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
        end
        UnitFramesPlus_PlayerColorHPBar();
        UnitFramesPlus_PlayerColorHPBarDisplayUpdate();
        if UnitFramesPlusDB["player"]["colorhp"] == 1 then
            if UnitFramesPlusDB["target"]["colorhp"] == 1 
            and UnitFramesPlusDB["focus"]["colorhp"] == 1 
            and UnitFramesPlusDB["party"]["colorhp"] == 1 then
                UnitFramesPlusDB["global"]["colorhp"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            end
        else
            UnitFramesPlusDB["global"]["colorhp"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
        end
        self:SetChecked(UnitFramesPlusDB["player"]["colorhp"]==1);
    end)

    --玩家生命条染色类型
    local UnitFramesPlus_OptionsFrame_PlayerColorHPSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PlayerColorHPSlider", UnitFramesPlus_Player_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PlayerColorHP, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSliderLow:SetText(UFP_OP_ColorHP_Class);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSliderHigh:SetText(UFP_OP_ColorHP_HPPct);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["player"]["colortype"] = value;
        UnitFramesPlus_PlayerColorHPBar();
        UnitFramesPlus_PlayerColorHPBarDisplayUpdate();
    end)

    --宠物设定
    local petconfig = UnitFramesPlus_Pet_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    petconfig:SetPoint("TOPLEFT", 16, -16);
    petconfig:SetText(UFP_OP_Pet_Options);

    --宠物目标
    local UnitFramesPlus_OptionsFrame_PetTarget = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PetTarget", UnitFramesPlus_Pet_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PetTarget:SetPoint("TOPLEFT", petconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_PetTarget:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PetTargetText:SetText(UFP_OP_Pet_Target);
    UnitFramesPlus_OptionsFrame_PetTarget:SetScript("OnClick", function(self)
        UnitFramesPlusDB["pet"]["target"] = 1 - UnitFramesPlusDB["pet"]["target"];    
        if UnitFramesPlusDB["pet"]["target"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PetTargetHPPct);
            UnitFramesPlus_OptionsFrame_PetTargetHPPctText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PetTargetScaleSlider);
            UnitFramesPlus_OptionsFrame_PetTargetScaleSliderText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PetTargetHPPct);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PetTargetScaleSlider);
        end
        UnitFramesPlus_PetTarget();
        self:SetChecked(UnitFramesPlusDB["pet"]["target"]==1);
    end)

    --宠物目标生命值百分比
    local UnitFramesPlus_OptionsFrame_PetTargetHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PetTargetHPPct", UnitFramesPlus_Pet_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PetTargetHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PetTarget, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PetTargetHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PetTargetHPPctText:SetText(UFP_OP_HPPct);
    UnitFramesPlus_OptionsFrame_PetTargetHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["pet"]["hppct"] = 1 - UnitFramesPlusDB["pet"]["hppct"];
        self:SetChecked(UnitFramesPlusDB["pet"]["hppct"]==1);
    end)

    --宠物目标缩放
    local UnitFramesPlus_OptionsFrame_PetTargetScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PetTargetScaleSlider", UnitFramesPlus_Pet_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PetTargetHPPct, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["pet"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_PetTargetScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_PetTargetScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["pet"]["scale"] = value/100;
        UnitFramesPlus_PetTargetScale(UnitFramesPlusDB["pet"]["scale"]);
        UnitFramesPlus_OptionsFrame_PetTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["pet"]["scale"]*100).."%");
    end)

    --宠物鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_PetMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PetMouseShow", UnitFramesPlus_Pet_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PetMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PetTargetScaleSlider, "TOPLEFT", -30, -35);
    UnitFramesPlus_OptionsFrame_PetMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PetMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_PetMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["pet"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["pet"]["mouseshow"] = 1 - UnitFramesPlusDB["pet"]["mouseshow"];
        if UnitFramesPlusDB["pet"]["mouseshow"] == 1 then
            if UnitFramesPlusDB["player"]["mouseshow"] == 1
            and UnitFramesPlusDB["target"]["mouseshow"] == 1 
            and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
            and UnitFramesPlusDB["party"]["mouseshow"] == 1 
            and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_PetBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["pet"]["mouseshow"]==1);
    end)

    --宠物头像内战斗信息
    local UnitFramesPlus_OptionsFrame_PetPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PetPortraitIndicator", UnitFramesPlus_Pet_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PetPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PetMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PetPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PetPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_PetPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["pet"]["indicator"] = 1 - UnitFramesPlusDB["pet"]["indicator"];
        UnitFramesPlus_PetPortraitIndicator();
        if UnitFramesPlusDB["pet"]["indicator"] == 1 then
            if UnitFramesPlusDB["player"]["indicator"] == 1 
            and UnitFramesPlusDB["target"]["indicator"] == 1 
            and UnitFramesPlusDB["focus"]["indicator"] == 1 
            and UnitFramesPlusDB["party"]["indicator"] == 1 then
                UnitFramesPlusDB["global"]["indicator"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["indicator"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["pet"]["indicator"]==1);
    end)

    --目标设定
    local targetconfig = UnitFramesPlus_Target_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    targetconfig:SetPoint("TOPLEFT", 16, -16);
    targetconfig:SetText(UFP_OP_Target_Options);

    --目标扩展框
    local UnitFramesPlus_OptionsFrame_TargetExtrabar = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetExtrabar", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetExtrabar:SetPoint("TOPLEFT", targetconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_TargetExtrabar:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetExtrabarText:SetText(UFP_OP_Player_Extrabar);
    UnitFramesPlus_OptionsFrame_TargetExtrabar:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["extrabar"] = 1 - UnitFramesPlusDB["target"]["extrabar"];
        if UnitFramesPlusDB["target"]["extrabar"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetHPMPPct);
            UnitFramesPlusDB["target"]["hpmp"] = 1;
            UnitFramesPlus_OptionsFrame_TargetHPMPPct:SetChecked(UnitFramesPlusDB["target"]["hpmp"]==1);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetHPMPUnit);
            UnitFramesPlus_OptionsFrame_TargetHPMPUnitText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetHPMPPct);
            UnitFramesPlus_OptionsFrame_TargetHPMPPctText:SetTextColor(1, 1, 1);
        end
        UnitFramesPlus_TargetExtrabar();
        self:SetChecked(UnitFramesPlusDB["target"]["extrabar"]==1);
    end)

    --目标不显示扩展框时的生命值和法力值(百分比)
    local UnitFramesPlus_OptionsFrame_TargetHPMPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetHPMPPct", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetHPMPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetExtrabar, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetHPMPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetHPMPPctText:SetText(UFP_OP_HPMP);
    UnitFramesPlus_OptionsFrame_TargetHPMPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["hpmp"] = 1 - UnitFramesPlusDB["target"]["hpmp"];
        if UnitFramesPlusDB["target"]["hpmp"] == 1 then
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetHPMPUnit);
            UnitFramesPlus_OptionsFrame_TargetHPMPUnitText:SetTextColor(1, 1, 1);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider);
            end
        else
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne);
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetHPMPUnit);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider);
            end
        end
        UnitFramesPlus_TargetHPMPPct();
        UnitFramesPlus_TargetHPValueDisplayUpdate();
        UnitFramesPlus_TargetMPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["target"]["hpmp"]==1);
    end)

    --目标生命值/法力值/百分比第一部分
    local UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne", UnitFramesPlus_Target_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetHPMPPct, "TOPLEFT", 165, 0);
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne, TargetHPMPPctPartOne_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne, UnitFramesPlusDB["target"]["hpmppartone"]);

    --目标斜线
    local splitline = UnitFramesPlus_Target_Options:CreateFontString(nil, "ARTWORK", "TextStatusBarText");
    splitline:SetPoint("LEFT", UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne, "RIGHT", -5, 0);
    splitline:SetText("/");

    --目标生命值/法力值/百分比第二部分
    local UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo", UnitFramesPlus_Target_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo:SetPoint("LEFT", splitline, "RIGHT", -11, 0);
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo, TargetHPMPPctPartTwo_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo, UnitFramesPlusDB["target"]["hpmpparttwo"]);

    --目标生命值、法力值单位
    local UnitFramesPlus_OptionsFrame_TargetHPMPUnit = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetHPMPUnit", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetHPMPUnit:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetHPMPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetHPMPUnit:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetHPMPUnitText:SetText(UFP_OP_Player_Unit);
    UnitFramesPlus_OptionsFrame_TargetHPMPUnit:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["hpmpunit"] = 1 - UnitFramesPlusDB["target"]["hpmpunit"];
        if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
            if UnitFramesPlusDB["target"]["hpmpunit"] == 1 then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider);
            else
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider);
            end
        end
        UnitFramesPlus_TargetHPValueDisplayUpdate();
        UnitFramesPlus_TargetMPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["target"]["hpmpunit"]==1);
    end)

    --目标生命值、法力值单位
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        local UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetWidth(95);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetHeight(16);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetHPMPUnit, "TOPLEFT", 183, 0);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSliderLow:SetText(UFP_OP_Player_UnitK);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSliderHigh:SetText(UFP_OP_Player_UnitW);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetMinMaxValues(1,2);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetValueStep(1);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetObeyStepOnDrag(true);
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetScript("OnValueChanged", function(self, value)
            UnitFramesPlusDB["target"]["unittype"] = value;
            UnitFramesPlus_TargetHPValueDisplayUpdate();
            UnitFramesPlus_TargetMPValueDisplayUpdate();
        end)
    end

    --目标职业按钮
    local UnitFramesPlus_OptionsFrame_TargetClassIcon = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetClassIcon", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetClassIcon:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetHPMPUnit, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetClassIcon:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetClassIconText:SetText(UFP_OP_ClassIcon);
    UnitFramesPlus_OptionsFrame_TargetClassIcon:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["classicon"] = 1 - UnitFramesPlusDB["target"]["classicon"];
        if UnitFramesPlusDB["target"]["classicon"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetClassIconMore);
            UnitFramesPlus_OptionsFrame_TargetClassIconMoreText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetClassIconMore);
        end
        UnitFramesPlus_TargetClassIcon();
        UnitFramesPlus_TargetClassIconDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["target"]["classicon"]==1);
    end)

    --目标职业图标左键观察，右键交易，中键密语，4键跟随
    local UnitFramesPlus_OptionsFrame_TargetClassIconMore = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetClassIconMore", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetClassIconMore:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetClassIcon, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetClassIconMore:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetClassIconMoreText:SetText(UFP_OP_ClassIcon_MoreAction);
    UnitFramesPlus_OptionsFrame_TargetClassIconMore:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["moreaction"] = 1 - UnitFramesPlusDB["target"]["moreaction"];
        self:SetChecked(UnitFramesPlusDB["target"]["moreaction"]==1);
    end)

    --目标种族或类型
    local UnitFramesPlus_OptionsFrame_TargetRace = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetRace", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetRace:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetClassIcon, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetRace:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetRaceText:SetText(UFP_OP_Race);
    UnitFramesPlus_OptionsFrame_TargetRace:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["race"] = 1 - UnitFramesPlusDB["target"]["race"];
        UnitFramesPlus_TargetRace();
        UnitFramesPlus_TargetRaceDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["target"]["race"]==1);
    end)

    --目标调节目标buff/debuff图标大小
    local UnitFramesPlus_OptionsFrame_TargetBuffSize = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetBuffSize", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetBuffSize:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetRace, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetBuffSize:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeText:SetText(UFP_OP_Target_BuffSize);
    UnitFramesPlus_OptionsFrame_TargetBuffSize:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["buffsize"] = 1 - UnitFramesPlusDB["target"]["buffsize"];
        if UnitFramesPlusDB["target"]["buffsize"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider);
            UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSliderText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider);
            UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSliderText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["buffsize"]==1);
    end)

    --目标自己施放的buff/debuff大小
    local UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetBuffSize, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSliderText:SetText(UFP_OP_Target_MySize..UnitFramesPlusDB["target"]["mysize"]);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSliderLow:SetText("8");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSliderHigh:SetText("32");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetMinMaxValues(8,32);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["target"]["mysize"] = value;
        UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSliderText:SetText(UFP_OP_Target_MySize..UnitFramesPlusDB["target"]["mysize"]);
    end)

    --目标其他人施放的buff/debuff大小
    local UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider, "TOPLEFT", 153, 0);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSliderText:SetText(UFP_OP_Target_OtherSize..UnitFramesPlusDB["target"]["othersize"]);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSliderLow:SetText("8");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSliderHigh:SetText("32");
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetMinMaxValues(8,32);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["target"]["othersize"] = value;
        UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSliderText:SetText(UFP_OP_Target_OtherSize..UnitFramesPlusDB["target"]["othersize"]);
    end)

    --目标头像缩放
    local UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider, "TOPLEFT", 0, -50);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["target"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["target"]["scale"] = value/100;
        UnitFramesPlus_TargetFrameScale(UnitFramesPlusDB["target"]["scale"]);
        UnitFramesPlus_OptionsFrame_TargetFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["target"]["scale"]*100).."%");
    end)

    --目标鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_TargetMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetMouseShow", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider, "TOPLEFT", -30, -35);
    UnitFramesPlus_OptionsFrame_TargetMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_TargetMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["target"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["target"]["mouseshow"] = 1 - UnitFramesPlusDB["target"]["mouseshow"];
        if UnitFramesPlusDB["target"]["mouseshow"] == 1 then
            if UnitFramesPlusDB["player"]["mouseshow"] == 1
            and UnitFramesPlusDB["pet"]["mouseshow"] == 1 
            and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
            and UnitFramesPlusDB["party"]["mouseshow"] == 1 
            and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_TargetBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["target"]["mouseshow"]==1);
    end)

    --目标头像类型开关
    local UnitFramesPlus_OptionsFrame_TargetPortraitType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetPortraitType", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetPortraitType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetPortraitType:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeText:SetText(UFP_OP_Portrait);
    UnitFramesPlus_OptionsFrame_TargetPortraitType:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["portrait"] = 1 - UnitFramesPlusDB["target"]["portrait"];
        UnitFramesPlus_TargetPortrait();
        if UnitFramesPlusDB["target"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider);
            if UnitFramesPlusDB["target"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
                UnitFramesPlus_OptionsFrame_TargetPortrait3DBGText:SetTextColor(1, 1, 1);
            elseif UnitFramesPlusDB["target"]["portraittype"] == 2 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_TargetPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
            if UnitFramesPlusDB["player"]["portrait"] == 1 
            and UnitFramesPlusDB["target"]["portrait"] == 1 
            and UnitFramesPlusDB["focus"]["portrait"] == 1 
            and UnitFramesPlusDB["party"]["portrait"] == 1 then
                UnitFramesPlusDB["global"]["portrait"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
                if UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
                elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
                end
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
            UnitFramesPlusDB["global"]["portrait"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["portrait"]==1);
    end)

    --目标头像类型
    local UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetPortraitType, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSliderLow:SetText(UFP_OP_3D);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSliderHigh:SetText(UFP_OP_CLASS);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["target"]["portraittype"] = value;
        UnitFramesPlus_TargetPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            UnitFramesPlus_OptionsFrame_TargetPortrait3DBGText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
        elseif value == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_TargetPortraitNPCNoText:SetTextColor(1, 1, 1);
        end
    end)

    --目标3D头像背景
    local UnitFramesPlus_OptionsFrame_TargetPortrait3DBG = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetPortrait3DBG", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetPortraitType, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetPortrait3DBGText:SetText(UFP_OP_Portrait_3DBG);
    UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["portrait3dbg"] = 1 - UnitFramesPlusDB["target"]["portrait3dbg"];
        UnitFramesPlus_TargetPortrait3DBGDisplayUpdate();
        if UnitFramesPlusDB["target"]["portrait3dbg"] == 1 then
            if UnitFramesPlusDB["player"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["focus"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["party"]["portrait3dbg"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    UnitFramesPlusDB["global"]["portrait3dbg"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portrait3dbg"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["portrait3dbg"]==1);
    end)

    --目标为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetPortrait3DBG, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["portraitnpcno"] = 1 - UnitFramesPlusDB["target"]["portraitnpcno"];
        UnitFramesPlus_TargetPortraitDisplayUpdate();
        if UnitFramesPlusDB["target"]["portraitnpcno"] == 1 then
            if UnitFramesPlusDB["focus"]["portraitnpcno"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    UnitFramesPlusDB["global"]["portraitnpcno"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portraitnpcno"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["portraitnpcno"]==1);
    end)

    --目标Shift拖动头像
    local UnitFramesPlus_OptionsFrame_TargetShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetShiftDrag", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetPortrait3DBG, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_TargetShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["movable"] = 1 - UnitFramesPlusDB["target"]["movable"];
        if UnitFramesPlusDB["target"]["movable"] == 1 then
            if UnitFramesPlusDB["player"]["movable"] == 1 
            and UnitFramesPlusDB["targettarget"]["movable"] == 1 
            and UnitFramesPlusDB["focus"]["movable"] == 1 
            and UnitFramesPlusDB["focustarget"]["movable"] == 1 
            and UnitFramesPlusDB["party"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["movable"]==1);
    end)

    --目标头像内战斗信息
    local UnitFramesPlus_OptionsFrame_TargetPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetPortraitIndicator", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetShiftDrag, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_TargetPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["indicator"] = 1 - UnitFramesPlusDB["target"]["indicator"];
        UnitFramesPlus_TargetPortraitIndicator();
        if UnitFramesPlusDB["target"]["indicator"] == 1 then
            if UnitFramesPlusDB["player"]["indicator"] == 1 
            and UnitFramesPlusDB["pet"]["indicator"] == 1 
            and UnitFramesPlusDB["focus"]["indicator"] == 1 
            and UnitFramesPlusDB["party"]["indicator"] == 1 then
                UnitFramesPlusDB["global"]["indicator"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["indicator"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["indicator"]==1);
    end)

    --目标生命条染色
    local UnitFramesPlus_OptionsFrame_TargetColorHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetColorHP", UnitFramesPlus_Target_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetColorHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetPortraitIndicator, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetColorHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetColorHPText:SetText(UFP_OP_ColorHP);
    UnitFramesPlus_OptionsFrame_TargetColorHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["target"]["colorhp"] = 1 - UnitFramesPlusDB["target"]["colorhp"];
        if UnitFramesPlusDB["target"]["colorhp"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetColorHPSlider);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetColorHPSlider);
        end
        UnitFramesPlus_TargetColorHPBar();
        UnitFramesPlus_TargetColorHPBarDisplayUpdate();
        if UnitFramesPlusDB["target"]["colorhp"] == 1 then
            if UnitFramesPlusDB["player"]["colorhp"] == 1 
            and UnitFramesPlusDB["focus"]["colorhp"] == 1 
            and UnitFramesPlusDB["party"]["colorhp"] == 1 then
                UnitFramesPlusDB["global"]["colorhp"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            end
        else
            UnitFramesPlusDB["global"]["colorhp"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
        end
        self:SetChecked(UnitFramesPlusDB["target"]["colorhp"]==1);
    end)

    --目标生命条染色类型
    local UnitFramesPlus_OptionsFrame_TargetColorHPSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetColorHPSlider", UnitFramesPlus_Target_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetColorHP, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_TargetColorHPSliderLow:SetText(UFP_OP_ColorHP_Class);
    UnitFramesPlus_OptionsFrame_TargetColorHPSliderHigh:SetText(UFP_OP_ColorHP_HPPct);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["target"]["colortype"] = value;
        UnitFramesPlus_TargetColorHPBar();
        UnitFramesPlus_TargetColorHPBarDisplayUpdate();
    end)

    --目标的目标设定
    local totconfig = UnitFramesPlus_TargetTarget_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    totconfig:SetPoint("TOPLEFT", 16, -16);
    totconfig:SetText(UFP_OP_ToT_Options);

    --目标的目标系统ToT状态
    local UnitFramesPlus_OptionsFrame_TargetTargetSYSToT = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetSYSToT", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetSYSToT:SetPoint("TOPLEFT", totconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_TargetTargetSYSToT:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetSYSToTText:SetText(UFP_OP_Target_SYSToT);
    UnitFramesPlus_OptionsFrame_TargetTargetSYSToT:SetScript("OnClick", function(self)
        --InterfaceOptionsFrame_OpenToCategory(InterfaceOptionsCombatPanel);
        InterfaceOptionsFrame:Hide();
        GameMenuButtonUIOptions:Click();
        InterfaceOptionsFrameCategoriesButton2:Click();
        self:SetChecked(tonumber(GetCVar("showTargetOfTarget"))==1);
    end)

    --目标的目标在进入游戏时自动关闭系统目标的目标
    local UnitFramesPlus_OptionsFrame_TargetTargetAutoToT = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetAutoToT", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetAutoToT:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetSYSToT, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetAutoToT:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetAutoToTText:SetText(UFP_OP_Target_AutoToT);
    UnitFramesPlus_OptionsFrame_TargetTargetAutoToT:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["systot"] = 1 - UnitFramesPlusDB["targettarget"]["systot"];
        self:SetChecked(UnitFramesPlusDB["targettarget"]["systot"]==1);
    end)

    --目标的目标
    local UnitFramesPlus_OptionsFrame_TargetTarget = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTarget", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTarget:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetSYSToT, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTarget:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetText:SetText(UFP_OP_Target_ToT);
    UnitFramesPlus_OptionsFrame_TargetTarget:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["showtot"] = 1 - UnitFramesPlusDB["targettarget"]["showtot"];
        if UnitFramesPlusDB["targettarget"]["showtot"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetTarget);
            UnitFramesPlus_OptionsFrame_TargetTargetTargetText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetDebuff);
            UnitFramesPlus_OptionsFrame_TargetTargetDebuffText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["targettarget"]["debuff"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown);
                UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldownText:SetTextColor(1, 1, 1);
            end
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider);
            UnitFramesPlus_OptionsFrame_TargetTargetScaleSliderText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetHPPct);
            UnitFramesPlus_OptionsFrame_TargetTargetHPPctText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck);
            UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheckText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetColorName);
            UnitFramesPlus_OptionsFrame_TargetTargetColorNameText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["targettarget"]["colorname"] == 1 then
	            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
	            UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
	        end
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetShortName);
            UnitFramesPlus_OptionsFrame_TargetTargetShortNameText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag);
            UnitFramesPlus_OptionsFrame_TargetTargetShiftDragText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait);
            UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["targettarget"]["portrait"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetTarget);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetDebuff);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetHPPct);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetShortName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
        end
        UnitFramesPlus_TargetTarget();
        UnitFramesPlus_TargetTargetTarget();
        self:SetChecked(UnitFramesPlusDB["targettarget"]["showtot"]==1);
    end)

    --目标的目标的目标
    local UnitFramesPlus_OptionsFrame_TargetTargetTarget = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetTarget", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetTarget:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTarget, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetTarget:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetTargetText:SetText(UFP_OP_Target_ToToT);
    UnitFramesPlus_OptionsFrame_TargetTargetTarget:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["showtotot"] = 1 - UnitFramesPlusDB["targettarget"]["showtotot"];
        UnitFramesPlus_TargetTargetTarget();
        self:SetChecked(UnitFramesPlusDB["targettarget"]["showtotot"]==1);
    end)

    --目标的目标职业图标头像
    local UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTarget, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitText:SetText(UFP_OP_ClassPortrait);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["portrait"] = 1 - UnitFramesPlusDB["targettarget"]["portrait"];
        UnitFramesPlus_TargetTargetClassPortraitDisplayUpdate();
        UnitFramesPlus_TargetTargetTargetClassPortraitDisplayUpdate();
        if UnitFramesPlusDB["targettarget"]["portrait"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["targettarget"]["portrait"]==1);
    end)

    --目标的目标为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["portraitnpcno"] = 1 - UnitFramesPlusDB["targettarget"]["portraitnpcno"];
        UnitFramesPlus_TargetTargetClassPortraitDisplayUpdate();
        UnitFramesPlus_TargetTargetTargetClassPortraitDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["targettarget"]["portraitnpcno"]==1);
    end)

    --目标的目标生命值百分比
    local UnitFramesPlus_OptionsFrame_TargetTargetHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetHPPct", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetHPPctText:SetText(UFP_OP_HPPct);
    UnitFramesPlus_OptionsFrame_TargetTargetHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["hppct"] = 1 - UnitFramesPlusDB["targettarget"]["hppct"];
        self:SetChecked(UnitFramesPlusDB["targettarget"]["hppct"]==1);
    end)

    --目标的目标敌友检测
    local UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetHPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheckText:SetText(UFP_OP_EnemyCheck);
    UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["enemycheck"] = 1 - UnitFramesPlusDB["targettarget"]["enemycheck"];
        if UnitFramesPlusDB["targettarget"]["enemycheck"] ~= 1 then
            _G["UFP_ToTFrame"].Highlight:SetAlpha(0);
            _G["UFP_ToToTFrame"].Highlight:SetAlpha(0);
        end
        self:SetChecked(UnitFramesPlusDB["targettarget"]["enemycheck"]==1);
    end)

    --目标的目标名字职业染色
    local UnitFramesPlus_OptionsFrame_TargetTargetColorName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetColorName", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetColorName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetColorName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameText:SetText(UFP_OP_ColorName);
    UnitFramesPlus_OptionsFrame_TargetTargetColorName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["colorname"] = 1 - UnitFramesPlusDB["targettarget"]["colorname"];
        if UnitFramesPlusDB["targettarget"]["colorname"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
            UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["targettarget"]["colorname"]==1);
    end)

    --目标的目标名字职业染色NPC不显示
    local UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetColorName, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["colornamenpcno"] = 1 - UnitFramesPlusDB["targettarget"]["colornamenpcno"];
        self:SetChecked(UnitFramesPlusDB["targettarget"]["colornamenpcno"]==1);
    end)

    --目标的目标名字显示为(*)
    local UnitFramesPlus_OptionsFrame_TargetTargetShortName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetShortName", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetShortName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetColorName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetShortName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetShortNameText:SetText(UFP_OP_ShortName);
    UnitFramesPlus_OptionsFrame_TargetTargetShortName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["shortname"] = 1 - UnitFramesPlusDB["focustarget"]["shortname"];
        UnitFramesPlus_TargetTargetDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["shortname"]==1);
    end)

    --目标的目标debuff
    local UnitFramesPlus_OptionsFrame_TargetTargetDebuff = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetDebuff", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetDebuff:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetShortName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuff:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffText:SetText(UFP_OP_Debuff);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuff:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["debuff"] = 1 - UnitFramesPlusDB["targettarget"]["debuff"];
        if UnitFramesPlusDB["targettarget"]["debuff"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown);
            UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldownText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown);
        end
        UnitFramesPlus_TargetTargetDebuff();
        self:SetChecked(UnitFramesPlusDB["targettarget"]["debuff"]==1);
    end)

    --目标的目标debuff冷却
    local UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetDebuff, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldownText:SetText(UFP_OP_Cooldown);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["cooldown"] = 1 - UnitFramesPlusDB["targettarget"]["cooldown"];
        UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldownDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["targettarget"]["cooldown"]==1);
    end)

    --目标的目标Shift拖动头像
    local UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag", UnitFramesPlus_TargetTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetDebuff, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_TargetTargetShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["targettarget"]["movable"] = 1 - UnitFramesPlusDB["targettarget"]["movable"];
        if UnitFramesPlusDB["focus"]["movable"] == 1 then
            if UnitFramesPlusDB["player"]["movable"] == 1 
            and UnitFramesPlusDB["target"]["movable"] == 1 
            and UnitFramesPlusDB["focus"]["movable"] == 1 
            and UnitFramesPlusDB["focustarget"]["movable"] == 1 
            and UnitFramesPlusDB["party"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["targettarget"]["movable"]==1);
    end)

    --目标的目标缩放
    local UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider", UnitFramesPlus_TargetTarget_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["targettarget"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["targettarget"]["scale"] = value/100;
        UnitFramesPlus_TargetTargetScale(UnitFramesPlusDB["targettarget"]["scale"]);
        UnitFramesPlus_OptionsFrame_TargetTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["targettarget"]["scale"]*100).."%");
    end)

    --焦点设定
    local focusconfig = UnitFramesPlus_Focus_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    focusconfig:SetPoint("TOPLEFT", 16, -16);
    focusconfig:SetText(UFP_OP_Focus_Options);

    --焦点扩展框
    local UnitFramesPlus_OptionsFrame_FocusExtrabar = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusExtrabar", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusExtrabar:SetPoint("TOPLEFT", focusconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_FocusExtrabar:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusExtrabarText:SetText(UFP_OP_Player_Extrabar);
    UnitFramesPlus_OptionsFrame_FocusExtrabar:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["extrabar"] = 1 - UnitFramesPlusDB["focus"]["extrabar"];
        if UnitFramesPlusDB["focus"]["extrabar"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusHPMPPct);
            UnitFramesPlusDB["focus"]["hpmp"] = 1;
            UnitFramesPlus_OptionsFrame_FocusHPMPPct:SetChecked(UnitFramesPlusDB["focus"]["hpmp"]==1);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusHPMPUnit);
            UnitFramesPlus_OptionsFrame_FocusHPMPUnitText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusHPMPPct);
            UnitFramesPlus_OptionsFrame_FocusHPMPPctText:SetTextColor(1, 1, 1);
        end
        UnitFramesPlus_FocusExtrabar();
        self:SetChecked(UnitFramesPlusDB["focus"]["extrabar"]==1);
    end)

    --焦点不显示扩展框时的生命值和法力值(百分比)
    local UnitFramesPlus_OptionsFrame_FocusHPMPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusHPMPPct", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusHPMPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusExtrabar, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusHPMPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusHPMPPctText:SetText(UFP_OP_HPMP);
    UnitFramesPlus_OptionsFrame_FocusHPMPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["hpmp"] = 1 - UnitFramesPlusDB["focus"]["hpmp"];
        if UnitFramesPlusDB["focus"]["hpmp"] == 1 then
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusHPMPUnit);
            UnitFramesPlus_OptionsFrame_FocusHPMPUnitText:SetTextColor(1, 1, 1);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider);
            end
        else
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne);
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusHPMPUnit);
            if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider);
            end
        end
        UnitFramesPlus_FocusHPMPPct();
        UnitFramesPlus_FocusHPValueDisplayUpdate();
        UnitFramesPlus_FocusMPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focus"]["hpmp"]==1);
    end)

    --焦点生命值/法力值/百分比第一部分
    local UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne", UnitFramesPlus_Focus_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusHPMPPct, "TOPLEFT", 165, 0);
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne, FocusHPMPPctPartOne_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne, UnitFramesPlusDB["focus"]["hpmppartone"]);

    --焦点斜线
    local splitline = UnitFramesPlus_Focus_Options:CreateFontString(nil, "ARTWORK", "TextStatusBarText");
    splitline:SetPoint("LEFT", UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne, "RIGHT", -5, 0);
    splitline:SetText("/");

    --焦点生命值/法力值/百分比第二部分
    local UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo", UnitFramesPlus_Focus_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo:SetPoint("LEFT", splitline, "RIGHT", -11, 0);
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo, FocusHPMPPctPartTwo_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo, UnitFramesPlusDB["focus"]["hpmpparttwo"]);

    --焦点生命值、法力值单位
    local UnitFramesPlus_OptionsFrame_FocusHPMPUnit = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusHPMPUnit", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusHPMPUnit:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusHPMPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusHPMPUnit:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusHPMPUnitText:SetText(UFP_OP_Player_Unit);
    UnitFramesPlus_OptionsFrame_FocusHPMPUnit:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["hpmpunit"] = 1 - UnitFramesPlusDB["focus"]["hpmpunit"];
        if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
            if UnitFramesPlusDB["focus"]["hpmpunit"] == 1 then
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider);
            else
                BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider);
            end
        end
        UnitFramesPlus_FocusHPValueDisplayUpdate();
        UnitFramesPlus_FocusMPValueDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focus"]["hpmpunit"]==1);
    end)

    --焦点生命值、法力值单位
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        local UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider", UnitFramesPlus_Focus_Options, "OptionsSliderTemplate");
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetWidth(95);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetHeight(16);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusHPMPUnit, "TOPLEFT", 183, 0);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSliderLow:SetText(UFP_OP_Player_UnitK);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSliderHigh:SetText(UFP_OP_Player_UnitW);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetMinMaxValues(1,2);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetValueStep(1);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetObeyStepOnDrag(true);
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetScript("OnValueChanged", function(self, value)
            UnitFramesPlusDB["focus"]["unittype"] = value;
            UnitFramesPlus_FocusHPValueDisplayUpdate();
            UnitFramesPlus_FocusMPValueDisplayUpdate();
        end)
    end

    --焦点职业图标
    local UnitFramesPlus_OptionsFrame_FocusClassIcon = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusClassIcon", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusClassIcon:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusHPMPUnit, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusClassIcon:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusClassIconText:SetText(UFP_OP_ClassIcon);
    UnitFramesPlus_OptionsFrame_FocusClassIcon:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["classicon"] = 1 - UnitFramesPlusDB["focus"]["classicon"];
        if UnitFramesPlusDB["focus"]["classicon"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusClassIconMore);
            UnitFramesPlus_OptionsFrame_FocusClassIconMoreText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusClassIconMore);
        end
        UnitFramesPlus_FocusClassIcon();
        UnitFramesPlus_FocusClassIconDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focus"]["classicon"]==1);
    end)

    --焦点职业图标左键观察，右键交易，中键密语，4键跟随
    local UnitFramesPlus_OptionsFrame_FocusClassIconMore = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusClassIconMore", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusClassIconMore:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusClassIcon, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_FocusClassIconMore:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusClassIconMoreText:SetText(UFP_OP_ClassIcon_MoreAction);
    UnitFramesPlus_OptionsFrame_FocusClassIconMore:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["moreaction"] = 1 - UnitFramesPlusDB["focus"]["moreaction"];
        self:SetChecked(UnitFramesPlusDB["focus"]["moreaction"]==1);
    end)

    --焦点种族或类型
    local UnitFramesPlus_OptionsFrame_FocusRace = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusRace", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusRace:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusClassIcon, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusRace:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusRaceText:SetText(UFP_OP_Race);
    UnitFramesPlus_OptionsFrame_FocusRace:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["race"] = 1 - UnitFramesPlusDB["focus"]["race"];
        UnitFramesPlus_FocusRace();
        UnitFramesPlus_FocusRaceDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focus"]["race"]==1);
    end)

    --快速焦点
    local UnitFramesPlus_OptionsFrame_FocusQuick = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusQuick", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusQuick:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusRace, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusQuick:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusQuickText:SetText(UFP_OP_Focus_QuickFocus);
    UnitFramesPlus_OptionsFrame_FocusQuick:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["quick"] = 1 - UnitFramesPlusDB["focus"]["quick"];
        if UnitFramesPlusDB["focus"]["quick"] == 1 then
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_FocusQuickDropDown);
        else
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusQuickDropDown);
        end
        UnitFramesPlus_FocusQuick();
        self:SetChecked(UnitFramesPlusDB["focus"]["quick"]==1);
    end)

    --快速焦点快捷键
    local UnitFramesPlus_OptionsFrame_FocusQuickDropDown = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusQuickDropDown", UnitFramesPlus_Focus_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_FocusQuickDropDown:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusQuick, "TOPLEFT", 165, 0);
    UnitFramesPlus_OptionsFrame_FocusQuickDropDown:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_FocusQuickDropDown, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_FocusQuickDropDown, QuickFocus_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_FocusQuickDropDown, UnitFramesPlusDB["focus"]["button"]);

    --焦点头像缩放
    local UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider", UnitFramesPlus_Focus_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusQuick, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["focus"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["focus"]["scale"] = value/100;
        UnitFramesPlus_FocusFrameScale(UnitFramesPlusDB["focus"]["scale"]);
        UnitFramesPlus_OptionsFrame_FocusFrameScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["focus"]["scale"]*100).."%");
    end)

    --焦点鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_FocusMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusMouseShow", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider, "TOPLEFT", -30, -35);
    UnitFramesPlus_OptionsFrame_FocusMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_FocusMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["focus"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["focus"]["mouseshow"] = 1 - UnitFramesPlusDB["focus"]["mouseshow"];
        if UnitFramesPlusDB["focus"]["mouseshow"] == 1 then
            if UnitFramesPlusDB["player"]["mouseshow"] == 1
            and UnitFramesPlusDB["pet"]["mouseshow"] == 1 
            and UnitFramesPlusDB["target"]["mouseshow"] == 1 
            and UnitFramesPlusDB["party"]["mouseshow"] == 1 
            and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_FocusBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["focus"]["mouseshow"]==1);
    end)

    --焦点头像类型开关
    local UnitFramesPlus_OptionsFrame_FocusPortraitType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusPortraitType", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusPortraitType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusPortraitType:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeText:SetText(UFP_OP_Portrait);
    UnitFramesPlus_OptionsFrame_FocusPortraitType:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["portrait"] = 1 - UnitFramesPlusDB["focus"]["portrait"];
        UnitFramesPlus_FocusPortrait();
        if UnitFramesPlusDB["focus"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider);
            if UnitFramesPlusDB["focus"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
                UnitFramesPlus_OptionsFrame_FocusPortrait3DBGText:SetTextColor(1, 1, 1);
            elseif UnitFramesPlusDB["focus"]["portraittype"] == 2 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_FocusPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
            if UnitFramesPlusDB["player"]["portrait"] == 1 
            and UnitFramesPlusDB["target"]["portrait"] == 1 
            and UnitFramesPlusDB["focus"]["portrait"] == 1 
            and UnitFramesPlusDB["party"]["portrait"] == 1 then
                UnitFramesPlusDB["global"]["portrait"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
                if UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
                elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
                end
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
            UnitFramesPlusDB["global"]["portrait"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["portrait"]==1);
    end)

    --焦点头像类型
    local UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider", UnitFramesPlus_Focus_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusPortraitType, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSliderLow:SetText(UFP_OP_3D);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSliderHigh:SetText(UFP_OP_CLASS);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["focus"]["portraittype"] = value;
        UnitFramesPlus_FocusPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            UnitFramesPlus_OptionsFrame_FocusPortrait3DBGText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
        elseif value == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_FocusPortraitNPCNoText:SetTextColor(1, 1, 1);
        end
    end)

    --焦点3D头像背景
    local UnitFramesPlus_OptionsFrame_FocusPortrait3DBG = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusPortrait3DBG", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusPortraitType, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusPortrait3DBGText:SetText(UFP_OP_Portrait_3DBG);
    UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["portrait3dbg"] = 1 - UnitFramesPlusDB["focus"]["portrait3dbg"];
        UnitFramesPlus_FocusPortrait3DBGDisplayUpdate();
        if UnitFramesPlusDB["focus"]["portrait3dbg"] == 1 then
            if UnitFramesPlusDB["player"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["target"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["party"]["portrait3dbg"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    UnitFramesPlusDB["global"]["portrait3dbg"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portrait3dbg"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["portrait3dbg"]==1);
    end)

    --焦点为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusPortrait3DBG, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["portraitnpcno"] = 1 - UnitFramesPlusDB["focus"]["portraitnpcno"];
        UnitFramesPlus_FocusPortraitDisplayUpdate();
        if UnitFramesPlusDB["focus"]["portraitnpcno"] == 1 then
            if UnitFramesPlusDB["target"]["portraitnpcno"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    UnitFramesPlusDB["global"]["portraitnpcno"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portraitnpcno"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["portraitnpcno"]==1);
    end)

    --焦点Shift拖动头像
    local UnitFramesPlus_OptionsFrame_FocusShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusShiftDrag", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusPortrait3DBG, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_FocusShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["movable"] = 1 - UnitFramesPlusDB["focus"]["movable"];
        if UnitFramesPlusDB["focus"]["movable"] == 1 then
            if UnitFramesPlusDB["player"]["movable"] == 1 
            and UnitFramesPlusDB["target"]["movable"] == 1 
            and UnitFramesPlusDB["targettarget"]["movable"] == 1 
            and UnitFramesPlusDB["focustarget"]["movable"] == 1 
            and UnitFramesPlusDB["party"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["movable"]==1);
    end)

    --焦点头像内战斗信息
    local UnitFramesPlus_OptionsFrame_FocusPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusPortraitIndicator", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusShiftDrag, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_FocusPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["indicator"] = 1 - UnitFramesPlusDB["focus"]["indicator"];
        UnitFramesPlus_FocusPortraitIndicator();
        if UnitFramesPlusDB["focus"]["indicator"] == 1 then
            if UnitFramesPlusDB["player"]["indicator"] == 1 
            and UnitFramesPlusDB["pet"]["indicator"] == 1 
            and UnitFramesPlusDB["target"]["indicator"] == 1 
            and UnitFramesPlusDB["party"]["indicator"] == 1 then
                UnitFramesPlusDB["global"]["indicator"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["indicator"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["indicator"]==1);
    end)

    --焦点生命条染色
    local UnitFramesPlus_OptionsFrame_FocusColorHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusColorHP", UnitFramesPlus_Focus_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusColorHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusPortraitIndicator, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusColorHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusColorHPText:SetText(UFP_OP_ColorHP);
    UnitFramesPlus_OptionsFrame_FocusColorHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focus"]["colorhp"] = 1 - UnitFramesPlusDB["focus"]["colorhp"];
        if UnitFramesPlusDB["focus"]["colorhp"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusColorHPSlider);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusColorHPSlider);
        end
        UnitFramesPlus_FocusColorHPBar();
        UnitFramesPlus_FocusColorHPBarDisplayUpdate();
        if UnitFramesPlusDB["focus"]["colorhp"] == 1 then
            if UnitFramesPlusDB["player"]["colorhp"] == 1 
            and UnitFramesPlusDB["target"]["colorhp"] == 1 
            and UnitFramesPlusDB["party"]["colorhp"] == 1 then
                UnitFramesPlusDB["global"]["colorhp"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            end
        else
            UnitFramesPlusDB["global"]["colorhp"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
        end
        self:SetChecked(UnitFramesPlusDB["focus"]["colorhp"]==1);
    end)

    --焦点生命条染色类型
    local UnitFramesPlus_OptionsFrame_FocusColorHPSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_FocusColorHPSlider", UnitFramesPlus_Focus_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusColorHP, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_FocusColorHPSliderLow:SetText(UFP_OP_ColorHP_Class);
    UnitFramesPlus_OptionsFrame_FocusColorHPSliderHigh:SetText(UFP_OP_ColorHP_HPPct);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["focus"]["colortype"] = value;
        UnitFramesPlus_FocusColorHPBar();
        UnitFramesPlus_FocusColorHPBarDisplayUpdate();
    end)

    --焦点目标设定
    local focustargetconfig = UnitFramesPlus_FocusTarget_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    focustargetconfig:SetPoint("TOPLEFT", 16, -16);
    focustargetconfig:SetText(UFP_OP_FocusTarget_Options);

    --焦点目标
    local UnitFramesPlus_OptionsFrame_FocusTarget = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTarget", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTarget:SetPoint("TOPLEFT", focustargetconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_FocusTarget:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetText:SetText(UFP_OP_Focus_ToF);
    UnitFramesPlus_OptionsFrame_FocusTarget:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["show"] = 1 - UnitFramesPlusDB["focustarget"]["show"];
        if UnitFramesPlusDB["focustarget"]["show"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider);
            UnitFramesPlus_OptionsFrame_FocusTargetScaleSliderText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetHPPct);
            UnitFramesPlus_OptionsFrame_FocusTargetHPPctText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck);
            UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheckText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetColorName);
            UnitFramesPlus_OptionsFrame_FocusTargetColorNameText:SetTextColor(1, 1, 1);
	        if UnitFramesPlusDB["focustarget"]["colorname"] == 1 then
	            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
	            UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
	        end
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetShortName);
            UnitFramesPlus_OptionsFrame_FocusTargetShortNameText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetDebuff);
            UnitFramesPlus_OptionsFrame_FocusTargetDebuffText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["focustarget"]["debuff"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
                UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldownText:SetTextColor(1, 1, 1);
            end
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag);
            UnitFramesPlus_OptionsFrame_FocusTargetShiftDragText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait);
            UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["focustarget"]["portrait"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetHPPct);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetShortName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuff);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
        end
        UnitFramesPlus_FocusTarget();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["show"]==1);
    end)

    --焦点目标职业图标头像
    local UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTarget, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitText:SetText(UFP_OP_ClassPortrait);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["portrait"] = 1 - UnitFramesPlusDB["focustarget"]["portrait"];
        UnitFramesPlus_FocusTargetClassPortraitDisplayUpdate();
        if UnitFramesPlusDB["focustarget"]["portrait"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["focustarget"]["portrait"]==1);
    end)

    --焦点目标为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["portraitnpcno"] = 1 - UnitFramesPlusDB["focustarget"]["portraitnpcno"];
        UnitFramesPlus_FocusTargetClassPortraitDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["portraitnpcno"]==1);
    end)

    --焦点目标生命值百分比
    local UnitFramesPlus_OptionsFrame_FocusTargetHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetHPPct", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetHPPctText:SetText(UFP_OP_HPPct);
    UnitFramesPlus_OptionsFrame_FocusTargetHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["hppct"] = 1 - UnitFramesPlusDB["focustarget"]["hppct"];
        UnitFramesPlus_FocusTargetDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["hppct"]==1);
    end)

    --焦点目标敌友检测
    local UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetHPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheckText:SetText(UFP_OP_EnemyCheck);
    UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["enemycheck"] = 1 - UnitFramesPlusDB["focustarget"]["enemycheck"];
        if UnitFramesPlusDB["focustarget"]["enemycheck"] ~= 1 then
            _G["UFP_ToFFrame"].Highlight:SetAlpha(0);
        end
        self:SetChecked(UnitFramesPlusDB["focustarget"]["enemycheck"]==1);
    end)

    --焦点目标名字职业染色
    local UnitFramesPlus_OptionsFrame_FocusTargetColorName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetColorName", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetColorName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetColorName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameText:SetText(UFP_OP_ColorName);
    UnitFramesPlus_OptionsFrame_FocusTargetColorName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["colorname"] = 1 - UnitFramesPlusDB["focustarget"]["colorname"];
        if UnitFramesPlusDB["focustarget"]["colorname"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
            UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
        end
        UnitFramesPlus_FocusTargetDisplayUpdate(id);
        self:SetChecked(UnitFramesPlusDB["focustarget"]["colorname"]==1);
    end)

    --焦点目标名字职业染色NPC不显示
    local UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetColorName, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["colornamenpcno"] = 1 - UnitFramesPlusDB["focustarget"]["colornamenpcno"];
        self:SetChecked(UnitFramesPlusDB["focustarget"]["colornamenpcno"]==1);
    end)

    --焦点目标名字显示为(*)
    local UnitFramesPlus_OptionsFrame_FocusTargetShortName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetShortName", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetShortName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetColorName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetShortName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetShortNameText:SetText(UFP_OP_ShortName);
    UnitFramesPlus_OptionsFrame_FocusTargetShortName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["shortname"] = 1 - UnitFramesPlusDB["focustarget"]["shortname"];
        UnitFramesPlus_FocusTargetDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["shortname"]==1);
    end)

    --焦点目标Debuff
    local UnitFramesPlus_OptionsFrame_FocusTargetDebuff = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetDebuff", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetDebuff:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetShortName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuff:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffText:SetText(UFP_OP_Debuff);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuff:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["debuff"] = 1 - UnitFramesPlusDB["focustarget"]["debuff"];
        if UnitFramesPlusDB["focustarget"]["debuff"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
            UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldownText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
        end
        UnitFramesPlus_FocusTargetDebuff();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["debuff"]==1);
    end)

    --目标的目标debuff冷却
    local UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetDebuff, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldownText:SetText(UFP_OP_Cooldown);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["cooldown"] = 1 - UnitFramesPlusDB["focustarget"]["cooldown"];
        UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldownDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["focustarget"]["cooldown"]==1);
    end)

    --焦点目标Shift拖动头像
    local UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag", UnitFramesPlus_FocusTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetDebuff, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_FocusTargetShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["focustarget"]["movable"] = 1 - UnitFramesPlusDB["focustarget"]["movable"];
        if UnitFramesPlusDB["focustarget"]["movable"] == 1 then
            if UnitFramesPlusDB["player"]["movable"] == 1 
            and UnitFramesPlusDB["target"]["movable"] == 1 
            and UnitFramesPlusDB["targettarget"]["movable"] == 1 
            and UnitFramesPlusDB["focus"]["movable"] == 1 
            and UnitFramesPlusDB["party"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["focustarget"]["movable"]==1);
    end)

    --焦点目标缩放
    local UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider", UnitFramesPlus_FocusTarget_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["focustarget"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["focustarget"]["scale"] = value/100;
        UnitFramesPlus_FocusTargetScale(UnitFramesPlusDB["focustarget"]["scale"]);
        UnitFramesPlus_OptionsFrame_FocusTargetScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["focustarget"]["scale"]*100).."%");
    end)

    --队伍设定
    local partyconfig = UnitFramesPlus_Party_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    partyconfig:SetPoint("TOPLEFT", 16, -16);
    partyconfig:SetText(UFP_OP_Party_Options);

    --自动开启传统小队界面
    local UnitFramesPlus_OptionsFrame_PartyOrigin = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyOrigin", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyOrigin:SetPoint("TOPLEFT", partyconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_PartyOrigin:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyOriginText:SetText(UFP_OP_Party_Origin);
    UnitFramesPlus_OptionsFrame_PartyOrigin:SetScript("OnClick", function(self)
        rl = "origin";
        StaticPopup_Show("UFP_RELOADUI");
        self:SetChecked(UnitFramesPlusDB["party"]["origin"]==1);
    end)

    --队友生命值
    local UnitFramesPlus_OptionsFrame_PartyHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyHP", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyOrigin, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyHPText:SetText(UFP_OP_Party_HP);
    UnitFramesPlus_OptionsFrame_PartyHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["hp"] = 1 - UnitFramesPlusDB["party"]["hp"];
        if UnitFramesPlusDB["party"]["hp"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyHPPct);
            UnitFramesPlus_OptionsFrame_PartyHPPctText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyHPPct);
        end
        UnitFramesPlus_PartyTargetPosition();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyHealthPctDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["hp"]==1);
    end)

    --队友生命值百分比
    local UnitFramesPlus_OptionsFrame_PartyHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyHPPct", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyHP, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyHPPctText:SetText(UFP_OP_Party_HPPct);
    UnitFramesPlus_OptionsFrame_PartyHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["hppct"] = 1 - UnitFramesPlusDB["party"]["hppct"];
        UnitFramesPlus_PartyTargetPosition();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyHealthPctDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["hppct"]==1);
    end)

    --队友名字染色
    local UnitFramesPlus_OptionsFrame_PartyColorName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyColorName", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyColorName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyHP, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyColorName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyColorNameText:SetText(UFP_OP_ColorName);
    UnitFramesPlus_OptionsFrame_PartyColorName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["colorname"] = 1 - UnitFramesPlusDB["party"]["colorname"];
        UnitFramesPlus_PartyName();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyColorNameDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["colorname"]==1);
    end)

    --队友名字显示为(*)
    local UnitFramesPlus_OptionsFrame_PartyShortName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyShortName", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyShortName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyColorName, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyShortName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyShortNameText:SetText(UFP_OP_ShortName);
    UnitFramesPlus_OptionsFrame_PartyShortName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["shortname"] = 1 - UnitFramesPlusDB["party"]["shortname"];
        UnitFramesPlus_PartyName();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyShortNameDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["shortname"]==1);
    end)

    --队友等级
    local UnitFramesPlus_OptionsFrame_PartyLevel = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyLevel", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyLevel:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyColorName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyLevel:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyLevelText:SetText(UFP_OP_Party_Level);
    UnitFramesPlus_OptionsFrame_PartyLevel:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["level"] = 1 - UnitFramesPlusDB["party"]["level"];
        UnitFramesPlus_PartyLevel();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyLevelDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["level"]==1);
    end)

    --队友离线检测
    local UnitFramesPlus_OptionsFrame_PartyOfflineDetection = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyOfflineDetection", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyOfflineDetection:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyLevel, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyOfflineDetection:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyOfflineDetectionText:SetText(UFP_OP_Party_OnOff);
    UnitFramesPlus_OptionsFrame_PartyOfflineDetection:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["onoff"] = 1 - UnitFramesPlusDB["party"]["onoff"];
        UnitFramesPlus_PartyOfflineDetection();
        UnitFramesPlus_PartyOfflineDetectionDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["party"]["onoff"]==1);
    end)

    --队友死亡检测
    local UnitFramesPlus_OptionsFrame_PartyDeathGhost = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyDeathGhost", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyDeathGhost:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyOfflineDetection, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyDeathGhost:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyDeathGhostText:SetText(UFP_OP_Party_Death);
    UnitFramesPlus_OptionsFrame_PartyDeathGhost:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["death"] = 1 - UnitFramesPlusDB["party"]["death"];
        self:SetChecked(UnitFramesPlusDB["party"]["death"]==1);
    end)

    --队友buff/debuff直接显示
    local UnitFramesPlus_OptionsFrame_PartyBuff = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyBuff", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyBuff:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyOfflineDetection, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyBuff:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffText:SetText(UFP_OP_Buff);
    UnitFramesPlus_OptionsFrame_PartyBuff:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["buff"] = 1 - UnitFramesPlusDB["party"]["buff"];
        if UnitFramesPlusDB["party"]["buff"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyBuffCooldown);
            UnitFramesPlus_OptionsFrame_PartyBuffCooldownText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyBuffHidetip);
            UnitFramesPlus_OptionsFrame_PartyBuffHidetipText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyBuffFilter);
            UnitFramesPlus_OptionsFrame_PartyBuffFilterText:SetTextColor(1, 1, 1);
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffCooldown);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffHidetip);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffFilter);
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
        end
        UnitFramesPlus_PartyBuff();
        self:SetChecked(UnitFramesPlusDB["party"]["buff"]==1);
    end)

    --队友目标debuff冷却
    local UnitFramesPlus_OptionsFrame_PartyBuffCooldown = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyBuffCooldown", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyBuffCooldown:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyBuff, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffCooldown:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffCooldownText:SetText(UFP_OP_Cooldown);
    UnitFramesPlus_OptionsFrame_PartyBuffCooldown:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["cooldown"] = 1 - UnitFramesPlusDB["party"]["cooldown"];
        UnitFramesPlus_OptionsFrame_PartyBuffCooldownDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["party"]["cooldown"]==1);
    end)

    --队友buff/debuff鼠标提示
    local UnitFramesPlus_OptionsFrame_PartyBuffHidetip = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyBuffHidetip", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyBuffHidetip:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyBuff, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyBuffHidetip:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffHidetipText:SetText(UFP_OP_HideBuffTip);
    UnitFramesPlus_OptionsFrame_PartyBuffHidetip:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["hidetip"] = 1 - UnitFramesPlusDB["party"]["hidetip"];
        self:SetChecked(UnitFramesPlusDB["party"]["hidetip"]==1);
    end)

    --队友Buff filter
    local UnitFramesPlus_OptionsFrame_PartyBuffFilter = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyBuffFilter", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyBuffFilter:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyBuffHidetip, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyBuffFilter:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffFilterText:SetText(UFP_OP_Filter);
    UnitFramesPlus_OptionsFrame_PartyBuffFilter:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["filter"] = 1 - UnitFramesPlusDB["party"]["filter"];
        if UnitFramesPlusDB["party"]["filter"] ~= 1 then
            UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
        else
            UIDropDownMenu_EnableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["filter"]==1);
    end)

    --队友Buff过滤类型
    local UnitFramesPlus_OptionsFrame_PartyBuffFilterType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyBuffFilterType", UnitFramesPlus_Party_Options, "UIDropDownMenuTemplate");
    UnitFramesPlus_OptionsFrame_PartyBuffFilterType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyBuffFilter, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyBuffFilterType:SetHitRectInsets(0, -100, 0, 0);
    UIDropDownMenu_SetWidth(UnitFramesPlus_OptionsFrame_PartyBuffFilterType, 95);
    UIDropDownMenu_Initialize(UnitFramesPlus_OptionsFrame_PartyBuffFilterType, PartyBuffFilterType_Init);
    UIDropDownMenu_SetSelectedID(UnitFramesPlus_OptionsFrame_PartyBuffFilterType, UnitFramesPlusDB["party"]["filtertype"]);

    --队友施法条
    local UnitFramesPlus_OptionsFrame_PartyCastbar = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyCastbar", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyCastbar:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyBuffFilter, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyCastbar:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyCastbarText:SetText(UFP_OP_Party_CastBar);
    UnitFramesPlus_OptionsFrame_PartyCastbar:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["castbar"] = 1 - UnitFramesPlusDB["party"]["castbar"];
        UnitFramesPlus_PartyCastbar();
        self:SetChecked(UnitFramesPlusDB["party"]["castbar"]==1);
    end)

    --队友头像缩放
    local UnitFramesPlus_OptionsFrame_PartyScaleSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PartyScaleSlider", UnitFramesPlus_Party_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetWidth(154);
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyCastbar, "TOPLEFT", 30, -45);
    UnitFramesPlus_OptionsFrame_PartyScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["party"]["scale"]*100).."%");
    UnitFramesPlus_OptionsFrame_PartyScaleSliderLow:SetText("50%");
    UnitFramesPlus_OptionsFrame_PartyScaleSliderHigh:SetText("150%");
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetMinMaxValues(50,150);
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["party"]["scale"] = value/100;
        UnitFramesPlus_PartyScale(UnitFramesPlusDB["party"]["scale"]);
        UnitFramesPlus_OptionsFrame_PartyScaleSliderText:SetText(UFP_OP_Scale..(UnitFramesPlusDB["party"]["scale"]*100).."%");
    end)

    --队友鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_PartyMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyMouseShow", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyMouseShow:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyScaleSlider, "TOPLEFT", -30, -35);
    UnitFramesPlus_OptionsFrame_PartyMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyMouseShowText:SetText(UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_PartyMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["party"]["mouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["party"]["mouseshow"] = 1 - UnitFramesPlusDB["party"]["mouseshow"];
        if UnitFramesPlusDB["party"]["mouseshow"] == 1 then
            if UnitFramesPlusDB["player"]["mouseshow"] == 1
            and UnitFramesPlusDB["pet"]["mouseshow"] == 1 
            and UnitFramesPlusDB["target"]["mouseshow"] == 1 
            and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
            and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_PartyBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["party"]["mouseshow"]==1);
    end)

    --队友头像类型开关
    local UnitFramesPlus_OptionsFrame_PartyPortraitType = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyPortraitType", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyPortraitType:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyPortraitType:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeText:SetText(UFP_OP_Portrait);
    UnitFramesPlus_OptionsFrame_PartyPortraitType:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["portrait"] = 1 - UnitFramesPlusDB["party"]["portrait"];
        UnitFramesPlus_PartyPortrait();
        if UnitFramesPlusDB["party"]["portrait"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
            if UnitFramesPlusDB["party"]["portraittype"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
                UnitFramesPlus_OptionsFrame_PartyPortrait3DBGText:SetTextColor(1, 1, 1);
            end
            if UnitFramesPlusDB["player"]["portrait"] == 1 
            and UnitFramesPlusDB["target"]["portrait"] == 1 
            and UnitFramesPlusDB["focus"]["portrait"] == 1
            and UnitFramesPlusDB["party"]["portrait"] == 1 then
                UnitFramesPlusDB["global"]["portrait"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
                if UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBGText:SetTextColor(1, 1, 1);
                elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
                    BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
                end
            end
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
            UnitFramesPlusDB["global"]["portrait"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["portrait"]==1);
    end)

    --队友头像类型
    local UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider", UnitFramesPlus_Party_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyPortraitType, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSliderLow:SetText(UFP_OP_3D);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSliderHigh:SetText(UFP_OP_CLASS);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["party"]["portraittype"] = value;
        UnitFramesPlus_PartyPortrait();
        if value == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
            UnitFramesPlus_OptionsFrame_PartyPortrait3DBGText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
        end
    end)

    --队友3D头像背景
    local UnitFramesPlus_OptionsFrame_PartyPortrait3DBG = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyPortrait3DBG", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyPortraitType, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyPortrait3DBGText:SetText(UFP_OP_Portrait_3DBG);
    UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["portrait3dbg"] = 1 - UnitFramesPlusDB["party"]["portrait3dbg"];
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyPortrait3DBGDisplayUpdate(id);
        end
        if UnitFramesPlusDB["party"]["portrait3dbg"] == 1 then
            if UnitFramesPlusDB["player"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["target"]["portrait3dbg"] == 1 
            and UnitFramesPlusDB["focus"]["portrait3dbg"] == 1 then
                if UnitFramesPlusDB["global"]["portrait"] == 1 
                and UnitFramesPlusDB["global"]["portraittype"] == 1 then
                    UnitFramesPlusDB["global"]["portrait3dbg"] = 1;
                    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(true);
                end
            end
        else
            UnitFramesPlusDB["global"]["portrait3dbg"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["portrait3dbg"]==1);
    end)

    --队友Shift拖动头像
    local UnitFramesPlus_OptionsFrame_PartyShiftDrag = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyShiftDrag", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyShiftDrag:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyPortrait3DBG, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyShiftDrag:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyShiftDragText:SetText(UFP_OP_Shift_Movable);
    UnitFramesPlus_OptionsFrame_PartyShiftDrag:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["movable"] = 1 - UnitFramesPlusDB["party"]["movable"];
        if UnitFramesPlusDB["party"]["movable"] == 1 then
            if UnitFramesPlusDB["player"]["movable"] == 1 
            and UnitFramesPlusDB["target"]["movable"] == 1 
            and UnitFramesPlusDB["targettarget"]["movable"] == 1 
            and UnitFramesPlusDB["focus"]["movable"] == 1 
            and UnitFramesPlusDB["focustarget"]["movable"] == 1 then
                UnitFramesPlusDB["global"]["movable"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["movable"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["movable"]==1);
    end)

    --队友头像内战斗信息
    local UnitFramesPlus_OptionsFrame_PartyPortraitIndicator = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyPortraitIndicator", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyPortraitIndicator:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyShiftDrag, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyPortraitIndicator:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyPortraitIndicatorText:SetText(UFP_OP_Portrait_Indicator);
    UnitFramesPlus_OptionsFrame_PartyPortraitIndicator:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["indicator"] = 1 - UnitFramesPlusDB["party"]["indicator"];
        UnitFramesPlus_PartyPortraitIndicator();
        if UnitFramesPlusDB["party"]["indicator"] == 1 then
            if UnitFramesPlusDB["player"]["indicator"] == 1 
            and UnitFramesPlusDB["pet"]["indicator"] == 1 
            and UnitFramesPlusDB["target"]["indicator"] == 1 
            and UnitFramesPlusDB["focus"]["indicator"] == 1 then
                UnitFramesPlusDB["global"]["indicator"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["indicator"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(false);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["indicator"]==1);
    end)

    --队友生命条染色
    local UnitFramesPlus_OptionsFrame_PartyColorHP = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyColorHP", UnitFramesPlus_Party_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyColorHP:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyPortraitIndicator, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyColorHP:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyColorHPText:SetText(UFP_OP_ColorHP);
    UnitFramesPlus_OptionsFrame_PartyColorHP:SetScript("OnClick", function(self)
        UnitFramesPlusDB["party"]["colorhp"] = 1 - UnitFramesPlusDB["party"]["colorhp"];
        if UnitFramesPlusDB["party"]["colorhp"] == 1 then
            BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
        else
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
        end
        UnitFramesPlus_PartyColorHPBar();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyColorHPBarDisplayUpdate(id);
        end
        if UnitFramesPlusDB["party"]["colorhp"] == 1 then
            if UnitFramesPlusDB["player"]["colorhp"] == 1 
            and UnitFramesPlusDB["target"]["colorhp"] == 1 
            and UnitFramesPlusDB["focus"]["colorhp"] == 1 then
                UnitFramesPlusDB["global"]["colorhp"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(true);
                BlizzardOptionsPanel_Slider_Enable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
            end
        else
            UnitFramesPlusDB["global"]["colorhp"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(false);
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
        end
        self:SetChecked(UnitFramesPlusDB["party"]["colorhp"]==1);
    end)

    --队友生命条染色类型
    local UnitFramesPlus_OptionsFrame_PartyColorHPSlider = CreateFrame("Slider", "UnitFramesPlus_OptionsFrame_PartyColorHPSlider", UnitFramesPlus_Party_Options, "OptionsSliderTemplate");
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetWidth(95);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetHeight(16);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyColorHP, "TOPLEFT", 183, 0);
    UnitFramesPlus_OptionsFrame_PartyColorHPSliderLow:SetText(UFP_OP_ColorHP_Class);
    UnitFramesPlus_OptionsFrame_PartyColorHPSliderHigh:SetText(UFP_OP_ColorHP_HPPct);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetMinMaxValues(1,2);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetValueStep(1);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetObeyStepOnDrag(true);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetScript("OnValueChanged", function(self, value)
        UnitFramesPlusDB["party"]["colortype"] = value;
        UnitFramesPlus_PartyColorHPBar();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyColorHPBarDisplayUpdate(id);
        end
    end)


    --队伍目标设定
    local partytargetconfig = UnitFramesPlus_PartyTarget_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    partytargetconfig:SetPoint("TOPLEFT", 16, -16);
    partytargetconfig:SetText(UFP_OP_PartyTarget_Options);

    --队友目标自动开启传统小队界面
    local UnitFramesPlus_OptionsFrame_PartyTargetOrigin = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetOrigin", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetOrigin:SetPoint("TOPLEFT", partytargetconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_PartyTargetOrigin:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetOriginText:SetText(UFP_OP_Party_Origin);
    UnitFramesPlus_OptionsFrame_PartyTargetOrigin:SetScript("OnClick", function(self)
        rl = "origin";
        StaticPopup_Show("UFP_RELOADUI");
        self:SetChecked(UnitFramesPlusDB["party"]["origin"]==1);
    end)

    --队友目标
    local UnitFramesPlus_OptionsFrame_PartyTarget = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTarget", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTarget:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetOrigin, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTarget:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetText:SetText(UFP_OP_Party_Target);
    UnitFramesPlus_OptionsFrame_PartyTarget:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["show"] = 1 - UnitFramesPlusDB["partytarget"]["show"];
        for id = 1, 4, 1 do
            _G["UFP_PartyTarget"..id]:SetAlpha(UnitFramesPlusDB["partytarget"]["show"]);
        end
        UnitFramesPlus_PartyTarget();
        if UnitFramesPlusDB["partytarget"]["show"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetLite);
            UnitFramesPlus_OptionsFrame_PartyTargetLiteText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetHPPct);
            UnitFramesPlus_OptionsFrame_PartyTargetHPPctText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck);
            UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheckText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetColorName);
            UnitFramesPlus_OptionsFrame_PartyTargetColorNameText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["partytarget"]["colorname"] == 1 then
	            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
	            UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
	        end
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetShortName);
            UnitFramesPlus_OptionsFrame_PartyTargetShortNameText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetDebuff);
            UnitFramesPlus_OptionsFrame_PartyTargetDebuffText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["partytarget"]["debuff"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
                UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldownText:SetTextColor(1, 1, 1);
            end
            -- BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetHighlight);
            -- UnitFramesPlus_OptionsFrame_PartyTargetHighlightText:SetTextColor(1, 1, 1);
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
            UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["partytarget"]["portrait"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetLite);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHPPct);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetShortName);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuff);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
            -- BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHighlight);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["show"]==1);
    end)

    --简易模式
    local UnitFramesPlus_OptionsFrame_PartyTargetLite = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetLite", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetLite:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTarget, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetLite:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetLiteText:SetText(UFP_OP_Party_TargetLite);
    UnitFramesPlus_OptionsFrame_PartyTargetLite:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["lite"] = 1 - UnitFramesPlusDB["partytarget"]["lite"];
        UnitFramesPlus_PartyTarget_Mode();
        if UnitFramesPlusDB["partytarget"]["lite"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
        else
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
            UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitText:SetTextColor(1, 1, 1);
            if UnitFramesPlusDB["partytarget"]["portrait"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
                UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
            end
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["lite"]==1);
    end)

    --队友目标职业图标头像
    local UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTarget, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitText:SetText(UFP_OP_ClassPortrait);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["portrait"] = 1 - UnitFramesPlusDB["partytarget"]["portrait"];
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyTargetClassPortraitDisplayUpdate(id);
        end
        if UnitFramesPlusDB["partytarget"]["portrait"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
            UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["portrait"]==1);
    end)

    --队友目标为NPC时不显示职业头像
    local UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["portraitnpcno"] = 1 - UnitFramesPlusDB["partytarget"]["portraitnpcno"];
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyTargetClassPortraitDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["portraitnpcno"]==1);
    end)

    --队友目标生命值百分比
    local UnitFramesPlus_OptionsFrame_PartyTargetHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetHPPct", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetHPPctText:SetText(UFP_OP_HPPct);
    UnitFramesPlus_OptionsFrame_PartyTargetHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["hppct"] = 1 - UnitFramesPlusDB["partytarget"]["hppct"];
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyTargetDisplayUpdate(id);
        end
        UnitFramesPlus_PartyTargetDebuffPosition();
        self:SetChecked(UnitFramesPlusDB["partytarget"]["hppct"]==1);
    end)

    --队友目标敌友检测
    local UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetHPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheckText:SetText(UFP_OP_EnemyCheck);
    UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["enemycheck"] = 1 - UnitFramesPlusDB["partytarget"]["enemycheck"];
        if UnitFramesPlusDB["partytarget"]["enemycheck"] ~= 1 then
            for id = 1, 4, 1 do
                _G["UFP_PartyTarget"..id].Highlight:SetAlpha(0);
            end
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["enemycheck"]==1);
    end)

    --队友目标名字职业染色
    local UnitFramesPlus_OptionsFrame_PartyTargetColorName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetColorName", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetColorName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetColorName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameText:SetText(UFP_OP_ColorName);
    UnitFramesPlus_OptionsFrame_PartyTargetColorName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["colorname"] = 1 - UnitFramesPlusDB["partytarget"]["colorname"];
        if UnitFramesPlusDB["partytarget"]["colorname"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
            UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNoText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
        end
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyTargetDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["colorname"]==1);
    end)

    --队友目标名字职业染色NPC不显示
    local UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetColorName, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNoText:SetText(UFP_OP_NPCNo);
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["colornamenpcno"] = 1 - UnitFramesPlusDB["partytarget"]["colornamenpcno"];
        self:SetChecked(UnitFramesPlusDB["partytarget"]["colornamenpcno"]==1);
    end)

    --队友目标名字显示为(*)
    local UnitFramesPlus_OptionsFrame_PartyTargetShortName = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetShortName", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetShortName:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetColorName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetShortName:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetShortNameText:SetText(UFP_OP_ShortName);
    UnitFramesPlus_OptionsFrame_PartyTargetShortName:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["shortname"] = 1 - UnitFramesPlusDB["partytarget"]["shortname"];
        UnitFramesPlus_PartyName();
        for id = 1, 4, 1 do
            UnitFramesPlus_PartyTargetDisplayUpdate(id);
        end
        self:SetChecked(UnitFramesPlusDB["partytarget"]["shortname"]==1);
    end)

    --队友目标Debuff
    local UnitFramesPlus_OptionsFrame_PartyTargetDebuff = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetDebuff", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetDebuff:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetShortName, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuff:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffText:SetText(UFP_OP_Debuff);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuff:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["debuff"] = 1 - UnitFramesPlusDB["partytarget"]["debuff"];
        if UnitFramesPlusDB["partytarget"]["debuff"] == 1 then
            BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
            UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldownText:SetTextColor(1, 1, 1);
        else
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
        end
        UnitFramesPlus_PartyTargetDebuff();
        self:SetChecked(UnitFramesPlusDB["partytarget"]["debuff"]==1);
    end)

    --队友目标debuff冷却
    local UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetDebuff, "TOPLEFT", 180, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldownText:SetText(UFP_OP_Cooldown);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown:SetScript("OnClick", function(self)
        UnitFramesPlusDB["partytarget"]["cooldown"] = 1 - UnitFramesPlusDB["partytarget"]["cooldown"];
        UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldownDisplayUpdate();
        self:SetChecked(UnitFramesPlusDB["partytarget"]["cooldown"]==1);
    end)

    --队友目标与玩家目标相同时高亮队友目标
    -- local UnitFramesPlus_OptionsFrame_PartyTargetHighlight = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_PartyTargetHighlight", UnitFramesPlus_PartyTarget_Options, "InterfaceOptionsCheckButtonTemplate");
    -- UnitFramesPlus_OptionsFrame_PartyTargetHighlight:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_PartyTargetDebuff, "TOPLEFT", 0, -30);
    -- UnitFramesPlus_OptionsFrame_PartyTargetHighlight:SetHitRectInsets(0, -100, 0, 0);
    -- UnitFramesPlus_OptionsFrame_PartyTargetHighlightText:SetText(UFP_OP_Highlight);
    -- UnitFramesPlus_OptionsFrame_PartyTargetHighlight:SetScript("OnClick", function(self)
    --     UnitFramesPlusDB["partytarget"]["highlight"] = 1 - UnitFramesPlusDB["partytarget"]["highlight"];
    --     for id = 1, 4, 1 do
    --         UnitFramesPlus_PartyTargetDisplayUpdate(id);
    --     end
    --     self:SetChecked(UnitFramesPlusDB["partytarget"]["highlight"]==1);
    -- end)

    --全局设定
    local otherconfig = UnitFramesPlus_Extra_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    otherconfig:SetPoint("TOPLEFT", 16, -16);
    otherconfig:SetText(UFP_OP_Ext_Options);

    --PVP鼠标移过时才显示数值
    local UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow", UnitFramesPlus_Extra_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow:SetPoint("TOPLEFT", otherconfig, "TOPLEFT", 0, -40);
    UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShowText:SetText("PVP "..UFP_OP_Mouse_Show);
    UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow:SetScript("OnClick", function(self)
        if tonumber(GetCVar("statusText")) ~= 1 then
            StaticPopup_Show("UFP_MOUSESHOW");
            self:SetChecked(UnitFramesPlusDB["extra"]["pvpmouseshow"]==1);
            return;
        end
        UnitFramesPlusDB["extra"]["pvpmouseshow"] = 1 - UnitFramesPlusDB["extra"]["pvpmouseshow"];
        if UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
            if UnitFramesPlusDB["player"]["mouseshow"] == 1
            and UnitFramesPlusDB["pet"]["mouseshow"] == 1 
            and UnitFramesPlusDB["target"]["mouseshow"] == 1 
            and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
            and UnitFramesPlusDB["party"]["mouseshow"] == 1 then
                UnitFramesPlusDB["global"]["mouseshow"] = 1;
                UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(true);
            end
        else
            UnitFramesPlusDB["global"]["mouseshow"] = 0;
            UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(false);
        end
        UnitFramesPlus_ArenaEnemyBarTextMouseShow();
        self:SetChecked(UnitFramesPlusDB["extra"]["pvpmouseshow"]==1);
    end)

    --PVP目标生命值百分比
    local UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct", UnitFramesPlus_Extra_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_ArenaEnemyHPPctText:SetText("PVP "..UFP_OP_HPPct);
    UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["extra"]["pvphppct"] = 1 - UnitFramesPlusDB["extra"]["pvphppct"];
        UnitFramesPlus_ArenaEnemyHPPct();
        self:SetChecked(UnitFramesPlusDB["extra"]["pvphppct"]==1);
    end)

    --BOSS生命值百分比
    local UnitFramesPlus_OptionsFrame_ExtraBossHPPct = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_ExtraBossHPPct", UnitFramesPlus_Extra_Options, "InterfaceOptionsCheckButtonTemplate");
    UnitFramesPlus_OptionsFrame_ExtraBossHPPct:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct, "TOPLEFT", 0, -30);
    UnitFramesPlus_OptionsFrame_ExtraBossHPPct:SetHitRectInsets(0, -100, 0, 0);
    UnitFramesPlus_OptionsFrame_ExtraBossHPPctText:SetText(UFP_OP_Ext_BossHPPct);
    UnitFramesPlus_OptionsFrame_ExtraBossHPPct:SetScript("OnClick", function(self)
        UnitFramesPlusDB["extra"]["bosshppct"] = 1 - UnitFramesPlusDB["extra"]["bosshppct"];
        UnitFramesPlus_BossHealthPct();
        for id = 1, 4, 1 do
            UnitFramesPlus_BossHealthPctDisplayUpdate(id)
        end
        self:SetChecked(UnitFramesPlusDB["extra"]["bosshppct"]==1);
    end)

    --治疗职业距离检测
    if UnitFramesPlusVar["rangecheck"]["enable"] == 1 then
        local UnitFramesPlus_OptionsFrame_ExtraRangeCheck = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_ExtraRangeCheck", UnitFramesPlus_Extra_Options, "InterfaceOptionsCheckButtonTemplate");
        UnitFramesPlus_OptionsFrame_ExtraRangeCheck:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_ExtraBossHPPct, "TOPLEFT", 0, -30);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheck:SetHitRectInsets(0, -100, 0, 0);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckText:SetText(UFP_OP_RangeCheck);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheck:SetScript("OnClick", function(self)
            UnitFramesPlusDB["extra"]["rangecheck"] = 1 - UnitFramesPlusDB["extra"]["rangecheck"];
            if UnitFramesPlusDB["extra"]["rangecheck"] == 1 then
                BlizzardOptionsPanel_CheckButton_Enable(UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance);
                UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstanceText:SetTextColor(1, 1, 1);
            else
                BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance);
            end
            UnitFramesPlus_RangeCheck();
            self:SetChecked(UnitFramesPlusDB["extra"]["rangecheck"]==1);
        end)
    end

    --治疗职业距离检测仅在副本内生效
    if UnitFramesPlusVar["rangecheck"]["enable"] == 1 then
        local UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance = CreateFrame("CheckButton", "UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance", UnitFramesPlus_Extra_Options, "InterfaceOptionsCheckButtonTemplate");
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance:SetPoint("TOPLEFT", UnitFramesPlus_OptionsFrame_ExtraRangeCheck, "TOPLEFT", 180, 0);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance:SetHitRectInsets(0, -100, 0, 0);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstanceText:SetText(UFP_OP_RangeCheck_InInstance);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance:SetScript("OnClick", function(self)
            UnitFramesPlusDB["extra"]["instanceonly"] = 1 - UnitFramesPlusDB["extra"]["instanceonly"];
            self:SetChecked(UnitFramesPlusDB["extra"]["instanceonly"]==1);
        end)
    end
end

function UnitFramesPlus_OptionPanel_OnShow()
    UnitFramesPlus_OptionsFrame_MinimapButton:SetChecked(UnitFramesPlusDB["minimap"]["button"]==1);
    UnitFramesPlus_OptionsFrame_SYSOnBar:SetChecked(false);
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        UnitFramesPlus_OptionsFrame_SYSOnBar_Unit:SetChecked(UnitFramesPlusDB["global"]["textunit"]==1);
    end
    UnitFramesPlusDB["global"]["mouseshow"] = 0;
    if UnitFramesPlusDB["player"]["mouseshow"] == 1 and UnitFramesPlusDB["pet"]["mouseshow"] == 1 
    and UnitFramesPlusDB["target"]["mouseshow"] == 1 and UnitFramesPlusDB["focus"]["mouseshow"] == 1 
    and UnitFramesPlusDB["party"]["mouseshow"] == 1 and UnitFramesPlusDB["extra"]["pvpmouseshow"] == 1 then
        UnitFramesPlusDB["global"]["mouseshow"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalMouseShow:SetChecked(UnitFramesPlusDB["global"]["mouseshow"]==1);
    UnitFramesPlusDB["global"]["portrait"] = 0;
    if UnitFramesPlusDB["player"]["portrait"] == 1 and UnitFramesPlusDB["target"]["portrait"] == 1 
    and UnitFramesPlusDB["focus"]["portrait"] == 1 and UnitFramesPlusDB["party"]["portrait"] == 1 then
        UnitFramesPlusDB["global"]["portrait"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalPortraitType:SetChecked(UnitFramesPlusDB["global"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider:SetValue(UnitFramesPlusDB["global"]["portraittype"]);
    UnitFramesPlusDB["global"]["portrait3dbg"] = 0;
    if UnitFramesPlusDB["player"]["portrait3dbg"] == 1 and UnitFramesPlusDB["target"]["portrait3dbg"] == 1 
    and UnitFramesPlusDB["focus"]["portrait3dbg"] == 1 and UnitFramesPlusDB["party"]["portrait3dbg"] == 1 then
        UnitFramesPlusDB["global"]["portrait3dbg"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG:SetChecked(UnitFramesPlusDB["global"]["portrait3dbg"]==1);
    UnitFramesPlusDB["global"]["portraitnpcno"] = 0;
    if UnitFramesPlusDB["target"]["portraitnpcno"] == 1 and UnitFramesPlusDB["focus"]["portraitnpcno"] == 1 then
        UnitFramesPlusDB["global"]["portraitnpcno"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo:SetChecked(UnitFramesPlusDB["global"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["global"]["portrait"] == 0 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
    elseif UnitFramesPlusDB["global"]["portrait"] == 1 then
        if UnitFramesPlusDB["global"]["portraittype"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortraitNPCNo);
        elseif UnitFramesPlusDB["global"]["portraittype"] == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_GlobalPortrait3DBG);
        end
    end
   UnitFramesPlusDB["global"]["movable"] = 0;
    if UnitFramesPlusDB["player"]["movable"] == 1 and UnitFramesPlusDB["target"]["movable"] == 1 
    and UnitFramesPlusDB["targettarget"]["movable"] == 1 and UnitFramesPlusDB["focus"]["movable"] == 1 
    and UnitFramesPlusDB["focustarget"]["movable"] == 1 and UnitFramesPlusDB["party"]["movable"] == 1 then
        UnitFramesPlusDB["global"]["movable"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalShiftDrag:SetChecked(UnitFramesPlusDB["global"]["movable"]==1);
    UnitFramesPlusDB["global"]["indicator"] = 0;
    if UnitFramesPlusDB["player"]["indicator"] == 1 and UnitFramesPlusDB["pet"]["indicator"] == 1 
    and UnitFramesPlusDB["target"]["indicator"] == 1 and UnitFramesPlusDB["focus"]["indicator"] == 1 
    and UnitFramesPlusDB["party"]["indicator"] == 1 then
        UnitFramesPlusDB["global"]["indicator"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalPortraitIndicator:SetChecked(UnitFramesPlusDB["global"]["indicator"]==1);
    UnitFramesPlusDB["global"]["colorhp"] = 0;
    if UnitFramesPlusDB["player"]["colorhp"] == 1 and UnitFramesPlusDB["target"]["colorhp"] == 1 
    and UnitFramesPlusDB["focus"]["colorhp"] == 1 and UnitFramesPlusDB["party"]["colorhp"] == 1 then
        UnitFramesPlusDB["global"]["colorhp"] = 1;
    end
    UnitFramesPlus_OptionsFrame_GlobalColorHP:SetChecked(UnitFramesPlusDB["global"]["colorhp"]==1);
    UnitFramesPlus_OptionsFrame_GlobalColorHPSlider:SetValue(UnitFramesPlusDB["global"]["colortype"]);
    if UnitFramesPlusDB["global"]["colorhp"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_GlobalColorHPSlider);
    end
    UnitFramesPlus_OptionsFrame_PlayerMouseShow:SetChecked(UnitFramesPlusDB["player"]["mouseshow"]==1);
    UnitFramesPlus_OptionsFrame_PlayerFrameScaleSlider:SetValue(UnitFramesPlusDB["player"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorder:SetChecked(UnitFramesPlusDB["player"]["dragonborder"]==1);
    UnitFramesPlus_OptionsFrame_PlayerDragonBorderType:SetText(PlayerDragonBorderTypeDropDown[UnitFramesPlusDB["player"]["bordertype"]]);
    if UnitFramesPlusDB["player"]["dragonborder"] ~= 1 then
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerDragonBorderType);
    end
    UnitFramesPlus_OptionsFrame_PlayerExtrabar:SetChecked(UnitFramesPlusDB["player"]["extrabar"]==1);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPct:SetChecked(UnitFramesPlusDB["player"]["hpmp"]==1);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne:SetText(PlayerHPMPPctDropDown[UnitFramesPlusDB["player"]["hpmppartone"]]);
    UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo:SetText(PlayerHPMPPctDropDown[UnitFramesPlusDB["player"]["hpmpparttwo"]]);
    if UnitFramesPlusDB["player"]["extrabar"] ~= 0 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerHPMPPct);
    end
    if UnitFramesPlusDB["player"]["hpmp"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerHPMPUnit);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartOne);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PlayerHPMPPctPartTwo);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerCoordinate);
    end
    UnitFramesPlus_OptionsFrame_PlayerHPMPUnit:SetChecked(UnitFramesPlusDB["player"]["hpmpunit"]==1);
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider:SetValue(UnitFramesPlusDB["player"]["unittype"]);
        if UnitFramesPlusDB["player"]["hpmpunit"] ~= 1 or UnitFramesPlusDB["player"]["hpmp"] ~= 1 then
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerUnitTypeSlider);
        end
    end
    UnitFramesPlus_OptionsFrame_PlayerColorHP:SetChecked(UnitFramesPlusDB["player"]["colorhp"]==1);
    UnitFramesPlus_OptionsFrame_PlayerColorHPSlider:SetValue(UnitFramesPlusDB["player"]["colortype"]);
    if UnitFramesPlusDB["player"]["colorhp"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerColorHPSlider);
    end
    UnitFramesPlus_OptionsFrame_PlayerPortraitType:SetChecked(UnitFramesPlusDB["player"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider:SetValue(UnitFramesPlusDB["player"]["portraittype"]);
    UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG:SetChecked(UnitFramesPlusDB["player"]["portrait3dbg"]==1);
    if UnitFramesPlusDB["player"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PlayerPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
    end
    if UnitFramesPlusDB["player"]["portrait"] == 1 then
        if UnitFramesPlusDB["player"]["portraittype"] == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PlayerPortrait3DBG);
        end
    end
    UnitFramesPlus_OptionsFrame_PlayerShiftDrag:SetChecked(UnitFramesPlusDB["player"]["movable"]==1);
    UnitFramesPlus_OptionsFrame_PlayerPortraitIndicator:SetChecked(UnitFramesPlusDB["player"]["indicator"]==1);
    UnitFramesPlus_OptionsFrame_PlayerFrameAutohide:SetChecked(UnitFramesPlusDB["player"]["autohide"]==1);
    UnitFramesPlus_OptionsFrame_PlayerCoordinate:SetChecked(UnitFramesPlusDB["player"]["coord"]==1);
    UnitFramesPlus_OptionsFrame_PetMouseShow:SetChecked(UnitFramesPlusDB["pet"]["mouseshow"]==1)
    UnitFramesPlus_OptionsFrame_PetPortraitIndicator:SetChecked(UnitFramesPlusDB["pet"]["indicator"]==1);
    UnitFramesPlus_OptionsFrame_PetTargetHPPct:SetChecked(UnitFramesPlusDB["pet"]["hppct"]==1);
    UnitFramesPlus_OptionsFrame_PetTargetScaleSlider:SetValue(UnitFramesPlusDB["pet"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_PetTarget:SetChecked(UnitFramesPlusDB["pet"]["target"]==1);
    if UnitFramesPlusDB["pet"]["target"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PetTargetHPPct);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PetTargetScaleSlider);
    end
    UnitFramesPlus_OptionsFrame_TargetExtrabar:SetChecked(UnitFramesPlusDB["target"]["extrabar"]==1);
    UnitFramesPlus_OptionsFrame_TargetHPMPPct:SetChecked(UnitFramesPlusDB["target"]["hpmp"]==1);
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne:SetText(TargetHPMPPctDropDown[UnitFramesPlusDB["target"]["hpmppartone"]]);
    UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo:SetText(TargetHPMPPctDropDown[UnitFramesPlusDB["target"]["hpmpparttwo"]]);
    if UnitFramesPlusDB["target"]["extrabar"] ~= 0 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetHPMPPct);
    end
    if UnitFramesPlusDB["target"]["hpmp"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetHPMPUnit);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartOne);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_TargetHPMPPctPartTwo);
    end
    UnitFramesPlus_OptionsFrame_TargetHPMPUnit:SetChecked(UnitFramesPlusDB["target"]["hpmpunit"]==1);
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider:SetValue(UnitFramesPlusDB["target"]["unittype"]);
        if UnitFramesPlusDB["target"]["hpmpunit"] ~= 1 or UnitFramesPlusDB["target"]["hpmp"] ~= 1 then
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetUnitTypeSlider);
        end
    end
    UnitFramesPlus_OptionsFrame_TargetFrameScaleSlider:SetValue(UnitFramesPlusDB["target"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_TargetMouseShow:SetChecked(UnitFramesPlusDB["target"]["mouseshow"]==1);
    UnitFramesPlus_OptionsFrame_TargetClassIcon:SetChecked(UnitFramesPlusDB["target"]["classicon"]==1);
    UnitFramesPlus_OptionsFrame_TargetClassIconMore:SetChecked(UnitFramesPlusDB["target"]["moreaction"]==1);
    if UnitFramesPlusDB["target"]["classicon"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetClassIconMore);
    end
    UnitFramesPlus_OptionsFrame_TargetRace:SetChecked(UnitFramesPlusDB["target"]["race"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetSYSToT:SetChecked(tonumber(GetCVar("showTargetOfTarget"))==1);
    UnitFramesPlus_OptionsFrame_TargetTargetAutoToT:SetChecked(UnitFramesPlusDB["targettarget"]["systot"]==1);
    UnitFramesPlus_OptionsFrame_TargetTarget:SetChecked(UnitFramesPlusDB["targettarget"]["showtot"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetTarget:SetChecked(UnitFramesPlusDB["targettarget"]["showtotot"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait:SetChecked(UnitFramesPlusDB["targettarget"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo:SetChecked(UnitFramesPlusDB["targettarget"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["targettarget"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_TargetTargetDebuff:SetChecked(UnitFramesPlusDB["targettarget"]["debuff"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown:SetChecked(UnitFramesPlusDB["targettarget"]["cooldown"]==1);
    if UnitFramesPlusDB["targettarget"]["debuff"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetDebuffCooldown);
    end
    UnitFramesPlus_OptionsFrame_TargetTargetShortName:SetChecked(UnitFramesPlusDB["focustarget"]["shortname"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider:SetValue(UnitFramesPlusDB["targettarget"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_TargetTargetHPPct:SetChecked(UnitFramesPlusDB["targettarget"]["hppct"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck:SetChecked(UnitFramesPlusDB["targettarget"]["enemycheck"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetColorName:SetChecked(UnitFramesPlusDB["targettarget"]["colorname"]==1);
    UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo:SetChecked(UnitFramesPlusDB["targettarget"]["colornamenpcno"]==1);
    if UnitFramesPlusDB["targettarget"]["colorname"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
    end
    UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag:SetChecked(UnitFramesPlusDB["targettarget"]["movable"]==1);
    if UnitFramesPlusDB["targettarget"]["showtot"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetTarget);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetDebuff);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetShortName);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetTargetScaleSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetHPPct);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetEnemyCheck);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetColorNameNPCNo);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetShiftDrag);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortrait);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_TargetBuffSize:SetChecked(UnitFramesPlusDB["target"]["buffsize"]==1);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider:SetValue(UnitFramesPlusDB["target"]["mysize"]);
    UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider:SetValue(UnitFramesPlusDB["target"]["othersize"]);
    if UnitFramesPlusDB["target"]["buffsize"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetBuffSizeMineSlider);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetBuffSizeOtherSlider);
    end
    UnitFramesPlus_OptionsFrame_TargetPortraitType:SetChecked(UnitFramesPlusDB["target"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider:SetValue(UnitFramesPlusDB["target"]["portraittype"]);
    UnitFramesPlus_OptionsFrame_TargetPortrait3DBG:SetChecked(UnitFramesPlusDB["target"]["portrait3dbg"]==1);
    UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo:SetChecked(UnitFramesPlusDB["target"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["target"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
    elseif UnitFramesPlusDB["target"]["portrait"] == 1 then
        if UnitFramesPlusDB["target"]["portraittype"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortraitNPCNo);
        elseif UnitFramesPlusDB["target"]["portraittype"] == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_TargetPortrait3DBG);
        end
    end
    UnitFramesPlus_OptionsFrame_TargetShiftDrag:SetChecked(UnitFramesPlusDB["target"]["movable"]==1);
    UnitFramesPlus_OptionsFrame_TargetPortraitIndicator:SetChecked(UnitFramesPlusDB["target"]["indicator"]==1);
    UnitFramesPlus_OptionsFrame_TargetColorHP:SetChecked(UnitFramesPlusDB["target"]["colorhp"]==1);
    UnitFramesPlus_OptionsFrame_TargetColorHPSlider:SetValue(UnitFramesPlusDB["target"]["colortype"]);
    if UnitFramesPlusDB["target"]["colorhp"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_TargetColorHPSlider);
    end
    UnitFramesPlus_OptionsFrame_FocusExtrabar:SetChecked(UnitFramesPlusDB["focus"]["extrabar"]==1);
    UnitFramesPlus_OptionsFrame_FocusHPMPPct:SetChecked(UnitFramesPlusDB["focus"]["hpmp"]==1);
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne:SetText(FocusHPMPPctDropDown[UnitFramesPlusDB["focus"]["hpmppartone"]]);
    UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo:SetText(FocusHPMPPctDropDown[UnitFramesPlusDB["focus"]["hpmpparttwo"]]);
    if UnitFramesPlusDB["focus"]["extrabar"] ~= 0 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusHPMPPct);
    end
    if UnitFramesPlusDB["focus"]["hpmp"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusHPMPUnit);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartOne);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusHPMPPctPartTwo);
    end
    UnitFramesPlus_OptionsFrame_FocusHPMPUnit:SetChecked(UnitFramesPlusDB["focus"]["hpmpunit"]==1);
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider:SetValue(UnitFramesPlusDB["focus"]["unittype"]);
        if UnitFramesPlusDB["focus"]["hpmpunit"] ~= 1 or UnitFramesPlusDB["focus"]["hpmp"] ~= 1 then
            BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusUnitTypeSlider);
        end
    end
    UnitFramesPlus_OptionsFrame_FocusMouseShow:SetChecked(UnitFramesPlusDB["focus"]["mouseshow"]==1);
    UnitFramesPlus_OptionsFrame_FocusFrameScaleSlider:SetValue(UnitFramesPlusDB["focus"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_FocusQuick:SetChecked(UnitFramesPlusDB["focus"]["quick"]==1);
    UnitFramesPlus_OptionsFrame_FocusQuickDropDownText:SetText(QuickFocusDropDown[UnitFramesPlusDB["focus"]["button"]]);
    if UnitFramesPlusDB["focus"]["quick"] ~= 1 then
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_FocusQuickDropDown);
    end
    UnitFramesPlus_OptionsFrame_FocusClassIcon:SetChecked(UnitFramesPlusDB["focus"]["classicon"]==1);
    UnitFramesPlus_OptionsFrame_FocusClassIconMore:SetChecked(UnitFramesPlusDB["focus"]["moreaction"]==1);
    if UnitFramesPlusDB["focus"]["classicon"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusClassIconMore);
    end
    UnitFramesPlus_OptionsFrame_FocusRace:SetChecked(UnitFramesPlusDB["focus"]["race"]==1);
    UnitFramesPlus_OptionsFrame_FocusPortraitType:SetChecked(UnitFramesPlusDB["focus"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider:SetValue(UnitFramesPlusDB["focus"]["portraittype"]);
    UnitFramesPlus_OptionsFrame_FocusPortrait3DBG:SetChecked(UnitFramesPlusDB["focus"]["portrait3dbg"]==1);
    UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo:SetChecked(UnitFramesPlusDB["focus"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["focus"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
    elseif UnitFramesPlusDB["focus"]["portrait"] == 1 then
        if UnitFramesPlusDB["target"]["portraittype"] == 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortraitNPCNo);
        elseif UnitFramesPlusDB["target"]["portraittype"] == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusPortrait3DBG);
        end
    end
    UnitFramesPlus_OptionsFrame_FocusShiftDrag:SetChecked(UnitFramesPlusDB["focus"]["movable"]==1);
    UnitFramesPlus_OptionsFrame_FocusColorHP:SetChecked(UnitFramesPlusDB["focus"]["colorhp"]==1);
    UnitFramesPlus_OptionsFrame_FocusColorHPSlider:SetValue(UnitFramesPlusDB["focus"]["colortype"]);
    if UnitFramesPlusDB["focus"]["colorhp"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusColorHPSlider);
    end
    UnitFramesPlus_OptionsFrame_FocusTarget:SetChecked(UnitFramesPlusDB["focustarget"]["show"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait:SetChecked(UnitFramesPlusDB["focustarget"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo:SetChecked(UnitFramesPlusDB["focustarget"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["focustarget"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_FocusTargetHPPct:SetChecked(UnitFramesPlusDB["focustarget"]["hppct"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck:SetChecked(UnitFramesPlusDB["focustarget"]["enemycheck"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetColorName:SetChecked(UnitFramesPlusDB["focustarget"]["colorname"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo:SetChecked(UnitFramesPlusDB["focustarget"]["colornamenpcno"]==1);
    if UnitFramesPlusDB["focustarget"]["colorname"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
    end
    UnitFramesPlus_OptionsFrame_FocusTargetShortName:SetChecked(UnitFramesPlusDB["focustarget"]["shortname"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuff:SetChecked(UnitFramesPlusDB["focustarget"]["debuff"]==1);
    UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown:SetChecked(UnitFramesPlusDB["focustarget"]["cooldown"]==1);
    if UnitFramesPlusDB["focustarget"]["debuff"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
    end
    UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider:SetValue(UnitFramesPlusDB["focustarget"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag:SetChecked(UnitFramesPlusDB["focustarget"]["movable"]==1);
    if UnitFramesPlusDB["focustarget"]["show"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_FocusTargetScaleSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetHPPct);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetEnemyCheck);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetColorNameNPCNo);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetShortName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuff);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetShiftDrag);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortrait);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_FocusPortraitIndicator:SetChecked(UnitFramesPlusDB["focus"]["indicator"]==1);
    UnitFramesPlus_OptionsFrame_PartyOrigin:SetChecked(UnitFramesPlusDB["party"]["origin"]==1);
    UnitFramesPlus_OptionsFrame_PartyMouseShow:SetChecked(UnitFramesPlusDB["party"]["mouseshow"]==1);
    UnitFramesPlus_OptionsFrame_PartyLevel:SetChecked(UnitFramesPlusDB["party"]["level"]==1);
    UnitFramesPlus_OptionsFrame_PartyColorName:SetChecked(UnitFramesPlusDB["party"]["colorname"]==1);
    UnitFramesPlus_OptionsFrame_PartyShortName:SetChecked(UnitFramesPlusDB["party"]["shortname"]==1);
    UnitFramesPlus_OptionsFrame_PartyHP:SetChecked(UnitFramesPlusDB["party"]["hp"]==1);
    UnitFramesPlus_OptionsFrame_PartyHPPct:SetChecked(UnitFramesPlusDB["party"]["hppct"]==1);
    if UnitFramesPlusDB["party"]["hp"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyHPPct);
    end
    UnitFramesPlus_OptionsFrame_PartyPortraitType:SetChecked(UnitFramesPlusDB["party"]["portrait"]==1)
    UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider:SetValue(UnitFramesPlusDB["party"]["portraittype"]);
    UnitFramesPlus_OptionsFrame_PartyPortrait3DBG:SetChecked(UnitFramesPlusDB["party"]["portrait3dbg"]==1);
    if UnitFramesPlusDB["party"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
    elseif UnitFramesPlusDB["party"]["portrait"] == 1 then
        if UnitFramesPlusDB["party"]["portraittype"] == 2 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
        end
    end
    UnitFramesPlus_OptionsFrame_PartyOfflineDetection:SetChecked(UnitFramesPlusDB["party"]["onoff"]==1);
    UnitFramesPlus_OptionsFrame_PartyDeathGhost:SetChecked(UnitFramesPlusDB["party"]["death"]==1);
    UnitFramesPlus_OptionsFrame_PartyShiftDrag:SetChecked(UnitFramesPlusDB["party"]["movable"]==1);
    UnitFramesPlus_OptionsFrame_PartyPortraitIndicator:SetChecked(UnitFramesPlusDB["party"]["indicator"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetOrigin:SetChecked(UnitFramesPlusDB["party"]["origin"]==1);
    UnitFramesPlus_OptionsFrame_PartyTarget:SetChecked(UnitFramesPlusDB["partytarget"]["show"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetLite:SetChecked(UnitFramesPlusDB["partytarget"]["lite"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait:SetChecked(UnitFramesPlusDB["partytarget"]["portrait"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo:SetChecked(UnitFramesPlusDB["partytarget"]["portraitnpcno"]==1);
    if UnitFramesPlusDB["partytarget"]["portrait"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_PartyTargetHPPct:SetChecked(UnitFramesPlusDB["partytarget"]["hppct"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck:SetChecked(UnitFramesPlusDB["partytarget"]["enemycheck"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetColorName:SetChecked(UnitFramesPlusDB["partytarget"]["colorname"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo:SetChecked(UnitFramesPlusDB["partytarget"]["colornamenpcno"]==1);
    if UnitFramesPlusDB["partytarget"]["colorname"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
    end
    UnitFramesPlus_OptionsFrame_PartyTargetShortName:SetChecked(UnitFramesPlusDB["partytarget"]["shortname"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuff:SetChecked(UnitFramesPlusDB["partytarget"]["debuff"]==1);
    -- UnitFramesPlus_OptionsFrame_PartyTargetHighlight:SetChecked(UnitFramesPlusDB["partytarget"]["highlight"]==1);
    UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown:SetChecked(UnitFramesPlusDB["partytarget"]["cooldown"]==1);
    if UnitFramesPlusDB["partytarget"]["debuff"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
    end
    if UnitFramesPlusDB["partytarget"]["show"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetLite);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHPPct);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorNameNPCNo);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetShortName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuff);
        -- BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHighlight);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
    elseif UnitFramesPlusDB["partytarget"]["lite"] == 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_PartyBuff:SetChecked(UnitFramesPlusDB["party"]["buff"]==1);
    UnitFramesPlus_OptionsFrame_PartyBuffHidetip:SetChecked(UnitFramesPlusDB["party"]["hidetip"]==1);
    UnitFramesPlus_OptionsFrame_PartyBuffCooldown:SetChecked(UnitFramesPlusDB["party"]["cooldown"]==1);
    UnitFramesPlus_OptionsFrame_PartyBuffFilter:SetChecked(UnitFramesPlusDB["party"]["filter"]==1);
    UnitFramesPlus_OptionsFrame_PartyBuffFilterType:SetText(PartyBuffFilterTypeDropDown[UnitFramesPlusDB["party"]["filtertype"]]);
    if UnitFramesPlusDB["party"]["buff"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffHidetip);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_FocusTargetDebuffCooldown);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffFilter);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
    end
    if UnitFramesPlusDB["party"]["filter"] ~= 1 then
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
    end
    UnitFramesPlus_OptionsFrame_PartyCastbar:SetChecked(UnitFramesPlusDB["party"]["castbar"]==1);
    UnitFramesPlus_OptionsFrame_PartyColorHP:SetChecked(UnitFramesPlusDB["party"]["colorhp"]==1);
    UnitFramesPlus_OptionsFrame_PartyColorHPSlider:SetValue(UnitFramesPlusDB["party"]["colortype"]);
    if UnitFramesPlusDB["party"]["colorhp"] ~= 1 then
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
    end
    UnitFramesPlus_OptionsFrame_PartyScaleSlider:SetValue(UnitFramesPlusDB["party"]["scale"]*100);
    UnitFramesPlus_OptionsFrame_PartyOrigin:SetChecked(UnitFramesPlusDB["party"]["origin"]==1);
    if UnitFramesPlusDB["party"]["origin"] ~= 1 then
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyHP);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyHPPct);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyColorName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyShortName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyLevel);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitType);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitTypeSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortrait3DBG);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyOfflineDetection);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyDeathGhost);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTarget);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHPPct);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetEnemyCheck);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetColorName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetShortName);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuff);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetDebuffCooldown);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuff);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffFilter);
        UIDropDownMenu_DisableDropDown(UnitFramesPlus_OptionsFrame_PartyBuffFilterType);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffCooldown);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyBuffHidetip);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyCastbar);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyScaleSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyMouseShow);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyShiftDrag);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyPortraitIndicator);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyColorHP);
        -- BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetHighlight);
        BlizzardOptionsPanel_Slider_Disable(UnitFramesPlus_OptionsFrame_PartyColorHPSlider);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortrait);
        BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_PartyTargetClassPortraitNPCNo);
    end
    UnitFramesPlus_OptionsFrame_ArenaEnemyMouseShow:SetChecked(UnitFramesPlusDB["extra"]["pvpmouseshow"]==1);
    UnitFramesPlus_OptionsFrame_ArenaEnemyHPPct:SetChecked(UnitFramesPlusDB["extra"]["pvphppct"]==1);
    UnitFramesPlus_OptionsFrame_ExtraBossHPPct:SetChecked(UnitFramesPlusDB["extra"]["bosshppct"]==1);
    if UnitFramesPlusVar["rangecheck"]["enable"] == 1 then
        UnitFramesPlus_OptionsFrame_ExtraRangeCheck:SetChecked(UnitFramesPlusDB["extra"]["rangecheck"]==1);
        UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance:SetChecked(UnitFramesPlusDB["extra"]["instanceonly"]==1);
        if UnitFramesPlusDB["extra"]["rangecheck"] ~= 1 then
            BlizzardOptionsPanel_CheckButton_Disable(UnitFramesPlus_OptionsFrame_ExtraRangeCheckInInstance);
        end
    end
end
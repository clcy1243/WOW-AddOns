local Enable_ToolTip = true -- Add progress to tooltip (true/false)

local L = {INSTANCE, WORLD_QUEST_BANNER, HONORABLE_KILLS}

function RAHT_print()
	local _, _, _, wq, wqq = GetAchievementCriteriaInfo(11153,1)
    local _, _, _, hk, hkq = GetAchievementCriteriaInfo(11154,1)
    local dg = 0
	for i = 1,GetAchievementNumCriteria(11152) do
        local _, _, _, a = GetAchievementCriteriaInfo(11152,i)
		dg = dg + a
	end
    print("|cFFFF5151[RAHT]|r " .. L[1] .. ": " .. dg .. "/30")
    print("|cFFFF5151[RAHT]|r " .. L[2] .. ": " .. wq .. "/" .. wqq)
    print("|cFFFF5151[RAHT]|r " .. L[3] .. ": " .. hk .. "/" .. hkq)
end

SLASH_RAHT1 = '/ht'
local function aphandler(msg)
	RAHT_print()
end
SlashCmdList['RAHT'] = aphandler

if Enable_ToolTip then
    local Artifact_ID = {
        ["128402"] = true,
        ["128292"] = true,
        ["128293"] = true,
        ["128403"] = true,
        ["127829"] = true,
        ["127830"] = true,
        ["128831"] = true,
        ["128832"] = true,
        ["128858"] = true,
        ["128859"] = true,
        ["128860"] = true,
        ["128821"] = true,
        ["128822"] = true,
        ["128306"] = true,
        ["128861"] = true,
        ["128826"] = true,
        ["128808"] = true,
        ["127857"] = true,
        ["128820"] = true,
        ["133959"] = true,
        ["128862"] = true,
        ["128938"] = true,
        ["128937"] = true,
        ["128940"] = true,
        ["133948"] = true,
        ["128823"] = true,
        ["128866"] = true,
        ["128867"] = true,
        ["120978"] = true,
        ["128868"] = true,
        ["128825"] = true,
        ["128827"] = true,
        ["133958"] = true,
        ["128869"] = true,
        ["128870"] = true,
        ["128872"] = true,
        ["134552"] = true,
        ["128476"] = true,
        ["128479"] = true,
        ["128935"] = true,
        ["128936"] = true,
        ["128819"] = true,
        ["128873"] = true,
        ["128911"] = true,
        ["128934"] = true,
        ["128942"] = true,
        ["128943"] = true,
        ["137246"] = true,
        ["128941"] = true,
        ["128910"] = true,
        ["128908"] = true,
        ["134553"] = true,
        ["128289"] = true,
        ["128288"] = true
    }

    local function RAHT_GameTip(tooltip)
        local _, link = tooltip:GetItem()
        if not link then return end
        
        local itemString = string.match(link, "item[%-?%d:]+")
        local _, itemId = strsplit(":", itemString)

        if itemId and Artifact_ID[itemId] then
            local _, _, _, wq, wqq = GetAchievementCriteriaInfo(11153,1)
            local _, _, _, hk, hkq = GetAchievementCriteriaInfo(11154,1)
            local dg = 0
            for i = 1,GetAchievementNumCriteria(11152) do
                local _, _, _, a = GetAchievementCriteriaInfo(11152,i)
                dg = dg + a
            end
            local tooltipstring = ""
            if dg ~= 0 and dg < 30 then
                tooltipstring = tooltipstring .. "|n" .. L[1] .. ": " .. dg .. "/30"
            end
            if wq ~= 0 and wq < wqq then
                tooltipstring = tooltipstring .. "|n" .. L[2] .. ": " .. wq .. "/" .. wqq
            end
            if hk ~= 0 and hk < hkq then
                tooltipstring = tooltipstring .. "|n" .. L[3] .. ": " .. hk .. "/" .. hkq
            end

            tooltip:AddLine(tooltipstring ,1 ,1 ,1)
            tooltip:Show()
        end

    end

    GameTooltip:HookScript("OnTooltipSetItem", RAHT_GameTip)
end
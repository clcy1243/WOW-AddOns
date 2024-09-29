local sounds = {} 
for k, v in pairs(SOUNDKIT) do 
    sounds[strlower(k:gsub("_",""))] = v 
end 

--HACK 
--[[
local BlizPlaySound = PlaySound 
function PlaySound(name, ...) 
    if (tonumber(name)) then 
        BlizPlaySound(name, ...) 
    else 
        name = strlower(name) 
        if (sounds[name]) then 
            BlizPlaySound(sounds[name]) 
        end 
    end 
end
]]

local function defaultcvar()

    -- 截圖品質(10最高)
    SetCVar("screenshotQuality", 10)
    -- 截圖格式，tga或jpg
    SetCVar("screenshotFormat", "tga")

    -- 反和諧，0關
    SetCVar("overrideArchive", 0)
    -- 顯示LUA錯誤，1開
    SetCVar("scriptErrors", 1)

    -- 浮動戰鬥文字逗點，1是有逗點
    SetCVar("breakUpLargeNumbers", 0)

    -- 顯示公會離線成員，0關
    SetCVar("guildShowOffline", 0)
    -- 裝備對比，0關
    SetCVar("alwaysCompareItems", 1)

    -- 顯示經驗值數值，1開
    SetCVar("xpBarText", 1)
    --進階提示，1開；tooltip的技能說明，關掉就只顯示技能名字了，這個現在默認是開啟的，不用特別去設置它
    SetCVar("UberTooltips", 1)

    -- 技能隊列，開了才能用自定延遲，1開
    SetCVar("reducedLagTolerance", 1)
    -- 自定延遲值，現在默認應該是0了，可設定的範圍是0~400
    SetCVar("maxSpellStartRecoveryOffset", 100)
    -- 切換技能時觸發保險，1開
    SetCVar("secureAbilityToggle", 1)
    -- 按下按鍵時施放技能，1開，這個現在默認是開啟的，不用特別去設置它
    SetCVar("ActionButtonUseKeyDown", 1)

    -- 公會頭銜，0關
    SetCVar("UnitNameGuildTitle", 0)
    -- 目標頭像顯示所有的增益效果，而非只顯示自己的，1開
    SetCVar("noBuffDebuffFilterOnTarget", 1)
    -- 移動時大地圖半透明，1開
    SetCVar("mapFade", 1)

    -- 背包剩餘空間，0關
    SetCVar("displayFreeBagSlots", 1)
    -- 背包反序排列
    -- SetSortBagsRightToLeft(false)
    -- 反向放置戰利品
    -- SetInsertItemsLeftToRight(false)
    -- 個人資源上的閃光動畫效果
    SetCVar("showSpenderFeedback", 1)
    -- 頭像上不顯示即將到來的治療，這個設定要重載才會生效
    SetCVar("predictedHealth", 1)
    -- 自動打開拾取紀錄，0關
    SetCVar("autoOpenLootHistory", 0)

    -- 只在滑鼠移過時顯示狀態數字
    SetCVar("statusText", 0)
    -- 接任務後自動追蹤直到完成
    SetCVar("autoQuestWatch", 1)
    -- 自動追蹤任務，當你達到一個任務地區時該任務會自動置頂以便觀察該任務
    SetCVar("autoQuestProgress", 1)

    -- 鏡頭跟隨地形，爬坡時往上，下坡時往下
    SetCVar("cameraTerrainTilt", 0)
    -- 顯示仇恨百分比，1開
    SetCVar("threatShowNumeric", 1)
    -- 顯示目標的目標，1開，這是介面裡就有的選項......
    SetCVar("showTargetOfTarget", 1)

    -- 顯示對話泡泡，1開
    SetCVar("chatBubbles", 1)
    -- 不在Tooltip(滑鼠提示)上顯示任務進度
    -- 比如賽納留斯有一長串的精華任務1/4、2/4
    -- 如果關了，M+副本的小怪進度也不會在Tooltip顯示
    SetCVar("showQuestTrackingTooltips", 0)

    -- 最大視距
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)

    -- 導演視角(或稱攝影機視角/動態視角)是一種很有臨場感的視角模式

    -- /console ActionCam off
    -- 替換[option]來設定
    -- /console ActionCam [option]

    -- basic - 基本ActionCam功能
    -- full - 全開ActionCam功能
    -- off - 關閉ActionCam功能
    -- default - 預設ActionCam選項

    -- overNames - 頭上有名條
    -- underNames - 腳下有名條

    -- headMove -鏡頭跟著玩家頭部動作
    -- heavyHeadMove - 鏡頭跟著玩家頭部動作(重)
    -- lowHeadMove - 鏡頭跟著頭(低)
    -- noHeadMove - 鏡頭不跟著頭

    -- focusOff - 焦距只對焦在目標身上
    -- focusOn - 動態對焦(沒有目標對焦)

    --[[ 在介面選項裡可以勾選"啟用大型名條"來使用預設的樣式 ]] --

    -- 姓名板職業染色，1開
    SetCVar("ShowClassColorInNameplate", 1)
    -- 在名條下顯示施法條，1開
    SetCVar("showVKeyCastbar", 1)
    -- 只在當前目標的名條下顯示施法條，0關
    SetCVar("showVKeyCastbarOnlyOnTarget", 0)
    -- 在名條下的施法條顯示法術名稱，1開
    SetCVar("showVKeyCastbarSpellName", 1)
    -- 非當前目標的名條透明度
    SetCVar("nameplateMinAlpha", 0.8)
    -- 7.1新加的，開啟友方血條時一併開啟友方npc姓名板
    SetCVar("nameplateShowFriendlyNPCs", 1)

    -- 名條寬高設定：預設是1，啟用大型名條後，預設是是1.39寬2.7高
    -- 數值可以自訂，如下例：改成1寬3高
    SetCVar("NamePlateHorizontalScale", 1)
    SetCVar("NamePlateVerticalScale", 3)
    -- 顯示名條的最遠距離：legion默認是60，以前是40；60太遠了，容易干擾畫面。建議遠程職業設定為你的最遠射程+5碼
    SetCVar("nameplateMaxDistance", 50)
    -- tab最近的目標
    SetCVar("Targetnearestuseold", 1)
    --[[ 視個人需求使用 ]] --

    -- 不讓名條貼邊，預設會貼邊的topinset是0.08，bottominset是0.1
    -- SetCVar("nameplateOtherTopInset", -1)
    -- SetCVar("nameplateOtherBottomInset", -1)
    -- 對重要NPC(如首領)
    -- SetCVar("nameplateLargeTopInset", -1)
    -- SetCVar("nameplateLargeBottomInset", -1)

    --[[ 玩家自身姓名板 ]] --

    -- 只能固定垂直方向的位置，當視角拉近時還是會水平偏移，預設topinset是0.5，bottominset是0.2(應該，我沒dump過)
    SetCVar("nameplateSelfTopInset", .7)
    SetCVar("nameplateSelfBottomInset", .3)
    -- 縮放，默認是1
    SetCVar("nameplateSelfScale", 1)
    --[[ 名條縮放 ]] --

    -- 不讓名條隨距離而變小，預設minscale是0.8
    SetCVar("namePlateMinScale", 1)
    SetCVar("namePlateMaxScale", 1)
    -- 如果要調整姓名板的全局縮放
    SetCVar("nameplateSelectedScale", 1)
    -- 重要NPC的名條縮放
    SetCVar("nameplateLargerScale", 1)

    -- 要在遊戲裡更改戰鬥文字的CVar，必需處於非戰鬥狀態，並於更改後/Reload重載介面！
    --[[ 浮動樣式 ]] --

    -- 新的浮動戰鬥文字運動方式，1往上2往下3弧形
    SetCVar("floatingCombatTextFloatMode", 1)
    -- 舊的動戰鬥文字運動方式，0開；使用這項，浮動戰鬥文字就會垂直往上，如同過去
    SetCVar("floatingCombatTextCombatDamageDirectionalScale", 0)
    --[[ 如果要關閉浮動戰鬥文字只要使用這兩項 ]] --

    -- 對目標傷害，0關；如果要關閉傷害數字，使用這項
    SetCVar("floatingCombatTextCombatDamage", 1)
    -- 對目標治療，0關；如果要關閉治療數字，使用這項
    SetCVar("floatingCombatTextCombatHealing", 1)

    --[[ 如果要調整細部(以前的子項目)再使用這些 0=關 1=開 ]] --

    -- 寵物對目標傷害
    SetCVar("floatingCombatTextPetMeleeDamage", 0)
    SetCVar("floatingCombatTextPetSpellDamage", 0)
    -- 目標盾提示
    SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 0)
    -- 自身得盾/護甲提示
    SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 0)

    --[[ 進階設定自己的浮動戰鬥文字 ]] --
    -- 閃招
    SetCVar("floatingCombatTextDodgeParryMiss", 0)
    -- 傷害減免
    SetCVar("floatingCombatTextDamageReduction", 0)
    -- 周期性傷害
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)
    -- 法術警示
    SetCVar("floatingCombatTextReactives", 1)
    -- 他人的糾纏效果(例如 誘補(xxxx-xxxx))
    SetCVar("floatingCombatTextSpellMechanics", 1)
    -- 聲望變化
    SetCVar("floatingCombatTextRepChanges", 0)
    -- 友方治療者名稱
    SetCVar("floatingCombatTextFriendlyHealers", 1)
    -- 進入/離開戰鬥文字提示
    SetCVar("floatingCombatTextCombatState", 0)
    -- 低MP/低HP文字提示
    SetCVar("floatingCombatTextLowManaHealth", 0)
    -- 連擊點
    SetCVar("floatingCombatTextComboPoints", 0)
    -- 能量獲得
    SetCVar("floatingCombatTextEnergyGains", 0)
    -- 周期性能量
    SetCVar("floatingCombatTextPeriodicEnergyGains", 0)
    -- 榮譽擊殺
    SetCVar("floatingCombatTextHonorGains", 0)
    -- 光環
    SetCVar("floatingCombatTextAuras", 0)
end

-- local frame = CreateFrame("FRAME", "defaultcvar")
--     frame:RegisterEvent("PLAYER_ENTERING_WORLD")
--         local function eventHandler(self, event, ...)
--             defaultcvar()
-- end
-- frame:SetScript("OnEvent", eventHandler)

local function fuckyou(self)
    if GetCVar("portal") == "CN" then
        ConsoleExec("portal TW")
    end
    SetCVar("profanityFilter", 0)
    self:UnregisterEvent("ADDON_LOADED")
end


local godie = CreateFrame("FRAME", nil)
    godie:RegisterEvent("ADDON_LOADED")
    godie:SetScript("OnEvent", fuckyou)

local mod	= DBM:NewMod("PT", "DBM-Party-BC", 12)
local L		= mod:GetLocalizedStrings()

mod.noStatistics = true

mod:SetRevision("20240412191704")

mod:RegisterEvents(
	"UPDATE_UI_WIDGET",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)
mod.noStatistics = true

-- Portals
local warnWavePortalSoon	= mod:NewAnnounce("WarnWavePortalSoon", 2, 57687)
local warnWavePortal		= mod:NewAnnounce("WarnWavePortal", 3, 57687)
local warnBossPortal		= mod:NewAnnounce("WarnBossPortal", 4, 33341)

local timerNextPortal		= mod:NewTimer(120, "TimerNextPortal", 57687, nil, nil, 6)

mod:AddBoolOption("ShowAllPortalTimers", false, "timer")

local lastPortal = 0

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 17879 or cid == 17880 then
		if self:IsRetail() then
			timerNextPortal:Start(30, lastPortal + 1)
			warnWavePortalSoon:Schedule(20)
		else
			timerNextPortal:Start(122, lastPortal + 1)
			warnWavePortalSoon:Schedule(112)
		end
	end
end

function mod:UPDATE_UI_WIDGET(table)
	local id = table.widgetID
	if id ~= (self:IsRetail() and 527 or 3120) then--TODO, confirm wrath classic still using custom ID from TBC classic of 3120
		return
	end
	local widgetInfo = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(id)
	if widgetInfo and widgetInfo.text then
		local text = widgetInfo.text
		local currentPortal = text:match("(%d+).+18")
		if not currentPortal then
			currentPortal = 0
		end
		currentPortal = tonumber(currentPortal) or 0
		if currentPortal > lastPortal then
			warnWavePortalSoon:Cancel()
			timerNextPortal:Cancel()
			if currentPortal == 6 or currentPortal == 12 or currentPortal == 18 then
				warnBossPortal:Show()
			else
				warnWavePortal:Show(currentPortal)
				if self.Options.ShowAllPortalTimers and not self:IsRetail() then
					timerNextPortal:Start(122, currentPortal + 1)--requires complete overhaul I haven't patience to do on retail
					warnWavePortalSoon:Schedule(112)--because portals spawn faster and faster each time with newer tech added in later years/TW versions
				end
			end
			lastPortal = currentPortal
		elseif currentPortal < lastPortal then
			lastPortal = 0
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Shielddown or msg:find(L.Shielddown) then
		self:SendSync("Wipe")
	end
end

function mod:OnSync(msg, arg)
	if msg == "Wipe" then
		warnWavePortalSoon:Cancel()
		timerNextPortal:Cancel()
	end
end

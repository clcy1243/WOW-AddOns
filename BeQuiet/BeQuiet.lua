local BeQ_History = {}

local BeQ_Msg = ChatFrame_MessageEventHandler;

function ChatFrame_MessageEventHandler (self, event, ...)
    if not IsInInstance() and (event == "CHAT_MSG_MONSTER_YELL" or event == "CHAT_MSG_MONSTER_SAY") then
	local name = select(2,...)
	local msg = select(1,...)

	if not BeQ_History[self] then
	    BeQ_History[self] = {}
	end

	if name and msg then
	    local npcmsg = string.lower(name .. msg)
	    local t = BeQ_History[self]

	    if t[npcmsg] then
		return
	    end

	    tinsert(t, npcmsg)
	    t[npcmsg] = true
	end
    end

    BeQ_Msg (self, event, ...)
end
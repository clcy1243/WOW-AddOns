-- Skada Scroll by oscarucb
local Skada = Skada
local addonName, vars = ...
local L = vars.L
local bars = Skada:GetModule("BarDisplay")
local mod = Skada:NewModule("Scroll")
local texpath = "Interface\\AddOns\\"..addonName
local scrollicon = texpath.."\\scroll"
local blankicon = texpath.."\\blank"
local db
local defaults = {
  speed = 2.0,
  kspeed = 3,
  icon = true, 
  button="MiddleButton",
}

mod.elap = 0
local debugenabled = false
local function debug(msg)
  if debugenabled then
    print(addonName..": "..msg)
  end
end

function mod.ShowCursor(win)
  --SetCursor(texpath)
  if not db.icon then return end
  --SetCursor(blankicon)
  SetCursor("ITEM_CURSOR")
  mod.ScrollIcon = mod.ScrollIcon or {}
  if not mod.ScrollIcon[win] then
    local f = CreateFrame("Frame", nil, win.bargroup)
    f:SetFrameStrata("TOOLTIP")
    f:SetSize(32,32)
    f:SetPoint("CENTER")
    local t = f:CreateTexture(nil, "OVERLAY")
    t:SetTexture(scrollicon)
    t:SetAllPoints(f)
    t:Show()
    mod.ScrollIcon[win] = f
  end
  mod.ScrollIcon[win]:Show()
end

function mod.HideCursor(win)
  ResetCursor()
  if not db.icon then return end
  mod.ScrollIcon[win]:Hide()
end

function mod.BeginScroll(win)
  debug("BeginScroll")
  mod.ypos = select(2,GetCursorPosition())
  mod.scrolling = win
  mod.ShowCursor(win)
end

function mod.EndScroll(win)
  debug("EndScroll")
  mod.scrolling = nil
  mod.HideCursor(win)
end

function mod.OnUpdate(f, elap)
  local win = mod.scrolling
  if not win then return end
  if not IsMouseButtonDown(db.button) then
    mod.EndScroll(win)
    return
  end
  mod.ShowCursor(win)
  mod.elap = mod.elap + elap
  if mod.elap < 0.1 then return end
  mod.elap = 0
  local newpos = select(2,GetCursorPosition())
  local step = (win.db.barheight + win.db.barspacing) / (win.bargroup:GetEffectiveScale() * db.speed)
  while math.abs(newpos - mod.ypos) > step do
    if newpos > mod.ypos then
       bars:OnMouseWheel(win, nil, 1)
       mod.ypos = mod.ypos + step
    else
       bars:OnMouseWheel(win, nil, -1)
       mod.ypos = mod.ypos - step
    end
  end
end

function SkadaScroll_Scroll(up)
  debug("Scroll "..(up and "up" or "down"))
  for _, win in pairs(Skada:GetWindows()) do
     for i=1,db.kspeed do
       bars:OnMouseWheel(win, nil, up and 1 or -1)
     end
  end
end

mod.frame = CreateFrame("Button", "SkadaScrollHiddenFrame", UIParent)
mod.frame:SetScript("OnUpdate", mod.OnUpdate)

local hooked = {}

function mod.ReloadSettings() -- called on profile load/change
    db = Skada.db.profile.scroll or {}
    Skada.db.profile.scroll = db
    for k,v in pairs(defaults) do
      if db[k] == nil then
        db[k] = v
      end
    end
end
hooksecurefunc(Skada,"ReloadSettings", mod.ReloadSettings)

function mod.Create(lib,win) -- Just created a BarDisplay for a window
  debug("Create")
  local bargroup = win.bargroup
  if bargroup and not hooked[bargroup] then
    bargroup:HookScript("OnMouseDown", function(frame, button) if button == db.button then mod.BeginScroll(hooked[bargroup]) end end)
    hooksecurefunc(bargroup,"SortBars", function() 
      local win = hooked[bargroup]
      if win then -- may be nil during a profile change
        mod.HookMore(win) 
      end
    end)
  end
  hooked[bargroup] = win
end

local function BarClick(bar, button)
  if button == db.button then 
     mod.BeginScroll(bar.scrollwin)
  elseif hooked[bar] then
     (hooked[bar])(bar, button)
  end
end

function mod.HookMore(win)
  if not hooked[win] then
    debug("HookMore")
    local bars = win.bargroup:GetBars()
    if bars then
      for name, bar in pairs(bars) do
         local old = bar:GetScript("OnMouseDown")
         if old ~= BarClick then
            bar:SetScript("OnMouseDown", BarClick)
            hooked[bar] = old
         end
         bar.scrollwin = win
      end
    end
    hooked[win] = true
  end
end

function mod.CreateBar(self, win, name, label, value, maxvalue, icon, o) -- creating a bar, mark window as stale
   debug("CreateBar: "..name)
   hooked[win] = false
end
hooksecurefunc(bars,"CreateBar", mod.CreateBar)


--
-- Options.
--

function mod.AddDisplayOptions(self, win, options)
  Skada.options.args.scrolloptions = {
    type = "group",
    name = L["Scroll"],
    order=100,
    set = function(info,val)
          db[info[#info]] = val; 
          debug(info[#info].." set to: "..tostring(val))
        end,
    get = function(info)
          return db[info[#info]] 
        end,
    args = {
      mheader = {
        name = L["Mouse"],
        type = "header",
        cmdHidden = true,
        order = 1,
      },
      speed = {
        type="range",
        name=L["Scrolling speed"],
        order=10,
        min=0.1,
        max=10,
	bigStep=1,
	width="full",
      },
      icon = {
        type="toggle",
        name=L["Scroll icon"],
        order=20,
      },
      button = {
        type="select",
        name=L["Scroll mouse button"],
        order=20,
        values={
          ["MiddleButton"] = KEY_BUTTON3,
          ["Button4"] = KEY_BUTTON4,
          ["Button5"] = KEY_BUTTON5,
        },
      },
      kheader = {
        name = L["Keybinding"],
        type = "header",
        cmdHidden = true,
        order = 100,
      },
      kspeed = {
        type="range",
        name=L["Key scrolling speed"],
        order=105,
        min=1,
        max=10,
        step=1,
	width="full",
      },
      upkey = {
        type="keybinding",
	order=110,
        name=COMBAT_TEXT_SCROLL_UP,
        set = function(info,val)
          local b1, b2 = GetBindingKey("SKADASCROLLUP")
          if b1 then SetBinding(b1) end
          if b2 then SetBinding(b2) end
          SetBinding(val, "SKADASCROLLUP")
          SaveBindings(GetCurrentBindingSet())
        end,
        get = function(info) return GetBindingKey("SKADASCROLLUP") end
      },
      downkey = {
        type="keybinding",
	order=120,
        name=COMBAT_TEXT_SCROLL_DOWN,
        set = function(info,val)
          local b1, b2 = GetBindingKey("SKADASCROLLDOWN")
          if b1 then SetBinding(b1) end
          if b2 then SetBinding(b2) end
          SetBinding(val, "SKADASCROLLDOWN")
          SaveBindings(GetCurrentBindingSet())
        end,
        get = function(info) return GetBindingKey("SKADASCROLLDOWN") end
      },
    }
  }
end

hooksecurefunc(bars,"Create", mod.Create)
hooksecurefunc(bars,"AddDisplayOptions", mod.AddDisplayOptions)
BINDING_NAME_SKADASCROLLUP = COMBAT_TEXT_SCROLL_UP
BINDING_NAME_SKADASCROLLDOWN = COMBAT_TEXT_SCROLL_DOWN



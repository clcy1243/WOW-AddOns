-- Hekili.lua
-- April 2014

local addon, ns = ...
local Hekili = _G[ addon ]

local class = ns.class
local state = ns.state
local scriptDB = Hekili.Scripts

local buildUI = ns.buildUI
local callHook = ns.callHook
local checkScript = ns.checkScript
local clashOffset = ns.clashOffset
local formatKey = ns.formatKey
local getSpecializationID = ns.getSpecializationID
local getResourceName = ns.getResourceName
local importModifiers = ns.importModifiers
local initializeClassModule = ns.initializeClassModule
local isKnown = ns.isKnown
local isUsable = ns.isUsable
local loadScripts = ns.loadScripts
local refreshBindings = ns.refreshBindings
local refreshOptions = ns.refreshOptions
local restoreDefaults = ns.restoreDefaults
local runOneTimeFixes = ns.runOneTimeFixes
local convertDisplays = ns.convertDisplays
local runHandler = ns.runHandler
local tableCopy = ns.tableCopy
local timeToReady = ns.timeToReady
local trim = string.trim

local mt_resource = ns.metatables.mt_resource

local AD = ns.lib.ArtifactData
local SF = ns.lib.SpellFlash
local ToggleDropDownMenu = Lib_ToggleDropDownMenu

local updatedDisplays = {}



-- checkImports()
-- Remove any displays or action lists that were unsuccessfully imported.
local function checkImports()

    local profile = Hekili.DB.profile

    for i = #profile.displays, 1, -1 do
        local display = profile.displays[ i ]
        if type( display ) ~= 'table' or display.Name:match("^@") then
            table.remove( profile.displays, i )
        else
            if not display.minST or type( display.minST ) ~= 'number' then display.minST = 0 end
            if not display.maxST or type( display.maxST ) ~= 'number' then display.maxST = 0 end
            if not display.minAE or type( display.minAE ) ~= 'number' then display.minAE = 0 end
            if not display.maxAE or type( display.maxAE ) ~= 'number' then display.maxAE = 0 end
            if not display.minAuto or type( display.minAuto ) ~= 'number' then display.minAuto = 0 end
            if not display.maxAuto or type( display.maxAuto ) ~= 'number' then display.maxAuto = 0 end
            if not display.rangeType then display.rangeType = 'ability' end

            if display['PvE Visibility'] and not display.alphaAlwaysPvE then
                if display['PvE Visibility'] == 'always' then
                    display.alwaysPvE = true
                    display.alphaAlwaysPvE = 1
                    display.targetPvE = false
                    display.alphaTargetPvE = 1
                    display.combatPvE = false
                    display.alphaCombatPvE = 1
                elseif display['PvE Visibility'] == 'combat' then
                    display.alwaysPvE = false
                    display.alphaAlwaysPvE = 1
                    display.targetPvE = false
                    display.alphaTargetPvE = 1
                    display.combatPvE = true
                    display.alphaCombatPvE = 1
                elseif display['PvE Visibility'] == 'target' then
                    display.alwaysPvE = false
                    display.alphaAlwaysPvE = 1
                    display.targetPvE = true
                    display.alphaTargetPvE = 1
                    display.combatPvE = false
                    display.alphaCombatPvE = 1
                else
                    display.alwaysPvE = false
                    display.alphaAlwaysPvE = 1
                    display.targetPvE = false
                    display.alphaTargetPvE = 1
                    display.combatPvE = false
                    display.alphaCombatPvE = 1
                end
                display['PvE Visibility'] = nil
            end

            if display['PvP Visibility'] and not display.alphaAlwaysPvP then
                if display['PvP Visibility'] == 'always' then
                    display.alwaysPvP = true
                    display.alphaAlwaysPvP = 1
                    display.targetPvP = false
                    display.alphaTargetPvP = 1
                    display.combatPvP = false
                    display.alphaCombatPvP = 1
                elseif display['PvP Visibility'] == 'combat' then
                    display.alwaysPvP = false
                    display.alphaAlwaysPvP = 1
                    display.targetPvP = false
                    display.alphaTargetPvP = 1
                    display.combatPvP = true
                    display.alphaCombatPvP = 1
                elseif display['PvP Visibility'] == 'target' then
                    display.alwaysPvP = false
                    display.alphaAlwaysPvP = 1
                    display.targetPvP = true
                    display.alphaTargetPvP = 1
                    display.combatPvP = false
                    display.alphaCombatPvP = 1
                else
                    display.alwaysPvP = false
                    display.alphaAlwaysPvP = 1
                    display.targetPvP = false
                    display.alphaTargetPvP = 1
                    display.combatPvP = false
                    display.alphaCombatPvP = 1
                end
                display['PvP Visibility'] = nil
            end
            
        end
    end
end
ns.checkImports = checkImports


function ns.pruneDefaults()
    
    local profile = Hekili.DB.profile

    for i = #profile.displays, 1, -1 do
        local display = profile.displays[ i ]
        if not ns.isDefault( display.Name, "displays" ) then
            display.Default = false
        end      
    end

    for i = #profile.actionLists, 1, -1 do
        local list = profile.actionLists[ i ]
        if type( list ) ~= 'table' or list.Name:match("^@") then
            for dispID, display in ipairs( profile.displays ) do
                if display.precombatAPL > i then display.precombatAPL = display.precombatAPL - 1 end
                if display.defaultAPL > i then display.defaultAPL = display.defaultAPL - 1 end
            end
            table.remove( profile.actionLists, i )
        elseif not ns.isDefault( list.Name, "actionLists" ) then
            list.Default = false
        end
            

    end    

end



local hookOnce = false

-- OnInitialize()
-- Addon has been loaded by the WoW client (1x).
function Hekili:OnInitialize()
    self.DB = LibStub( "AceDB-3.0" ):New( "HekiliDB", self:GetDefaults() )

    self.Options = self:GetOptions()
    self.Options.args.profiles = LibStub( "AceDBOptions-3.0" ):GetOptionsTable( self.DB )

    -- Add dual-spec support
    ns.lib.LibDualSpec:EnhanceDatabase( self.DB, "Hekili" )
    ns.lib.LibDualSpec:EnhanceOptions( self.Options.args.profiles, self.DB )

    self.DB.RegisterCallback( self, "OnProfileChanged", "TotalRefresh" )
    self.DB.RegisterCallback( self, "OnProfileCopied", "TotalRefresh" )
    self.DB.RegisterCallback( self, "OnProfileReset", "TotalRefresh" )

    ns.lib.AceConfig:RegisterOptionsTable( "Hekili", self.Options )
    self.optionsFrame = ns.lib.AceConfigDialog:AddToBlizOptions( "Hekili", "Hekili" )
    self:RegisterChatCommand( "hekili", "CmdLine" )
    self:RegisterChatCommand( "hek", "CmdLine" )

    local LDB = LibStub( "LibDataBroker-1.1", true )
    local LDBIcon = LDB and LibStub( "LibDBIcon-1.0", true )
    if LDB then
        ns.UI.Minimap = LDB:NewDataObject( "Hekili", {
            type = "launcher",
            text = "Hekili",
            icon = "Interface\\ICONS\\spell_nature_bloodlust",
            OnClick = function( f, button )
                if button == "RightButton" then ns.StartConfiguration()
                else
                    if not hookOnce then 
                        hooksecurefunc("Lib_UIDropDownMenu_InitializeHelper", function(frame)
                            for i = 1, LIB_UIDROPDOWNMENU_MAXLEVELS do
                                if _G["Lib_DropDownList"..i.."Backdrop"].SetTemplate then _G["Lib_DropDownList"..i.."Backdrop"]:SetTemplate("Transparent") end
                                if _G["Lib_DropDownList"..i.."MenuBackdrop"].SetTemplate then _G["Lib_DropDownList"..i.."MenuBackdrop"]:SetTemplate("Transparent") end
                            end
                        end )
                        hookOnce = true
                    end
                    ToggleDropDownMenu( 1, nil, Hekili_Menu, f:GetName(), "MENU" )
                end
                GameTooltip:Hide()
            end,
            OnTooltipShow = function( tt )
                tt:AddDoubleLine( "Hekili", ns.UI.Minimap.text )
                tt:AddLine( "|cFFFFFFFFLeft-click to make quick adjustments.|r" )
                tt:AddLine( "|cFFFFFFFFRight-click to open the options interface.|r" )
            end,
        } )

        function ns.UI.Minimap:RefreshDataText()
            local p = Hekili.DB.profile
            local color = "FFFFD100"

            self.text = format( "|c%s%s|r  %sCD|r  %sInt|r  %sPot|r",
                color,
                p['Mode Status'] == 0 and "Single" or ( p['Mode Status'] == 2 and "AOE" or ( p['Mode Status'] == 3 and "Auto" or "X" ) ),
                p.Cooldowns and "|cFF00FF00" or "|cFFFF0000",
                p.Interrupts and "|cFF00FF00" or "|cFFFF0000",
                p.Potions and "|cFF00FF00" or "|cFFFF0000" )
        end

        ns.UI.Minimap:RefreshDataText()

        if LDBIcon then
            LDBIcon:Register( "Hekili", ns.UI.Minimap, self.DB.profile.iconStore )
        end
    end


    if not self.DB.profile.Version or self.DB.profile.Version < 7 or not self.DB.profile.Release or self.DB.profile.Release < 20161000 then
        self.DB:ResetDB()
    end

    self.DB.profile.Release = self.DB.profile.Release or 20170416.0


    initializeClassModule()
    refreshBindings()
    restoreDefaults()
    runOneTimeFixes()
    convertDisplays()
    checkImports()
    refreshOptions()
    loadScripts()

    ns.updateTalents()
    ns.updateGear()

    ns.primeTooltipColors()

    callHook( "onInitialize" )

    if class.file == 'NONE' then
        if self.DB.profile.Enabled then
            self.DB.profile.Enabled = false
            self.DB.profile.AutoDisabled = true
        end
        for i, buttons in ipairs( ns.UI.Buttons ) do
            for j, _ in ipairs( buttons ) do
                buttons[j]:Hide()
            end
        end
    end

end


function Hekili:ReInitialize()
    ns.initializeClassModule()
    refreshBindings()
    restoreDefaults()
    convertDisplays()
    checkImports()
    refreshOptions()
    runOneTimeFixes()
    loadScripts()

    ns.updateTalents()
    ns.updateGear()

    self.DB.profile.Release = self.DB.profile.Release or 20161003.1

    callHook( "onInitialize" )

    if self.DB.profile.Enabled == false and self.DB.profile.AutoDisabled then 
        self.DB.profile.AutoDisabled = nil
        self.DB.profile.Enabled = true
        self:Enable()
    end

    if class.file == 'NONE' then
        self.DB.profile.Enabled = false
        self.DB.profile.AutoDisabled = true
        for i, buttons in ipairs( ns.UI.Buttons ) do
            for j, _ in ipairs( buttons ) do
                buttons[j]:Hide()
            end
        end
    end

end    


function Hekili:OnEnable()

    ns.specializationChanged()
    ns.StartEventHandler()
    buildUI()
    ns.overrideBinds()
    ns.ReadKeybindings()

    Hekili.s = ns.state

    -- May want to refresh configuration options, key bindings.
    if self.DB.profile.Enabled then
        self:UpdateDisplays()
        ns.Audit()
    else
        self:Disable()
    end

end


function Hekili:OnDisable()
    self.DB.profile.Enabled = false
    ns.StopEventHandler()
    buildUI()
end


function Hekili:Toggle()
    self.DB.profile.Enabled = not self.DB.profile.Enabled
    if self.DB.profile.Enabled then self:Enable()
    else self:Disable() end
end


-- Texture Caching,
local s_textures = setmetatable( {},
    {
        __index = function(t, k)
            local a = _G[ 'GetSpellTexture' ](k)
            if a and k ~= GetSpellInfo( 115698 ) then t[k] = a end
            return (a)
        end
    } )

local i_textures = setmetatable( {},
    {
        __index = function(t, k)
            local a = select(10, GetItemInfo(k))
            if a then t[k] = a end
            return a
        end
    } )

-- Insert textures that don't work well with predictions.
s_textures[GetSpellInfo(115356)] = 1029585  -- Windstrike
s_textures[GetSpellInfo(17364)] = 132314  -- Stormstrike
-- NYI:  Need Chain Lightning/Lava Beam here.

local function GetSpellTexture( spell )
    -- if class.abilities[ spell ].item then return i_textures[ spell ] end
    return ( s_textures[ spell ] )
end


local z_PVP = {
    arena = true,
    pvp = true
}


local palStack = {}

function Hekili:ProcessActionList( dispID, hookID, listID, slot, depth, action, wait, clash )
    
    local display = self.DB.profile.displays[ dispID ]
    local list = self.DB.profile.actionLists[ listID ]

    local debug = self.ActiveDebug

    -- if debug then self:Debug( "Testing action list [ %d - %s ].", listID, list and list.Name or "ERROR - Does Not Exist"  ) end
    if debug then self:Debug( "Previous Recommendation:  %s at +%.2fs, clash is %.2f.", action or "NO ACTION", wait or 30, clash or 0 ) end

    -- the stack will prevent list loops, but we need to keep this from destroying existing data... later.
    if not list then
        if debug then self:Debug( "No list with ID #%d.  Should never see.", listID ) end
    elseif palStack[ list.Name ] then
        if debug then self:Debug( "Action list loop detected.  %s was already processed earlier.  Aborting.", list.Name ) end
        return 
    else
        if debug then self:Debug( "Adding %s to the list of processed action lists.", list.Name ) end
        palStack[ list.Name ] = true
    end
    
    local chosen_action = action
    local chosen_clash = clash or 0
    local chosen_wait = wait or 30
    local chosen_depth = depth or 0

    local stop = false

    if ns.visible.list[ listID ] then
        local actID = 1

        while actID <= #list.Actions and chosen_wait do
            if chosen_wait <= state.cooldown.global_cooldown.remains then
                if debug then self:Debug( "The last selected ability ( %s ) is available at (or before) the next GCD.  End loop.", chosen_action ) end
                if debug then self:Debug( "Removing %s from list of processed action lists.", list.Name ) end
                palStack[ list.Name ] = nil
                return chosen_action, chosen_wait, chosen_clash, chosen_depth
            elseif chosen_wait == 0 then
                if debug then self:Debug( "The last selected ability ( %s ) has no wait time.  End loop.", chosen_action ) end
                if debug then self:Debug( "Removing %s from list of processed action lists.", list.Name ) end
                palStack[ list.Name ] = nil
                return chosen_action, chosen_wait, chosen_clash, chosen_depth
            elseif stop then
                if debug then self:Debug( "Returning to parent list after completing Run_Action_List ( %d - %s ).", listID, list.Name ) end
                if debug then self:Debug( "Removing %s from list of processed action lists.", list.Name ) end
                palStack[ list.Name ] = nil
                return chosen_action, chosen_wait, chosen_clash, chosen_depth
            end

            if ns.visible.action[ listID..':'..actID ] then

                -- Check for commands before checking actual actions.
                local entry = list.Actions[ actID ]
                state.this_action = entry.Ability
                state.this_args = entry.Args
                
                state.delay = nil
                chosen_depth = chosen_depth + 1

                local minWait = state.cooldown.global_cooldown.remains

                -- Need to expand on modifiers, gather from other settings as needed.
                if debug then self:Debug( "\n[ %2d ] Testing entry %s:%d ( %s ) with modifiers ( %s ).", chosen_depth, list.Name, actID, entry.Ability, entry.Args or "NONE" ) end

                local ability = class.abilities[ entry.Ability ]

                local wait_time = 30
                local clash = 0

                local known = isKnown( state.this_action )

                if debug then self:Debug( "%s is %s.", ability.name, known and "KNOWN" or "NOT KNOWN" ) end

                if known then
                    local scriptID = listID .. ':' .. actID

                    -- Used to notify timeToReady() about an artificial delay for this ability.
                    state.script.entry = entry.whenReady == 'script' and scriptID or nil

                    wait_time = timeToReady( state.this_action )
                    clash = clashOffset( state.this_action )

                    state.delay = wait_time
                    importModifiers( listID, actID )

                    if wait_time >= chosen_wait then
                        if debug then self:Debug( "This action is not available in time for consideration ( %.2f vs. %.2f ).  Skipping.", wait_time, chosen_wait ) end
                    else
                        -- APL checks.
                        if entry.Ability == 'variable' then
                            -- local aScriptValue = checkScript( 'A', scriptID )
                            local varName = entry.ModVarName or state.args.name

                            if debug then self:Debug( " - variable.%s will refer to this action's script.", varName or "MISSING" ) end

                            if varName ~= nil then -- and aScriptValue ~= nil then
                                state.variable[ "_" .. varName ] = scriptID
                                -- We just store the scriptID so that the variable actually gets tested at time of comparison.
                            end

                        elseif entry.Ability == 'call_action_list' or entry.Ability == 'run_action_list' then
                            -- We handle these here to avoid early forking between starkly different APLs.
                            local aScriptPass = true

                            if not entry.Script or entry.Script == '' then if debug then self:Debug( "%s does not have any required conditions.", ability.name ) end
                            else
                                aScriptPass = checkScript( 'A', scriptID )
                                if debug then self:Debug( "Conditions %s:  %s", aScriptPass and "MET" or "NOT MET", ns.getConditionsAndValues( 'A', scriptID ) ) end
                            end

                            if aScriptPass then

                                local aList = entry.ModName or state.args.name

                                if aList then
                                    -- check to see if we have a real list name.
                                    local called_list = 0
                                    for i, list in ipairs( self.DB.profile.actionLists ) do
                                        if list.Name == aList then
                                            called_list = i
                                            break
                                        end
                                    end

                                    if called_list > 0 then
                                        if debug then self:Debug( "The action list for %s ( %s ) was found.", entry.Ability, aList ) end
                                        chosen_action, chosen_wait, chosen_clash, chosen_depth = self:ProcessActionList( dispID, listID .. ':' .. actID , called_list, slot, chosen_depth, chosen_action, chosen_wait, chosen_clash )
                                        stop = entry == 'run_action_list'
                                        calledList = true
                                    else
                                        if debug then self:Debug( "The action list for %s ( %s ) was not found - %s / %s.", entry.Ability, aList, entry.ModName or "nil", state.args.name or "nil" ) end
                                    end
                                end

                            end

                        else
                            local preservedWait = wait_time
                            local interval = state.gcd / 3
                            local calledList = false

                            -- There is a leak inside here, it worsens with higher testCounts.
                            for testCount = 1, ( self.LowImpact or self.DB.profile['Low Impact Mode'] ) and 2 or 5 do

                                if stop or calledList then break end

                                if testCount == 1 then
                                elseif testCount == 2 then  state.delay = preservedWait + 0.1
                                elseif testCount == 3 then  state.delay = preservedWait + ( state.gcd / 2 )
                                elseif testCount == 4 then  state.delay = preservedWait + state.gcd
                                elseif testCount == 5 then  state.delay = preservedWait + ( state.gcd * 2 )
                                end

                                local newWait = max( 0, state.delay - clash )
                                local usable = isUsable( state.this_action )

                                if debug then self:Debug( "Test #%d at [ %.2f + %.2f ] - Ability ( %s ) is %s.", testCount, state.offset, state.delay, entry.Ability, usable and "USABLE" or "NOT USABLE" ) end
                                
                                if usable then
                                    local chosenWaitValue = max( 0, chosen_wait - chosen_clash )
                                    local readyFirst = newWait < chosenWaitValue

                                    if debug then self:Debug( " - this ability is %s at %.2f before the previous ability at %.2f.", readyFirst and "READY" or "NOT READY", newWait, chosenWaitValue ) end

                                    if readyFirst then
                                        local hasResources = ns.hasRequiredResources( state.this_action )
                                        if debug then self:Debug( " - the required resources are %s.", hasResources and "AVAILABLE" or "NOT AVAILABLE" ) end

                                        if hasResources then
                                            local aScriptPass = true

                                            if not entry.Script or entry.Script == '' then if debug then self:Debug( ' - this ability has no required conditions.' ) end
                                            else 
                                                aScriptPass = checkScript( 'A', scriptID )
                                                if debug then self:Debug( "Conditions %s:  %s", aScriptPass and "MET" or "NOT MET", ns.getConditionsAndValues( 'A', scriptID ) ) end
                                            end

                                            if aScriptPass then
                                                if entry.Ability == 'wait' then
                                                        -- local args = ns.getModifiers( listID, actID )
                                                    if not state.args.sec then state.args.sec = 1 end
                                                    if state.args.sec > 0 then
                                                        state.advance( state.args.sec )
                                                        actID = 0
                                                    end

                                                elseif entry.Ability == 'potion' then
                                                    local potionName = state.args.ModName or state.args.name or class.potion
                                                    local potion = class.potions[ potionName ]

                                                    if potion then
                                                        -- do potion things
                                                        slot.scriptType = entry.ScriptType or 'simc'
                                                        slot.display = dispID
                                                        slot.button = i

                                                        slot.wait = state.delay

                                                        slot.hook = hookID
                                                        slot.list = listID
                                                        slot.action = actID

                                                        slot.actionName = state.this_action
                                                        slot.listName = list.Name

                                                        slot.resource = ns.resourceType( chosen_action )
                                                        
                                                        slot.caption = entry.Caption
                                                        slot.indicator = ( entry.Indicator and entry.Indicator ~= 'none' ) and entry.Indicator
                                                        slot.texture = select( 10, GetItemInfo( potion.item ) )
                                                        
                                                        chosen_action = state.this_action
                                                        chosen_wait = state.delay
                                                        chosen_clash = clash
                                                        break
                                                    end

                                                else
                                                    slot.scriptType = entry.ScriptType or 'simc'
                                                    slot.display = dispID
                                                    slot.button = i

                                                    slot.wait = state.delay

                                                    slot.hook = hookID
                                                    slot.list = listID
                                                    slot.action = actID

                                                    slot.actionName = state.this_action
                                                    slot.listName = list.Name

                                                    slot.resource = ns.resourceType( chosen_action )
                                                    
                                                    slot.caption = entry.Caption
                                                    slot.indicator = ( entry.Indicator and entry.Indicator ~= 'none' ) and entry.Indicator
                                                    slot.texture = ability.texture
                                                    
                                                    chosen_action = state.this_action
                                                    chosen_wait = state.delay
                                                    chosen_clash = clash
                                                end

                                                if entry.CycleTargets and state.active_enemies > 1 and ability and ability.cycle then
                                                    if state.dot[ ability.cycle ].up and state.active_dot[ ability.cycle ] < ( state.args.MaxTargets or state.active_enemies ) then
                                                        slot.indicator = 'cycle'
                                                    end
                                                end

                                                break                                               
                                            end
                                        end
                                    end
                                end
                            end

                            state.delay = preservedWait

                        end
                    end
                end
            end

            actID = actID + 1

        end

    end

    palStack[ list.Name ] = nil
    return chosen_action, chosen_wait, chosen_clash, chosen_depth

end


function Hekili:ProcessHooks( dispID, solo )

    if not self.DB.profile.Enabled then return end

    if not self.Pause then
        local display = self.DB.profile.displays[ dispID ]

        ns.queue[ dispID ] = ns.queue[ dispID ] or {}
        local Queue = ns.queue[ dispID ]

        if display and ns.visible.display[ dispID ] then

            state.reset( dispID )

            local debug = self.ActiveDebug

            if debug then self:SetupDebug( display.Name ) end

            for k in pairs( palStack ) do palStack[k] = nil end

            if Queue then
                for k, v in pairs( Queue ) do
                    for l, w in pairs( v ) do
                        if type( Queue[ k ][ l ] ) ~= 'table' then
                            Queue[k][l] = nil
                        end
                    end
                end
            end

            local dScriptPass = true -- checkScript( 'D', dispID )

            if debug then self:Debug( "*** START OF NEW DISPLAY ***\n" ..
                "Display %d (%s) is %s.", dispID, display.Name, ( self.Config or dScriptPass ) and "VISIBLE" or "NOT VISIBLE" ) end
            
            -- if debug then self:Debug( "Conditions %s:  %s", dScriptPass and "MET" or "NOT MET", ns.getConditionsAndValues( 'D', dispID ) ) end

            if ( self.Config or dScriptPass ) then
                
                for i = 1, ( display.numIcons or 4 ) do

                    local chosen_action
                    local chosen_wait, chosen_clash, chosen_depth = 30, self.DB.profile.Clash or 0, 0

                    Queue[i] = Queue[i] or {}

                    local slot = Queue[i]

                    local attempts = 0

                    if debug then self:Debug( "\n[ ** ] Checking for recommendation #%d ( time offset: %.2f ).", i, state.offset ) end

                    for k in pairs( state.variable ) do
                        state.variable[ k ] = nil
                    end

                    if display.precombatAPL and display.precombatAPL > 0 and state.time == 0 then
                        -- We have a precombat display and combat hasn't started.
                        local listName = self.DB.profile.actionLists[ display.precombatAPL ].Name

                        if debug then self:Debug("Processing precombat action list [ %d - %s ].", display.precombatAPL, listName ) end
                        chosen_action, chosen_wait, chosen_clash, chosen_depth = self:ProcessActionList( dispID, hookID, display.precombatAPL, slot, chosen_depth, chosen_action, chosen_wait, chosen_clash )
                        if debug then self:Debug( "Completed precombat action list [ %d - %s ].", display.precombatAPL, listName ) end
                    end

                    if display.defaultAPL and display.defaultAPL > 0 and chosen_wait > 0 then
                        local listName = self.DB.profile.actionLists[ display.defaultAPL ].Name

                        if debug then self:Debug("Processing default action list [ %d - %s ].", display.default, listName ) end
                        chosen_action, chosen_wait, chosen_clash, chosen_depth = self:ProcessActionList( dispID, hookID, display.defaultAPL, slot, chosen_depth, chosen_action, chosen_wait, chosen_clash )
                        if debug then self:Debug( "Completed precombat action list [ %d - %s ].", display.defaultAPL, listName ) end
                    end

                    if debug then self:Debug( "Recommendation #%d is %s at %.2f.", i, chosen_action or "NO ACTION", state.offset + chosen_wait ) end

                    -- Wipe out the delay, as we're advancing to the cast time.
                    state.delay = 0

                    if chosen_action then
                        -- We have our actual action, so let's get the script values if we're debugging.

                        if self.ActiveDebug then ns.implantDebugData( slot ) end

                        slot.time = state.offset + chosen_wait
                        slot.exact_time = state.now + state.offset + chosen_wait
                        slot.since = i > 1 and slot.time - Queue[ i - 1 ].time or 0
                        slot.resources = slot.resources or {}
                        slot.depth = chosen_depth

                        for k,v in pairs( class.resources ) do
                            slot.resources[k] = state[k].current 
                            if state[k].regen then slot.resources[k] = min( state[k].max, slot.resources[k] + ( state[k].regen * chosen_wait ) ) end
                        end

                        slot.resource_type = ns.resourceType( chosen_action )

                        if i < display.numIcons then

                            -- Advance through the wait time.
                            state.advance( chosen_wait )

                            local action = class.abilities[ chosen_action ]

                            -- Start the GCD.
                            if action.gcdType ~= 'off' and state.cooldown.global_cooldown.remains == 0 then
                                state.setCooldown( 'global_cooldown', state.gcd )
                            end

                            -- Advance the clock by cast_time.
                            if action.cast > 0 and not action.channeled then
                                state.advance( action.cast )
                            end

                            -- Put the action on cooldown.  (It's slightly premature, but addresses CD resets like Echo of the Elements.)
                            if class.abilities[ chosen_action ].charges and action.recharge > 0 then
                                state.spendCharges( chosen_action, 1 )
                            elseif chosen_action ~= 'global_cooldown' then
                                state.setCooldown( chosen_action, action.cooldown )
                            end

                            state.cycle = slot.indicator == 'cycle'

                            -- Spend resources.
                            ns.spendResources( chosen_action )

                            -- Perform the action.
                            ns.runHandler( chosen_action )

                            -- Advance the clock by cast_time.
                            if action.cast > 0 and action.channeled then
                                state.advance( action.cast )
                            end

                            -- Move the clock forward if the GCD hasn't expired.
                            if state.cooldown.global_cooldown.remains > 0 then
                                state.advance( state.cooldown.global_cooldown.remains )
                            end

                        end

                    else
                        for n = i, display.numIcons do
                            slot[n] = nil
                        end
                        break
                    end

                end

            end

        end

    end

    -- if not solo then C_Timer.After( 1 / self.DB.profile['Updates Per Second'], self[ 'ProcessDisplay'..dispID ] ) end
    ns.displayUpdates[ dispID ] = GetTime()
    updatedDisplays[ dispID ] = 0
    -- Hekili:UpdateDisplay( dispID )

end


local pvpZones = {
    arena = true,
    pvp = true
}


local function CheckDisplayCriteria( dispID )

    local display = Hekili.DB.profile.displays[ dispID ]
    local switch, mode = Hekili.DB.profile['Switch Type'], Hekili.DB.profile['Mode Status']
    local _, zoneType = IsInInstance()

    -- if C_PetBattles.IsInBattle() or Hekili.Barber or UnitInVehicle( 'player' ) or not ns.visible.display[ dispID ] then
    if C_PetBattles.IsInBattle() or UnitOnTaxi( 'player' ) or Hekili.Barber or HasVehicleActionBar() or not ns.visible.display[ dispID ] then
        return 0

    elseif ( switch == 0 and not display.showSwitchAuto ) or ( switch == 1 and not display.showSwitchAE ) or ( mode == 0 and not display.showST ) or ( mode == 3 and not display.showAuto ) or ( mode == 2 and not display.showAE ) then
        return 0

    elseif not pvpZones[ zoneType ] then
        
        if display.visibilityType == 'a' then
            return display.alphaShowPvE

        else
            if display.targetPvE and UnitExists( 'target' ) and not ( UnitIsDead( 'target' ) or not UnitCanAttack( 'player', 'target' ) ) then
                return display.alphaTargetPvE

            elseif display.combatPvE and UnitAffectingCombat( 'player' ) then
                return display.alphaCombatPvE

            elseif display.alwaysPvE then
                return display.alphaAlwaysPvE

            end
        end

        return 0

    elseif pvpZones[ zoneType ] then
        
        if display.visibilityType == 'a' then
            return display.alphaShowPvP

        else
            if display.targetPvP and UnitExists( 'target' ) and not ( UnitIsDead( 'target' ) or not UnitCanAttack( 'player', 'target' ) ) then
                return display.alphaTargetPvP

            elseif display.combatPvP and UnitAffectingCombat( 'player' ) then
                return display.alphaCombatPvP

            elseif display.alwaysPvP then
                return display.alphaAlwaysPvP

            end
        end

        return 0

    elseif not Hekili.Config and not ns.queue[ dispID ] then
        return 0

    end

    return 0

end
ns.CheckDisplayCriteria = CheckDisplayCriteria


function Hekili_GetRecommendedAbility( display, entry )

    if type( display ) == 'string' then
        local found = false
        for dispID, disp in pairs(Hekili.DB.profile.displays) do
            if not found and disp.Name == display then
                display = dispID
                found = true
            end
        end
        if not found then return nil, "Display name not found." end
    end

    if not Hekili.DB.profile.displays[ display ] then
        return nil, "Display not found."
    end

    if not ns.queue[ display ] then
        return nil, "No queue for that display."
    end

    if not ns.queue[ display ][ entry ] then
        return nil, "No entry #" .. entry .. " for that display."
    end

    return class.abilities[ ns.queue[ display ][ entry ].actionName ].id

end



local flashes = {}
local checksums = {}
local applied = {}

function Hekili:UpdateDisplay( dispID )

    local self = self or Hekili

    if not self.DB.profile.Enabled then
        return
    end

    -- for dispID, display in pairs(self.DB.profile.displays) do
    local display = self.DB.profile.displays[ dispID ]

    if not ns.UI.Buttons or not ns.UI.Buttons[ dispID ] then return end

    if self.Pause then
        ns.UI.Buttons[ dispID ][1].Overlay:SetTexture('Interface\\Addons\\Hekili\\Textures\\Pause.blp')
        ns.UI.Buttons[ dispID ][1].Overlay:Show()

    else
        flashes[dispID] = flashes[dispID] or 0

        ns.UI.Buttons[ dispID ][1].Overlay:Hide()

        local alpha = CheckDisplayCriteria( dispID ) or 0

        if alpha > 0 then
            local Queue = ns.queue[ dispID ]

            local gcd_start, gcd_duration = GetSpellCooldown( class.abilities.global_cooldown.id )
            local now = GetTime()

            _G[ "HekiliDisplay" .. dispID ]:Show()

            for i, button in ipairs( ns.UI.Buttons[ dispID ] ) do
                if not Queue or not Queue[i] and ( self.DB.profile.Enabled or self.Config ) then
                    for n = i, display.numIcons do
                        ns.UI.Buttons[dispID][n].Texture:SetTexture( 'Interface\\ICONS\\Spell_Nature_BloodLust' )
                        ns.UI.Buttons[dispID][n].Texture:SetVertexColor(1, 1, 1)
                        ns.UI.Buttons[dispID][n].Caption:SetText(nil)
                        if not self.Config then
                            ns.UI.Buttons[dispID][n]:Hide()
                        else
                            ns.UI.Buttons[dispID][n]:Show()
                            ns.UI.Buttons[dispID][n]:SetAlpha(alpha)
                        end
                    end
                    break
                end

                local aKey, caption, indicator = Queue[i].actionName, Queue[i].caption, Queue[i].indicator

                if aKey then
                    button:Show()
                    button:SetAlpha(alpha)
                    button.Texture:SetTexture( Queue[i].texture or class.abilities[ aKey ].texture or GetSpellTexture( class.abilities[ aKey ].id ) )
                    local zoom = ( display.iconZoom or 0 ) / 200
                    button.Texture:SetTexCoord( zoom, 1 - zoom, zoom, 1 - zoom )
                    button.Texture:Show()

                    if display.showIndicators and indicator then
                        if indicator == 'cycle' then button.Icon:SetTexture( "Interface\\Addons\\Hekili\\Textures\\Cycle" ) end
                        if indicator == 'cancel' then button.Icon:SetTexture( "Interface\\Addons\\Hekili\\Textures\\Cancel" ) end
                        button.Icon:Show()
                    else
                        button.Icon:Hide()
                    end

                    if display.showCaptions and ( i == 1 or display.queuedCaptions ) then
                        button.Caption:SetText( caption )
                    else
                        button.Caption:SetText( nil )
                    end

                    if display.showKeybindings and ( display.queuedKBs or i == 1 ) then
                        button.Keybinding:SetText( self:GetBindingForAction( aKey, not display.lowercaseKBs == true ) )
                    else
                        button.Keybinding:SetText( nil )
                    end

                    if i == 1 then
                        if display.showTargets then
                            -- 0 = single
                            -- 2 = cleave
                            -- 2 = aoe
                            -- 3 = auto
                            local min_targets, max_targets = 0, 0
                            local mode = Hekili.DB.profile['Mode Status']

                            if display.displayType == 'a' then -- Primary
                                if mode == 0 then
                                    min_targets = 0
                                    max_targets = 1
                                elseif mode == 2 then
                                    min_targets = display.simpleAOE or 2
                                    max_targets = 0
                                end

                            elseif display.displayType == 'b' then -- Single-Target
                                min_targets = 0
                                max_targets = 1

                            elseif display.displayType == 'c' then -- AOE
                                min_targets = display.simpleAOE or 2
                                max_targets = 0
                            
                            elseif display.displayType == 'd' then -- Auto
                                -- do nothing

                            elseif display.displayType == 'z' then -- Custom, old style.
                                if mode == 0 then
                                    if display.minST > 0 then min_targets = display.minST end
                                    if display.maxST > 0 then max_targets = display.maxST end
                                elseif mode == 2 then
                                    if display.minAE > 0 then min_targets = display.minAE end
                                    if display.maxAE > 0 then max_targets = display.maxAE end
                                elseif mode == 3 then
                                    if display.minAuto > 0 then min_targets = display.minAuto end
                                    if display.maxAuto > 0 then max_targets = display.maxAuto end
                                end
                            end

                            -- local detected = ns.getNameplateTargets()
                            -- if detected == -1 then detected = ns.numTargets() end

                            local detected = max( 1, ns.getNumberTargets() )
                            local targets = detected

                            if min_targets > 0 then targets = max( min_targets, targets ) end
                            if max_targets > 0 then targets = min( max_targets, targets ) end

                            local targColor = ''

                            if detected < targets then targColor = '|cFFFF0000'
                            elseif detected > targets then targColor = '|cFF00C0FF' end

                            if targets > 1 then button.Targets:SetText( targColor .. targets .. '|r' )
                            else button.Targets:SetText( nil ) end
                        else
                            button.Targets:SetText( nil )
                        end
                    end

                    if display.blizzGlow and ( i == 1 or display.queuedBlizzGlow ) and IsSpellOverlayed( class.abilities[ aKey ].id ) then
                        ActionButton_ShowOverlayGlow( button )
                    else
                        ActionButton_HideOverlayGlow( button )
                    end

                    local start, duration = GetSpellCooldown( class.abilities[ aKey ].id )
                    local gcd_remains = gcd_start + gcd_duration - GetTime()

                    if class.abilities[ aKey ].gcdType ~= 'off' and ( not start or start == 0 or ( start + duration ) < ( gcd_start + gcd_duration ) ) then
                        start = gcd_start
                        duration = gcd_duration
                    end

                    if i == 1 then
                        button.Cooldown:SetCooldown( start, duration )

                        if SF and display.spellFlash and GetTime() >= flashes[dispID] + 0.2 then
                            SF.FlashAction( class.abilities[ aKey ].id, display.spellFlashColor )
                            flashes[dispID] = GetTime()
                        end

                        if ( class.file == 'HUNTER' or class.file == 'MONK' ) and Queue[i].exact_time and Queue[i].exact_time ~= gcd_start + gcd_duration and Queue[i].exact_time > now then
                            -- button.Texture:SetDesaturated( Queue[i].time > 0 )
                            button.Delay:SetText( format( "%.1f", Queue[i].exact_time - now ) )
                        else
                            -- button.Texture:SetDesaturated( false )
                            button.Delay:SetText( nil )
                        end

                    else
                        if ( start + duration ~= gcd_start + gcd_duration ) then
                            button.Cooldown:SetCooldown( start, duration )
                        else
                            button.Cooldown:SetCooldown( 0, 0 )
                        end
                    end

                    if display.rangeType == 'melee' then
                        local minR = ns.lib.RangeCheck:GetRange( 'target' )
                        
                        if minR and minR >= 5 then 
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(1, 0, 0)
                        elseif i == 1 and select(2, IsUsableSpell( class.abilities[ aKey ].id ) ) then
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(0.4, 0.4, 0.4)
                        else
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(1, 1, 1)
                        end
                    elseif display.rangeType == 'ability' then
                        local rangeSpell = class.abilities[ aKey ].range and GetSpellInfo( class.abilities[ aKey ].range ) or class.abilities[ aKey ].name
                        if ns.lib.SpellRange.IsSpellInRange( rangeSpell, 'target' ) == 0 then
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(1, 0, 0)
                        elseif i == 1 and select(2, IsUsableSpell( class.abilities[ aKey ].id )) then
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(0.4, 0.4, 0.4)
                        else
                            ns.UI.Buttons[dispID][i].Texture:SetVertexColor(1, 1, 1)
                        end
                    elseif display.rangeType == 'off' then
                        ns.UI.Buttons[dispID][i].Texture:SetVertexColor(1, 1, 1)
                    end

                else

                    -- print( "no aKey", dispID, display.Name, i )
                    ns.UI.Buttons[dispID][i].Texture:SetTexture( nil )
                    ns.UI.Buttons[dispID][i].Cooldown:SetCooldown( 0, 0 )
                    ns.UI.Buttons[dispID][i]:Hide()

                end

            end

        else

            for i, button in ipairs(ns.UI.Buttons[dispID]) do
                button:Hide()

            end
        end
    end

end


function Hekili:UpdateDisplays()
    local now = GetTime()

    for display, update in pairs( updatedDisplays ) do
        if now - update > 0.033 then
            Hekili:UpdateDisplay( display )
            updatedDisplays[ display ] = now
        end
    end
end
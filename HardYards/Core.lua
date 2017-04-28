--[[
		    ----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----


         #        #     #######     ########      #######            #       #    #######     ########      #######         #####
         #        #    #       #    #       ##    #      ##           #     #    #       #    #       ##    #      ##     ##     ##
         #        #   #         #   #         #   #        #           #   #    #         #   #         #   #        #   #         #
         #        #   #         #   #       ##    #         #           # #     #         #   #       ##    #         #   ##
         ##########   ###########   ########      #         #            #      ###########   ########      #         #     #####
         #        #   #         #   #      #      #         #            #      #         #   #      #      #         #          ##
         #        #   #         #   #       #     #        #             #      #         #   #       #     #        #             #
         #        #   #         #   #        #    #      ##              #      #         #   #        #    #      ##     ##     ##
         #        #   #         #   #         #   #######                #      #         #   #         #   #######         #####


		    ----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----


                          Tarocalypse, a rotund monk wizened from his travels through Azeroth, was relaxing at the
                        waters edge of the Steam Pools in Feralas. Drowsy from the restorative ambience, he heard a
                            disturbance and opened his sleepy eyes enough to discern a figure moving toward him.

                                   "Tell me of your travels Taraezor, it is a surprise to see you here."

                                           "Perhaps if I had known you were here I would have..."

                          Tarocalypse raised a paw. "Enough of that Taraezor, let's enjoy the solitude together."

                                Taraezor sat down, his weary feet dangling in the soothing sulfuric waters.

                       A while passed as both silently enjoyed the relaxing thermal springs. Then Tarocalypse spoke.

                              "Tell me my good friend, I have been pondering the mysteries of Azeroth lately"
                            "and one such mystery is how to calculate distance. It seems it just can't be done."

                              "Agreed my wise friend. But I wouldn't have let it get my head into such a spin"
                                         "that I had to retreat to here," observed Taraezor wryly.

                                           "Ahhh but the ways of Azeroth do concern me Taraezor."
                                      "Take for example my Yaungol Wind Chimes. They can be heard..."

                                                "Up to 25 yards away," interrupted Taraezor.

                                        "Oh, is that so. And I have this candle, Elune's Candle..."

                                              "Effective up to 30 yards," fired back Taraezor.

                                          "Oh right I see. Come Winter's Veil and my Mistletoe..."

                                          "20 yards Tarocalypse," sighed Taraezor, already bored.

                                   This seemed to silence Tarocalypse, amazed that Taraezor knew so much.

                                       "Tell me Taraezor, what brings YOU here to the thermal pools?"

                         "I've been doing the Hard Yards Tarocalypse, the Hard Yards," he said with a cheeky smile.


		    ----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----(||)----o----

						    ----o----(||)----oo----(||)----o----

							    v2.09 29th March 2017
						    Copyright (C) Taraezor / Chris Birch

						    ----o----(||)----oo----(||)----o----

]]

local addonName, L = ...

-- Globals
----------
HardYards_min, HardYards_max = 0, 0

-- Localisation Optimisation - Lua
----------------------------------
local modf = math.modf
local random = random
local gmatch = string.gmatch
local lower = string.lower
local match = string.match
local sub = string.sub
local tonumber = tonumber
local tostring = tostring

-- Localisation Optimisation - API
----------------------------------
local CheckInteractDistance = CheckInteractDistance
local IsControlKeyDown = IsControlKeyDown
local IsItemInRange = IsItemInRange
local PlaySoundKitID = PlaySoundKitID
local StopSound = StopSound
local UnitCanAssist = UnitCanAssist
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitIsUnit = UnitIsUnit

-- Preset Ranges
----------------
local hy_rangeItems = {

	35278,	-- 80:	Reinforced Net
	41265,	-- 70:	Eyesore Blaster
	32825,	-- 60:	Soul Cannon, 34111/34121 Trained Rock Falcon
	116139,	-- 50:	Haunting Memento
	23836,	-- 45:	Wrangling Rope
	44114,  -- 40:	Old Spices, 44228 Baby Spice, 90888 Foot Ball, 90883 The Pigskin, 28767 The Decapitator, 109167 Findle's Loot-A-Rang
	24501,	-- 35:	Gordawg's Boulder
	32960,	-- 30:	Elekk Dispersion Ray, 21713 Elune's Candle, 85231 Bag of Clams, 9328 Super Snapper FX, 7734 Six Demon Bag
	4,	-- 28:	Follow
	86567,	-- 25:	Yaungol Wind Chime, 13289 Egan's Blaster
	10645,	-- 20:	Gnomish Death Ray
	46722,	-- 15:	Grol'dom Net, 56184 Duarn's Net, 31129 Blackwhelp Net, 1251 Linen Bandage
	40551,	-- 10:	Gore Bladder, 34913 Highmesa's Cleansing Seeds, 21267 Toasting Goblet, 32321 Sparrowhawk Net
	33278,	-- 8:	Burning Torch, 2 Trading
	3,	-- 7:	Dueling
	63427,	-- 6:	Worgsaw
	37727,	-- 5:	Ruby Acorn, 36771 Sturdy Crates
}

local hy_rangeMax = { "80", "70", "60", "50", "45", "40", "35", "30", "28", "25", "20", "15", "10", "8", "7", "6", "5"}
local hy_rangeMin = { "70.1", "60.1", "50.1", "45.1", "40.1", "35.1", "30.1", "28.1", "25.1", "20.1", "15.1", "10.1", "8.1", "7.1", "6.1", "5.1", "0"}

local hy_rangeAlt = {
	["32825"] = 37887, 	-- 60: Seeds of Nature's Wrath
	["32698"] = 23836,	-- 45: Goblin Rocket Launcher
	["44114"] = 34471,	-- 40: Vial of the Sunwell
	["24501"] = 18904,	-- 35: Zorbin's Ultra-Shrinker
	["32960"] = 34191,	-- 30: Handful of Snowflakes
	["86567"] = 31463,	-- 25: Zezzak's Shard (F NPC/P)
	["10645"] = 21519,	-- 20: Mistletoe (F NPC/P)
	["46722"] = 33069,	-- 15: Sturdy Rope
	["40551"] = 42441,	-- 10: Bouldercrag's Bomb
	["33278"] = 34368,	-- 8:  Attuned Crystal Cores
}

-- Colour Scheme
----------------
local hy_colour_X11Chocolate		= "\124cFFD2691E"	-- HardYards chat line prefix
local hy_colour_X11SandyBrown		= "\124cFFF4A460"	-- Highlight and warning messages
local hy_colour_X11BurlyWood		= "\124cFFDEB887"	-- Plain text
local hy_colour_X11Brown		= "\124cFFA52A2A"	-- Error messages
local hy_colour_X11Peru			= "\124cFFCD853F"	-- Debug messages
local hy_colour_numbers			= hy_colour_X11SandyBrown
local hy_colour_arrows			= hy_colour_X11BurlyWood
local hy_colour_label			= hy_colour_X11Chocolate

-- Borders
----------
local textures = { "Interface\\Tooltips\\UI-Tooltip-Border", "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		"Interface\\DialogFrame\\UI-DialogBox-Border", "Interface\\ChatFrame\\ChatFrameBackground",
		"Interface\\Buttons\\UI-SliderBar-Border", "Interface\AchievementFrame\UI-Achievement-WoodBorder"}
local scaleSizes = { 0.5, 0.4, 0.5, 0.1, 0.5, 0.1}

-- Locals
---------
local hy_on = true
local hy_range = ""

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::          UTILITY         :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

local function round( num, places )		-- round to nearest integer, ties round away from zero
	local mult = 10 ^ ( places or 0 )
	return modf( num * mult + ( ( num < 0 and -1 ) or 1 ) * 0.5 ) / mult
end

local function printHY( message )
	DEFAULT_CHAT_FRAME:AddMessage( "\124cFFD2691E Hard Yards: \124cFFDEB887".. message.. "\124r" )
end

local function HardYards_SetBorder()

	if HardYardsDB.border == 7 then
		HardYards:SetBackdrop(nil)
	else
		HardYards:SetBackdropBorderColor(1,1,1,1)
		HardYards:SetBackdrop({ edgeFile = textures[ HardYardsDB.border ],
					edgeSize= HardYardsDB.size * scaleSizes[ HardYardsDB.border ] })
	end
end

local function HardYards_SetSize()

	HardYards.rangeText:SetTextHeight( HardYardsDB.size )
	HardYards.rangeText:ClearAllPoints()
	HardYards.rangeText:SetPoint( "CENTER", HardYardsDB.size/30, -( HardYardsDB.size/10 ) )

end
--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::         COLOURING        :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

-- Note that if the player alters any of the colours while a Tooltip is being shown then that Tooltip will gain a second "Distance:..."
-- line. To avoid this, the tooltip routine would need to remove the colour from its search mechanism, with the low risk of a false positive
-- match as the hex code would now be absent. The hex code pretty much ensures a unique match to text only inserted by Hard Yards

local function SetLocalsFromDB( databaseEntity )

	if ( databaseEntity == "arrows" ) then
		hy_colour_arrows = "\124c".. format( "FF%02x%02x%02x",  HardYardsDB.arrows.r * 255, HardYardsDB.arrows.g * 255,
						HardYardsDB.arrows.b * 255 )
	elseif ( databaseEntity == "numbers" ) then
		hy_colour_numbers = "\124c".. format( "FF%02x%02x%02x",  HardYardsDB.numbers.r * 255, HardYardsDB.numbers.g * 255,
						HardYardsDB.numbers.b * 255 )
	elseif ( databaseEntity == "label" ) then
		hy_colour_label = "\124c".. format( "FF%02x%02x%02x",  HardYardsDB.label.r * 255, HardYardsDB.label.g * 255,
						HardYardsDB.label.b * 255 )
	end
end

local function ColourPicker( databaseEntity )

	ColorPickerFrame.originalColours = { HardYardsDB[ databaseEntity ].r, HardYardsDB[ databaseEntity ].g,
						HardYardsDB[ databaseEntity ].b }

	ColorPickerFrame.func = function()
		local rNew, gNew, bNew = ColorPickerFrame:GetColorRGB()
		HardYardsDB[ databaseEntity ].r, HardYardsDB[ databaseEntity ].g, HardYardsDB[ databaseEntity ].b = rNew, gNew, bNew
		HardYardsDB[ databaseEntity ].r = round( HardYardsDB[ databaseEntity ].r, 3)
		HardYardsDB[ databaseEntity ].g = round( HardYardsDB[ databaseEntity ].g, 3)
		HardYardsDB[ databaseEntity ].b = round( HardYardsDB[ databaseEntity ].b, 3)
		SetLocalsFromDB( databaseEntity )
	end

	if ( HardYardsDB[ databaseEntity ].r == 0 ) and ( HardYardsDB[ databaseEntity ].g == 0 ) and
			( HardYardsDB[ databaseEntity ].b == 0 ) then
		ColorPickerFrame:SetColorRGB( 0.004, 0.004, 0.004 )
	else
		ColorPickerFrame:SetColorRGB( HardYardsDB[ databaseEntity ].r, HardYardsDB[ databaseEntity ].g,
						HardYardsDB[ databaseEntity ].b )
	end

	ColorPickerFrame.cancelFunc = function()
		HardYardsDB[ databaseEntity ].r, HardYardsDB[ databaseEntity ].g, HardYardsDB[ databaseEntity ].b
				= unpack( ColorPickerFrame.originalColours )
		SetLocalsFromDB( databaseEntity )
	end

	ColorPickerFrame:Show()
end

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::    DO THE HARD YARDS     :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

local between, missed, furthest = "", 0, 0

local function DoTheHardYards( unitID, actualTarget )

	between, missed, furthest, result = hy_colour_arrows.. " <-> ".. hy_colour_numbers, 0, 0, false

	for i=1,#hy_rangeItems do
		result = false
		if hy_rangeItems[i] < 10 then
			result = CheckInteractDistance( unitID, hy_rangeItems[i] ) or 0
		else
			result = IsItemInRange( hy_rangeItems[i], unitID )
		end
		if ( result == nil ) then
			local v = tostring( hy_rangeItems[i] )
			if hy_rangeAlt[v] then
				if hy_rangeAlt[v] < 10 then
					result = CheckInteractDistance( unitID, hy_rangeAlt[v] ) or 0
				else
					result = IsItemInRange( hy_rangeAlt[v], unitID )
				end
--if result == true then print("Alt true: "..hy_rangeAlt[v]) end
			end
--		else
--print("true: "..hy_rangeItems[i])
		end
		if result == true then
			furthest = i
			missed = 0
		elseif result == nil then
			missed = i
		else
			break
		end
	end

	if furthest == #hy_rangeMax then
		hy_range = hy_colour_numbers.. "Melee"
		if ( actualTarget == true ) then
			HardYards_min = 0
			HardYards_max = 5
		end
	elseif furthest > 0 then
		if missed > 0 then
			hy_range = hy_colour_numbers.. hy_rangeMin[ missed ].. between.. hy_rangeMax[ furthest ]
			if ( actualTarget == true ) then
				HardYards_min = tonumber( hy_rangeMin[ missed ] )
				HardYards_max = tonumber( hy_rangeMax[ furthest ] )
			end
		else
			hy_range = hy_colour_numbers.. hy_rangeMin[ furthest ].. between.. hy_rangeMax[ furthest ]
			if ( actualTarget == true ) then
				HardYards_min = tonumber( hy_rangeMin[ furthest ] )
				HardYards_max = tonumber( hy_rangeMax[ furthest ] )
			end
		end
	elseif missed > 0 then
		hy_range = hy_colour_numbers.. hy_rangeMin[ missed ].. between.. "80+"
		if ( actualTarget == true ) then
			HardYards_min = tonumber( hy_rangeMin[ missed ] )
			HardYards_max = -1
		end
	else
		hy_range = hy_colour_numbers.. "80+"
		if ( actualTarget == true ) then
			HardYards_min = -1
			HardYards_max = -1
		end
	end
end

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::   SHOW THE HARD YARDS    :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

local function ShowTheHardYards()
	HardYards.rangeText:SetText( hy_range )
	HardYards.rangeText:SetTextColor( nil,nil,nil,1 )
	local width, height = HardYards.rangeText:GetWidth(), HardYards.rangeText:GetHeight()
	HardYards:SetSize( width*1.2, height*1.3 )
	if ( HardYardsDB.border == 7 ) then
		HardYards:SetBackdropBorderColor( 1,1,1,0 )
	else
		HardYards:SetBackdropBorderColor( 1,1,1,1 )
	end
end

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::        ON UPDATE         :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

local function HardYards_OnUpdate()

	if UnitExists( "target" ) then
		DoTheHardYards( "target", true )
		if ( HardYardsDB.show == true ) then
			ShowTheHardYards()
		end
	else
		HardYards:SetBackdropBorderColor( 1,1,1,0 )
		HardYards.rangeText:SetTextColor( nil,nil,nil,0 )
	end

	if ( HardYardsDB.tooltip == "off" ) then
		return
	end

	-- Targeted Units - when mouse over a unit
	local owner = GameTooltip:GetOwner()
	if ( owner ~= nil ) and ( owner:GetName() == "UIParent" ) then
		local _, unitID = GameTooltip:GetUnit()
		if unitID and not UnitIsUnit( unitID, "player" ) then

			local line, found = "", 0
			local compareLine = hy_colour_label.. "Distance: "
			for i = GameTooltip:NumLines(), 3, -1 do
				line = _G["GameTooltipTextLeft"..i ]:GetText()
				if ( line ~= nil ) then
					if ( match( line, compareLine ) ) then
						found = i
						break
					end
				end
			end

			DoTheHardYards( unitID, false )

			if ( found == 0 ) then
				GameTooltip:AddLine( compareLine.. hy_range )
			else
				_G["GameTooltipTextLeft".. found ]:SetText( compareLine.. hy_range )
			end
			GameTooltip:Show()
		end
	end

end

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::      INITIALISATION      :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

local function PlayerLogin( self )

	if ( HardYardsDB == nil )		then	HardYardsDB 		=	{}	end
	if ( HardYardsDB.show == nil )		then 	HardYardsDB.show	=	true 	end
	if ( HardYardsDB.arrows == nil )	then 	HardYardsDB.arrows	=	{} 	end	-- X11BurlyWood DEB887
	if ( HardYardsDB.arrows.r == nil )	then 	HardYardsDB.arrows.r	=	0.87 	end
	if ( HardYardsDB.arrows.g == nil )	then 	HardYardsDB.arrows.g	=	0.72 	end
	if ( HardYardsDB.arrows.b == nil )	then 	HardYardsDB.arrows.b	=	0.53 	end
	if ( HardYardsDB.numbers == nil )	then 	HardYardsDB.numbers	=	{} 	end	-- X11SandyBrown F4A460
	if ( HardYardsDB.numbers.r == nil )	then 	HardYardsDB.numbers.r	=	0.96 	end
	if ( HardYardsDB.numbers.g == nil )	then 	HardYardsDB.numbers.g	=	0.64 	end
	if ( HardYardsDB.numbers.b == nil )	then 	HardYardsDB.numbers.b	=	0.38 	end
	if ( HardYardsDB.label == nil )		then 	HardYardsDB.label	=	{} 	end	-- X11Chocolate D2691E
	if ( HardYardsDB.label.r == nil )	then 	HardYardsDB.label.r	=	0.82 	end
	if ( HardYardsDB.label.g == nil )	then 	HardYardsDB.label.g	=	0.41 	end
	if ( HardYardsDB.label.b == nil )	then 	HardYardsDB.label.b	=	0.12 	end
	if ( HardYardsDB.border == nil )	then 	HardYardsDB.border	=	1 	end
	if ( HardYardsDB.size == nil )		then 	HardYardsDB.size	=	20 	end
	if ( HardYardsDB.tooltip == nil )	then 	HardYardsDB.tooltip	=	"on" 	end

	SetLocalsFromDB( "arrows" )
	SetLocalsFromDB( "numbers" )
	SetLocalsFromDB( "label" )

	HardYards:SetFrameStrata( "BACKGROUND" )
	HardYards:SetClampedToScreen( true )
	HardYards:EnableMouse( false )
	HardYards:SetMovable( true )
	HardYards:ClearAllPoints()
	if HardYardsDB.x and HardYardsDB.y then
		HardYards:SetPoint( "TOPLEFT", HardYardsDB.x, -( UIParent:GetHeight() - HardYardsDB.y ) )
	else
		HardYards:SetPoint( "TOPLEFT", ( UIParent:GetWidth() / 2 ), -( UIParent:GetHeight() / 2 ) )
	end

	HardYards:SetScript( "OnMouseDown", function( self, button )
		if ( button == "LeftButton" ) and IsControlKeyDown() then
			self:StartMoving()
		end
	end)
	HardYards:SetScript( "OnMouseUp", function( self )
		self:StopMovingOrSizing()
		HardYardsDB.x = HardYards:GetLeft()
		HardYardsDB.y = HardYards:GetTop()
	end)

	HardYards.rangeText = HardYards:CreateFontString( nil, "OVERLAY" )
	HardYards.rangeText:SetFont( "Fonts\\FRIZQT__.TTF", 42, "THICKOUTLINE" )
	HardYards_SetSize()
	HardYards_SetBorder()

	faction = UnitFactionGroup( "player" )
end

--------------------------------------------------------------------------------------------------------------------------------------------

local function HardYards_OnEvent( self, event, parm1 )

	if ( event == "PLAYER_LOGIN" ) then
		PlayerLogin( self )
	end
end

local HardYards = CreateFrame( "Frame", "HardYards", UIParent )
HardYards:RegisterEvent( "PLAYER_LOGIN" )
HardYards:SetScript( "OnEvent", HardYards_OnEvent )
HardYards:SetScript( "OnUpdate", HardYards_OnUpdate )

--========================================================================================================================================--
--||																	||--
--||                                             --=<[:::      SLASH COMMANDS      :::]>=--                                             ||--
--||																	||--
--========================================================================================================================================--

--------------------------------------------------------------------------------------------------------------------------------------------
SLASH_HardYards1, SLASH_HardYards2, SLASH_HardYards3, SLASH_HardYards4 = "/hardyards", "/hard", "/yards", "/hy"
--------------------------------------------------------------------------------------------------------------------------------------------

local soundkitHandle = nil

SlashCmdList[ "HardYards" ] = function( options )

	local firstParm, firstParm3, secondParm, secondParm3, thirdParm, thirdParm3, fourthParm, fourthParm3

	for v in gmatch( options, "%S+" ) do
		v = lower( v )
		if not firstParm3 then
			firstParm = v
			firstParm3 = sub( v,1,3 )
		elseif not secondParm3 then
			secondParm = v
			secondParm3 = sub( v,1,3 )
		elseif not thirdParm3 then
			thirdParm = v
			thirdParm3 = sub( v,1,3 )
		else
			fourthParm = v
			fourthParm3 = sub( v,1,3 )
			break
		end
	end

	if ( firstParm3 == "?" ) or ( firstParm3 == nil ) then
		print("Chat Commands:\n"..
			hy_colour_X11SandyBrown.. "arr\124r = to change arrow colour\n"..
			hy_colour_X11SandyBrown.. "lab\124r = to change label colour (tooltip only)\n"..
			hy_colour_X11SandyBrown.. "num\124r = to change number colour\n"..
			"        (for any of the above 'def' to restore defaults. eg: '/hy num def')\n\n"..
			hy_colour_X11SandyBrown.. "bor n\124r = choose a border, numbered 1 to 7. eg: '/hy bor 2'\n"..
			hy_colour_X11SandyBrown.. "siz n\124r = size, numbered 5 to 100. eg: '/hy siz 20'\n\n"..
			hy_colour_X11SandyBrown.. "tip x\124r = show range in tooltips. x = 'off' or 'on'\n"..
			hy_colour_X11SandyBrown.."show / hide\124r  = Show / Hide the main Hard Yards range frame\n\n"..
			hy_colour_X11SandyBrown.."ver\124r  = show version number\n")

	elseif ( firstParm3 == "arr" ) then
		if ( secondParm3 == "def" ) then
			HardYardsDB.arrows.r, HardYardsDB.arrows.g, HardYardsDB.arrows.b = 0.87, 0.72, 0.53
			SetLocalsFromDB( "arrows" )
		else
			ColourPicker( "arrows" )
		end

	elseif ( firstParm3 == "lab" ) then
		if ( secondParm3 == "def" ) then
			HardYardsDB.label.r, HardYardsDB.label.g, HardYardsDB.label.b = 0.82, 0.41, 0.12
			SetLocalsFromDB( "label" )
		else
			ColourPicker( "label" )
		end

	elseif ( firstParm3 == "num" ) then
		if ( secondParm3 == "def" ) then
			HardYardsDB.numbers.r, HardYardsDB.numbers.g, HardYardsDB.numbers.b = 0.96, 0.64, 0.38
			SetLocalsFromDB( "numbers" )
		else
			ColourPicker( "numbers" )
		end

	elseif ( firstParm3 == "bor" ) then
		if ( secondParm3 >= "1" ) and ( secondParm3 <= "7" ) then
			HardYardsDB.border = tonumber( secondParm3 )
			HardYards_SetBorder()
		else
			printHY( hy_colour_X11SandyBrown.. "Border: ".. hy_colour_X11BurlyWood.. "Set as '1' to '7', with 7 = no border" )
		end

	elseif ( firstParm3 == "siz" ) then
		local size = tonumber( secondParm3 ) or 0
		if ( size >= 5 ) and ( size <= 100 ) then
			HardYardsDB.size = size
			HardYards_SetSize()
			HardYards_SetBorder()
		else
			printHY( hy_colour_X11SandyBrown.. "Size: ".. hy_colour_X11BurlyWood.. "Set as '5' to '100', with 20 suggested" )
		end

	elseif ( firstParm3 == "too" ) or ( firstParm3 == "tip" ) then
		if ( secondParm3 == "on" ) or ( secondParm3 == "off" ) then
			HardYardsDB.tooltip = secondParm3
		else
			printHY( hy_colour_X11SandyBrown.. "Tooltip: ".. hy_colour_X11BurlyWood.. "Say 'on' or 'off'. eg: '/hy tip on'" )
		end

	elseif ( firstParm3 == "hid" ) then
		HardYardsDB.show = false
		HardYards:SetBackdropBorderColor( 1,1,1,0 )
		HardYards.rangeText:SetTextColor( nil,nil,nil,0 )

	elseif ( firstParm3 == "sho" ) then
		HardYardsDB.show = true

	elseif ( firstParm3 == "ver" ) then
		local version = GetAddOnMetadata( addonName, "Version" )
		printHY( hy_colour_X11SandyBrown.. "Version: ".. hy_colour_X11BurlyWood.. version )

	-- Easter Eggs. Enjoy!

	elseif ( firstParm3 == "z" ) then
		if ( soundkitHandle ) then
			StopSound( soundkitHandle, 5000 )
			soundkitHandle = nil
		else
			local soundSelection = random( 2 )
			if ( soundSelection == 1 ) then
				_, soundkitHandle = PlaySoundKitID( 14952 )		-- Northrend Transport Music
			else
				_, soundkitHandle = PlaySoundKitID( 12800 )		-- Howling Fjord
			end
		end
	end
end

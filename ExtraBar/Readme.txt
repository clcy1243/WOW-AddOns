ExtraBars mod for World of Warcraft

Author: Massiner of Nathrezim
Version: 2.0.1

Description: Adds 4 additional movable action bars to the interface

Usage:
- To add actions drag them from your inventory, spell book, macro's tab, or other buttons into the button you want them in.
- To change settings go to the Interface-Addons-Extra Bar menu option
- Some options to manipulate the bar are available via graphical controls on the bar
  (enabled by unlocking the bar via it's config screen, or faintly showing icon in the top right corner of the bar)
- To move the bar drag it with the mouse, note you can't move the bar if it has been locked in the settings
- To bind keys to the buttons go to the 'Extra Bar' section of 'Key Bindings'

Restrictions:
- Most settings cannot be changed while in combat
- Actions cannot be dragged to or from the bar while in combat

History:
04-Oct-2016	v2.0.1	- Addressed bug where on first login Items would not trigger off EB buttons
					- No longer attempt to show a tooltip for items that the player no longer holds (resulted in a silent error)
					- Equipment sets wont show up as disabled when you log back in (it was a visual only issue)
27-Sep-2016	v2.0.0	- Complete overhaul of the underlying Button Engine
						- Proper Support for Flyout spells, and Equipment sets
						- Spell Glow now included
						- Hides the faint config button when bar is locked in place
						- Adjusted names of config options
						- Improved performance (should be)
						- AlternateButtonTemplate is no longer required (my very first wow addon)
						- Updated to Masque support (Button Facade is no longer supported)
						- Ability to set Flyout direction
						- Others???
						- (we skipped v1 numbering... Really in essense Extra Bars has been release for a long long time, so going to v2 felt appropriate)


24-Jul-2016 v0.7.19 - Updated for WoW Legion (v7)
					- Made fix to cooldowns
					- fix for mounts
					- works with the additional specs
16-Oct-2014 v0.7.18	- Clear Mounts/Critters and battlepets, this is because the old values are no longer valid
15-Oct-2014 v0.7.17	- Updated for WoW v6.0.2
30-Jun-2013 v0.7.16 - Updated for WoW v5.3
14-Apr-2013 v0.7.15 - Extra Bars will now always hide when entering a pet battle
11-Mar-2013 v0.7.14 - Updated for WoW v5.2
04-Dec-2012 v0.7.13 - Update for WoW v5.1
					- Added support for battlepets
03-Sep-2012 v0.7.12 - extended hide on vehicle to also hide the bars when the override bar is active (e.g. when doing darkmoon faire dailies)
01-Sep-2012 v0.7.11 - Update for WoW v5.0.4
11-Dec-2011 v0.7.10 - Update version to reflect WoW v4.3
					- Added delay of 5 seconds at login before checking macros
13-Aug-2011	v0.7.9 - Updated version number to reflect latest WoW (4.2) client
24-Feb-2011	v0.7.8 - Companions (mounts/critters) should now be less prone to errors (the icon may temporarily be incorrect for a few moments when first logging in, if the companion is not in cache)
			       - Fixed problem that was causing some spells to be removed from the bar when switching specs
				   - Button Facade support has been added
20-Oct-2010 v0.7.7 - Removed debug statement that was accidentally left in
19-Oct-2010 v0.7.6 - Updated to be compatible with v4.0.1 of WoW
21-Dec-2009 v0.7.5 - Resolved positioning problem introduced in previous release that affected the bar in some cases
19-Dec-2009 v0.7.4 - Fixed issue preventing a few certain mounts and pets not activating when clicked (most notably the Bronze Protodrake).
				   - Positioning of the Extra Bars is now stored as part of the saved variables
				   - Made minor alteration to prevent accidentally dragging a button out of its position
				   - Updated toc to reflect WoW v3.3 compatibility
10-Aug-2009 v0.7.3 - Fixed issue preventing items not in the player inventory not having an icon on the bar
				   - Lowered Bar strata to reduce the chance other UI elements appear underneath it
09-Aug-2009 v0.7.2 - Changed how items were tracked to work better with enchants (etc) and stacks of items
				   - Added some additional events that trigger spell status updates
				   - Updated toc to reflect WoW v3.2 compatibility
07-July-2009 v0.7.1 - Fixed error with how companions were kept updated
14-Jun-2009 v0.7 - Added graphical controls to provide quicker bar configuration and adjustment
				 - Corrected issue with Companions on the bar when a new companion is learnt
				 - Added a scale option to resize the bars
10-May-2009 v0.61 - Corrected tooltip for the new Number of Buttons config option
09-May-2009 v0.6 - Introduced 3 additional bars
				 - Ability to set number of buttons
				 - Vertical layout option
				 - Disable tooltips option
				 - Ability to put mounts and critters on the bar
				 - Updated name (Now Extra Bars since there is more than one, the folder name hasn't changed however)
03-May-2009 v0.5 - Beta version of ExtraBar
########################################################################################################################################
	_______ _     _ __   __ _     _ _____
	|______ |____/    \_/   |     |   |  
	______| |    \_    |    |_____| __|__

########################################################################################################################################

Team:			snakster, T3T, Mardoxx

Contributors:	ianpatt, behippo, Indie, gibbed, GreatClone, Gopher, Kratos

Version:		2.1

Download:		http://www.skyrimnexus.com/downloads/file.php?id=3863

########################################################################################################################################

The following mods/utilities are required for SkyUI:

* The Skyrim Script Extender (SKSE), version 1.4.8 or newer
	http://skse.silverlock.org/

* The Nexus Mod Manager (NMM) is recommended for properly installing and setting up SkyUI.
	http://skyrimnexus.com/content/modmanager/

------------------------------------------------------------

If you're using GreatClone's Celtic Icon theme that comes with SkyUI, you can get the latest version directly from the author:
* GreatClone Celtic Icons, by GreatClone
	http://www.skyrimnexus.com/downloads/file.php?id=3979

########################################################################################################################################


	1. Introduction

	2. Changelog

	3. Installation

	4. Troubleshooting

	5. Credits & Acknowledgements
	
	6. Contact
	
	7. Permissions


########################################################################################################################################



========================================================================================================================================
 1. Introduction
========================================================================================================================================

SkyUI is mod that aims to improve Skyrim's User Interface by making it easier to use with mouse and keyboard,
less wasteful of available screen space and nicer to look at.

We do all that while keeping true to the style of the original UI, so new and old components are integrated seamlessly.
It is not our goal to re-create the complete interface from scratch.
Instead we try to identify and change areas that need improvement, while leaving the things that are already good alone.

Further general objectives and design concepts are:

* Finding a good balance between 'dumbed down' and 'information overkill'.

* Easy installation and setup by providing a user-friendly installer through the Nexus Mod Manager.

* Great customization support by using a seperate configuration file.

* Blending features in as good as possible - players shouldn't feel reminded that they're using a mod.


Since improving the whole UI is a big undertaking, we release only single menus at a time as we make progress.
The first menu we addressed was the Inventory. In version 2.0, we included new Barter, Container and Magic menus.

For a more detailed description, please see our mod description on SkyrimNexus.


========================================================================================================================================
 2. Changelog
========================================================================================================================================

------------------------------------------------------------
2.1:

[General]
- Added compatiblity for the Skyrim version 1.4.21.
- Added multi-language support for Czech, English, French, German, Italian, Polish, Russian and Spanish.
- Added several options to the installer (font size, separate V/W column, special resolution).
- Added a BAIN Conversion File (BCF) including an installation wizard for better Wyre Bash support. Thanks to Lojack!
- Fixed a bug where selling/dropping/storing stacked items could cause the selected entry to jump to the bottom of the list.
- The last selected category, entry and scroll position are now saved and restored when re-opening the inventory/magic menu.
- Sorting parameters are now preserved if possible when switching through categories.
- Improved the SKSE version check so it will also display a warning when using outdated versions.
- Most features of our SKSE plugins have been reworked and are now integrated in SKSE itself.
- Various other tweaks and minor fixes.

[InventoryMenu]
- Fixed a rare bug that could cause crashes after recharging an item.

[MagicMenu]
- Fixed skill level sorting.
- Added 'Favorite' as a sort option.

[ContainerMenu]
- Fixed stealing text for Russian game version.
- Fixed overlapping of to steal/to place text for large itemcards.

------------------------------------------------------------
2.0:

[InventoryMenu]
- Fixed enchantment mini-icon so it's no longer displayed for enchanted weapons only.
- Fixed missing sort options for name field in the favorites category.
- Fixed backspace canceling the search.
- Fixed searching for non-English languages (i.e. Russian).
- Improved sorting system. Null/invalid values are now always at the bottom.
- Empty categories are greyed out and no longer selectable by mouse or during keyboard/controller navigation.
- Included a bundled version of Gibbed's Container Categorization SKSE plugin. Thanks for giving us permission to use it!

[MagicMenu]
- Initial release

[BarterMenu]
- Initial release

[ContainerMenu]
- Initial release

------------------------------------------------------------
1.1:

[InventoryMenu]
- Updated gibbed's interface extensions plugin to support the latest Skyrim version 1.3.10.0.
- Improved support for XBOX360 controller: LB/RB can now be used to change the active column, Left Stick changes the sorting order.
- Made SKSE warning message less intrusive; it's only shown once after each game restart now.
- Fixed LT/RT equip bug with XBOX360 controller.
- Fixed bug where 3D model/item card would not update in certain situations (dropping an item, charging an item, etc.).
- Removed custom fontconfig.txt to avoid font problems with other font mods, or with the Russian version of the game.
- Optimized column layout so it only shows states and information that make sense for the active category.
- Updated T3T's straight icon theme to include new inventory icons.
- Updated GreatClone's icon theme to the latest version. Now includes inventory icons as well, and category icons have been improved.
- Fixed wrong inventory icon for spell tomes.
- Various minor tweaks and fixes.

------------------------------------------------------------
1.0:

[InventoryMenu]
- Initial release


========================================================================================================================================
 3. Installation
========================================================================================================================================

We recommend using the Nexus Mod Manager to install SkyUI. It easily lets you install and remove the mods, and you may even pick the
icon theme in the installer.

Basically, there are three ways to install SkyUI:
- Let NMM download and install the archive for you (recommended).
- Download the archive manually and install it with NMM.
- Download and install the archive manually.

Choose one method:

------------------------------------------------------------
 a) Automatic Download with NMM
------------------------------------------------------------

1.	Click the 'Download with manager' button on top of the file.

2.	SkyUI will appear in in NMM's Mods list once it's downloaded. Double-click the SkyUI entry to activate it.

3.	In the installer window, select a custom icon theme if you want to, then click Install.
	If you are prompted to overwrite anything, click Yes to All.

4.	Done!

OR

------------------------------------------------------------
 b) Manual Download with NMM
------------------------------------------------------------

1.	Start NMM and click on 'Mods'.

2.	In the left icon bar, click on 'Add Mod From File' and select the downloaded archive file.

3.	SkyUI will now appear in the list. Double-click to activate it.

4.	In the installer window, select a custom icon theme if you want to, then click Install.
	If you are prompted to overwrite anything, click 'Yes to All'.

5.	Done!

OR

------------------------------------------------------------
 c) Manual Installation without NMM
------------------------------------------------------------

1.	Locate the 'Data/' folder in your Skyrim installation directory.
	Typically it's found at 'Program Files/Steam/steamapps/common/skyrim/Data/'.

2.	Extract the contents of the downloaded archive file to your Data/ folder.
	If you are prompted to overwrite anything, click 'Yes to All'.

In case you want to use a custom icon theme:
3.	Locate the 'Data/SkyUI Extras/' folder. In there, pick a theme subfolder and copy
	'skyui_icons_cat.swf' and 'skyui_icons_inv.swf' to 'Data/Interface'.

4.	Done!


========================================================================================================================================
 4. Troubleshooting
========================================================================================================================================

------------------------------------------------------------
Problem: There's a message on my screen, telling me that I'm missing the Skyrim Script Extender (SKSE). What do I have to do?

Solution: There are two things that can cause this:
	1)	You didn't install the Skyrim Script Extender (or you installed it incorrectly).
		Get it from http://skse.silverlock.org/ and follow the included instructions.
		
	2)	Everything was fine before, then Skyrim was patched to a new version and the message started appearing.
		This is because each new patch also requires an update of SKSE. So just you'll just have to wait until that is released, then
		get the new version and everything should be back to normal.

------------------------------------------------------------
Problem: There are dollar signs ($) in front of all words in the main menu (and in lots of other places, too)!

Solution: This happens if you accidently removed 'Data/Interface/Translate_<language>.txt'. The downloaded SkyUI archive contains the
	original versions of these files in 'SkyUI Extras/Original Translates/'.
	So just copy the file matching your language from there back to 'Data/Interface/'.
		
------------------------------------------------------------
Problem: I changed something in skyui.cfg, now it's not working anymore.

Solution: If you made a mistake in the config, SkyUI may stop working. In this case, just revert back to the original config from the
	downloaded SkyUI archive.


========================================================================================================================================
 5. Credits & Acknowledgements
========================================================================================================================================

Besides the SkyUI team itself, there are other people as well who helped significantly to make this mod a reality.
In the following they are listed by name, including a list of their contributions.

Kratos:
	Was a core member of the SkyUI team until version 2.1 and as such contributed significantly to the project in various areas.

ianpatt:
	Added lots of new functions to the Skyrim Script Extender, that greatly helped us during development and enabled new features that
	would otherwise be impossible.

behippo:
	Helped improving/advancing the interface extensions plugin by decoding the game classes and giving us access to them through SKSE.

Gibbed:
	Created the 'gibbed interface extensions' SKSE plugin, which makes more game data available for display in the inventory.
	Also allowed us to bundle his container categorization plugin. As of version 2.1, both these plugins have been included in SKSE
	itself.

Indie:
	Created our trailer and helps with QA and user support.

GreatClone:
	Created an amazing set of alternative category icons.

Gopher:
	Did most of the work on the NMM installer, created an installation tutorial video and promoted SkyUI on his YouTube channel.

Lojack:
	Created a BCF (including an installation wizard) for SkyUI to improve the installation experience for Wyre Bash users.
	Also added an auto-conversion feature to Wyre Bash itself so this BCF is automatically applied.

Ismelda:
	Provided configs for very high resolutions used with multi-monitor setups.

Wakeupbrandon:
	His mock-up inspired the overall layout of the new inventory.


Thanks to all the testers, who helped a great deal with improving the overall quality of this mod:
	ToJKa, HellKnight, xporc, MadCat221, Ismelda, Gribbles, freesta, Cartrodus, TheCastle (in random order)

Last but not least, thanks to the whole SKSE team, because without their Script Extender creating this mod wouldn't have been possible.


========================================================================================================================================
 6. Contact
========================================================================================================================================

For direct contact, send a PM to schlangster at

	http://www.skyrimnexus.com/
		or
	http://forums.bethsoft.com/

If you need help, please leave a comment on our Nexus page instead of contacting me directly.

	
========================================================================================================================================
 7. Permissions
========================================================================================================================================	

Some assets in SkyUI belong to other authors.
You will need to seek permission from these authors before you can use their assets.

You are not allowed to upload this file to other sites unless given permission by me to do so.
You are not allowed to convert this file to work on other games.
 
You must get permission from me before you are allowed to modify my files for bug fixes and improvements.
You must get permission from me before you are allowed to use any of the assets in this file.

### Version 0.99.38 2025-09-05
* TOC update for 11.2.0.
* Fixed known issue [#6: the Ping System keybind for Ping displays a "Can't ping this." error](https://legacy.curseforge.com/wow/addons/stealth-alerter/issues/6) thanks to VfX / Bitwise1057.
* Cleanups by VfX / Bitwise1057.

### Version 0.99.37 2025-01-12
* TOC update for 11.0.7.
* Help wanted for known issue [#6: the Ping System keybind for Ping displays a "Can't ping this." error](https://legacy.curseforge.com/wow/addons/stealth-alerter/issues/6).

### Version 0.99.36 2024-08-14
* TOC update for 11.0.2.
* Help wanted for known issue [#6: the Ping System keybind for Ping displays a "Can't ping this." error](https://legacy.curseforge.com/wow/addons/stealth-alerter/issues/6).

### Version 0.99.35 2024-06-16
* TOC update for 10.2.7.
* Added a second spellId for Stealth (Rogue).
* Removed Potion of Minor Invisibility.
* Added Potion of the Hushed Zephyr.
* Help wanted for known issue [#6: the Ping System keybind for Ping displays a "Can't ping this." error](https://legacy.curseforge.com/wow/addons/stealth-alerter/issues/6).

### Version 0.99.34 2023-12-29
* TOC update for 10.2.0.
* Help wanted for known issue [#6: the Ping System keybind for Ping displays a "Can't ping this." error](https://legacy.curseforge.com/wow/addons/stealth-alerter/issues/6).

### Version 0.99.33 2023-05-03
* TOC update for 10.1.0.
* Added IconTexture.

### Version 0.99.32 2022-11-17
* File name fix.

### Version 0.99.31 2022-11-17
* TOC update for 10.0.2.

### Version 0.99.30 2021-01-01
* Added Potion of the Hidden Spirit.
* Corrected Prowl (Druid) description.

### Version 0.99.29 2020-11-30
* TOC update for 9.0.2.

### Version 0.99.28 2020-11-02
* TOC update for 9.0.1.

### Version 0.99.27 2018-07-28
* Added Camouflage (Hunter) again, since it still exists.

### Version 0.99.26 2018-07-23
* TOC update for 8.0.0.
* Updated COMBAT_LOG_EVENT_UNFILTERED event handling with new CombatLogGetCurrentEventInfo() function.
* Added Potion of Minor Invisibility and Potion of Trivial Invisibility.
* Removed Camouflage (Hunter).
* Added non-localized Allied races names (DarkIronDwarf, KulTiran, LightforgedDraenei, VoidElf, HighmountainTauren, MagharOrc, Nightborne, and ZandalariTroll).

### Version 0.99.25 2016-07-31
* TOC update for 7.0.3.
* Fixed API calls that were causing a LUA error.
* Some new Legion stealth or invisibility spells may be missing.

### Version 0.99.24 2015-09-07
* Added Draenic Invisibility Potion.

### Version 0.99.23 2015-07-01
TOC update for 6.2.0.

### Version 0.99.22 2015-03-15
* TOC update for 6.1.0.
* Added Stealthman 54 devices.

### Version 0.99.21 2014-10-19
* TOC update for 6.0.2.

### Version 0.99.20 2014-04-30
* Added Mage Greater Invisibility.
* Reverted hostility detection back to using a table, and only try to use a tool tip for Pandaren. It turns out that the tool tip mechanism fails surprisingly frequently [thanks Billtopia].

### Version 0.99.19 2014-04-06
* Added Rogue Shroud of Concealment [thanks Twopro].
* Rewrote hostility detection to use a tool tip instead of a table, now hostility for all races (including Pandaren) is detected correctly [thanks Billtopia].

### Version 0.99.18 2014-04-02
* Fixed screen flash when a hostile Vanish is detected. I had it backwards so the screen flashed when a friendly Vanish was detected.

### Version 0.99.17 2014-03-07
* Added an option to flash the screen red when a hostile action is detected [thanks Twopro]. Screen flash is enabled by default, "/sal noflash" disables it.

### Version 0.99.16 2014-02-17
* Fixed two mistakes in the lookup tables that could cause the wrong color log message to be printed for Night Elf and Blood Elf. Non-localized names don't have spaces.

### Version 0.99.15 2014-02-07
* Faction and race lookups now use non-localized names. This should fix the localization crash and you won't need to change names to your local language anymore. Note that log messages will still be in English.
* Added table lookup error trap [thanks Maroot].

### Version 0.99.14 2014-02-06
* TOC update for 5.4.2.
* Added Pandaren race. Unfortunately, there is no way to tell if a player is hostile based on GUID from the combat log. Any spells cast by Pandaren will appear in red text as hostile, even if they are cast by a friendly player.

### Version 0.99.13 2011-12-03
* TOC update for 4.3.0.

### Version 0.99.12 2011-06-30
* TOC update for 4.2.0.

### Version 0.99.11 2011-05-07
* TOC update for 4.1.0a.
* Removed Rogue Stealth movement penalty description, since it was removed.
* Fixed a typo.
* Looked into adding Rogue Smoke Bomb casts, but it looks to be impossible because the cast doesn't show up in the combat log.

### Version 0.99.10 2010-12-17
* Now works with 4.0.3a.
* Added Goblin and Worgen races.
* Added Hunter Camouflage.
* Added more nil race pointer checks to prevent crashes and Lua errors. It's unclear to me how race would ever be nil, but apparently it is sometimes.

### Version 0.99.9 2010-10-23
* TOC update for 4.0.1.
* Added a "nofriendly" option to hide friendly actions and only show enemy actions.
* Added a "terse" option that hides the race and duration in messages.
* Updated Rogue 4.0.1 ability levels.
* Looked into adding player level, it looks impossible due to limitations in the Blizzard APIs and the way I wanted to do it.

### Version 0.99.8 2010-05-27
* Added player race to messages so that they now read "Player (race) ...".

### Version 0.99.7 2009-12-09
* Updated for Prowl and Stealth rank changes in 3.3.

### Version 0.99.6 2009-12-05
* TOC update for 3.3.
* Added the duration for Invisibility (20 seconds) in the message.

### Version 0.99.5 2009-10-30
* Fixed a typo that would cause a Lua error for Horde characters.

### Version 0.99.4 2009-10-28
* Added color coding to the messages to make it more obvious who cast the ability. Casts from friendly players are printed in blue and casts from hostile players are printed in red.

### Version 0.99.3 2009-08-24
* Fixed a typo that could cause a Lua error if Stealth Alerter was disabled.

### Version 0.99.2 2009-08-21
* Removed some code used for debugging that printed a message when Hunters cast Misdirection.

### Version 0.99.1 2009-08-12
* Several scoping fixes that could cause strange interactions with other AddOns.

### Version 0.99.0 2009-08-12
* Initial release.

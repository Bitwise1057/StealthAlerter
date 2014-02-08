local StealthAlerterMyEnemiesTable = nil;
local StealthAlerterAllianceTable = {"Draenei", "Dwarf", "Human", "Gnome", "Night Elf", "Worgen", "Pandaren"};
local StealthAlerterHordeTable = {"Blood Elf", "Orc", "Troll", "Tauren", "Undead", "Goblin", "Pandaren"}; 

--
-- Search a table.
--
local function SearchTable(race, table)

   ---
   --- Error trap for bad things that may happen (thanks Maroot).
   ---
   if ((not table) or (type(table) ~= "table")) then 
      return false; 
   end

   for _, v in pairs(table) do
      if (v == race) then 
         return true;
      end
   end

   return false;
end -- local function SearchTable()

-- 
-- Show the help.
--
local function ShowHelp()
   if StealthAlerterEnabled then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is on, type \"/sal off\" to turn it off.", 0.0, 0.85, 0.0);
      if StealthAlerterShowFriendly == true then
         DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will show friendly actions, type \"/sal nofriendly\" to turn them off.", 0.0, 0.85, 0.0);
      else
         DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will hide friendly actions, type \"/sal friendly\" to turn them on.", 0.0, 0.85, 0.0);
      end
      if StealthAlerterTerse == true then
         DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will print terse messages, type \"/sal noterse\" for more detail.", 0.0, 0.85, 0.0);
      else
         DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will print detailed messages, type \"/sal terse\" for less detail.", 0.0, 0.85, 0.0);
      end
   else
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is off, type \"/sal on\" to turn it on.", 0.0, 0.85, 0.0);
   end
end -- local function ShowHelp()

--
-- Handle slash commands.
--
function StealthAlerterCommand(command)
   local argc, argv = 0, {};
   gsub(command, "[^%s]+", function (word) argc=argc+1; argv[argc]=word; end);

   if (argc == 1) and (argv[1] == "help") then
      ShowHelp();
   elseif (argc == 1) and (argv[1] == "off") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is off, type \"/sal on\" to turn it on.", 0.0, 0.85, 0.0);
      StealthAlerterEnabled = false;
      StealthAlerterFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
   elseif (argc == 1) and (argv[1] == "on") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is on, type \"/sal off\" to turn it off.", 0.0, 0.85, 0.0);
      StealthAlerterEnabled = true;
      StealthAlerterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
   elseif (argc == 1) and (argv[1] == "debug") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." debug is on, type \"/sal undebug\" to turn debugging off.", 0.0, 0.85, 0.0);
      StealthAlerterDebug = true;
   elseif (argc == 1) and (argv[1] == "undebug") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." debug is off, type \"/sal debug\" to turn debugging on.", 0.0, 0.85, 0.0);
      StealthAlerterDebug = false;
   elseif (argc == 1) and (argv[1] == "friendly") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will show friendly actions, type \"/sal nofriendly\" to turn them off.", 0.0, 0.85, 0.0);
      StealthAlerterShowFriendly = true;
   elseif (argc == 1) and (argv[1] == "nofriendly") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will hide friendly actions, type \"/sal friendly\" to turn them on.", 0.0, 0.85, 0.0);
      StealthAlerterShowFriendly = false;
   elseif (argc == 1) and (argv[1] == "terse") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will print terse messages, type \"/sal noterse\" for more detail.", 0.0, 0.85, 0.0);
      StealthAlerterTerse = true;
   elseif (argc == 1) and (argv[1] == "noterse") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter will print detailed messages, type \"/sal terse\" for less detail.", 0.0, 0.85, 0.0);
      StealthAlerterTerse = false;
   else
      ShowHelp();
   end
end -- function StealthAlerterCommand()

-- 
-- Do stuff when the Addon is loaded.
--
function StealthAlerterOnLoad()
   StealthAlerterVersion = "0.99.15 (February 7, 2014)";   -- Version number.

   --
   -- Register a command handler.
   -- 
   SlashCmdList["STEALTHALERTERCMD"] = StealthAlerterCommand;
   SLASH_STEALTHALERTERCMD1 = "/sal";
   SLASH_STEALTHALERTERCMD2 = "/stealthalerter";
   
   if StealthAlerterEnabled == nil then
      StealthAlerterEnabled = true;
   end

   if StealthAlerterDebug == nil then
      StealthAlerterDebug = false;
   end

   if StealthAlerterShowFriendly == nil then
      StealthAlerterShowFriendly = true;
   end

   if StealthAlerterTerse == nil then
      StealthAlerterTerse = false;
   end

   --
   -- Get our faction.
   --
   -- factionGroup is the non-localized (English) faction name of the faction ('Horde', 'Alliance', or 'Neutral').
   -- factionName is the localized name of the faction - not used.
   --
   local myFactionGroup, myFactionName = UnitFactionGroup("player");

   -- 
   -- Set our enemies.
   --
   if myFactionGroup == "Horde" then
      StealthAlerterMyEnemiesTable = StealthAlerterAllianceTable;
   else
      StealthAlerterMyEnemiesTable = StealthAlerterHordeTable;
   end 

   StealthAlerterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

   return;
end -- function StealthAlerterOnLoad()

-- 
-- Handle the events we've registered, print messages and do stuff.
--
function StealthAlerterOnEvent(event, ...)
   local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, mysteryArgument, destGUID, destName, destFlags, anotherMysteryArgument, spellId, spellName = select(1, ...)

   if StealthAlerterEnabled == false then
      return;
   end

   --
   -- Look for interesting SPELL_CAST_SUCCESS events.
   --
   if event == "COMBAT_LOG_EVENT_UNFILTERED" and type == "SPELL_CAST_SUCCESS" then
      --
      -- Enable for verbose logging.  Probably a bad idea.
      --
      -- DEFAULT_CHAT_FRAME:AddMessage(""..spellId.." "..spellName.." "..sourceGUID.." "..sourceName..".", 0.41, 0.8, 0.94);

      --
      -- Detect Rogues casting Vanish.
      --
      if spellId == 1856 then 
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Vanish.", 1.0, 0.25, 0.25);
            else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish (3 seconds).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Vanish.", 0.41, 0.8, 0.94);
            else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish (3 seconds).", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Rogues casting Stealth.
      --
      elseif spellId == 1784 then 
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth.", 1.0, 0.25, 0.25);
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Stealth.", 1.0, 0.25, 0.25);
            end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth.", 0.41, 0.8, 0.94);
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Stealth.", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Druids casting Prowl.
      --
      elseif spellId == 5215 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Prowl.", 1.0, 0.25, 0.25);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Prowl (speed reduced by 30%).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Prowl.", 0.41, 0.8, 0.94);
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Prowl (speed reduced by 30%).", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Night Elves casting Shadowmeld.
      --
      elseif spellId == 58984 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Shadowmeld.", 1.0, 0.25, 0.25);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Shadowmeld.", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Shadowmeld.", 0.41, 0.8, 0.94);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Shadowmeld.", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Hunters casting Camouflage.
      --
      elseif spellId == 51753 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Camouflage.", 1.0, 0.25, 0.25);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Camouflage (60 seconds).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Camouflage.", 0.41, 0.8, 0.94);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Camouflage (60 seconds).", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Mages casting Invisibility.
      --
      elseif spellId == 66 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Invisibility.", 1.0, 0.25, 0.25);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Invisibility (20 seconds).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Invisibility.", 0.41, 0.8, 0.94);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Invisibility (20 seconds).", 0.41, 0.8, 0.94);
	    end
	 end
      --
      -- Detect Invisibility potions.
      --
      elseif spellId == 3680 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used a Lesser Invisibility Potion.", 1.0, 0.25, 0.25);
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used a Lesser Invisibility Potion (15 seconds).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used a Lesser Invisibility Potion.", 0.41, 0.8, 0.94);
            else
	       DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used a Lesser Invisibility Potion (15 seconds).", 0.41, 0.8, 0.94);
	    end
	 end
      elseif spellId == 11392 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if raceFilename ~= nil and SearchTable(raceFilename, StealthAlerterMyEnemiesTable) then 
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used an Invisibility Potion.", 1.0, 0.25, 0.25); 
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used an Invisibility Potion (18 seconds).", 1.0, 0.25, 0.25);
	    end
	 elseif raceFilename ~= nil and StealthAlerterShowFriendly then
            if StealthAlerterTerse then
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used an Invisibility Potion.", 0.41, 0.8, 0.94);
	    else
               DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used an Invisibility Potion (18 seconds).", 0.41, 0.8, 0.94);
	    end
	 end
      end
   end
end -- function StealthAlerterOnEvent()

local StealthAlerterMyEnemiesTable = nil;
local StealthAlerterAllianceTable = {"Draenei", "Dwarf", "Human", "Gnome", "Night Elf"};
local StealthAlerterHordeTable = {"Blood Elf", "Orc", "Troll", "Tauren", "Undead"};

--
-- Search a table.
--
local function SearchTable(race, table)

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
   else
      ShowHelp();
   end
end -- function StealthAlerterCommand()

-- 
-- Do stuff when the AddOn is loaded.
--
function StealthAlerterOnLoad()
   StealthAlerterVersion = "0.99.8";   -- Version number.

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
  
   --
   -- Get our race.
   --
   -- myFileName is not used.
   --
   local myRace, myFileName = UnitRace("player");

   -- 
   -- Set our ememies.
   --
   if SearchTable(myRace, StealthAlerterAllianceTable) then
      StealthAlerterMyEnemiesTable = StealthAlerterHordeTable;
   elseif SearchTable(myRace, StealthAlerterHordeTable) then
      StealthAlerterMyEnemiesTable = StealthAlerterAllianceTable;
   end

   StealthAlerterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

   return;
end -- function StealthAlerterOnLoad()

-- 
-- Handle the events we've registered, print messages and do stuff.
--
function StealthAlerterOnEvent(event, ...)
   local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName = select(1, ...)

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
      -- DEFAULT_CHAT_FRAME:AddMessage(""..spellId.." "..spellName.." " ..sourceName.. ".", 0.41, 0.8, 0.94);

      --
      -- Detect Rogues casting Vanish.
      --
      if spellId == 1856 then 
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 1 (10 seconds).", 1.0, 0.25, 0.25);
	 else
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 1 (10 seconds).", 0.41, 0.8, 0.94);
	 end
      elseif spellId == 1857 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 2 (10 seconds).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 2 (10 seconds).", 0.41, 0.8, 0.94);
	 end
      elseif spellId == 26889 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 3 (10 seconds).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Vanish rank 3 (10 seconds).", 0.41, 0.8, 0.94);
	 end
      --
      -- Detect Rogues casting Stealth.
      --
      elseif spellId == 1784 then 
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Stealth (speed reduced by 30%).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Stealth (speed reduced by 30%).", 0.41, 0.8, 0.94);
	 end
      --
      -- Detect Druids casting Prowl.
      --
      elseif spellId == 5215 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Prowl (speed reduced by 30%).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Prowl (speed reduced by 30%).", 0.41, 0.8, 0.94);
	 end
      --
      -- Detect Night Elves casting Shadowmeld.
      --
      elseif spellId == 58984 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Shadowmeld.", 1.0, 0.25, 0.25);
	 else
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Shadowmeld.", 0.41, 0.8, 0.94);
	 end
      --
      -- Detect Mages casting Invisibility.
      --
      elseif spellId == 66 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Invisibility (20 seconds).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." ("..race..") cast Invisibility (20 seconds).", 0.41, 0.8, 0.94);
	 end
      --
      -- Detect Invisibility potions.
      --
      elseif spellId == 3680 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used a Lesser Invisibility Potion (15 seconds).", 1.0, 0.25, 0.25);
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used a Lesser Invisibility Potion (15 seconds).", 0.41, 0.8, 0.94);
	 end
      elseif spellId == 11392 then
         local class, classFilename, race, raceFilename, sex = GetPlayerInfoByGUID(sourceGUID);
	 if race ~= nil and SearchTable(race, StealthAlerterMyEnemiesTable) then 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used an Invisibility Potion (18 seconds).", 1.0, 0.25, 0.25); 
         else 
            DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " ("..race..") used an Invisibility Potion (18 seconds).", 0.41, 0.8, 0.94);
	 end
      end
   end
end -- function StealthAlerterOnEvent()

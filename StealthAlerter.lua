local function ShowHelp()
   if StealthAlerterEnabled then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is on, type \"/sal off\" to turn it off.", 0.0, 0.85, 0.0);
   else
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is off, type \"/sal on\" to turn it on.", 0.0, 0.85, 0.0);
   end
end -- local function ShowHelp()

function StealthAlerterCommand(command)
   local argc, argv = 0, {};
   gsub(command, "[^%s]+", function (word) argc=argc+1; argv[argc]=word; end);

   if (argc == 1) and (argv[1] == "help") then
      ShowHelp();
   elseif (argc == 1) and (argv[1] == "off") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is off, type \"/sal on\" to turn it on.", 0.0, 0.85, 0.0);
      StealthAlerterEnabled = false;
      StealthAlerterFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
      StealthAlerterFrame:UnRegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
   elseif (argc == 1) and (argv[1] == "on") then
      DEFAULT_CHAT_FRAME:AddMessage("Stealth Alerter "..StealthAlerterVersion.." is on, type \"/sal off\" to turn it off.", 0.0, 0.85, 0.0);
      StealthAlerterEnabled = true;
      StealthAlerterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
      StealthAlerterFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
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

function StealthAlerterOnLoad()
   StealthAlerterVersion = "0.99.2";   -- Version number.

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

   StealthAlerterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
   StealthAlerterFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

   return;
end -- function StealthAlerterOnLoad()

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
      -- DEFAULT_CHAT_FRAME:AddMessage("".. spellId .." "..spellName.." " .. sourceName .. ".", 0.41, 0.8, 0.94);

      --
      -- Detect Rogues casting Vanish.
      --
      if spellId == 1856 then 
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Vanish rank 1.", 0.41, 0.8, 0.94);
      elseif spellId == 1857 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Vanish rank 2.", 0.41, 0.8, 0.94);
      elseif spellId == 26889 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Vanish rank 3.", 0.41, 0.8, 0.94);
      --
      -- Detect Rogues casting Stealth.
      --
      elseif spellId == 1784 then 
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth rank 1 (speed reduced by 50%).", 0.41, 0.8, 0.94);
      elseif spellId == 1785 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth rank 2 (speed reduced by 40%).", 0.41, 0.8, 0.94);
      elseif spellId == 1786 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth rank 3 (speed reduced by 35%).", 0.41, 0.8, 0.94);
      elseif spellId == 1787 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Stealth rank 4 (speed reduced by 30%).", 0.41, 0.8, 0.94);
      --
      -- Detect Druids casting Prowl.
      --
      elseif spellId == 5215 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Prowl rank 1 (speed reduced by 40%).", 0.41, 0.8, 0.94);
      elseif spellId == 6783 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Prowl rank 2 (speed reduced by 35%).", 0.41, 0.8, 0.94);
      elseif spellId == 9913 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Prowl rank 3 (speed reduced by 30%).", 0.41, 0.8, 0.94);
      --
      -- Detect Night Elves casting Shadowmeld.
      --
      elseif spellId == 58984 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Shadowmeld.", 0.41, 0.8, 0.94);
      --
      -- Detect Mages casting Invisibility.
      --
      elseif spellId == 66 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName.." cast Invisibility.", 0.41, 0.8, 0.94);
      --
      -- Detect Invisibility potions.
      --
      elseif spellId == 3680 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used a Lesser Invisibility Potion (15 seconds).", 0.41, 0.8, 0.94);
      elseif spellId == 11392 then
         DEFAULT_CHAT_FRAME:AddMessage(""..sourceName .. " used an Invisibility Potion (18 seconds).", 0.41, 0.8, 0.94);
      end
   end
end -- function StealthAlerterOnEvent()

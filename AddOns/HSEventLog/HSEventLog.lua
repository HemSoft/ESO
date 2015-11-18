-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
HSEventLogAddon = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
HSEventLogAddon.name = "HSEventLog"
HSEventLogAddon.log = ""
HSEventLogAddon.logLines = {}
HSEventLogAddon.logLinesToKeep = 8
HSEventLogAddon.inventoryToMonitor =
{
  { Name = "Grand Soul Gem"    , Above = 0, Below = 50 },
  { Name = "Potent Nirncrux"   , Above = 0, Below = 999 },
  { Name = "Fortified Nirncrux", Above = 0, Below = 999 },
  { Name = "Raw Ancestor Silk" , Above = 0, Below = 100 },
  { Name = "Rough Ruby Ash"    , Above = 0, Below = 100 },
  { Name = "Rubedite Ore"      , Above = 0, Below = 100 },
  { Name = "Kuta"              , Above = 0, Below = 999 },
  { Name = "Crawlers"          , Above = 0, Below = 100 },
  { Name = "Guts"              , Above = 0, Below = 100 },
  { Name = "Insect Parts"      , Above = 0, Below = 100 },
  { Name = "Worms"             , Above = 0, Below = 100 }
}
HSEventLogAddon.lastChampionXP = 0

-- Next we create a function that will initialize our addon
function HSEventLogAddon:Initialize()
  --self.inCombat = IsUnitInCombat("player")

  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACHIEVEMENTS_UPDATED, self.OnAchievementsUpdated)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, self.OnLootReceived)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, self.OnEventZoneChanged)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SKILL_XP_UPDATE, self.OnEventSkillXpUpdate)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_COMPLETE, self.OnEventQuestComplete)

  self.savedVariables = ZO_SavedVars:New("HSEventLogSavedVariables", 1, nil, {})
  self:RestorePosition()
  LogInventory("")
end

function GetChampionPoints()
  local playerChampionXP = GetPlayerChampionXP()
  local playerChampionPointsEarned = GetPlayerChampionPointsEarned()
  local championXPInRank = GetChampionXPInRank(playerChampionPointsEarned)
  local championPointsMax = GetMaxSpendableChampionPointsInAttribute() * 3
  local enlightenedMultiplier = GetEnlightenedMultiplier()
  local enlightenedPool = GetEnlightenedPool()
  local enlightAvailForAccount = IsEnlightenedAvailableForAccount()
  local enlightAvailForChar = IsEnlightenedAvailableForCharacter()
  local earnedAchievementPoints = GetEarnedAchievementPoints()

  if playerChampionXP == nil then
    playerChampionXP = 0
  end
  if championXPInRank == nil then
    championXPInRank = 400000
  end
  if playerChampionPointsEarned == nil then
    playerChampionPointsEarned = 0
  end
  if enlightenedMultiplier == nil then
    enlightenedMultiplier = 3
  end
  if enlightenedPool == nil then
    enlightenedPool = 0
  end

  local championXPDiff = playerChampionXP - HSEventLogAddon.lastChampionXP
  HSEventLogAddon.lastChampionXP = playerChampionXP
  local championXPPercent = Round((playerChampionXP / championXPInRank) * 100)

  local result = "Champion Points = " .. playerChampionXP .. ' (' .. championXPPercent .. '%)/' .. championXPInRank .. ' (Earned: ' .. playerChampionPointsEarned .. '/' .. championPointsMax .. ') Enlightened pool: ' .. enlightenedPool
  return result
end
 
function HSEventLogAddon:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  HSEventLogAddonIndicator:ClearAnchors()
  HSEventLogAddonIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

---------------------------------------------------------------------------------------------------------
-- E V E N T S
---------------------------------------------------------------------------------------------------------
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function HSEventLogAddon.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == HSEventLogAddon.name then
    HSEventLogAddon:Initialize()
  end
end

function HSEventLogAddon.OnAchievementsUpdated(eventCode)
  local earnedAchievementPoints = GetEarnedAchievementPoints()
  local totAchievementPoints = GetTotalAchievementPoints()
  WriteLog(GetTimeString() .. " -- Achievement points: " .. earnedAchievementPoints .. " / " .. totAchievementPoints)
end

function HSEventLogAddon.OnEventQuestComplete(eventCode, questName, level, previousExperience, currentExperience, rank, previousPoints, currentPoints)
  LogInventory(text)
end

function HSEventLogAddon.OnEventSkillXpUpdate(eventCode, skillType, skillIndex, reason, rank, previousXP, currentXP)
  LogInventory(text)
end

function HSEventLogAddon.OnIndicatorMoveStop()
  HSEventLogAddon.savedVariables.left = HSEventLogAddonIndicator:GetLeft()
  HSEventLogAddon.savedVariables.top = HSEventLogAddonIndicator:GetTop()
end

function HSEventLogAddon.OnPlayerCombatState(event, inCombat)
  LogInventory(text)
end

function HSEventLogAddon.OnEventZoneChanged(eventCode, zoneName, subZoneName, newSubzone)
  LogInventory(text)
end

function HSEventLogAddon.OnLootReceived(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self)
  local usedBagSlots = GetNumBagUsedSlots(INVENTORY_BACKPACK)
  local maxBagSlots = GetBagSize(INVENTORY_BACKPACK)
  local text = ""
  local itemName2 = itemName

  if string.find(itemName, "^p") ~= nil or string.find(itemName, "^n") ~= nil  then
    itemName2 = string.sub(itemName, 1, string.len(itemName) - 2)
  end

  text = "Got " .. quantity .. " " .. itemName2 .. " Bag " .. usedBagSlots .. "/" .. maxBagSlots .. "\n"
  LogInventory(text)
end

function LogInventory(text)
  local usedBagSlots = GetNumBagUsedSlots(INVENTORY_BACKPACK)
  local backpackItemName = ""
  local backpackItemType = ""
  local trophyCount = 0
  local collectibleCount = 0
  local backpackItemTotalCount = 0
  local lowerBackpackItemName = ""
  local lowerInventoryToMonitor = ""
  local correctedBackpackItemName = ""

  if text == nil then
    text = ''
  end

  HSEventLogAddon.inventoryToMonitorCount = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

  for x = 1, usedBagSlots do
    backpackItemName = GetItemName(INVENTORY_BACKPACK, x)
    backpackItemType = GetItemType(INVENTORY_BACKPACK, x)

    if (backpackItemType == ITEMTYPE_TROPHY) then
      trophyCount = trophyCount + 1
    end
    if (backpackItemType == ITEMTYPE_COLLECTIBLE) then
      collectibleCount = collectibleCount + 1
    end
    lowerBackpackItemName = string.lower(backpackItemName)

    -- Loop through inventory to monitor array
    for y = 1, #HSEventLogAddon.inventoryToMonitor do
      backpackItemTotalCount = GetItemTotalCount(INVENTORY_BACKPACK, x)

      lowerInventoryToMonitor = string.lower(HSEventLogAddon.inventoryToMonitor[y].Name)
      correctedBackpackItemName = string.sub(lowerBackpackItemName, 1, string.len(lowerInventoryToMonitor))

      if (lowerInventoryToMonitor == correctedBackpackItemName) then
        HSEventLogAddon.inventoryToMonitorCount[y] = backpackItemTotalCount
      end
    end
  end

  for y = 1, #HSEventLogAddon.inventoryToMonitor do
    if (HSEventLogAddon.inventoryToMonitorCount[y] > HSEventLogAddon.inventoryToMonitor[y].Above) and (HSEventLogAddon.inventoryToMonitorCount[y] < HSEventLogAddon.inventoryToMonitor[y].Below) then
      if HSEventLogAddon.inventoryToMonitor[y].Name ~= nil and HSEventLogAddon.inventoryToMonitorCount[y] ~= nil then
        text = text .. HSEventLogAddon.inventoryToMonitor[y].Name .. " = " .. HSEventLogAddon.inventoryToMonitorCount[y] .. "\n"
      end
    end
  end

  text = text .. "Collectibles = " .. collectibleCount .. "\n"
  text = text .. "Trophies = " .. trophyCount .. "\n"
  text = text .. GetChampionPoints() .. "\n"
  WriteLog(GetTimeString() .. "\n" .. text)

end

function Round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(HSEventLogAddon.name, EVENT_ADD_ON_LOADED, HSEventLogAddon.OnAddOnLoaded)

---------------------------------------------------------------------------------------------------------
-- H E L P E R    F U N C T I O N S
---------------------------------------------------------------------------------------------------------
function WriteLog(text)
  HSEventLogAddonIndicatorLabel:SetText(text)
end









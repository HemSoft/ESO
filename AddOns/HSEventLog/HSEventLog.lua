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
  { Name = "Ancestor Silk"     , Above = 0, Below = 100 },
  { Name = "Ruby Ash"          , Above = 0, Below = 100 },
  { Name = "Rubedite Ore"      , Above = 0, Below = 100 },
  { Name = "Itade"             , Above = 0, Below = 100 },
  { Name = "Repora"            , Above = 0, Below = 100 },
  { Name = "Kuta"              , Above = 0, Below = 999 },
  { Name = "Crawlers"          , Above = 0, Below = 100 },
  { Name = "Guts"              , Above = 0, Below = 100 },
  { Name = "Insect Parts"      , Above = 0, Below = 100 },
  { Name = "Worms"             , Above = 0, Below = 100 }
}
HSEventLogAddon.lastChampionXP = 0

-- Next we create a function that will initialize our addon
function HSEventLogAddon:Initialize()
  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACHIEVEMENTS_UPDATED, self.OnAchievementsUpdated)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, self.OnLootReceived)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, self.OnEventZoneChanged)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SKILL_XP_UPDATE, self.OnEventSkillXpUpdate)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_COMPLETE, self.OnEventQuestComplete)

  self.savedVariables = ZO_SavedVars:New("HSEventLogSavedVariables", 2, nil, {})
  HSEventLogAddon:SetSavedVariables()
  self:RestorePosition()
  LogInventory("")
end

function HSEventLogAddon:SetSavedVariables()
  self.savedVariables.AlliancePoints = GetAlliancePoints()
  self.savedVariables.BankedCash = GetBankedMoney()
  self.savedVariables.BankedTelvarStones = GetBankedTelvarStones()
  self.savedVariables.Cash = GetCurrentMoney()
  self.savedVariables.ChampionPointsEarned = GetPlayerChampionPointsEarned()
  self.savedVariables.Date = GetDate()
  self.savedVariables.GuildCount = GetNumGuilds()
  self.savedVariables.MailCount = GetNumMailItems()
  self.savedVariables.MailMax = GetMaxMailItems()
  self.savedVariables.MaxBagSize = GetBagSize(BAG_BACKPACK)
  self.savedVariables.MaxBankSize = GetBagSize(BAG_BANK)
  self.savedVariables.NumberOfFriends = GetNumFriends()
  self.savedVariables.SecondsPlayed = GetSecondsPlayed()
  self.savedVariables.Time = GetFormattedTime()
  self.savedVariables.UsedBagSlots = GetNumBagUsedSlots(BAG_BACKPACK)
  self.savedVariables.UsedBankSlots = GetNumBagUsedSlots(BAG_BANK)

  -- Needs to be supported by reader app:
  local secsMinLeftB, secsMinTotalB, secsMaxLeftB, secsMaxTotalB, numSlotsB, numFreeSlotsB, iconsB = HSEventLogAddon:GetCraftingData(CRAFTING_TYPE_BLACKSMITHING)
  self.savedVariables.BlacksmithingSecondsMinimumLeft  = secsMinLeftB
  self.savedVariables.BlacksmithingSecondsMinimumTotal = secsMinTotalB
  self.savedVariables.BlacksmithingSecondsMaximumLeft  = secsMaxLeftB
  self.savedVariables.BlacksmithingSecondsMaximumTotal = secsMaxTotalB
  self.savedVariables.BlacksmithingSlotsMax            = numSlotsB
  self.savedVariables.BlacksmithingSlotsFree           = numFreeSlotsB

  local secsMinLeftW, secsMinTotalW, secsMaxLeftW, secsMaxTotalW, numSlotsW, numFreeSlotsW, iconsW = HSEventLogAddon:GetCraftingData(CRAFTING_TYPE_WOODWORKING)
  self.savedVariables.WoodworkingSecondsMinimumLeft  = secsMinLeftB
  self.savedVariables.WoodworkingSecondsMinimumTotal = secsMinTotalB
  self.savedVariables.WoodworkingSecondsMaximumLeft  = secsMaxLeftB
  self.savedVariables.WoodworkingSecondsMaximumTotal = secsMaxTotalB
  self.savedVariables.WoodworkingSlotsMax            = numSlotsB
  self.savedVariables.WoodworkingSlotsFree           = numFreeSlotsB

  local secsMinLeftC, secsMinTotalC, secsMaxLeftC, secsMaxTotalC, numSlotsC, numFreeSlotsC, iconsC = HSEventLogAddon:GetCraftingData(CRAFTING_TYPE_CLOTHIER)
  self.savedVariables.ClothingSecondsMinimumLeft  = secsMinLeftB
  self.savedVariables.ClothingSecondsMinimumTotal = secsMinTotalB
  self.savedVariables.ClothingSecondsMaximumLeft  = secsMaxLeftB
  self.savedVariables.ClothingSecondsMaximumTotal = secsMaxTotalB
  self.savedVariables.ClothingSlotsMax            = numSlotsB
  self.savedVariables.ClothingSlotsFree           = numFreeSlotsB

--  self.savedVariables.Inventory = {}
--  local usedBagSlots = GetNumBagUsedSlots(INVENTORY_BACKPACK)
--  for x = 1, usedBagSlots do
--    self.savedVariables.Inventory[x].Name = GetItemName(INVENTORY_BACKPACK, x)
--    self.savedVariables.Inventory[x].Type = GetItemType(INVENTORY_BACKPACK, x)
--    self.savedVariables.Inventory[x].Count = GetItemTotalCount(INVENTORY_BACKPACK, x)
--  end
end

function HSEventLogAddon:GetChampionPoints()
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
  text = text .. HSEventLogAddon:GetChampionPoints() .. "\n"

  local timeMs, totalDurationMs = GetTimeUntilCanBeTrained()
  local timeMinutes = timeMs / 1000 / 60
  d(timeMinutes .. " minutes until mount training")
  local inventoryBonus, maxInventoryBonus, staminaBonus, maxStaminaBonus, speedBonus, maxSpeedBonus = GetRidingStats()
  d("Bag: " .. inventoryBonus .. '/' .. maxInventoryBonus)
  d("Stamina: " .. staminaBonus .. '/' .. maxStaminaBonus)
  d("Speed: " .. speedBonus .. '/' .. maxSpeedBonus)

  d("Available Skill Points: " .. GetAvailableSkillPoints())
-- Returns: number numPoints
  d("Skyshards: " .. GetNumSkyShards())
-- Returns: number numShards
  d("Skill Types: " .. GetNumSkillTypes())
-- Returns: number numSkillTypes

  local numSkillTypes = GetNumSkillTypes()
  for skillType = 1, numSkillTypes do
    local numSkillLines = GetNumSkillLines(skillType)
    for skillIndex = 1, numSkillLines do
      local skillLineInfoName, skillLineInfoRank = GetSkillLineInfo(skillType, skillIndex)
      local skillLineXpInfoLastRankXp, skillLineXpInfoNextRankXP, skillLineXpInfoCurrentXp = GetSkillLineXPInfo(SkillType skillType, skillIndex)
      -- GetSkillLineRankXPExtents(number SkillType skillType, number skillIndex, number rank)
      -- Returns: number:nilable startXP, number:nilable nextRankStartXP
      local numSkillAbilities = GetNumSkillAbilities(skillType, skillIndex)
      for abilityIndex = 1, numSkillAbilities do
        local SkillAbilityName, SkillAbilityTextureName, SkillAbilityEarnedRank, SkillAbilityIsPassive, SkillAbilityIsUltimate, SkillAbilityIsPurchased, SkillAbilityProgressionIndex = GetSkillAbilityInfo(skillType, skillIndex, abilityIndex)
        -- GetSkillAbilityId(number SkillType skillType, number skillIndex, number abilityIndex, boolean showUpgrade)
        -- Returns: number abilityId
        local SkillAbilityUpgradeInfoCurrentUpgradeLevel, SkillAbilityUpgradeInfoMaxUpgradeLevel = GetSkillAbilityUpgradeInfo(skillType, skillIndex, number abilityIndex)
      end
    end
  end
  
-- GetSkillAbilityNextUpgradeInfo(number SkillType skillType, number skillIndex, number abilityIndex)
-- Returns: string name, textureName texture, number:nilable earnedRank
-- GetCraftingSkillLineIndices(number TradeskillType craftingSkillType)
-- Returns: number SkillType skillType, number skillIndex-- 

  HSEventLogAddon:SetSavedVariables()
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

HSEventLogAddon:GetCraftingData = function(craftClass)
  local icons = {}
  local secsMinLeft = 0
  local secsMinTotal = 0
  local secsMaxLeft = 0
  local secsMaxTotal = 0

  local numSlots = GetMaxSimultaneousSmithingResearch(craftClass)
  local numResearchLines = GetNumSmithingResearchLines(craftClass)
  local numFreeSlots = numSlots
  for researchLine = 1, numResearchLines do
    local name, icon, numTraits, researchTimeSecs = GetSmithingResearchLineInfo(craftClass, researchLine)
    for researchTrait = 1, numTraits do
      totalTimeSecs, timeLeftSecs = GetSmithingResearchLineTraitTimes(craftClass, researchLine, researchTrait)
      if ((totalTimeSecs ~= nil) and (timeLeftSecs ~= nil)) then
        table.insert(icons, icon)
        numFreeSlots = numFreeSlots - 1
        if timeLeftSecs > secsMaxLeft then
          secsMaxLeft = timeLeftSecs
          secsMaxTotal = totalTimeSecs
        end
        if (timeLeftSecs < secsMinLeft) or (secsMinLeft == 0) then
          secsMinLeft = timeLeftSecs
          secsMinTotal = totalTimeSecs
        end
      end
    end
  end
  return secsMinLeft, secsMinTotal, secsMaxLeft, secsMaxTotal, numSlots, numFreeSlots, icons
end
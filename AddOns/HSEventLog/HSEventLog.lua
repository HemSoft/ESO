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
  { Name = "Itade"             , Above = 0, Below = 999 },
  { Name = "Repora"            , Above = 0, Below = 999 },
  { Name = "Hakeijo"           , Above = 0, Below = 999 },
  { Name = "Rejera"            , Above = 0, Below = 999 },
  { Name = "Jehade"            , Above = 0, Below = 999 },
  { Name = "Kuta"              , Above = 0, Below = 999 },
  { Name = "Crawlers"          , Above = 0, Below = 100 },
  { Name = "Guts"              , Above = 0, Below = 100 },
  { Name = "Insect Parts"      , Above = 0, Below = 100 },
  { Name = "Worms"             , Above = 0, Below = 100 }
}
HSEventLogAddon.lastChampionXP = 0
HSEventLogAddon.lastQuestName = ""

-- Constants
HSEventLogAddon.SKILL_TYPE_NONE = 0
HSEventLogAddon.SKILL_TYPE_CLASS = 1
HSEventLogAddon.SKILL_TYPE_WEAPON = 2
HSEventLogAddon.SKILL_TYPE_ARMOR = 3
HSEventLogAddon.SKILL_TYPE_WORLD = 4
HSEventLogAddon.SKILL_TYPE_GUILD = 5
HSEventLogAddon.SKILL_TYPE_AVA = 6
HSEventLogAddon.SKILL_TYPE_RACIAL = 7
HSEventLogAddon.SKILL_TYPE_TRADESKILL = 8
HSEventLogAddon.SKILL_TYPE_CHAMPION = 9

HSEventLogAddon.SkillType  = {
  [HSEventLogAddon.SKILL_TYPE_NONE] = "None",
  [HSEventLogAddon.SKILL_TYPE_CLASS] = "Class",
  [HSEventLogAddon.SKILL_TYPE_WEAPON] = "Weapon",
  [HSEventLogAddon.SKILL_TYPE_ARMOR] = "Armor",
  [HSEventLogAddon.SKILL_TYPE_WORLD] = "World",
  [HSEventLogAddon.SKILL_TYPE_GUILD] = "Guild",
  [HSEventLogAddon.SKILL_TYPE_AVA] = "PvP",
  [HSEventLogAddon.SKILL_TYPE_RACIAL] = "Racial",
  [HSEventLogAddon.SKILL_TYPE_TRADESKILL] = "TradeSkill",
  [HSEventLogAddon.SKILL_TYPE_CHAMPION] = "Champion"
}

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
  HSEventLogAddon:WriteLog(GetTimeString() .. " -- Achievement points: " .. earnedAchievementPoints .. " / " .. totAchievementPoints)
end

function HSEventLogAddon.OnEventQuestComplete(eventCode, questName, level, previousExperience, currentExperience, rank, previousPoints, currentPoints)
  local dateTime = GetDate() .. " " .. GetTimeString()
  local questInfo = {}
  questInfo.QuestCompletionTime = dateTime
  questInfo.EventCode = eventCode
  questInfo.Name = questName
  questInfo.Level = level
  questInfo.PrevExp = previousExperience
  questInfo.CurrExp = currentExperience
  questInfo.Rank = rank
  questInfo.PrevPoints = previousPoints
  questInfo.CurrPoints = currentPoints
  questInfo.Zone = GetUnitZone("player")

  if HSEventLogAddon.savedVariables.Quest == nil then
    d("Resetting quest on savedVariables")
    HSEventLogAddon.savedVariables.Quest = {}
  end

  if HSEventLogAddon.lastQuestName ~= questName then
    d("PrevXP=" .. previousExperience .. ", CurrXP=" .. currentExperience .. ", PrevPoints=" .. previousPoints .. ", CurrPoints=" .. currentPoints)
    table.insert(HSEventLogAddon.savedVariables.Quest, questInfo)
    HSEventLogAddon.lastQuestName = questName
  end

  HSEventLogAddon:LogInventory(text)
  HSEventLogAddon:SetSavedVariables()
end

function HSEventLogAddon.OnEventPvPRankPointUpdate(eventCode, unitTag, rankPoints, difference)
  self.savedVariables.PvpInfo = HSEventLogAddon:GetPvPInfo()
end

function HSEventLogAddon.OnEventSkillXpUpdate(eventCode, skillType, skillIndex, reason, rank, previousXP, currentXP)
  local skillName, skillRank = GetSkillLineInfo(skillType, skillIndex)
  local lastRankXP, nextRankXP, currentXP = GetSkillLineXPInfo(skillType, skillIndex)
  local percentage = string.format("%.2f", (((currentXP - lastRankXP) / (nextRankXP - lastRankXP) * 100)))
  d("Skill: " .. skillName .. ", Rank: " .. skillRank .. " CurrXP: " .. currentXP .. "/" .. nextRankXP .. " = " .. percentage .. "%")
  --HSEventLogAddon:LogInventory(text)
end

function HSEventLogAddon.OnEventZoneChanged(eventCode, zoneName, subZoneName, newSubzone)
  
  HSEventLogAddon:LogInventory(text)
end

function HSEventLogAddon.OnIndicatorMoveStop()
  HSEventLogAddon.savedVariables.left = HSEventLogAddonIndicator:GetLeft()
  HSEventLogAddon.savedVariables.top = HSEventLogAddonIndicator:GetTop()
end

function HSEventLogAddon.OnPlayerCombatState(event, inCombat)

  HSEventLogAddon:LogInventory(text)
end

--function HSEventLogAddon.OnLootReceived(eventCode, receivedBy, itemName, quantity, itemSound, lootType, self,  isPickpocketLoot, questItemIcon, itemId)
--function HSEventLogAddon.OnLootReceived( _, itemLink, quantity, _, lootType, mine)
function HSEventLogAddon.OnLootReceived(eventCode, bagId, slotId, isNewItem, itemSoundCategory, updateReason)

  local usedBagSlots = GetNumBagUsedSlots(BAG_BACKPACK)
  local maxBagSlots = GetBagSize(BAG_BACKPACK)
  
  local itemType = GetItemType(bagId, slotId)
  local itemLink = GetItemLink(bagId, slotId, LINK_STYLE_DEFAULT)
  local itemName = GetItemLinkName(itemLink)
  
  local itemInstanceId = GetItemInstanceId(bagId, slotId)

  local itemTotalCount = GetItemTotalCount(bagId, slotId)
  local bankTotalCount = 0

  if (bagId ~= BAG_BANK) then
    -- Try to find this inventory in the bank:
    local usedBankSlots = GetNumBagUsedSlots(BAG_BANK)
    local maxBankSlots = GetBagSize(BAG_BANK)
    for x = 1, usedBankSlots do
      local bankItemType = GetItemType(BAG_BANK, x)
      local bankItemLink = GetItemLink(BAG_BANK, x, LINK_STYLE_DEFAULT)
      local bankItemName = GetItemLinkName(bankItemLink)
      local bankItemInstanceId = GetItemInstanceId(BAG_BANK, x)
      local bankItemTotalCount = GetItemTotalCount(BAG_BANK, x)

      if bankItemName:lower() == itemName:lower() then
        bankTotalCount = bankItemTotalCount
      end
    end
    
    local text = itemName .. " (" .. itemTotalCount .. "/" .. bankTotalCount .. ") " .. usedBagSlots .. "/" .. maxBagSlots .. "\n"
    --HSEventLogAddon:LogInventory(text, itemName)
  end
end

function HSEventLogAddon.OnEventSmithingTraitResearchCompleted(eventCode, craftingSkillType, researchLineIndex, traitIndex)

  HSEventLogAddon:SetSavedVariables()
end

function HSEventLogAddon.OnEventSmithingTraitResearchStarted(eventCode, craftingSkillType, researchLineIndex, traitIndex)

  HSEventLogAddon:SetSavedVariables()
end

function HSEventLogAddon.OnEventRidingSkillImprovement(eventCode, ridingSkillType, previous, current, source)

  HSEventLogAddon:SetSavedVariables()
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(HSEventLogAddon.name, EVENT_ADD_ON_LOADED, HSEventLogAddon.OnAddOnLoaded)

---------------------------------------------------------------------------------------------------------
-- H E L P E R    F U N C T I O N S
---------------------------------------------------------------------------------------------------------
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
  local championXPPercent = HSEventLogAddon:Round((playerChampionXP / championXPInRank) * 100)

  local result = "Champion Points = " .. playerChampionXP .. ' (' .. championXPPercent .. '%)/' .. championXPInRank .. ' (Earned: ' .. playerChampionPointsEarned .. '/' .. championPointsMax .. ') Enlightened pool: ' .. enlightenedPool

  return result
end
 
function HSEventLogAddon:GetCraftingData(craftClass)
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

function HSEventLogAddon:GetGuildInfo()
  local guildTable = {}
  local guildInfo = {}

  guildCount = GetNumGuilds()
  for x = 1, guildCount do
    guildInfo = {}

    local members, membersOnline, leaderName = GetGuildInfo(x)
    guildInfo = {
      Name = GetGuildName(x)
    , Description = GetGuildDescription(x)
    , Founded = GetGuildFoundedDate(x)
    , AllicanceId = GetGuildAlliance(x)
    , MotD = GetGuildMotD(x)
    , Members = members
    , MembersOnline = membersOnline
    , LeaderName = leaderName
    }

    table.insert(guildTable, guildInfo)
  end
  return guildTable
end

function HSEventLogAddon:GetInventory(whereToLook)
  local inventoryTable = {}
  local inventory = {}

  usedSlots = GetNumBagUsedSlots(whereToLook)

  for x = 1, usedSlots do
    local icon, sellPrice, meetsUsageRequirement, equipType, itemStyle = GetItemLinkInfo(GetItemLink(whereToLook, x, LINK_STYLE_DEFAULT))

    local itemLink = GetItemLink(whereToLook, x, LINK_STYLE_DEFAULT)
    local itemName = GetItemLinkName(itemLink)
    if itemName ~= nil then
      inventory = {}
      inventory = {
        ArmorType = GetItemArmorType(whereToLook, x)
      , Consumable = IsItemConsumable(whereToLook, x)
      , Info = GetItemInfo(whereToLook, x)
      , InstanceId = GetItemInstanceId(whereToLook, x)
      , IsBound = IsItemBound(whereToLook, x)
      , IsEquipable = IsEquipable(whereToLook, x)
      , IsUsable = IsItemUsable(whereToLook, x)
      , Location = whereToLook
      , Name = itemName
      , IsJunk = IsItemJunk(whereToLook, x)
      , Link = itemLink
      , Icon = icon
      , SellPrice = sellPrice
      , MeetsUsageRequirement = meetsUsageRequirement
      , EquipType = equipType
      , ItemStyle = itemStyle
      , RequiredLevel = GetItemRequiredLevel(whereToLook, x)
      , RequiredVeteranRank = GetItemRequiredVeteranRank(whereToLook, x)
      , StackSize = GetSlotStackSize(whereToLook, x)
      , StatValue = GetItemStatValue(whereToLook, x)
      , TotalCount = GetItemTotalCount(whereToLook, x)
      , Trait = GetItemTrait(whereToLook, x)
      , Type = GetItemType(whereToLook, x)
          -- Returns: string icon, number sellPrice, boolean meetsUsageRequirement, number equipType, number itemStyle
      }
      table.insert(inventoryTable, inventory)
    end
  end

  return inventoryTable
end

function HSEventLogAddon:GetJournal()
  local journal = {}
  local journalInfo = {}

  local questCount = GetNumJournalQuests()
  for questIndex = 1, questCount do
    journalInfo = {}
    if IsValidQuestIndex(questIndex) then
      journalInfo.RepeatType = GetJournalQuestRepeatType(questIndex)
      journalInfo.QuestName, journalInfo.BackgroundText, journalInfo.ActiveStepText, journalInfo.ActiveStepType, journalInfo.ActiveStepTrackerOverrideText, journalInfo.Completed, journalInfo.Tracked, journalInfo.QuestLevel, journalInfo.Pushed, journalInfo.QuestType, journalInfo.InstanceDisplayType = GetJournalQuestInfo(questIndex)
      table.insert(journal, journalInfo)
      local compl = "No"
      if journalInfo.Completed == true then
        compl = "Yes"
      end
    end
  end
  return journal
end

function HSEventLogAddon:GetPvPInfo()
  local rankPoints = GetUnitAvARankPoints("player")
  local rank, subRank = GetUnitAvARank("player")
  local subRankStartsAt, nextSubRankAt, rankStartsAt, nextRankAt = GetAvARankProgress(rankPoints)
  local pointsNeededForRank = GetNumPointsNeededForAvARank(Rank)

  local PvPInfo = {
    RankPoints = rankPoints,
    Rank = rank,
    SubRank = subRank,
    SubRankStartsAt = subRankStartsAt,
    NextSubRankAt = nextSubRankAt,
    RankStartsAt = rankStartsAt,
    NextRankAt = nextRankAt,
    PointsNeededForRank = pointsNeededForRank
  }
  return PvPInfo
end

function HSEventLogAddon:GetSkills()
  local skill = {}
  local skillInfo = {}
  local numSkillTypes = GetNumSkillTypes()

  for skillType = 1, numSkillTypes do
    local numSkillLines = GetNumSkillLines(skillType)
    for skillIndex = 1, numSkillLines do
      skillInfo = {}
      skillInfo.Name, skillInfo.Rank = GetSkillLineInfo(skillType, skillIndex)
      skillInfo.LastRankXp, skillInfo.NextRankXP, skillInfo.XP = GetSkillLineXPInfo(skillType, skillIndex)
      table.insert(skill, skillInfo)
    end
  end
  return skill
end

function HSEventLogAddon:GetTitles()
  local titleTable = {}
  local numberOfTitles = GetNumTitles()

  for titleIndex = 1, numberOfTitles do
    local title = GetTitle(titleIndex)
    table.insert(titleTable, title)
  end

  return titleTable
end

function HSEventLogAddon:Initialize()
  -- Next we create a function that will initialize our addon
  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACHIEVEMENTS_UPDATED, self.OnAchievementsUpdated)
  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, self.OnLootReceived)

  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, self.OnLootReceived)
    
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ZONE_CHANGED, self.OnEventZoneChanged)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SKILL_XP_UPDATE, self.OnEventSkillXpUpdate)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_QUEST_COMPLETE, self.OnEventQuestComplete)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SMITHING_TRAIT_RESEARCH_COMPLETED, self.OnEventSmithingTraitResearchCompleted)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_SMITHING_TRAIT_RESEARCH_STARTED, self.OnEventSmithingTraitResearchStarted)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_RIDING_SKILL_IMPROVEMENT, self.OnEventRidingSkillImprovement)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_RANK_POINT_UPDATE, self.OnEventPvPRankPointUpdate) 

  self.savedVariables = ZO_SavedVars:New("HSEventLogSavedVariables", 11, nil, {})
  self.accountVariables = ZO_SavedVars:NewAccountWide("HSEventLogAccountVariables", 11, nil, {})

  HSEventLogAddon:SetSavedVariables()
  self:RestorePosition()
  HSEventLogAddon:LogInventory("")
end

function HSEventLogAddon:LogInventory(text, itemName)
  local usedBagSlots = GetNumBagUsedSlots(BAG_BACKPACK)
  local backpackItemName = ""
  local backpackItemType = ""
  local trophyCount = 0
  local collectibleCount = 0
  local backpackItemTotalCount = 0
  local lowerBackpackItemName = ""
  local lowerInventoryToMonitor = ""
  
  if text == nil then
    text = ''
  end

  HSEventLogAddon.inventoryToMonitorCount = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

  for x = 1, usedBagSlots do
    backpackItemName = GetItemName(BAG_BACKPACK, x)
    backpackItemType = GetItemType(BAG_BACKPACK, x)

    if (backpackItemType == ITEMTYPE_TROPHY) then
      trophyCount = trophyCount + 1
    end
    if (backpackItemType == ITEMTYPE_COLLECTIBLE) then
      collectibleCount = collectibleCount + 1
    end
    lowerBackpackItemName = string.lower(backpackItemName)

    -- Loop through inventory to monitor array
    for y = 1, #HSEventLogAddon.inventoryToMonitor do
      backpackItemTotalCount = GetItemTotalCount(BAG_BACKPACK, x)

      lowerInventoryToMonitor = string.lower(HSEventLogAddon.inventoryToMonitor[y].Name)
      local correctedBackpackItemName = string.sub(lowerBackpackItemName, 1, string.len(lowerInventoryToMonitor))

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

  text = text .. "Achievement Points: " .. GetEarnedAchievementPoints() .. "/" .. GetTotalAchievementPoints() .. "\n"
  text = text .. HSEventLogAddon:GetChampionPoints() .. "\n"
 
  self.savedVariables.PvpInfo = HSEventLogAddon:GetPvPInfo()
  text = text .. "PVP Rank: " .. self.savedVariables.PvpInfo.Rank .. "/" .. self.savedVariables.PvpInfo.nextRankAt .. ", SubRank: " .. self.savedVariables.PvpInfo.SubRank .. "/" .. self.savedVariables.PvpInfo.nextSubRankAt

  HSEventLogAddon:SetSavedVariables()
  HSEventLogAddon:WriteLog(GetDate() .. " " .. GetTimeString() .. "\n" .. text)
end

function HSEventLogAddon:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
  if left == 0 and top == 0 then
    left = 100
    top = 100
  end
 
  HSEventLogAddonIndicator:ClearAnchors()
  HSEventLogAddonIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

function HSEventLogAddon:Round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function HSEventLogAddon:GetResearchGrid()
  local researchTable = {}

  -- CRAFTING_TYPE_BLACKSMITHING
  -- CRAFTING_TYPE_CLOTHIER
  -- CRAFTING_TYPE_WOODWORKING
  local _,_,MAXTRAITS = GetSmithingResearchLineInfo(1,1)

  local blacksmi
  thingResearchLines = GetNumSmithingResearchLines(CRAFTING_TYPE_BLACKSMITHING)
  for line = 1, blacksmithingResearchLines do
    for trait = 1, MAXTRAITS do
      local traitType, traitDescription, known = GetSmithingResearchLineTraitInfo(CRAFTING_TYPE_BLACKSMITHING, x, trait)
      local _,remaining = GetSmithingResearchLineTraitTimes(CRAFTING_TYPE_BLACKSMITHING, line, trait)
      d(traitType .. ", " .. traitDescription .. ", " .. known)
    end
  end

--  for craft, value in pairs(CS.account.crafting.research[CURRENT_PLAYER]) do
--    for line = 1, GetNumSmithingResearchLines(craft) do
--      CS.account.crafting.research[CURRENT_PLAYER][craft][line] = {}
--      if not CS.account.crafting.studies[CURRENT_PLAYER][craft][line] then CS.account.crafting.studies[CURRENT_PLAYER][craft][line] = false end
--      if not CS.account.crafting.stored[craft][line] then CS.account.crafting.stored[craft][line] = {} end
--      for trait = 1, MAXTRAITS do
--        if not CS.account.crafting.stored[craft][line][trait] then CS.account.crafting.stored[craft][line][trait] = {} end
--        local _,_,known = GetSmithingResearchLineTraitInfo(craft,line,trait)
--        local _,remaining = GetSmithingResearchLineTraitTimes(craft,line,trait)
--        if remaining then CS.account.crafting.research[CURRENT_PLAYER][craft][line][trait] = remaining + GetTimeStamp()
--        else CS.account.crafting.research[CURRENT_PLAYER][craft][line][trait] = known end
--        CS.UpdatePanelIcon(craft,line,trait)
--      end
--    end
--  end
end

function HSEventLogAddon:SetSavedVariables()
  self.savedVariables.Title = GetUnitTitle("player")
  self.savedVariables.Level = GetUnitLevel("player")
  self.savedVariables.VeteranRank = GetUnitVeteranRank("player")
  self.savedVariables.EffectiveLevel = GetUnitEffectiveLevel("player")
  self.savedVariables.Zone = GetUnitZone("player")
  self.savedVariables.XP = GetUnitXP("player")
  self.savedVariables.XPMax = GetUnitXPMax("player")
  self.savedVariables.IsVeteran = IsUnitVeteran("player")
  self.savedVariables.VP = GetUnitVeteranPoints("player")
  self.savedVariables.VPMax = GetUnitVeteranPointsMax("player")
  self.savedVariables.Alliance = GetAllianceName(GetUnitAlliance("player"))

  self.savedVariables.AchievementPoints = GetEarnedAchievementPoints()
  self.savedVariables.Skill = HSEventLogAddon:GetSkills()
  self.savedVariables.Titles = HSEventLogAddon:GetTitles()
  self.savedVariables.Journal = HSEventLogAddon:GetJournal()
  if self.savedVariables.Quest == nil then
    self.savedVariables.Quest = {}
  end

  self.savedVariables.PvpInfo = HSEventLogAddon:GetPvPInfo()
  
  self.savedVariables.Inventory  = HSEventLogAddon:GetInventory(BAG_BACKPACK)
  --self.accountVariables = HSEventLogAddon:GetInventory(BAG_BANK)

  self.savedVariables.HealthMax = GetPlayerStat(STAT_HEALTH_MAX, STAT_BONUS_OPTION_APPLY_BONUS, STAT_SOFT_CAP_OPTION_DONT_APPLY_SOFT_CAP)

  self.savedVariables.AlliancePoints = GetAlliancePoints()
  self.savedVariables.BankedCash = GetBankedMoney()
  self.savedVariables.BankedTelvarStones = GetBankedTelvarStones()
  self.savedVariables.Cash = GetCurrentMoney()
  self.savedVariables.ChampionPointsEarned = GetPlayerChampionPointsEarned()
  self.savedVariables.Class = GetUnitClass("player")
  self.savedVariables.Date = GetDate()
  self.savedVariables.GuildCount = GetNumGuilds()
  self.savedVariables.GuildInfo = HSEventLogAddon:GetGuildInfo()
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
  self.savedVariables.WoodworkingSecondsMinimumLeft  = secsMinLeftW
  self.savedVariables.WoodworkingSecondsMinimumTotal = secsMinTotalW
  self.savedVariables.WoodworkingSecondsMaximumLeft  = secsMaxLeftW
  self.savedVariables.WoodworkingSecondsMaximumTotal = secsMaxTotalW
  self.savedVariables.WoodworkingSlotsMax            = numSlotsW
  self.savedVariables.WoodworkingSlotsFree           = numFreeSlotsW

  local secsMinLeftC, secsMinTotalC, secsMaxLeftC, secsMaxTotalC, numSlotsC, numFreeSlotsC, iconsC = HSEventLogAddon:GetCraftingData(CRAFTING_TYPE_CLOTHIER)
  self.savedVariables.ClothingSecondsMinimumLeft  = secsMinLeftC
  self.savedVariables.ClothingSecondsMinimumTotal = secsMinTotalC
  self.savedVariables.ClothingSecondsMaximumLeft  = secsMaxLeftC
  self.savedVariables.ClothingSecondsMaximumTotal = secsMaxTotalC
  self.savedVariables.ClothingSlotsMax            = numSlotsC
  self.savedVariables.ClothingSlotsFree           = numFreeSlotsC

  self.savedVariables.AvailableSkillPoints = GetAvailableSkillPoints()
  self.savedVariables.Skyshards = GetNumSkyShards()
  self.savedVariables.EnlightenedPool = GetEnlightenedPool()

  local TimeTilMountFeed, TotalTime = nil, nil
  for ii = 0, 10, 1 do
    TimeTilMountFeed, TotalTime = GetTimeUntilCanBeTrained(ii)
    if TimeTilMountFeed ~= nil and TotalTime ~= nil then break end
  end
  if TimeTilMountFeed == nil or TotalTime == nil then
    TimeTilMountFeed = 0
  end

  self.savedVariables.SecondsUntilMountTraining = TimeTilMountFeed / 1000

  local inventoryBonus, maxInventoryBonus, staminaBonus, maxStaminaBonus, speedBonus, maxSpeedBonus = GetRidingStats()
  self.savedVariables.MountCapacity = inventoryBonus
  self.savedVariables.MountStamina = staminaBonus
  self.savedVariables.MountSpeed = speedBonus
end

function HSEventLogAddon:WriteLog(text)

  HSEventLogAddonIndicatorLabel:SetText(text)
end
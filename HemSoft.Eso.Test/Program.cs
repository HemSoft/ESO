using System.Linq;

namespace HemSoft.Eso.CharacterMonitor
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Timers;
    using Domain;
    using Domain.Managers;
    using NLua;
    using Lua = NLua.Lua;

    internal static class Program
    {
        private static void Main()
        {
            Timer_Elapsed(null, null);
            var timer = new Timer
            {
                Interval = 1*60*1000,
                Enabled = true
            };
            timer.Elapsed += Timer_Elapsed;
            timer.Start();
            Console.ReadLine();
        }

        private static void Timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            var lua = new Lua();
            var skillList = new List<CharacterSkill>();
            var questList = new List<CharacterQuest>();
            var guildList = new List<AccountGuild>();
            var inventoryList = new List<CharacterInventory>();
            var titleList = new List<string>();
            var characterStat = new CharacterStat();

            var achievementCategories = new List<AchievementCategory>();
            var achievementSubCategories = new List<AchievementSubCategory>();
            var achievementInfos = new List<AchievementInfo>();
            var achievementCriterias = new List<AchievementCriteria>();

            const string filePath = @"C:\Users\franz\Documents\Elder Scrolls Online\live\SavedVariables\HSEventLog.lua";
            if (!File.Exists(filePath))
            {
                return;
            }
            lua.DoFile(filePath);
            var luaTable = lua["HSEventLogSavedVariables"] as LuaTable;
            var dict = lua.GetTableDict(luaTable);

            foreach (var tables in dict)
            {
                //Console.WriteLine($"{tables.Key} = {tables.Value}");
                var accounts = lua.GetTableDict(tables.Value as LuaTable);
                foreach (var acc in accounts)
                {
                    var currentAccount = acc.Key.ToString().Substring(1);

                    var account = AccountManager.GetByName(currentAccount);
                    if (string.IsNullOrEmpty(account.Name))
                    {
                        account.Name = currentAccount;
                        AccountManager.Save(account);
                    }

                    var characters = lua.GetTableDict(acc.Value as LuaTable);
                    foreach (var c in characters)
                    {
                        var currentCharacter = c.Key.ToString();

                        var character = CharacterManager.GetByName(account.Id, currentCharacter);
                        if (string.IsNullOrWhiteSpace(character.Name))
                        {
                            character.Name = currentCharacter;
                            character.AccountId = account.Id;
                            CharacterManager.Save(character);
                        }

                        var lastCharacterActivity = CharacterActivityManager.GetLastActivity(character.Id);
                        var characterActivity = new CharacterActivity {CharacterId = character.Id};

                        var properties = lua.GetTableDict(c.Value as LuaTable);
                        var esoProperty = new LastUpdate();
                        foreach (var property in properties)
                        {
                            switch (property.Key.ToString())
                            {
                                case "AchievementPoints":
                                    characterActivity.AchievementPoints = int.Parse(property.Value.ToString());
                                    break;
                                case "Achievements":
                                    achievementCategories = new List<AchievementCategory>();
                                    var achievementCategoriesDictList = lua.GetTableDict(property.Value as LuaTable);

                                    foreach (var categoryTable in achievementCategoriesDictList)
                                    {
                                        var achievementCategoriesDictList2 = lua.GetTableDict(categoryTable.Value as LuaTable);
                                        var achievementCategory = new AchievementCategory();
                                        achievementCategory.CharacterId = character.Id;

                                        foreach (var category in achievementCategoriesDictList2)
                                        {
                                            switch (category.Key.ToString())
                                            {
                                                case "Achievements":
                                                    achievementCategory.Achievements = int.Parse(category.Value.ToString());
                                                    break;
                                                case "EarnedPoints":
                                                    achievementCategory.EarnedPointes = int.Parse(category.Value.ToString());
                                                    break;
                                                case "Name":
                                                    achievementCategory.Name = category.Value.ToString();
                                                    break;
                                                case "SubCategories":
                                                    achievementCategory.SubCategories = int.Parse(category.Value.ToString());
                                                    break;
                                                case "SubCategoryInfo":
                                                    achievementSubCategories = new List<AchievementSubCategory>();
                                                    var subCategoryDictList = lua.GetTableDict(category.Value as LuaTable);
                                                    foreach (var subCategory1 in subCategoryDictList)
                                                    {
                                                        var subCategoryDictList2 = lua.GetTableDict(subCategory1.Value as LuaTable);
                                                        var subCategory = new AchievementSubCategory();
                                                        subCategory.AchievementCategoryId = achievementCategory.Id;
                                                        subCategory.AchievementCategory = achievementCategory;

                                                        foreach (var subCategory2 in subCategoryDictList2)
                                                        {
                                                            switch (subCategory2.Key.ToString())
                                                            {
                                                                case "AchievementInfo":
                                                                    achievementInfos = new List<AchievementInfo>();
                                                                    var achievementInfoDictList = lua.GetTableDict(subCategory2.Value as LuaTable);
                                                                    foreach (var achievementInfo1 in achievementInfoDictList)
                                                                    {
                                                                        var achievementInfoDictList2 = lua.GetTableDict(achievementInfo1.Value as LuaTable);
                                                                        var achievementInfo = new AchievementInfo();
                                                                        achievementInfo.AchievementSubCategory = subCategory;
                                                                        var completedDate = string.Empty;
                                                                        var completedTime = string.Empty;
                                                                        var completed = false;
                                                                        foreach (var achievementInfo2 in achievementInfoDictList2)
                                                                        {
                                                                            switch (achievementInfo2.Key.ToString())
                                                                            {
                                                                                case "Completed":
                                                                                    completed = bool.Parse(achievementInfo2.Value.ToString());
                                                                                    break;
                                                                                case "CompletedDate":
                                                                                    completedDate = achievementInfo2.Value.ToString();
                                                                                    break;
                                                                                case "CompletedTime":
                                                                                    completedTime = achievementInfo2.Value.ToString();
                                                                                    break;
                                                                                case "Criterion":
                                                                                    var criterionDictList = lua.GetTableDict(achievementInfo2.Value as LuaTable);
                                                                                    achievementCriterias = new List<AchievementCriteria>();
                                                                                    foreach (var criterion1 in criterionDictList)
                                                                                    {
                                                                                        var criterionDictList2 = lua.GetTableDict(criterion1.Value as LuaTable);
                                                                                        var criteria = new AchievementCriteria();
                                                                                        criteria.AchievementInfo = achievementInfo;
                                                                                        criteria.AchievementInfoId = achievementInfo.Id;
                                                                                        foreach (var criterion2 in criterionDictList2)
                                                                                        {
                                                                                            switch (criterion2.Key.ToString())
                                                                                            {
                                                                                                case "Completed":
                                                                                                    if (criterion2.Value.ToString() == "1")
                                                                                                    { 
                                                                                                        criteria.Completed = true;
                                                                                                    }
                                                                                                    else
                                                                                                    { 
                                                                                                        criteria.Completed = false;
                                                                                                    }
                                                                                                    break;
                                                                                                case "Description":
                                                                                                    criteria.Description = criterion2.Value.ToString();
                                                                                                    break;
                                                                                                case "Required":
                                                                                                    if (criterion2.Value.ToString() == "1")
                                                                                                    {
                                                                                                        criteria.Required = true;
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        criteria.Required = false;
                                                                                                    }
                                                                                                    break;
                                                                                            }
                                                                                        }
                                                                                        achievementCriterias.Add(criteria);
                                                                                    }
                                                                                    achievementInfo.AchievementCriterias = achievementCriterias;
                                                                                    break;
                                                                                case "Description":
                                                                                    achievementInfo.Description = achievementInfo2.Value.ToString();
                                                                                    break;
                                                                                case "Id":
                                                                                    achievementInfo.Id = int.Parse(achievementInfo2.Value.ToString());
                                                                                    break;
                                                                                case "Name":
                                                                                    achievementInfo.Name = achievementInfo2.Value.ToString();
                                                                                    break;
                                                                                case "Points":
                                                                                    achievementInfo.Points = int.Parse(achievementInfo2.Value.ToString());
                                                                                    break;
                                                                            }
                                                                        }

                                                                        if (completed &&
                                                                            !string.IsNullOrWhiteSpace(completedDate) &&
                                                                            !string.IsNullOrWhiteSpace(completedTime))
                                                                        {
                                                                            achievementInfo.Completed = DateTime.Parse(completedDate + " " + completedTime);
                                                                        }
                                                                        achievementInfos.Add(achievementInfo);
                                                                    }
                                                                    subCategory.AchievementInfoes = achievementInfos;
                                                                    break;
                                                                case "Achievements":
                                                                    subCategory.Achievements = int.Parse(subCategory2.Value.ToString());
                                                                    break;
                                                                case "EarnedPoints":
                                                                    subCategory.EarnedPoints = int.Parse(subCategory2.Value.ToString());
                                                                    break;
                                                                case "Name":
                                                                    subCategory.Name = subCategory2.Value.ToString();
                                                                    break;
                                                                case "TotalPoints":
                                                                    subCategory.TotalPoints = int.Parse(subCategory2.Value.ToString());
                                                                    break;
                                                            }
                                                        }

                                                        achievementSubCategories.Add(subCategory);
                                                    }

                                                    achievementCategory.AchievementSubCategories = achievementSubCategories;
                                                    break;
                                                case "TotalPoints":
                                                    achievementCategory.TotalPoints = int.Parse(category.Value.ToString());
                                                    break;
                                            }
                                        }
                                        achievementCategories.Add(achievementCategory);
                                    }
                                    break;
                                case "Alliance":
                                    break;
                                case "AlliancePoints":
                                    characterActivity.AlliancePoints = int.Parse(property.Value.ToString());
                                    break;
                                case "AvailableSkillPoints":
                                    characterActivity.AvailableSkillPoints = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedCash":
                                    characterActivity.BankedCash = int.Parse(property.Value.ToString());
                                    break;
                                case "BankedTelvarStones":
                                    characterActivity.BankedTelvarStones = int.Parse(property.Value.ToString());
                                    break;

                                case "BlacksmithingSecondsMaximumLeft":
                                    characterActivity.BlacksmithingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMaximumTotal":
                                    characterActivity.BlacksmithingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMinimumLeft":
                                    characterActivity.BlacksmithingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSecondsMinimumTotal":
                                    characterActivity.BlacksmithingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSlotsFree":
                                    characterActivity.BlacksmithingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingSlotsMax":
                                    characterActivity.BlacksmithingSlotsMax = int.Parse(property.Value.ToString());
                                    break;
                                case "BlacksmithingDone":
                                    characterActivity.BlacksmthingDone = bool.Parse(property.Value.ToString());
                                    break;

                                case "ClothingSecondsMaximumLeft":
                                    characterActivity.ClothingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMaximumTotal":
                                    characterActivity.ClothingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMinimumLeft":
                                    characterActivity.ClothingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSecondsMinimumTotal":
                                    characterActivity.ClothingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSlotsFree":
                                    characterActivity.ClothingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingSlotsMax":
                                    characterActivity.ClothingSlotsMax = int.Parse(property.Value.ToString());
                                    break;
                                case "ClothingDone":
                                    characterActivity.ClothingDone = bool.Parse(property.Value.ToString());
                                    break;

                                case "Cash":
                                    characterActivity.Cash = int.Parse(property.Value.ToString());
                                    break;
                                case "ChampionPointsEarned":
                                    characterActivity.ChampionPointsEarned = int.Parse(property.Value.ToString());
                                    break;
                                case "Date":
                                    esoProperty.Date = property.Value.ToString();
                                    break;
                                case "EffectiveLevel":
                                    characterActivity.EffectiveLevel = int.Parse(property.Value.ToString());
                                    break;
                                case "EnlightenedPool":
                                    characterActivity.EnlightenedPool = int.Parse(property.Value.ToString());
                                    break;
                                case "GuildCount":
                                    characterActivity.GuildCount = int.Parse(property.Value.ToString());
                                    break;
                                case "GuildInfo":
                                    guildList.Clear();
                                    var guildDictList = lua.GetTableDict(property.Value as LuaTable);

                                    foreach (var gd in guildDictList)
                                    {
                                        var accountGuild = new AccountGuild { AccountId = account.Id };
                                        var guildInfo = lua.GetTableDict(gd.Value as LuaTable);
                                        foreach (var g in guildInfo)
                                        {
                                            switch (g.Key.ToString().ToLower())
                                            {
                                                case "allianceid":
                                                    accountGuild.AllianceId = int.Parse(g.Value.ToString());
                                                    break;
                                                case "alliancename":
                                                    accountGuild.AllianceName = g.Value.ToString();
                                                    break;
                                                case "description":
                                                    accountGuild.Description = g.Value.ToString().Replace("\n", string.Empty);
                                                    break;
                                                case "founded":
                                                    if (!string.IsNullOrWhiteSpace(g.Value.ToString()))
                                                    {
                                                        accountGuild.Founded = DateTime.Parse(g.Value.ToString());
                                                    }
                                                    break;
                                                case "leadername":
                                                    accountGuild.LeaderName = g.Value.ToString();
                                                    break;
                                                case "motd":
                                                    accountGuild.MotDescription = g.Value.ToString().Replace("\n", string.Empty);
                                                    break;
                                                case "name":
                                                    accountGuild.Name = g.Value.ToString();
                                                    break;
                                                case "members":
                                                    accountGuild.Members = int.Parse(g.Value.ToString());
                                                    break;
                                                case "membersonline":
                                                    accountGuild.MembersOnline = int.Parse(g.Value.ToString());
                                                    break;
                                            }
                                        }

                                        guildList.Add(accountGuild);
                                    }

                                    break;
                                case "Journal":
                                    break;
                                case "Inventory":
                                    inventoryList.Clear();
                                    var inventoryDictList = lua.GetTableDict(property.Value as LuaTable);
                                    foreach (var i in inventoryDictList)
                                    {
                                        var inventoryProperties = lua.GetTableDict(i.Value as LuaTable);
                                        var inventory = new CharacterInventory { CharacterId = character.Id };
                                        foreach (var ip in inventoryProperties)
                                        {
                                            switch (ip.Key.ToString().ToLower())
                                            {
                                                case "armortype":
                                                    inventory.ArmorType = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "consumable":
                                                    inventory.IsConsumable = (bool) ip.Value;
                                                    break;
                                                case "equiptype":
                                                    inventory.EquipType = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "icon":
                                                    inventory.Icon = ip.Value.ToString();
                                                    break;
                                                case "info":
                                                    inventory.Info = ip.Value.ToString();
                                                    break;
                                                case "instanceid":
                                                    inventory.InstanceId = long.Parse(ip.Value.ToString());
                                                    break;
                                                case "isbound":
                                                    inventory.IsBound = (bool) ip.Value;
                                                    break;
                                                case "isequipable":
                                                    inventory.IsEquipable = (bool) ip.Value;
                                                    break;
                                                case "isjunk":
                                                    inventory.IsJunk = (bool) ip.Value;
                                                    break;
                                                case "isusable":
                                                    inventory.IsUsable = (bool) ip.Value;
                                                    break;
                                                case "itemstyle":
                                                    inventory.ItemStyle = ip.Value.ToString();
                                                    break;
                                                case "link":
                                                    inventory.Link = ip.Value.ToString();
                                                    break;
                                                case "location":
                                                    inventory.Location = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "meetsusagerequirement":
                                                    inventory.MeetsUsageRequirement = (bool) ip.Value;
                                                    break;
                                                case "name":
                                                    inventory.Name = ip.Value.ToString();
                                                    break;
                                                case "requiredlevel":
                                                    inventory.RequiredLevel = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "requiredveteranrank":
                                                    inventory.RequiredVeteranRank = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "sellprice":
                                                    inventory.SellPrice = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "stacksize":
                                                    inventory.StackSize = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "statvalue":
                                                    inventory.StatValue = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "totalcount":
                                                    inventory.TotalCount = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "trait":
                                                    inventory.Trait = int.Parse(ip.Value.ToString());
                                                    break;
                                                case "type":
                                                    inventory.ItemType = int.Parse(ip.Value.ToString());
                                                    break;
                                            }
                                        }
                                        inventoryList.Add(inventory);
                                    }
                                    break;
                                case "IsVeteran":
                                    characterActivity.IsVeteran = bool.Parse(property.Value.ToString());
                                    break;
                                case "Level":
                                    characterActivity.Level = int.Parse(property.Value.ToString());
                                    break;
                                case "MailCount":
                                    characterActivity.MailCount = int.Parse(property.Value.ToString());
                                    break;
                                case "MailMax":
                                    characterActivity.MailMax = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBagSize":
                                    characterActivity.MaxBagSize = int.Parse(property.Value.ToString());
                                    break;
                                case "MaxBankSize":
                                    characterActivity.MaxBankSize = int.Parse(property.Value.ToString());
                                    break;
                                case "MountCapacity":
                                    characterActivity.MountCapacity = int.Parse(property.Value.ToString());
                                    break;
                                case "MountStamina":
                                    characterActivity.MountStamina = int.Parse(property.Value.ToString());
                                    break;
                                case "MountSpeed":
                                    characterActivity.MountSpeed = int.Parse(property.Value.ToString());
                                    break;
                                case "NumberOfFriends":
                                    characterActivity.NumberOfFriends = int.Parse(property.Value.ToString());
                                    break;
                                case "PlayerStats":
                                    characterStat = new CharacterStat { CharacterId = character.Id };
                                    var characterStatDict = lua.GetTableDict(property.Value as LuaTable);
                                    foreach (var cs in characterStatDict)
                                    {
                                        switch (cs.Key.ToString())
                                        {
                                            case "ArmorRating":
                                                characterStat.ArmorRating = int.Parse(cs.Value.ToString());
                                                break;
                                            case "AttackPower":
                                                characterStat.AttackPower = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Block":
                                                characterStat.Block = int.Parse(cs.Value.ToString());
                                                break;
                                            case "CriticalResistance":
                                                characterStat.CriticalResistance = int.Parse(cs.Value.ToString());
                                                break;
                                            case "CriticalStrike":
                                                characterStat.CriticalStrike = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistCold":
                                                characterStat.DamageResistCold = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistDisease":
                                                characterStat.DamageResistDisease = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistDrown":
                                                characterStat.DamageResistDrown = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistEarth":
                                                characterStat.DamageResistEarth = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistFire":
                                                characterStat.DamageResistFire = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistGeneric":
                                                characterStat.DamageResistGeneric = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistMagic":
                                                characterStat.DamageResistMagic = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistOblivion":
                                                characterStat.DamageResistOblivion = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistPhysical":
                                                characterStat.DamageResistPhysical = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistPoison":
                                                characterStat.DamageResistPoison = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistShock":
                                                characterStat.DamageResistShock = int.Parse(cs.Value.ToString());
                                                break;
                                            case "DamageResistStart":
                                                characterStat.DamageResistStart = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Dodge":
                                                characterStat.Dodge = int.Parse(cs.Value.ToString());
                                                break;
                                            case "HealingTaken":
                                                characterStat.HealingTaken = int.Parse(cs.Value.ToString());
                                                break;
                                            case "HealthMax":
                                                characterStat.HealthMax = int.Parse(cs.Value.ToString());
                                                break;
                                            case "HealthRegenCombat":
                                                characterStat.HealthRegenCombat = int.Parse(cs.Value.ToString());
                                                break;
                                            case "HealthRegenIdle":
                                                characterStat.HealthRegenIdle = int.Parse(cs.Value.ToString());
                                                break;
                                            case "MagickaMax":
                                                characterStat.MagickaMax = int.Parse(cs.Value.ToString());
                                                break;
                                            case "MagickaRegenCombat":
                                                characterStat.MagickaRegenCombat = int.Parse(cs.Value.ToString());
                                                break;
                                            case "MagickaRegenIdle":
                                                characterStat.MagickaRegenIdle = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Miss":
                                                characterStat.Miss = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Mitigation":
                                                characterStat.MitigationX = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Parry":
                                                characterStat.Parry = int.Parse(cs.Value.ToString());
                                                break;
                                            case "PhysicalPenetration":
                                                characterStat.PhysicalPenetration = int.Parse(cs.Value.ToString());
                                                break;
                                            case "PhysicalResist":
                                                characterStat.PhysicalResist = int.Parse(cs.Value.ToString());
                                                break;
                                            case "Power":
                                                characterStat.Power = int.Parse(cs.Value.ToString());
                                                break;
                                            case "SpellCritical":
                                                characterStat.SpellCritical = int.Parse(cs.Value.ToString());
                                                break;
                                            case "SpellMitigation":
                                                characterStat.SpellMitigation = int.Parse(cs.Value.ToString());
                                                break;
                                            case "SpellPenetration":
                                                characterStat.SpellPenetration = int.Parse(cs.Value.ToString());
                                                break;
                                            case "SpellPower":
                                                characterStat.SpellPower = int.Parse(cs.Value.ToString());
                                                break;
                                            case "SpellResist":
                                                characterStat.SpellResist = int.Parse(cs.Value.ToString());
                                                break;
                                            case "StaminaMax":
                                                characterStat.StaminaMax = int.Parse(cs.Value.ToString());
                                                break;
                                            case "StaminaRegenCombat":
                                                characterStat.StaminaRegenCombat = int.Parse(cs.Value.ToString());
                                                break;
                                            case "StaminaRegenIdle":
                                                characterStat.StaminaRegenIdle = int.Parse(cs.Value.ToString());
                                                break;
                                            case "WeaponPower":
                                                characterStat.WeaponPower = int.Parse(cs.Value.ToString());
                                                break;
                                        }
                                    }
                                    break;
                                case "Quest":
                                    questList.Clear();
                                    var quests = lua.GetTableDict(property.Value as LuaTable);
                                    foreach (var q in quests)
                                    {
                                        var quest = lua.GetTableDict(q.Value as LuaTable);
                                        var characterQuest = new CharacterQuest { CharacterId = character.Id };
                                        foreach (var qp in quest)
                                        {
                                            switch (qp.Key.ToString().ToLower())
                                            {
                                                case "currexp":
                                                    characterQuest.CurrentExperience = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "currpoints":
                                                    characterQuest.CurrentPoints = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "eventcode":
                                                    characterQuest.EventCode = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "name":
                                                    characterQuest.Name = qp.Value.ToString();
                                                    break;
                                                case "level":
                                                    characterQuest.Level = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "prevexp":
                                                    characterQuest.PreviousExperience = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "prevpoints":
                                                    characterQuest.PreviousPoints = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "questcompletiontime":
                                                    // 20151210 06:47:56
                                                    var dt = qp.Value.ToString();
                                                    var year = int.Parse(dt.Substring(0, 4));
                                                    var month = int.Parse(dt.Substring(4, 2));
                                                    var day = int.Parse(dt.Substring(6, 2));
                                                    var hour = int.Parse(dt.Substring(9, 2));
                                                    var minute = int.Parse(dt.Substring(12, 2));
                                                    var second = int.Parse(dt.Substring(15, 2));
                                                    characterQuest.Completed = new DateTime(year, month, day, hour, minute, second).ToUniversalTime();
                                                    break;
                                                case "rank":
                                                    characterQuest.Rank = int.Parse(qp.Value.ToString());
                                                    break;
                                                case "zone":
                                                    characterQuest.Zone = qp.Value.ToString();
                                                    break;
                                            }
                                        }
                                        questList.Add(characterQuest);
                                    }
                                    break;
                                case "SecondsPlayed":
                                    characterActivity.SecondsPlayed = int.Parse(property.Value.ToString());
                                    character.HoursPlayed = (int) characterActivity.SecondsPlayed.Value / 60 / 60;
                                    break;
                                case "SecondsUntilMountTraining":
                                    characterActivity.SecondsUntilMountTraining =
                                        int.Parse(Math.Round(decimal.Parse(property.Value.ToString())).ToString());
                                    break;
                                case "Skill":
                                    skillList.Clear();
                                    var skills = lua.GetTableDict(property.Value as LuaTable);
                                    foreach (var s in skills)
                                    {
                                        var skill = lua.GetTableDict(s.Value as LuaTable);
                                        var skillClass = new CharacterSkill();
                                        foreach (var sk in skill)
                                        {
                                            switch (sk.Key.ToString().ToLower())
                                            {
                                                case "name":
                                                    skillClass.SkillId = SkillManager.GetSkillId(sk.Value.ToString());
                                                    if (skillClass.SkillId == 0)
                                                    {
                                                        var newSkillLookup = new SkillLookup
                                                        {
                                                            Name = sk.Value.ToString()
                                                        };
                                                        skillClass.SkillId = SkillManager.Save(newSkillLookup);
                                                    }
                                                    break;
                                                case "rank":
                                                    skillClass.Rank = int.Parse(sk.Value.ToString());
                                                    break;
                                                case "xp":
                                                    skillClass.XP = int.Parse(sk.Value.ToString());
                                                    break;
                                                case "lastrankxp":
                                                    skillClass.LastRankXP = int.Parse(sk.Value.ToString());
                                                    break;
                                                case "nextrankxp":
                                                    skillClass.NextRankXP = int.Parse(sk.Value.ToString());
                                                    break;
                                            }
                                        }
                                        skillList.Add(skillClass);
                                    }
                                    break;
                                case "Skyshards":
                                    characterActivity.Skyshards = int.Parse(property.Value.ToString());
                                    break;
                                case "Time":
                                    esoProperty.Time = property.Value.ToString();
                                    break;
                                case "UsedBagSlots":
                                    characterActivity.UsedBagSlots = int.Parse(property.Value.ToString());
                                    break;
                                case "UsedBankSlots":
                                    characterActivity.UsedBankSlots = int.Parse(property.Value.ToString());
                                    break;
                                case "VeteranRank":
                                    characterActivity.VeteranRank = int.Parse(property.Value.ToString());
                                    break;
                                case "VP":
                                    characterActivity.VP = int.Parse(property.Value.ToString());
                                    break;
                                case "VPMax":
                                    characterActivity.VPMax = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMaximumLeft":
                                    characterActivity.WoodworkingSecondsMaximumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMaximumTotal":
                                    characterActivity.WoodworkingSecondsMaximumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMinimumLeft":
                                    characterActivity.WoodworkingSecondsMinimumLeft = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSecondsMinimumTotal":
                                    characterActivity.WoodworkingSecondsMinimumTotal = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSlotsFree":
                                    characterActivity.WoodworkingSlotsFree = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingSlotsMax":
                                    characterActivity.WoodworkingSlotsMax = int.Parse(property.Value.ToString());
                                    break;
                                case "WoodworkingDone":
                                    characterActivity.WoodworkingDone = bool.Parse(property.Value.ToString());
                                    break;

                                case "XP":
                                    characterActivity.XP = int.Parse(property.Value.ToString());
                                    break;
                                case "XPMax":
                                    characterActivity.XPMax = int.Parse(property.Value.ToString());
                                    break;
                                case "Zone":
                                    characterActivity.Zone = property.Value.ToString();
                                    break;
                                case "version":
                                    break;
                                case "left":
                                    break;
                                case "top":
                                    break;
                                case "HealthMax":
                                    break;
                                case "Title":
                                    character.Title = property.Value.ToString();
                                    break;
                                case "Titles":
                                    titleList.Clear();
                                    var titles = lua.GetTableDict(property.Value as LuaTable);
                                    titleList.AddRange(titles.Select(t => t.Value.ToString()));
                                    break;
                                default:
                                    break;
                            }
                        }

                        // Some post-mortem rules:

                        // 1) If Mount stats is all 60, we don't need to feed the horse.
                        if (characterActivity != null &&
                            characterActivity.MountCapacity == 60 &&
                            characterActivity.MountSpeed == 60 &&
                            characterActivity.MountStamina == 60)
                        {
                            characterActivity.SecondsUntilMountTraining = null;
                        }

                        if (esoProperty.Time == null)
                        {
                            Console.WriteLine($"Invalid time information for { character.Name }");
                            return;
                        }

                        if (esoProperty.Time.Length == 1)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 1))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 2)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 2))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 3)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 1)),
                                int.Parse(esoProperty.Time.Substring(1, 2))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 4)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                0,
                                int.Parse(esoProperty.Time.Substring(0, 2)),
                                int.Parse(esoProperty.Time.Substring(2, 2))
                            ).ToUniversalTime();
                        }
                        else if (esoProperty.Time.Length == 5)
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                int.Parse(esoProperty.Time.Substring(0, 1)),
                                int.Parse(esoProperty.Time.Substring(1, 2)),
                                int.Parse(esoProperty.Time.Substring(3, 2))
                            ).ToUniversalTime();
                        }
                        else
                        {
                            characterActivity.LastLogin = new DateTime
                            (
                                int.Parse(esoProperty.Date.Substring(0, 4)),
                                int.Parse(esoProperty.Date.Substring(4, 2)),
                                int.Parse(esoProperty.Date.Substring(6, 2)),
                                int.Parse(esoProperty.Time.Substring(0, 2)),
                                int.Parse(esoProperty.Time.Substring(2, 2)),
                                int.Parse(esoProperty.Time.Substring(4, 2))
                            ).ToUniversalTime();
                        }

                        if (!account.LastLogin.HasValue)
                        {
                            account.LastLogin = characterActivity.LastLogin.Value;
                            AccountManager.Save(account);
                        }
                        else
                        {
                            if (DateTime.Compare(characterActivity.LastLogin.Value, account.LastLogin.Value) > 0)
                            {
                                account.LastLogin = characterActivity.LastLogin.Value;
                                AccountManager.Save(account);
                            }
                        }

                        // Uncomment two lines below to force updates:
                        //UpdateCharacterActvity(account, character, characterActivity, skillList, questList, inventoryList, titleList, guildList, characterStat, achievementCategories);
                        //Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");

                        if (!character.LastLogin.HasValue)
                        {
                            UpdateCharacterActvity(account, character, characterActivity, skillList, questList, inventoryList, titleList, guildList, characterStat, achievementCategories);
                            Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                        }
                        else if (DateTime.Compare(characterActivity.LastLogin.Value, lastCharacterActivity.LastLogin.Value) > 0)
                        {
                            UpdateCharacterActvity(account, character, characterActivity, skillList, questList, inventoryList, titleList, guildList, characterStat, achievementCategories);
                            Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                        }
                        else if (lastCharacterActivity.LastLogin.HasValue)
                        {
                            if (DateTime.Compare(characterActivity.LastLogin.Value, lastCharacterActivity.LastLogin.Value) > 0)
                            {
                                UpdateCharacterActvity(account, character, characterActivity, skillList, questList, inventoryList, titleList, guildList, characterStat, achievementCategories);
                                Console.WriteLine($"Updated { character.Name } at { DateTime.Now.ToLongTimeString() }");
                            }
                        }
                    }
                }
            }
        }

        private static void UpdateCharacterActvity(Account account, Character character, CharacterActivity characterActivity,
            List<CharacterSkill> skillList, List<CharacterQuest> quests, List<CharacterInventory> inventoryList,
            List<string> titleList, List<AccountGuild> guildList, CharacterStat characterStat, 
            List<AchievementCategory> achievementCategories)
        {
            Console.WriteLine($"--> Updating { character.Name } ...");
            character.AchievementPoints = characterActivity.AchievementPoints;
            character.AlliancePoints = characterActivity.AlliancePoints;
            character.BankedTelvarStones = characterActivity.BankedTelvarStones;
            account.BankedTelvarStones = character.BankedTelvarStones;
            if (characterActivity.LastLogin != null) character.LastLogin = characterActivity.LastLogin.Value;
            if (character.EnlightenedPool == null || characterActivity.EnlightenedPool > 0)
            {
                if (character.EffectiveLevel > 50)
                {
                    character.ChampionPointsEarned = characterActivity.ChampionPointsEarned;
                    character.EnlightenedPool = characterActivity.EnlightenedPool;
                }
            }
            if (account.EnlightenedPool == null || characterActivity.EnlightenedPool > 0)
            {
                if (character.EffectiveLevel > 50)
                {
                    account.ChampionPointsEarned = characterActivity.ChampionPointsEarned;
                    account.EnlightenedPool = characterActivity.EnlightenedPool;
                }
            }
            character.EffectiveLevel = characterActivity.EffectiveLevel;

            AccountManager.Save(account);
            Console.WriteLine($"--> Updating { character.Name } Skills ...");
            CharacterManager.SaveSkills(skillList, character.Id);
            CharacterManager.SaveTitles(titleList, character.Id);

            //TODO:
            //Console.WriteLine($"--> Updating { character.Name } Achievements ...");
            //CharacterManager.SaveAchievements(achievementCategories);

            Console.WriteLine($"--> Updating { character.Name } Inventory ...");
            CharacterInventoryManager.Save(inventoryList);
            Console.WriteLine($"--> Updating { character.Name } Quests ...");
            CharacterQuestManager.Save(quests);
            CharacterManager.Save(character);
            Console.WriteLine($"--> Updating { character.Name } Activities ...");
            CharacterActivityManager.Save(characterActivity);
            CharacterStatManager.Save(characterStat);
            AccountManager.SaveGuildInfo(guildList);
            AccountManager.Save(account);
            Console.WriteLine($"--> Updating { character.Name } Done.");
        }
    }

    public class LastUpdate
    {
        public string Date { get; set; }
        public string Time { get; set; }
    }
}
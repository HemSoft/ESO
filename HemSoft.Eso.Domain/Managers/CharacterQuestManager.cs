namespace HemSoft.Eso.Domain.Managers
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;


    public static class CharacterQuestManager
    {
        public static List<CharacterQuest> GetAll()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharacterQuests.Include("Character").ToList();
            }
        }

        public static List<OrsiniumDaily> GetOrsiniumDailiesStatus()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                var orsiniumDailies = new List<OrsiniumDaily>();
                var characters = context.Characters.Include("CharacterQuests").ToList();
                foreach (var c in characters)
                {
                    if (c.EffectiveLevel == 66)
                    {
                        var daily = new OrsiniumDaily { Character = c };
                        var completedCount = 0;
                        foreach (var q in c.CharacterQuests)
                        {
                            // Dailies reset on CST time:
                            if (q.Completed.AddHours(-6).Date == DateTime.UtcNow.AddHours(-6).Date)
                            {
                                switch (q.Name)
                                {
                                    // Dolmen
                                    case "Heresy of Ignorance":
                                        daily.HeresyOfIgnorance = true;
                                        completedCount++;
                                        break;
                                    case "Meat for the Masses":
                                        daily.MeatForTheMasses = true;
                                        completedCount++;
                                        break;
                                    case "Nature's Bounty":
                                        daily.NaturesBounty = true;
                                        completedCount++;
                                        break;
                                    case "Reeking of Foul Play":
                                        daily.ReekingOfFoulPlay = true;
                                        completedCount++;
                                        break;
                                    case "Scholarly Salvage":
                                        daily.MadUrkazbur = true;
                                        completedCount++;
                                        break;
                                    case "Snow and Steam":
                                        daily.SnowAndSteam = true;
                                        completedCount++;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                        daily.AllQuestsCompletedClass = completedCount == 6 ? "success" : "active";
                        orsiniumDailies.Add(daily);
                    }

                }
                return orsiniumDailies;
            }
        }

        public static List<DailyPledge> GetPledgeStatus()
        {
            using (var context = new EsoEntities())
            {
                var dailyPledges = new List<DailyPledge>();

                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // First step is to identify any characters that have skill 50 or above in order to do pledges:
                var characters = context.Characters.Where(x => x.EffectiveLevel >= 45).ToList();

                foreach (var c in characters)
                {
                    var dailyPledge = new DailyPledge { Character = c };

                    // Check to see if this character has completed any pledges today:
                    var quests = context.CharacterQuests.Where(x => x.CharacterId == c.Id).ToList();

                    foreach (var q in quests)
                    {
                        if (q.Name.ToLower().Contains("pledge"))
                        {
                            // Writs reset at midnight CST.
                            if (q.Completed.AddHours(-6).Date == DateTime.UtcNow.AddHours(-6).Date)
                            {
                                if (q.Name.ToLower().Contains("veteran"))
                                {
                                    dailyPledge.VeteranPledgeCompleted = true;
                                }
                                else
                                {
                                    dailyPledge.NormalPledgeCompleted = true;
                                }
                            }
                        }
                    }

                    if (dailyPledge.NormalPledgeCompleted && dailyPledge.VeteranPledgeCompleted)
                    {
                        dailyPledge.AllPledgesCompleted = true;
                    }

                    dailyPledges.Add(dailyPledge);
                }

                return dailyPledges;
            }
        }

        public static List<DailyWrit> GetWritStatus()
        {
            using (var context = new EsoEntities())
            {
                var dailyWrits = new List<DailyWrit>();

                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // First step is to identify any characters that have skill 50 in one of the writ skill lines:
                var characters =
                    (
                        from c in context.Characters
                        join s in context.CharacterSkills on c.Id equals s.CharacterId
                        join sl in context.SkillLookups on s.SkillId equals sl.Id
                        where
                            s.Rank == 50 &&
                            (
                                sl.Name == "Alchemy" ||
                                sl.Name == "Blacksmithing" ||
                                sl.Name == "Clothing" ||
                                sl.Name == "Enchanting" ||
                                sl.Name == "Provisioning" ||
                                sl.Name == "Woodworking"
                                ) &&
                            c.EffectiveLevel >= 50
                        select new
                        {
                            Character = c
                        }
                    ).Distinct().ToList();

                // With a list of potential characters, check to see if they have completed the writ today:
                var dailyWrit = new DailyWrit();

                bool update = true;
                foreach (var c in characters)
                {
                    // Check to see if this character has completed the writs today:
                    var quests = context.CharacterQuests.Where(x => x.CharacterId == c.Character.Id).ToList();

                    // See if we have a daily writ object already for this character id:
                    if (dailyWrits.Any())
                    {
                        if (dailyWrit.Character.Id != c.Character.Id)
                        {
                            UpdateMissedWrits(dailyWrit);
                            dailyWrits.Add(dailyWrit);
                            dailyWrit = new DailyWrit { Character = c.Character };
                        }
                    }
                    else
                    {
                        if (dailyWrit.Character != null)
                        {
                            UpdateMissedWrits(dailyWrit);
                            dailyWrits.Add(dailyWrit);
                        }
                        dailyWrit = new DailyWrit { Character = c.Character };
                    }

                    foreach (var q in quests)
                    {
                        // Writs reset at midnight CST.
                        if (q.Completed.AddHours(-6).Date == DateTime.UtcNow.AddHours(-6).Date)
                        {
                            switch (q.Name)
                            {
                                case "Alchemist Writ":
                                    dailyWrit.AlchemyCompleted = true;
                                    break;
                                case "Blacksmith Writ":
                                    dailyWrit.BlacksmithingCompleted = true;
                                    break;
                                case "Clothier Writ":
                                    dailyWrit.ClothingCompleted = true;
                                    break;
                                case "Enchanter Writ":
                                    dailyWrit.EnchantingCompleted = true;
                                    break;
                                case "Provisioner Writ":
                                    dailyWrit.ProvisioningCompleted = true;
                                    break;
                                case "Woodworker Writ":
                                    dailyWrit.WoodworkingCompleted = true;
                                    break;
                            }
                        }
                    }
                }
                UpdateMissedWrits(dailyWrit);
                dailyWrits.Add(dailyWrit);
                return dailyWrits;
            }
        }

        private static void UpdateMissedPledges(DailyPledge dailyPledge)
        {
        }

        private static void UpdateMissedWrits(DailyWrit dailyWrit)
        {
            // If character has max skill in one of the writs, then set that writ to false, as opposed to null.
            // null indicates the character is not maxed in that skill, thus doesn't need to do the writ.
            var missedWrits = false;
            foreach (var skill in dailyWrit.Character.CharacterSkills)
            {
                switch (skill.SkillLookup.Name)
                {
                    case "Alchemy":
                        if (skill.Rank == 50 && dailyWrit.AlchemyCompleted == null)
                        {
                            dailyWrit.AlchemyCompleted = false;
                            missedWrits = true;
                        }
                        break;
                    case "Blacksmithing":
                        if (skill.Rank == 50 && dailyWrit.BlacksmithingCompleted == null)
                        {
                            dailyWrit.BlacksmithingCompleted = false;
                            missedWrits = true;
                        }
                        break;
                    case "Clothing":
                        if (skill.Rank == 50 && dailyWrit.ClothingCompleted == null)
                        {
                            dailyWrit.ClothingCompleted = false;
                            missedWrits = true;
                        }
                        break;
                    case "Enchanting":
                        if (skill.Rank == 50 && dailyWrit.EnchantingCompleted == null)
                        {
                            dailyWrit.EnchantingCompleted = false;
                            missedWrits = true;
                        }
                        break;
                    case "Provisioning":
                        if (skill.Rank == 50 && dailyWrit.ProvisioningCompleted == null)
                        {
                            dailyWrit.ProvisioningCompleted = false;
                            missedWrits = true;
                        }
                        break;
                    case "Woodworking":
                        if (skill.Rank == 50 && dailyWrit.WoodworkingCompleted == null)
                        {
                            dailyWrit.WoodworkingCompleted = false;
                            missedWrits = true;
                        }
                        break;
                }
            }

            dailyWrit.AllWritsCompleted = !missedWrits;
            if (dailyWrit.AllWritsCompleted)
            {
                dailyWrit.AllWritsCompletedClass = "success";
            }
            else
            {
                if (missedWrits)
                {
                    dailyWrit.AllWritsCompletedClass = "danger";
                }
            }
        }

        public static void Save(List<CharacterQuest> luaQuests)
        {
            if (luaQuests == null || !luaQuests.Any())
            {
                return;
            }

            var luaQuestsOrdered = luaQuests.OrderBy(x => x.Completed);

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // Get last saved quest for this character:
                var characterId = luaQuestsOrdered.FirstOrDefault()?.CharacterId;
                if (characterId.HasValue)
                {
                    foreach (var luaQuest in luaQuestsOrdered)
                    {
                        var dbQuests = context.CharacterQuests.Where(x => x.CharacterId == characterId);
                        if (dbQuests.Any())
                        {
                            var dbLastComplated = dbQuests.OrderByDescending(x => x.Completed).FirstOrDefault().Completed;

                            if (DateTime.Compare(luaQuest.Completed, dbLastComplated) > 0)
                            {
                                context.CharacterQuests.Add(luaQuest);
                                context.SaveChanges();
                            }
                        }
                        else
                        {
                            // None in the database, go ahead and save:
                            context.CharacterQuests.Add(luaQuest);
                            context.SaveChanges();
                        }
                    }
                }
            }
        }

        public static void Save(CharacterQuest characterQuest)
        {
            using (var context = new EsoEntities())
            {
                try
                {
                    context.Configuration.LazyLoadingEnabled = false;
                    context.Configuration.ProxyCreationEnabled = false;
                    context.CharacterQuests.Add(characterQuest);
                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.ToString());
                }
            }
        }
    }
}
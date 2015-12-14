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

        public static void GetWritStatus()
        {
            using (var context = new EsoEntities())
            {
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
                        )
                    select new
                    {
                        Character = c
                      , Skill = s
                      , SkillLookup = sl
                    }
                ).ToList();
                foreach (var c in characters)
                {
                    Console.WriteLine($"{c.Character.Name}, {c.SkillLookup.Name}, {c.Skill.Rank}");
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
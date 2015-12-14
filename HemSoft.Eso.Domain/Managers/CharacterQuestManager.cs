using System;
using System.Diagnostics;
using System.Linq;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;

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
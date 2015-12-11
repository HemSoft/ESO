using System;
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
                var s = context.CharacterQuests.Select(x => new
                {
                    Id = x.Id,
                    x.CharacterId,
                    x.CurrentExperience,
                    x.CurrentPoints,
                    x.Level,
                    x.Name,
                    x.PreviousExperience,
                    x.PreviousPoints,
                    x.Zone,
                    Character = context.Characters.Where(y => y.Id == x.Id)

                });
                return context.CharacterQuests.Include("Character").ToList();
            }
        }

        public static List<dynamic> GetSomething()
        {
            var ret = new
            {

            };
            return null;
        } 

        public static void Save(List<CharacterQuest> characterQuests)
        {
            if (characterQuests == null || !characterQuests.Any())
            {
                return;
            }

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // Get last saved quest for this character:
                var characterId = characterQuests.FirstOrDefault()?.CharacterId;
                if (characterId.HasValue)
                {
                    var charQuests = context.CharacterQuests.Where(x => x.CharacterId == characterId);
                    if (charQuests.Any())
                    {
                        var lastCompleted = charQuests.OrderByDescending(x => x.Completed).FirstOrDefault().Completed;

                        foreach (var characterQuest in characterQuests)
                        {
                            if (DateTime.Compare(lastCompleted, characterQuest.Completed) < 0)
                            {
                                context.CharacterQuests.Add(characterQuest);
                            }
                        }
                        context.SaveChanges();
                    }
                    else
                    {
                        // None in the database, go ahead and save:
                        foreach (var characterQuest in characterQuests)
                        {
                            context.CharacterQuests.Add(characterQuest);
                        }
                        context.SaveChanges();
                    }
                }
            }
        }

        public static void Save(CharacterQuest characterQuest)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                context.CharacterQuests.Add(characterQuest);
                context.SaveChanges();
            }
        }
    }
}
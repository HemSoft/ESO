using System;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;
    using System.Linq;

    public static class CharacterActivityManager
    {
        public static List<CharacterActivity> GetAllActivityByCharacterId(int characterId)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharacterActivities
                    .OrderBy(o => o.LastLogin)
                    .Where(x => x.CharacterId == characterId)
                    .ToList();
            }
        }

        public static CharacterActivity GetLastActivity(int characterId)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.CharacterActivities
                    .OrderByDescending(o => o.LastLogin)
                    .FirstOrDefault(x => x.CharacterId == characterId);
                return result ?? new CharacterActivity();
            }
        }

        public static void Save(CharacterActivity characterActivity)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var lastCharacterActivity = GetLastActivity(characterActivity.CharacterId);
                if (lastCharacterActivity == null)
                {
                    context.CharacterActivities.Add(characterActivity);
                }
                else
                {
                    if (lastCharacterActivity.LastLogin.HasValue)
                    {
                        if (DateTime.Compare(characterActivity.LastLogin.Value, lastCharacterActivity.LastLogin.Value) >
                            0)
                        {
                            context.CharacterActivities.Add(characterActivity);
                            context.SaveChanges();
                        }
                    }
                }
            }
        }
    }
}

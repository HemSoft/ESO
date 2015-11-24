namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class CharacterActivityManager
    {
        public static CharacterActivity GetLastActivity(int characterId)
        {
            using (var context = new EsoEntities())
            {
                var result = context.CharacterActivities.LastOrDefault(x => x.CharacterId == characterId);
                return result ?? new CharacterActivity();
            }
        }

        public static void Save(CharacterActivity characterActivity)
        {
            using (var context = new EsoEntities())
            {
                context.CharacterActivities.Add(characterActivity);
                context.SaveChanges();
            }
        }
    }
}

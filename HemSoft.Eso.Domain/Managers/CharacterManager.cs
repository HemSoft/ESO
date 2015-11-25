namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;
    using System.Linq;

    public static class CharacterManager
    {
        public static List<Character> GetAllByAccountId(int accountId)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.Characters.Where(x => x.AccountId == accountId).ToList();
            }
        }

        public static Character GetByName(int accountId, string name)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Characters.FirstOrDefault(x => x.Name.Contains(name) && x.AccountId == accountId);
                return result ?? new Character();
            }
        }

        public static void Save(Character character)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Characters.FirstOrDefault(x => x.Name.Contains(character.Name));
                if (result == null)
                {
                    context.Characters.Add(character);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(character);
                }
                context.SaveChanges();
            }
        }

    }
}

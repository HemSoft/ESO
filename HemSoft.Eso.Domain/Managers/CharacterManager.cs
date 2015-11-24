namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class CharacterManager
    {
        public static Character GetByName(int accountId, string name)
        {
            using (var context = new EsoEntities())
            {
                var result = context.Characters.FirstOrDefault(x => x.Name.Contains(name) && x.AccountId == accountId);
                return result ?? new Character();
            }
        }

        public static void Save(Character character)
        {
            using (var context = new EsoEntities())
            {
                var result = context.Accounts.FirstOrDefault(x => x.Name.Contains(character.Name));
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

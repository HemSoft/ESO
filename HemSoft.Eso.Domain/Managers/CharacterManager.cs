namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class CharacterManager
    {
        public static EsoCharacter GetByName(int accountId, string name)
        {
            using (var context = new EsoEntities())
            {
                var result = context.EsoCharacters.FirstOrDefault(x => x.Name.Contains(name) && x.AccountId == accountId);
                return result ?? new EsoCharacter();
            }
        }

        public static void Save(EsoCharacter esoCharacter)
        {
            using (var context = new EsoEntities())
            {
                var result = context.EsoAccounts.FirstOrDefault(x => x.Name.Contains(esoCharacter.Name));
                if (result == null)
                {
                    context.EsoCharacters.Add(esoCharacter);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(esoCharacter);
                }
                context.SaveChanges();
            }
        }

    }
}

using System.Data.Entity;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class AccountManager
    {
        public static EsoAccount GetByName(string name)
        {
            using (var context = new EsoEntities())
            {
                var result = context.EsoAccounts.FirstOrDefault(x => x.Name.Contains(name));
                return result ?? new EsoAccount();
            }
        }

        public static void Save(EsoAccount esoAccount)
        {
            using (var context = new EsoEntities())
            {
                var result = context.EsoAccounts.FirstOrDefault(x => x.Name.Contains(esoAccount.Name));
                if (result == null)
                {
                    context.EsoAccounts.Add(esoAccount);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(esoAccount);
                }
                context.SaveChanges();
            }
        }
    }
}

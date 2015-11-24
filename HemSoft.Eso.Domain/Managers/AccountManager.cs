using System.Data.Entity;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class AccountManager
    {
        public static Account GetByName(string name)
        {
            using (var context = new EsoEntities())
            {
                var result = context.Accounts.FirstOrDefault(x => x.Name.Contains(name));
                return result ?? new Account();
            }
        }

        public static void Save(Account esoAccount)
        {
            using (var context = new EsoEntities())
            {
                var result = context.Accounts.FirstOrDefault(x => x.Name.Contains(esoAccount.Name));
                if (result == null)
                {
                    context.Accounts.Add(esoAccount);
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

namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;
    using System.Linq;

    public static class AccountManager
    {
        public static List<Account> GetAll()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.Accounts.ToList();
            }
        }

        public static Account GetByName(string name)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Accounts.FirstOrDefault(x => x.Name.Contains(name));
                return result ?? new Account();
            }
        }

        public static void Save(Account account)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Accounts.FirstOrDefault(x => x.Name.Contains(account.Name));
                if (result == null)
                {
                    context.Accounts.Add(account);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(account);
                }
                context.SaveChanges();
            }
        }
    }
}

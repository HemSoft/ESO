using System.Collections.Generic;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Linq;

    public static class TitleManager
    {
        public static int GetTitleId(string name)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.TitleLookups.Where(x => x.Name == name).Select(x => x.Id).FirstOrDefault();
            }
        }

        public static int Save(TitleLookup titleLookup)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.TitleLookups.FirstOrDefault(x => x.Name.Contains(titleLookup.Name));
                if (result == null)
                {
                    context.TitleLookups.Add(titleLookup);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(titleLookup);
                }
                context.SaveChanges();
                return titleLookup.Id;
            }
        }

        public static void Save(IEnumerable<string> titleList)
        {
            foreach (var title in titleList)
            {
                var id = TitleManager.GetTitleId(title);
                if (id == 0)
                {
                    var newTitleLookup = new TitleLookup { Name = title };
                    TitleManager.Save(newTitleLookup);
                }
            }
        }
    }
}

namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;
    using System.Linq;

    public static class SkillManager
    {
        public static int GetSkillId(string name)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.SkillLookups.Where(x => x.Name == name).Select(x => x.Id).FirstOrDefault();
            }
        }

        public static int Save(SkillLookup skillLookup)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.SkillLookups.FirstOrDefault(x => x.Name.Contains(skillLookup.Name));
                if (result == null)
                {
                    context.SkillLookups.Add(skillLookup);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(skillLookup);
                }
                context.SaveChanges();
                return skillLookup.Id;
            }
        }
    }
}

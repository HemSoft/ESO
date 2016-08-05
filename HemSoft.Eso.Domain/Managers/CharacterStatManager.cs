namespace HemSoft.Eso.Domain.Managers
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;


    public static class CharacterStatManager
    {
        public static List<CharacterStat> GetAll()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharacterStats.Include("Character").ToList();
            }
        }

        public static int Save(CharacterStat characterStat)
        {
            if (characterStat == null)
            {
                return -1;
            }

            using (var context = new EsoEntities())
            {
                try
                {
                    context.Configuration.LazyLoadingEnabled = false;
                    context.Configuration.ProxyCreationEnabled = false;

                    var result = context.CharacterStats.FirstOrDefault(x => x.CharacterId == characterStat.CharacterId);
                    if (result == null)
                    {
                        context.CharacterStats.Add(characterStat);
                    }
                    else
                    {
                        context.Entry(result).CurrentValues.SetValues(characterStat);
                    }
                    context.SaveChanges();
                    return characterStat.Id;
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.ToString());
                    return -1;
                }
            }
        }
    }
}
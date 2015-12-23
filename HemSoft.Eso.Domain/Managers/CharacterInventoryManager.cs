namespace HemSoft.Eso.Domain.Managers
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;


    public static class CharacterInventoryManager
    {
        public static string GetTraitTypeName(int traitTypeId)
        {
            return Enum.GetName(typeof(TraitType), traitTypeId);
        }

        public static List<CharacterInventory> GetAll()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharacterInventories.Include("Character").ToList();
            }
        }

        public static void Save(List<CharacterInventory> inventories)
        {
            if (inventories == null || !inventories.Any())
            {
                return;
            }

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // Get last saved quest for this character:
                foreach (var inv in inventories)
                {
                    var dbInventory = context.CharacterInventories
                        .FirstOrDefault(x => x.InstanceId == inv.InstanceId && x.CharacterId == inv.CharacterId);
                    if (dbInventory != null)
                    {
                        inv.Id = dbInventory.Id;
                        context.Entry(dbInventory).CurrentValues.SetValues(inv);
                        context.SaveChanges();
                    }
                    else
                    {
                        // None in the database, go ahead and add:
                        context.CharacterInventories.Add(inv);
                        context.SaveChanges();
                    }
                }
            }
        }

        public static void Save(CharacterQuest characterQuest)
        {
            using (var context = new EsoEntities())
            {
                try
                {
                    context.Configuration.LazyLoadingEnabled = false;
                    context.Configuration.ProxyCreationEnabled = false;
                    context.CharacterQuests.Add(characterQuest);
                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.ToString());
                }
            }
        }
    }
}
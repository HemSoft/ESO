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

                var characterId = inventories[0].CharacterId;

                // We need to clear the inventory before we proceed:
                foreach (var source in context.CharacterInventories.Where(x => x.CharacterId == characterId))
                {
                    context.CharacterInventories.Remove(source);
                }
                context.SaveChanges();

                foreach (var inv in inventories)
                {
                    // TODO: Normalize inv.Name
                    context.CharacterInventories.Add(inv);
                    context.SaveChanges();
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
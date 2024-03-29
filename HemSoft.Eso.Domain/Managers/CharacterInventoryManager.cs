﻿using System.Globalization;
using System.Text.RegularExpressions;
using System.Threading;

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

        public static List<GetAllInventory_Result> GetAllInventory()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.GetAllInventory(string.Empty).ToList();
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
                context.CharacterInventories.RemoveRange
                (
                    context.CharacterInventories.Where(x => x.CharacterId == characterId)
                );
                context.SaveChanges();

                foreach (var inv in inventories)
                {
                    // TODO: Normalize inv.Name
                    if (inv.InstanceId > 0)
                    {
                        var cultureInfo = Thread.CurrentThread.CurrentCulture;
                        var textInfo = cultureInfo.TextInfo;
                        var inventoryName = textInfo.ToTitleCase(inv.Name);

                        inventoryName = inventoryName.Replace("^N", string.Empty);
                        inventoryName = inventoryName.Replace("^P", string.Empty);
                        inventoryName = inventoryName.Replace("^NS", string.Empty);
                        inventoryName = inventoryName.Replace("^NP", string.Empty);

                        inv.Name = inventoryName;

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
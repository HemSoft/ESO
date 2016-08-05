using System;
using System.Security.Cryptography.X509Certificates;

namespace HemSoft.Eso.Domain.Managers
{
    using System.Collections.Generic;
    using System.Linq;

    public static class CharacterManager
    {
        public static List<Character> GetAllByAccountId(int accountId)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.Characters.Where(x => x.AccountId == accountId).ToList();
            }
        }

        public static List<Character> GetAllWithQuests()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.Characters.Include("CharacterQuests").ToList();
            }
        }

        public static Character GetByName(int accountId, string name)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Characters.FirstOrDefault(x => x.Name.Contains(name) && x.AccountId == accountId);
                return result ?? new Character();
            }
        }

        public static List<CharactersNeedingAttention_Result> GetCharactersNeedingAttention()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharactersNeedingAttention().ToList();
            }
        }

        public static List<Character> GetCharacterQuests(int characterId)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.Characters.Include("CharacterQuests").Where(x => x.Id == characterId).ToList();
            }
        }

        public static List<CharacterResearch_Result> GetCharacterResearch()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.CharacterResearch().ToList();
            }
        }

        public static List<GetCharacterSkills_Result> GetCharacterSkills()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.GetCharacterSkills().ToList();
            }
        }

        public static NextUpInResearch_Result GetNextUpInResearch()
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                return context.NextUpInResearch().FirstOrDefault();
            }
        }

        public static void Save(Character character)
        {
            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;
                var result = context.Characters.FirstOrDefault(x => x.Name.Contains(character.Name));
                if (result == null)
                {
                    context.Characters.Add(character);
                }
                else
                {
                    context.Entry(result).CurrentValues.SetValues(character);
                }
                context.SaveChanges();
            }
        }

        public static void SaveAchievements(List<AchievementCategory> achievementCategories)
        {
            if (achievementCategories == null || !achievementCategories.Any())
            {
                return;
            }

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                // Loop through top level AchievementCategory:
                foreach (var achievementCategory in achievementCategories.ToList())
                {
                    // Does an achievement category already exist for the character:
                    var characterId = achievementCategory.CharacterId;
                    var result = context.AchievementCategories.FirstOrDefault(x => x.CharacterId == characterId && achievementCategory.Name == x.Name);
                    if (result == null)
                    {
                        // Does not already exist, so insert it:
                        var asc = achievementCategory.AchievementSubCategories;
                        achievementCategory.AchievementSubCategories = null;
                        context.AchievementCategories.Add(achievementCategory);
                        try
                        {
                            context.SaveChanges();
                        }
                        catch (Exception)
                        {
                        }
                        achievementCategory.AchievementSubCategories = asc;
                    }
                    else
                    {
                        achievementCategory.Id = result.Id;
                        context.Entry(result).CurrentValues.SetValues(achievementCategory);
                        context.SaveChanges();
                    }

                    foreach (var achievementSubCategory in achievementCategory.AchievementSubCategories.ToList())
                    {
                        var result2 = context.AchievementSubCategories.FirstOrDefault(x => x.AchievementCategoryId == achievementCategory.Id && x.Name == achievementSubCategory.Name);
                        if (result2 == null)
                        {
                            // Does not already exist, so insert it:
                            var ac = achievementSubCategory.AchievementCategory;
                            achievementSubCategory.AchievementCategory = null;
                            var ais = achievementSubCategory.AchievementInfoes;
                            achievementSubCategory.AchievementInfoes = null;
                            achievementSubCategory.AchievementCategoryId = achievementCategory.Id;
                            context.AchievementSubCategories.Add(achievementSubCategory);
                            try
                            {
                                context.SaveChanges();
                            }
                            catch (Exception ex)
                            {
                                if (ex.GetType() == typeof (DuplicateWaitObjectException))
                                {
                                    
                                }
                            }
                            achievementSubCategory.AchievementCategory = ac;
                            achievementSubCategory.AchievementInfoes = ais;
                        }
                        else
                        {
                            achievementSubCategory.Id = result2.Id;
                            context.Entry(result2).CurrentValues.SetValues(achievementSubCategory);
                            context.SaveChanges();
                        }

                        foreach (var achievementInfo in achievementSubCategory.AchievementInfoes.ToList())
                        {
                            var result3 = context.AchievementInfoes.FirstOrDefault(x => x.AchievementSubCategoryId == achievementSubCategory.Id && x.Name == achievementInfo.Name);
                            if (result3 == null)
                            {
                                var acs = achievementInfo.AchievementCriterias;
                                achievementInfo.AchievementCriterias = null;
                                var asc = achievementInfo.AchievementSubCategory;
                                if (achievementInfo.AchievementSubCategory != null)
                                {
                                    achievementInfo.AchievementSubCategoryId = achievementInfo.AchievementSubCategory.Id;
                                }
                                achievementInfo.AchievementSubCategory = null;
                                context.AchievementInfoes.Add(achievementInfo);
                                try
                                {
                                    context.SaveChanges();
                                }
                                catch (Exception ex)
                                {
                                }
                                achievementInfo.AchievementCriterias = acs;
                                achievementInfo.AchievementSubCategory = asc;
                            }
                            else
                            {
                                if (achievementInfo.Id == 0)
                                {
                                    achievementInfo.Id = result3.Id;
                                }
                                context.Entry(result3).CurrentValues.SetValues(achievementInfo);
                                context.SaveChanges();
                            }

                            foreach (var criteria in achievementInfo.AchievementCriterias.ToList())
                            {
                                var result4 = context.AchievementCriterias.FirstOrDefault(x => x.AchievementInfoId == achievementInfo.Id && x.Description == criteria.Description);
                                if (result4 == null)
                                {
                                    //var x = criteria.AchievementInfo;
                                    if (criteria.AchievementInfo != null)
                                    {
                                        criteria.AchievementInfoId = criteria.AchievementInfo.Id;
                                    }
                                    //criteria.AchievementInfo = null;
                                    context.AchievementCriterias.Add(criteria);
                                    try
                                    {
                                        context.SaveChanges();
                                    }
                                    catch (Exception)
                                    {
                                    }
                                    //criteria.AchievementInfo = x;
                                }
                                else
                                {
                                    criteria.Id = result4.Id;
                                    context.Entry(result4).CurrentValues.SetValues(criteria);
                                    try
                                    {
                                        context.SaveChanges();
                                    }
                                    catch (Exception)
                                    {
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public static void SaveSkills(List<CharacterSkill> skills, int characterId)
        {
            if (skills == null || !skills.Any())
            {
                return;
            }

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                foreach (var skill in skills)
                {
                    skill.CharacterId = characterId;

                    var result = context.CharacterSkills.FirstOrDefault(x => x.SkillId == skill.SkillId && x.CharacterId == skill.CharacterId);
                    if (result == null)
                    {
                        context.CharacterSkills.Add(skill);
                    }
                    else
                    {
                        skill.Id = result.Id;
                        context.Entry(result).CurrentValues.SetValues(skill);
                    }
                    context.SaveChanges();
                }
            }
        }

        public static void SaveTitles(List<string> titles, int characterId)
        {
            if (titles == null || !titles.Any())
            {
                return;
            }

            using (var context = new EsoEntities())
            {
                context.Configuration.LazyLoadingEnabled = false;
                context.Configuration.ProxyCreationEnabled = false;

                foreach (var title in titles)
                {
                    // First step, see if this title is in the title lookup:
                    var match = context.TitleLookups.FirstOrDefault(x => x.Name == title) ??
                                context.TitleLookups.Add(new TitleLookup { Name = title });
                    context.SaveChanges();

                    var result = context.CharacterTitles.FirstOrDefault(x => x.TitleId == match.Id && x.CharacterId == characterId);
                    if (result == null)
                    {
                        var newCharacterTitle = new CharacterTitle
                        {
                            Achieved = DateTime.UtcNow,
                            TitleId = match.Id,
                            CharacterId = characterId
                        };
                        context.CharacterTitles.Add(newCharacterTitle);
                        context.SaveChanges();
                    }
                }
            }
        }

    }
}

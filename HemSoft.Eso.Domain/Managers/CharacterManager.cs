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
                    var t = new CharacterTitle();
                    t.CharacterId = characterId;

                    var result = context.CharacterTitles.FirstOrDefault(x => x.TitleId == t.TitleId && x.CharacterId == t.CharacterId);
                    if (result == null)
                    {
                        context.CharacterTitles.Add(t);
                    }
                    else
                    {
                        t.Id = result.Id;
                        context.Entry(result).CurrentValues.SetValues(title);
                    }
                    context.SaveChanges();
                }
            }
        }

    }
}

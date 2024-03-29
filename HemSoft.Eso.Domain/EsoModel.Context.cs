﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HemSoft.Eso.Domain
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class EsoEntities : DbContext
    {
        public EsoEntities()
            : base("name=EsoEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Account> Accounts { get; set; }
        public virtual DbSet<AllianceLookup> AllianceLookups { get; set; }
        public virtual DbSet<Character> Characters { get; set; }
        public virtual DbSet<CharacterActivity> CharacterActivities { get; set; }
        public virtual DbSet<ClassLookup> ClassLookups { get; set; }
        public virtual DbSet<RaceLookup> RaceLookups { get; set; }
        public virtual DbSet<CharacterSkill> CharacterSkills { get; set; }
        public virtual DbSet<SkillLookup> SkillLookups { get; set; }
        public virtual DbSet<CharacterQuest> CharacterQuests { get; set; }
        public virtual DbSet<CharacterInventory> CharacterInventories { get; set; }
        public virtual DbSet<CharacterTitle> CharacterTitles { get; set; }
        public virtual DbSet<TitleLookup> TitleLookups { get; set; }
        public virtual DbSet<ArmorTypeLookup> ArmorTypeLookups { get; set; }
        public virtual DbSet<EquipTypeLookup> EquipTypeLookups { get; set; }
        public virtual DbSet<ItemTraitTypeLookup> ItemTraitTypeLookups { get; set; }
        public virtual DbSet<ItemTypeLookup> ItemTypeLookups { get; set; }
        public virtual DbSet<AccountGuild> AccountGuilds { get; set; }
        public virtual DbSet<CharacterStat> CharacterStats { get; set; }
        public virtual DbSet<AchievementCategory> AchievementCategories { get; set; }
        public virtual DbSet<AchievementCriteria> AchievementCriterias { get; set; }
        public virtual DbSet<AchievementInfo> AchievementInfoes { get; set; }
        public virtual DbSet<AchievementSubCategory> AchievementSubCategories { get; set; }
    
        public virtual ObjectResult<CharactersNeedingAttention_Result> CharactersNeedingAttention()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CharactersNeedingAttention_Result>("CharactersNeedingAttention");
        }
    
        public virtual ObjectResult<CharactersNeedingAttentionWithinHours_Result> CharactersNeedingAttentionWithinHours(Nullable<int> hours)
        {
            var hoursParameter = hours.HasValue ?
                new ObjectParameter("hours", hours) :
                new ObjectParameter("hours", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CharactersNeedingAttentionWithinHours_Result>("CharactersNeedingAttentionWithinHours", hoursParameter);
        }
    
        public virtual ObjectResult<GetLastCharacterActivity_Result> GetLastCharacterActivity()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetLastCharacterActivity_Result>("GetLastCharacterActivity");
        }
    
        public virtual ObjectResult<CharacterResearch_Result> CharacterResearch()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CharacterResearch_Result>("CharacterResearch");
        }
    
        public virtual ObjectResult<NextUpInResearch_Result> NextUpInResearch()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<NextUpInResearch_Result>("NextUpInResearch");
        }
    
        public virtual ObjectResult<GetAccounts_Result> GetAccounts()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetAccounts_Result>("GetAccounts");
        }
    
        public virtual ObjectResult<GetCharacterSkills_Result> GetCharacterSkills()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetCharacterSkills_Result>("GetCharacterSkills");
        }
    
        public virtual ObjectResult<GetAllInventory_Result> GetAllInventory(string inventoryName)
        {
            var inventoryNameParameter = inventoryName != null ?
                new ObjectParameter("InventoryName", inventoryName) :
                new ObjectParameter("InventoryName", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetAllInventory_Result>("GetAllInventory", inventoryNameParameter);
        }
    }
}

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
    }
}

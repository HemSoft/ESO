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
    }
}

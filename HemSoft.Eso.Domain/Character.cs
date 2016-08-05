//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class Character
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Character()
        {
            this.CharacterActivities = new HashSet<CharacterActivity>();
            this.CharacterSkills = new HashSet<CharacterSkill>();
            this.CharacterQuests = new HashSet<CharacterQuest>();
            this.CharacterInventories = new HashSet<CharacterInventory>();
            this.CharacterTitles = new HashSet<CharacterTitle>();
            this.CharacterStats = new HashSet<CharacterStat>();
            this.AchievementCategories = new HashSet<AchievementCategory>();
        }
    
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int AccountId { get; set; }
        public Nullable<int> ClassId { get; set; }
        public Nullable<int> RaceId { get; set; }
        public Nullable<int> AllianceId { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
        public Nullable<int> EnlightenedPool { get; set; }
        public Nullable<int> EffectiveLevel { get; set; }
        public Nullable<int> ChampionPointsEarned { get; set; }
        public Nullable<int> AchievementPoints { get; set; }
        public Nullable<int> HoursPlayed { get; set; }
        public Nullable<int> BankedTelvarStones { get; set; }
        public Nullable<int> AlliancePoints { get; set; }
        public string FullImage { get; set; }
        public string FaceImage { get; set; }
        public string BuildImage { get; set; }
        public string Title { get; set; }
    
        public virtual Account Account { get; set; }
        public virtual AllianceLookup AllianceLookup { get; set; }
        public virtual ClassLookup ClassLookup { get; set; }
        public virtual RaceLookup RaceLookup { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterActivity> CharacterActivities { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterSkill> CharacterSkills { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterQuest> CharacterQuests { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterInventory> CharacterInventories { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterTitle> CharacterTitles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterStat> CharacterStats { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AchievementCategory> AchievementCategories { get; set; }
    }
}

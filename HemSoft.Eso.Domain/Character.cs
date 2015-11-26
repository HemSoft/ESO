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
        }
    
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int AccountId { get; set; }
        public int ClassId { get; set; }
        public int RaceId { get; set; }
        public int AllianceId { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
    
        public virtual Account Account { get; set; }
        public virtual AllianceLookup AllianceLookup { get; set; }
        public virtual ClassLookup ClassLookup { get; set; }
        public virtual RaceLookup RaceLookup { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CharacterActivity> CharacterActivities { get; set; }
    }
}

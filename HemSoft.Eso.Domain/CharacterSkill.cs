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
    
    public partial class CharacterSkill
    {
        public int Id { get; set; }
        public int CharacterId { get; set; }
        public int SkillId { get; set; }
        public int XP { get; set; }
        public int Rank { get; set; }
        public int NextRankXP { get; set; }
        public int LastRankXP { get; set; }
    
        public virtual Character Character { get; set; }
        public virtual SkillLookup SkillLookup { get; set; }
    }
}

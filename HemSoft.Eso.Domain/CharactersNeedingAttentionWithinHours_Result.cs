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
    
    public partial class CharactersNeedingAttentionWithinHours_Result
    {
        public int CharacterId { get; set; }
        public string CharacterName { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
        public string HourseFeedingStatus { get; set; }
        public string BlacksmithingStatus { get; set; }
        public string ClothingStatus { get; set; }
        public string WoodworkingStatus { get; set; }
    }
}

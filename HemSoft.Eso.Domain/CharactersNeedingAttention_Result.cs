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
    
    public partial class CharactersNeedingAttention_Result
    {
        public int CharacterId { get; set; }
        public string CharacterName { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
        public Nullable<System.DateTime> BlacksmithingStatus { get; set; }
        public Nullable<System.DateTime> ClothingStatus { get; set; }
        public Nullable<System.DateTime> WoodworkingStatus { get; set; }
        public Nullable<System.DateTime> HorseFeedingStatus { get; set; }
    }
}

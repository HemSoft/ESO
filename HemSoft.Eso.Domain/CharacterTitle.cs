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
    
    public partial class CharacterTitle
    {
        public int Id { get; set; }
        public int CharacterId { get; set; }
        public int TitleId { get; set; }
        public System.DateTime Achieved { get; set; }
    
        public virtual Character Character { get; set; }
        public virtual TitleLookup TitleLookup { get; set; }
    }
}

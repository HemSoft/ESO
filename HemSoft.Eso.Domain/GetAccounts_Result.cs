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
    
    public partial class GetAccounts_Result
    {
        public int AccountId { get; set; }
        public string AccountName { get; set; }
        public string AccountPassword { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
        public string Description { get; set; }
        public string CharacterName { get; set; }
        public Nullable<int> EnlightenedPool { get; set; }
    }
}
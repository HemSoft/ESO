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
    
    public partial class CharacterActivity
    {
        public int Id { get; set; }
        public int CharacterId { get; set; }
        public Nullable<int> AlliancePoints { get; set; }
        public Nullable<int> BankedCash { get; set; }
        public Nullable<int> BankedTelvarStones { get; set; }
        public Nullable<int> Cash { get; set; }
        public Nullable<int> ChampionPointsEarned { get; set; }
        public Nullable<int> GuildCount { get; set; }
        public Nullable<System.DateTime> LastLogin { get; set; }
        public Nullable<int> MailCount { get; set; }
        public Nullable<int> MailMax { get; set; }
        public Nullable<int> MaxBagSize { get; set; }
        public Nullable<int> MaxBankSize { get; set; }
        public Nullable<int> NumberOfFriends { get; set; }
        public Nullable<long> SecondsPlayed { get; set; }
        public Nullable<int> UsedBagSlots { get; set; }
        public Nullable<int> UsedBankSlots { get; set; }
        public Nullable<int> BlacksmithingSecondsMaximumLeft { get; set; }
        public Nullable<int> BlacksmithingSecondsMaximumTotal { get; set; }
        public Nullable<int> BlacksmithingSecondsMinimumLeft { get; set; }
        public Nullable<int> BlacksmithingSecondsMinimumTotal { get; set; }
        public Nullable<int> BlacksmithingSlotsFree { get; set; }
        public Nullable<int> BlacksmithingSlotsMax { get; set; }
        public Nullable<int> ClothingSecondsMaximumLeft { get; set; }
        public Nullable<int> ClothingSecondsMaximumTotal { get; set; }
        public Nullable<int> ClothingSecondsMinimumLeft { get; set; }
        public Nullable<int> ClothingSecondsMinimumTotal { get; set; }
        public Nullable<int> ClothingSlotsFree { get; set; }
        public Nullable<int> ClothingSlotsMax { get; set; }
        public Nullable<int> WoodworkingSecondsMaximumLeft { get; set; }
        public Nullable<int> WoodworkingSecondsMaximumTotal { get; set; }
        public Nullable<int> WoodworkingSecondsMinimumLeft { get; set; }
        public Nullable<int> WoodworkingSecondsMinimumTotal { get; set; }
        public Nullable<int> WoodworkingSlotsFree { get; set; }
        public Nullable<int> WoodworkingSlotsMax { get; set; }
        public Nullable<int> AvailableSkillPoints { get; set; }
        public Nullable<int> Skyshards { get; set; }
        public Nullable<int> MountCapacity { get; set; }
        public Nullable<int> MountStamina { get; set; }
        public Nullable<int> MountSpeed { get; set; }
        public Nullable<long> SecondsUntilMountTraining { get; set; }
        public Nullable<int> EnlightenedPool { get; set; }
        public Nullable<int> EffictiveLevel { get; set; }
        public Nullable<int> Level { get; set; }
        public string Zone { get; set; }
        public Nullable<bool> IsVeteran { get; set; }
        public Nullable<int> VeteranRank { get; set; }
        public Nullable<int> VP { get; set; }
        public Nullable<int> VPMax { get; set; }
        public Nullable<int> XP { get; set; }
        public Nullable<int> XPMax { get; set; }
    
        public virtual Character Character { get; set; }
    }
}

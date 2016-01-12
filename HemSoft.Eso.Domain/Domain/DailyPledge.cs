namespace HemSoft.Eso.Domain
{
    public class DailyPledge
    {
        public Character Character { get; set; }
        public bool AllPledgesCompleted { get; set; }
        public bool NormalPledgeCompleted { get; set; }
        public bool VeteranPledgeCompleted { get; set; }
    }
}
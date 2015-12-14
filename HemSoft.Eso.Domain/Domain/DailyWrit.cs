namespace HemSoft.Eso.Domain
{
    public class DailyWrit
    {
        public Character Character { get; set; }
        public bool AllWritsCompleted { get; set; }
        public string AllWritsCompletedClass { get; set; }
        public bool? AlchemyCompleted { get; set; }
        public bool? BlacksmithingCompleted { get; set; }
        public bool? ClothingCompleted { get; set; }
        public bool? EnchantingCompleted { get; set; }
        public bool? ProvisioningCompleted { get; set; }
        public bool? WoodworkingCompleted { get; set; }
    }
}
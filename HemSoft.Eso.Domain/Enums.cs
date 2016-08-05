using System.ComponentModel;

namespace HemSoft.Eso.Domain
{
    public enum QuestType
    {
        QuestTypeNone = 0,
        QuestTypeGroup = 1,
        QuestTypeMainStory = 2,
        QuestTypeGuild = 3,
        QuestTypeCrafting = 4,
        QuestTypeDungeon = 5,
        QuestTypeRaid = 6,
        QuestTypeAva = 7,
        QuestTypeClass = 8,
        QuestTypeQaTest = 9,
        QuestTypeAvaGroup = 10,
        QuestTypeAvaGrand = 11
    }

    public enum TraitType
    {
        [Description("Armor Divine")]
        ArmorDivine = 18,
        ArmorExploration = 17,
        ArmorImpenetrable = 12,
        ArmorInfused = 16,
        ArmorIntricate = 20,
        ArmorNirnhoned = 25,
        ArmorOrnate = 19,
        ArmorReinforced = 13,
        ArmorSturdy = 11,
        ArmorTraining = 15,
        ArmorWellFitted = 14,
        JewelryArcane = 22,
        JewelryHealthy = 21,
        JewelryOrnate = 24,
        JewelryRobust = 23,
        None = 0,
        SpecialStat = 27,
        WeaponCharged = 2,
        WeaponDefending = 5,
        WeaponInfused = 4,
        WeaponIntricate = 9,
        WeaponNirnhoned = 26,
        WeaponOrnate = 10,
        WeaponPowered = 1,
        WeaponPrecise = 3,
        WeaponSharpened = 7,
        WeaponTraining = 6,
        WeaponWeighted = 8
    }
}

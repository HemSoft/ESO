module App.Domain {

    export interface ICharacter {

        Id: number,
        Name: string,
        Description: string,
        AccountId: number,
        ClassId: number,
        RaceId: number,
        AllianceId: number,
        LastLogin: Date,
        EnlightenedPool: number,
        EffectiveLevel: number,
        ChampionPointsEarned: number,
        AchievementPoints: number,
        HoursPlayed: number,
        BankedTelvarStones: number,
        AlliancePoints: number,
        Account: App.Domain.IAccount,

    }

    export class Character implements ICharacter {

        constructor(public Id: number,
                    public Name: string,
                    public Description: string,
                    public AccountId: number,
                    public ClassId: number,
                    public RaceId: number,
                    public AllianceId: number,
                    public LastLogin: Date,
                    public EnlightenedPool: number,
                    public EffectiveLevel: number,
                    public ChampionPointsEarned: number,
                    public AchievementPoints: number,
                    public HoursPlayed: number,
                    public BankedTelvarStones: number,
                    public AlliancePoints: number,
                    public Account: App.Domain.IAccount) {
        }

    }

}
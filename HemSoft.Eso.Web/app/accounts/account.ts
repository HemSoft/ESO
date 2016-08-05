module App.Domain {
    export interface IAccount {
        Id: number;
        Name: string;
        Password: string;
        LastLogin: Date;
        Description: string;
        EnlightenedPool: number;
        ChampionPointsEarned: number;
        HoursePlayed: number;
        BankedTelvarStones: number;
        Characters: any[];
    }

    export class Account implements IAccount {
        constructor(public Id: number,
                    public Name: string,
                    public Password: string,
                    public LastLogin: Date,
                    public Description: string,
                    public EnlightenedPool: number,
                    public ChampionPointsEarned: number,
                    public HoursePlayed: number,
                    public BankedTelvarStones: number,
                    public Characters: any[]) {
        }
    }
}
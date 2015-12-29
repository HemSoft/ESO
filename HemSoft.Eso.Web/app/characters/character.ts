module App.Domain {

    export interface ICharacter {

        id: number,
        name: string,
        description: string,
        accountId: number,
        classId: number,
        raceId: number,
        allianceId: number,
        lastLogin: Date,
        enlightenedPool: number,
        effectiveLevel: number,
        championPointsEarned: number,
        achievementPoints: number,
        hoursPlayed: number,
        bankedTelvarStones: number,
        alliancePoints: number,
        account: App.Domain.IAccount,

    }

    export class Character implements ICharacter {

        constructor(public id: number,
                    public name: string,
                    public description: string,
                    public accountId: number,
                    public classId: number,
                    public raceId: number,
                    public allianceId: number,
                    public lastLogin: Date,
                    public enlightenedPool: number,
                    public effectiveLevel: number,
                    public championPointsEarned: number,
                    public achievementPoints: number,
                    public hoursPlayed: number,
                    public bankedTelvarStones: number,
                    public alliancePoints: number,
                    public account: App.Domain.IAccount) {
        }

    }

}
module App.Domain {

    export interface IAccount {
        id: number;
        name: string;
        password: string;
        lastLogin: Date;
        description: string;
        enlightenedPool: number;
        championPointsEarned: number;
        hoursePlayed: number;
        bankedTelvarStones: number;
        characters: any[];
    }

    export class Account implements IAccount {

        constructor(public id: number,
                    public name: string,
                    public password: string,
                    public lastLogin: Date,
                    public description: string,
                    public enlightenedPool: number,
                    public championPointsEarned: number,
                    public hoursePlayed: number,
                    public bankedTelvarStones: number,
                    public characters: any[]) {
        }

    }

}
module App.Domain {

    export class Account {
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

}
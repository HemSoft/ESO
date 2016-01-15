module App.Common {
    import Account = Domain.Account;
    import Character = Domain.Character;

    export interface IDataAccessService {
        serverPath: string;

        getAccountResource(): ng.resource.IResourceClass<IAccountResource>;
    }

    export interface IAccountResource extends ng.resource.IResource<Account> {}
    export interface ICharacterResource extends ng.resource.IResource<Character> {}

    export class DataAccessService implements IDataAccessService {
        serverPath: string;
        selectedAccount: App.Domain.IAccount;
        selectedCharacter: App.Domain.ICharacter;

        static $inject = ["$resource", "appSettings"];
        constructor(private $resource: ng.resource.IResourceService, private appSettings) {
            this.serverPath = appSettings.serverPath;
        }

        getAccountResource(): ng.resource.IResourceClass<IAccountResource> {
            return this.$resource(this.serverPath + "/api/Accounts/:Id");
        }

        getAllInventory(): ng.resource.IResourceClass<IAccountResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetAllInventory");
        }

        getCharacterActivityByCharacterId(characterId: number): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + `/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId=${characterId}`);
        }

        getCharacterQuests(characterId: number): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetCharacterQuests?characterId=" + characterId);
        }

        getCharacterResource(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/:Id");
        }

        getCharacters(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/characters/GetCharacters");
        }

        getCharacterSkills(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetCharacterSkills");
        }

        getCharactersByAccountId(accountId: number): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + `/api/Characters/GetCharactersByAccountId?accountId=${accountId}`);
        }

        getCharactersNeedingAttention(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetCharactersNeedingAttention");
        }

        getCharactersResearching(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetCharacterResearch");
        }

        getLastCharacterActivity(characterId: number): any {
            return this.$resource(this.serverPath + "/api/CharacterActivities/GetLastCharacterActivity?characterId=" + characterId);
        }

        getPledgeStatus(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetPledgeStatus");
        }

        getWritStatus(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetWritStatus");
        }

        getWrothgarStatus(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetOrsiniumStatus");
        }
    }

    angular.module("common.services")
        .service("dataAccessService", DataAccessService);
}
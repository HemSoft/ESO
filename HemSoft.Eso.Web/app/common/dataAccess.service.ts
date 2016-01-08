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

        getCharacterActivityByCharacterId(characterId: number): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + `/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId=${characterId}`);
        }

        getCharacterQuests(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/GetCharacterQuests");
        }

        getCharacterResource(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/:Id");
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

    }

    angular.module("common.services")
        .service("dataAccessService", DataAccessService);
}
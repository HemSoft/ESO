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

        static $inject = ["$resource", "appSettings"];
        constructor(private $resource: ng.resource.IResourceService,
                    private appSettings) {
            this.serverPath = appSettings.serverPath;
        }

        getAccountResource(): ng.resource.IResourceClass<IAccountResource> {
            return this.$resource(this.serverPath + "/api/Accounts/:Id");
        }

        getCharacterResource(): ng.resource.IResourceClass<ICharacterResource> {
            return this.$resource(this.serverPath + "/api/Characters/:Id");
        }

    }

    angular.module("common.services")
        .service("dataAccessService", DataAccessService);
}
module App.Common {
    import Account = Domain.Account;

    export interface IDataAccessService {
        getAccountResource(): ng.resource.IResourceClass<IAccountResource>;
    }

    export interface IAccountResource extends ng.resource.IResource<Account> {
    }

    export class DataAccessService implements IDataAccessService {
        static $inject = ["$resource"];
        constructor(private $resource: ng.resource.IResourceService) {
        }

        getAccountResource(): ng.resource.IResourceClass<IAccountResource> {
            return this.$resource("/api/Account/:Id");
        }
    }

    angular.module("common.services")
        .service("dataAccessService", DataAccessService);
}
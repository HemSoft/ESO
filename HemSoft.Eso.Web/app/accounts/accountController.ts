module App.AccountController {

    interface IAccountViewModel {
        title: string;
        accounts: App.Domain.Account[];
        selectedAccount: App.Domain.IAccount;
        selectAccount: Function;
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;
    }

    class AccountController implements IAccountViewModel {
        vmac: AccountController;
        title: string;
        accounts: App.Domain.IAccount[];
        selectedAccount: App.Domain.IAccount;
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;

        static $inject = ["dataAccessService", "$rootScope"];
        constructor(private dataService: App.Common.DataAccessService, private $rootscope: ng.IScope) {
            this.title = "Accounts";
            this.dataAccessService = dataService;
            this.rootScope = $rootscope;

            var accountResource = dataService.getAccountResource();
            accountResource.query((data: App.Domain.IAccount[]) => {
                this.accounts = data;
            });
        }

        selectAccount(account) {
            this.selectedAccount = account;
            this.dataAccessService.selectedAccount = account;
            this.rootScope.$broadcast("accountSelected");
        }
    }

    angular.module("app").controller("accountController", AccountController);

}
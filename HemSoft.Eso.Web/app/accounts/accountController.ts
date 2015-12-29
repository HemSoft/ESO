module App.AccountController {

    interface IAccountViewModel {
        title: string;
        accounts: App.Domain.Account[];
        selectedAccount: App.Domain.Account;
        selectAccount: Function;
    }

    class AccountController implements IAccountViewModel {
        title: string;
        accounts: App.Domain.Account[];
        selectedAccount: App.Domain.Account;

        static $inject = ["dataAccessService"];
        constructor(private dataAccessService: App.Common.DataAccessService) {
            this.title = "Accounts";

            var accountResource = dataAccessService.getAccountResource();
            accountResource.query((data: App.Domain.IAccount[]) => {
                this.accounts = data;
            });

        }

        selectAccount(account) {
            this.selectedAccount = account;
        }
    }

    angular.module("app").controller("accountController", AccountController);

}
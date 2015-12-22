module App.AccountController {

    export interface IAccountViewModel {
        title: string;
        accounts: App.Domain.Account[];
        selectedAccount: App.Domain.Account;
        selectAccount: Function;
    }

    export class AccountController implements IAccountViewModel {
        resource: Function;
        constants: any[];

        title: string;
        accounts: App.Domain.Account[]; //resource(constants.apiUrl + "Accounts/:id").query();
        selectedAccount: App.Domain.Account;

        constructor($resource, constants) {
            this.title = "Accounts";
            this.resource = $resource;
            this.constants = constants
        }

        selectAccount(account) {
            this.selectedAccount = account;
        }
    }

    angular.module("app").controller("accountController", AccountController);

}
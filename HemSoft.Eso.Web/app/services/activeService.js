angular.module('esoApp').service('ActiveService', function () {
    var service = {};

    var accountSelected = null;

    service.getAccountSelected = function () {
        console.log("ActiveService:getAccountSelected() ==> accountSelected = " + accountSelected);
        return accountSelected;
    }
    service.accountSelected = function (account) {
        accountSelected = account;
        console.log("ActiveService:accountSelectedSetToTrue() ==> accountSelected = " + accountSelected);
    }
    service.accountSelectedSetToFalse = function () {
        accountSelected = null;
        console.log("ActiveService:accountSelectedSetToFalse() ==> accountSelected = " + accountSelected);
    }

    return service;
})
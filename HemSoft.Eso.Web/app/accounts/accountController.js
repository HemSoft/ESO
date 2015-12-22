var App;
(function (App) {
    var AccountController;
    (function (AccountController_1) {
        var AccountController = (function () {
            function AccountController($resource, constants) {
                this.title = "Accounts";
                this.resource = $resource;
                this.constants = constants;
            }
            AccountController.prototype.selectAccount = function (account) {
                this.selectedAccount = account;
            };
            return AccountController;
        })();
        AccountController_1.AccountController = AccountController;
        angular.module("app").controller("accountController", AccountController);
    })(AccountController = App.AccountController || (App.AccountController = {}));
})(App || (App = {}));
//# sourceMappingURL=accountController.js.map
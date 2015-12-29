var App;
(function (App) {
    var AccountController;
    (function (AccountController_1) {
        var AccountController = (function () {
            function AccountController(dataAccessService) {
                var _this = this;
                this.dataAccessService = dataAccessService;
                this.title = "Accounts";
                var accountResource = dataAccessService.getAccountResource();
                accountResource.query(function (data) {
                    _this.accounts = data;
                });
            }
            AccountController.prototype.selectAccount = function (account) {
                this.selectedAccount = account;
            };
            AccountController.$inject = ["dataAccessService"];
            return AccountController;
        })();
        angular.module("app").controller("accountController", AccountController);
    })(AccountController = App.AccountController || (App.AccountController = {}));
})(App || (App = {}));
//# sourceMappingURL=accountController.js.map
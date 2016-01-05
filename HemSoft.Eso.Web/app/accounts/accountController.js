var App;
(function (App) {
    var AccountController;
    (function (AccountController_1) {
        var AccountController = (function () {
            function AccountController(dataService, $rootscope) {
                var _this = this;
                this.dataService = dataService;
                this.$rootscope = $rootscope;
                this.title = "Accounts";
                this.dataAccessService = dataService;
                this.rootScope = $rootscope;
                var accountResource = dataService.getAccountResource();
                accountResource.query(function (data) {
                    _this.accounts = data;
                });
            }
            AccountController.prototype.selectAccount = function (account) {
                this.selectedAccount = account;
                this.dataAccessService.selectedAccount = account;
                this.rootScope.$broadcast("accountSelected");
            };
            AccountController.$inject = ["dataAccessService", "$rootScope"];
            return AccountController;
        })();
        angular.module("app").controller("accountController", AccountController);
    })(AccountController = App.AccountController || (App.AccountController = {}));
})(App || (App = {}));
//# sourceMappingURL=accountController.js.map
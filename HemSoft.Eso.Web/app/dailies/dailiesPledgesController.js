var App;
(function (App) {
    var DailiesPledges;
    (function (DailiesPledges) {
        var DailiesPledgesController = (function () {
            function DailiesPledgesController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.getPledgeStatus();
            }
            DailiesPledgesController.prototype.getPledgeStatus = function () {
                var _this = this;
                var res = this.dataAccessService.getPledgeStatus();
                res.query(function (data) {
                    _this.pledges = data;
                });
            };
            DailiesPledgesController.$inject = ["dataAccessService"];
            return DailiesPledgesController;
        })();
        angular.module("app").controller("dailiesPledgesController", DailiesPledgesController);
    })(DailiesPledges = App.DailiesPledges || (App.DailiesPledges = {}));
})(App || (App = {}));
//# sourceMappingURL=dailiesPledgesController.js.map
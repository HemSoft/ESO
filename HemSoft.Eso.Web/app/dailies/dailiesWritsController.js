var App;
(function (App) {
    var DailiesWrits;
    (function (DailiesWrits) {
        var DailiesWritsController = (function () {
            function DailiesWritsController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.getWritStatus();
            }
            DailiesWritsController.prototype.getWritStatus = function () {
                var _this = this;
                var res = this.dataAccessService.getWritStatus();
                res.query(function (data) {
                    _this.writs = data;
                });
            };
            DailiesWritsController.$inject = ["dataAccessService"];
            return DailiesWritsController;
        })();
        angular.module("app").controller("dailiesWritsController", DailiesWritsController);
    })(DailiesWrits = App.DailiesWrits || (App.DailiesWrits = {}));
})(App || (App = {}));

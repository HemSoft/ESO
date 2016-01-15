var App;
(function (App) {
    var DailiesWrothgar;
    (function (DailiesWrothgar) {
        var DailiesWrothgarController = (function () {
            function DailiesWrothgarController(dataService) {
                this.dataService = dataService;
                this.title = "Wrothgar";
                this.dataAccessService = dataService;
                this.getWritStatus();
            }
            DailiesWrothgarController.prototype.getWritStatus = function () {
                var _this = this;
                var res = this.dataAccessService.getWrothgarStatus();
                res.query(function (data) {
                    _this.wrothgarStatus = data;
                });
            };
            DailiesWrothgarController.$inject = ["dataAccessService"];
            return DailiesWrothgarController;
        })();
        angular.module("app").controller("dailiesWrothgarController", DailiesWrothgarController);
    })(DailiesWrothgar = App.DailiesWrothgar || (App.DailiesWrothgar = {}));
})(App || (App = {}));

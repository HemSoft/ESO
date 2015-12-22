var App;
(function (App) {
    var Common;
    (function (Common) {
        var DataAccessService = (function () {
            function DataAccessService($resource) {
                this.$resource = $resource;
            }
            DataAccessService.prototype.getAccountResource = function () {
                return this.$resource("/api/Account/:Id");
            };
            DataAccessService.$inject = ["$resource"];
            return DataAccessService;
        })();
        Common.DataAccessService = DataAccessService;
        angular.module("common.services")
            .service("dataAccessService", DataAccessService);
    })(Common = App.Common || (App.Common = {}));
})(App || (App = {}));
//# sourceMappingURL=dataAccess.service.js.map
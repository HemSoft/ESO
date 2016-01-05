var App;
(function (App) {
    var Common;
    (function (Common) {
        var DataAccessService = (function () {
            function DataAccessService($resource, appSettings) {
                this.$resource = $resource;
                this.appSettings = appSettings;
                this.serverPath = appSettings.serverPath;
            }
            DataAccessService.prototype.getAccountResource = function () {
                return this.$resource(this.serverPath + "/api/Accounts/:Id");
            };
            DataAccessService.prototype.getCharacterActivityByCharacterId = function (characterId) {
                return this.$resource(this.serverPath + ("/api/CharacterActivities/GetCharacterActivitiesByCharacterId?characterId=" + characterId));
            };
            DataAccessService.prototype.getCharacterResource = function () {
                return this.$resource(this.serverPath + "/api/Characters/:Id");
            };
            DataAccessService.prototype.getCharactersByAccountId = function (accountId) {
                return this.$resource(this.serverPath + ("/api/Characters/GetCharactersByAccountId?accountId=" + accountId));
            };
            DataAccessService.prototype.getCharactersNeedingAttention = function () {
                return this.$resource(this.serverPath + "/api/Characters/GetCharactersNeedingAttention");
            };
            DataAccessService.$inject = ["$resource", "appSettings"];
            return DataAccessService;
        })();
        Common.DataAccessService = DataAccessService;
        angular.module("common.services")
            .service("dataAccessService", DataAccessService);
    })(Common = App.Common || (App.Common = {}));
})(App || (App = {}));

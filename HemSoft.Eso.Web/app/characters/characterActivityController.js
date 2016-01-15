var App;
(function (App) {
    var CharacterActivityController;
    (function (CharacterActivityController_1) {
        var CharacterActivityController = (function () {
            function CharacterActivityController(dataService, $rootScope, $scope) {
                var _this = this;
                this.dataService = dataService;
                this.$rootScope = $rootScope;
                this.$scope = $scope;
                this.title = "Character Activity";
                this.dataAccessService = dataService;
                this.scope = $scope;
                this.selectCharacter();
                this.scope.$on("characterSelected", function () {
                    _this.selectCharacter();
                });
            }
            CharacterActivityController.prototype.getCharacterActivityBagUsageString = function (characterActivity) {
                return characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize;
            };
            CharacterActivityController.prototype.getCharacterActivityBankUsageString = function (characterActivity) {
                return characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize;
            };
            CharacterActivityController.prototype.getCharacterActivityTimePlayed = function (characterActivity) {
                if (characterActivity !== undefined && characterActivity !== null) {
                    return (characterActivity.SecondsPlayed / 60 / 60) | 0;
                }
            };
            CharacterActivityController.prototype.selectCharacter = function () {
                var _this = this;
                this.selectedCharacter = this.dataAccessService.selectedCharacter;
                if (this.selectedCharacter === undefined) {
                    return;
                }
                var characterResource = this.dataAccessService.getCharacterActivityByCharacterId(this.selectedCharacter.Id);
                characterResource.query(function (data) {
                    _this.characterActivities = data;
                });
            };
            CharacterActivityController.$inject = ["dataAccessService", "$rootScope", "$scope"];
            return CharacterActivityController;
        })();
        angular.module("app").controller("characterActivityController", CharacterActivityController);
    })(CharacterActivityController = App.CharacterActivityController || (App.CharacterActivityController = {}));
})(App || (App = {}));

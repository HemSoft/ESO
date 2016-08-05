var App;
(function (App) {
    var CharacterInfoController;
    (function (CharacterInfoController_1) {
        var CharacterInfoController = (function () {
            function CharacterInfoController(dataService, $location) {
                this.dataService = dataService;
                this.$location = $location;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.getCharacters();
                this.selectedCharacter = null;
                this.selectedCharacterLastActivity = null;
            }
            CharacterInfoController.prototype.getCharacters = function () {
                var _this = this;
                var res = this.dataAccessService.getCharacters();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterInfoController.prototype.getLastCharacterActivity = function (id) {
                var _this = this;
                var res = this.dataAccessService.getLastCharacterActivity(id);
                res.get(function (data) {
                    _this.selectedCharacterLastActivity = data;
                });
            };
            CharacterInfoController.prototype.characterSelected = function (item) {
                this.selectedCharacter = item;
                this.getLastCharacterActivity(item.Id);
            };
            CharacterInfoController.$inject = ["dataAccessService", "$location"];
            return CharacterInfoController;
        })();
        angular.module("app").controller("characterInfoController", CharacterInfoController);
    })(CharacterInfoController = App.CharacterInfoController || (App.CharacterInfoController = {}));
})(App || (App = {}));
//# sourceMappingURL=characterInfoConttroller.js.map
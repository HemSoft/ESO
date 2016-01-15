var App;
(function (App) {
    var CharacterQuestsController;
    (function (CharacterQuestsController_1) {
        var CharacterQuestsController = (function () {
            function CharacterQuestsController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.getCharacters();
                this.selectedCharacter = null;
                this.characterQuests = null;
                this.questSortType = "Completed";
                this.questSortReverse = true;
            }
            CharacterQuestsController.prototype.getCharacters = function () {
                var _this = this;
                var res = this.dataAccessService.getCharacters();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterQuestsController.prototype.characterSelected = function (item) {
                var _this = this;
                this.selectedCharacter = item;
                if (this.selectedCharacter !== undefined && this.selectedCharacter !== null) {
                    var res = this.dataAccessService.getCharacterQuests(this.selectedCharacter.Id);
                    res.query(function (data) {
                        _this.characterQuests = data;
                    });
                }
            };
            CharacterQuestsController.$inject = ["dataAccessService"];
            return CharacterQuestsController;
        })();
        angular.module("app").controller("characterQuestsController", CharacterQuestsController);
    })(CharacterQuestsController = App.CharacterQuestsController || (App.CharacterQuestsController = {}));
})(App || (App = {}));

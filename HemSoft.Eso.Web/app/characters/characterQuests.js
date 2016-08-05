var App;
(function (App) {
    var CharacterQuestsController;
    (function (CharacterQuestsController_1) {
        var CharacterQuestsController = (function () {
            function CharacterQuestsController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.selectCharactersResearching();
            }
            CharacterQuestsController.prototype.selectCharactersResearching = function () {
                var _this = this;
                var res = this.dataAccessService.getCharacterQuests();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterQuestsController.$inject = ["dataAccessService"];
            return CharacterQuestsController;
        })();
        angular.module("app").controller("characterQuestsController", CharacterQuestsController);
    })(CharacterQuestsController = App.CharacterQuestsController || (App.CharacterQuestsController = {}));
})(App || (App = {}));
//# sourceMappingURL=characterQuests.js.map
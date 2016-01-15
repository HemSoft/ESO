var App;
(function (App) {
    var CharacterResearchController;
    (function (CharacterResearchController_1) {
        var CharacterResearchController = (function () {
            function CharacterResearchController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.selectCharactersResearching();
            }
            CharacterResearchController.prototype.selectCharactersResearching = function () {
                var _this = this;
                var res = this.dataAccessService.getCharactersResearching();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterResearchController.$inject = ["dataAccessService"];
            return CharacterResearchController;
        })();
        angular.module("app").controller("characterResearchController", CharacterResearchController);
    })(CharacterResearchController = App.CharacterResearchController || (App.CharacterResearchController = {}));
})(App || (App = {}));

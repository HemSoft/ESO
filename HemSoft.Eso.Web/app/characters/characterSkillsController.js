var App;
(function (App) {
    var CharacterSkillsController;
    (function (CharacterSkillsController_1) {
        var CharacterSkillsController = (function () {
            function CharacterSkillsController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.selectCharactersSkills();
                this.questSortType = "Completed";
                this.questSortReverse = true;
            }
            CharacterSkillsController.prototype.selectCharactersSkills = function () {
                var _this = this;
                var res = this.dataAccessService.getCharacterSkills();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterSkillsController.$inject = ["dataAccessService"];
            return CharacterSkillsController;
        })();
        angular.module("app").controller("characterSkillsController", CharacterSkillsController);
    })(CharacterSkillsController = App.CharacterSkillsController || (App.CharacterSkillsController = {}));
})(App || (App = {}));
//# sourceMappingURL=characterSkillsController.js.map
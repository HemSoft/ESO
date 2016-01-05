var App;
(function (App) {
    var CharacterActivityControllerCharacterController;
    (function (CharacterActivityControllerCharacterController) {
        var CharacterController = (function () {
            function CharacterController(dataService) {
                this.dataService = dataService;
                this.title = "Characters Needing Attention";
                this.dataAccessService = dataService;
                this.selectCharactersNeedingAttention();
            }
            CharacterController.prototype.selectCharactersNeedingAttention = function () {
                var _this = this;
                var res = this.dataAccessService.getCharactersByAccountId(this.selectedAccount.Id);
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterController.prototype.selectCharacter = function (character) {
                this.selectedCharacter = character;
                this.dataAccessService.selectedCharacter = character;
                this.rootScope.$broadcast("characterSelected");
            };
            CharacterController.$inject = ["dataAccessService"];
            return CharacterController;
        })();
        angular.module("app").controller("characterController", CharacterController);
    })(CharacterActivityControllerCharacterController = App.CharacterActivityControllerCharacterController || (App.CharacterActivityControllerCharacterController = {}));
})(App || (App = {}));

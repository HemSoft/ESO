var App;
(function (App) {
    var CharacterController;
    (function (CharacterController_1) {
        var CharacterController = (function () {
            function CharacterController(dataAccessService) {
                var _this = this;
                this.dataAccessService = dataAccessService;
                this.title = "Characters";
                var characterResource = dataAccessService.getCharacterResource();
                characterResource.query(function (data) {
                    _this.characters = data;
                });
            }
            CharacterController.prototype.selectCharacter = function (character) {
                this.selectedCharacter = character;
            };
            CharacterController.$inject = ["dataAccessService"];
            return CharacterController;
        })();
        angular.module("app").controller("characterController", CharacterController);
    })(CharacterController = App.CharacterController || (App.CharacterController = {}));
})(App || (App = {}));
//# sourceMappingURL=characterController.js.map
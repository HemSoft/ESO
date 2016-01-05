var App;
(function (App) {
    var CharacterController;
    (function (CharacterController_1) {
        var CharacterController = (function () {
            function CharacterController(dataService, $rootScope, $scope) {
                var _this = this;
                this.dataService = dataService;
                this.$rootScope = $rootScope;
                this.$scope = $scope;
                this.title = "Characters";
                this.dataAccessService = dataService;
                this.selectAccount();
                this.rootScope = $rootScope;
                this.scope = $scope;
                this.scope.$on("accountSelected", function () {
                    _this.selectAccount();
                });
            }
            CharacterController.prototype.selectAccount = function () {
                var _this = this;
                this.selectedAccount = this.dataAccessService.selectedAccount;
                if (this.selectedAccount === undefined) {
                    return;
                }
                var characterResource = this.dataAccessService.getCharactersByAccountId(this.selectedAccount.Id);
                characterResource.query(function (data) {
                    _this.characters = data;
                });
            };
            CharacterController.prototype.selectCharacter = function (character) {
                this.selectedCharacter = character;
                this.dataAccessService.selectedCharacter = character;
                this.rootScope.$broadcast("characterSelected");
            };
            CharacterController.$inject = ["dataAccessService", "$rootScope", "$scope"];
            return CharacterController;
        })();
        angular.module("app").controller("characterController", CharacterController);
    })(CharacterController = App.CharacterController || (App.CharacterController = {}));
})(App || (App = {}));

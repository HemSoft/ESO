module App.CharacterActivityControllerCharacterController {

    interface ICharacterViewModel {
        title: string;
        selectedAccount: App.Domain.IAccount;
        characters: App.Domain.ICharacter[];
        selectedCharacter: App.Domain.ICharacter;
        selectAccount: Function;
        selectCharacter: Function;
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;
        scope: ng.IScope;
    }

    class CharacterController implements ICharacterViewModel {
        title: string;
        selectedAccount: App.Domain.IAccount;
        characters: App.Domain.ICharacter[];
        selectedCharacter: App.Domain.ICharacter;
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;
        scope: ng.IScope;

        static $inject = ["dataAccessService", "$rootScope", "$scope"];
        constructor(private dataService: App.Common.DataAccessService, private $rootScope: ng.IScope, private $scope: ng.IScope) {
            this.title = "Characters";
            this.dataAccessService = dataService;
            this.selectAccount();
            this.rootScope = $rootScope;

            this.scope = $scope;
            this.scope.$on("accountSelected", () => {
                this.selectAccount();
            });
        }

        selectAccount() {
            this.selectedAccount = this.dataAccessService.selectedAccount;
            if (this.selectedAccount === undefined) {
                return;
            }

            var characterResource = this.dataAccessService.getCharactersByAccountId(this.selectedAccount.Id);
            characterResource.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }

        selectCharacter(character) {
            this.selectedCharacter = character;
            this.dataAccessService.selectedCharacter = character;
            this.rootScope.$broadcast("characterSelected");
        }
    }

    angular.module("app").controller("characterController", CharacterController);

}
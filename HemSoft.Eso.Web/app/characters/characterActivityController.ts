module App.CharacterActivityController {

    interface ICharacterActivityViewModel {
        title: string;
        selectedCharacter: App.Domain.ICharacter;
        characterActivities: App.Domain.ICharacterActivity[];
        selectCharacter: Function;
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;
        scope: ng.IScope;
    }

    class CharacterActivityController implements ICharacterActivityViewModel {
        title: string;
        selectedCharacter: App.Domain.ICharacter;
        characterActivities: App.Domain.ICharacterActivity[];
        dataAccessService: App.Common.DataAccessService;
        rootScope: ng.IScope;
        scope: ng.IScope;

        static $inject = ["dataAccessService", "$rootScope", "$scope"];
        constructor(private dataService: App.Common.DataAccessService, private $rootScope: ng.IScope, private $scope: ng.IScope) {
            this.title = "Character Activity";
            this.dataAccessService = dataService;
            this.scope = $scope;
            this.selectCharacter();

            this.scope.$on("characterSelected", () => {
                this.selectCharacter();
            });
        }

        getCharacterActivityBagUsageString(characterActivity: App.Domain.ICharacterActivity) {
            return characterActivity.UsedBagSlots + "/" + characterActivity.MaxBagSize;
        }

        getCharacterActivityBankUsageString(characterActivity: App.Domain.ICharacterActivity) {
            return characterActivity.UsedBankSlots + "/" + characterActivity.MaxBankSize;
        }

        getCharacterActivityTimePlayed(characterActivity: App.Domain.ICharacterActivity) {
            if (characterActivity !== undefined && characterActivity !== null) {
                return (characterActivity.SecondsPlayed / 60 / 60) | 0;
            }
        }

        selectCharacter() {
            this.selectedCharacter = this.dataAccessService.selectedCharacter;
            if (this.selectedCharacter === undefined) {
                return;
            }

            var characterResource = this.dataAccessService.getCharacterActivityByCharacterId(this.selectedCharacter.Id);
            characterResource.query((data: App.Domain.ICharacterActivity[]) => {
                this.characterActivities = data;
            });
        }
    }

    angular.module("app").controller("characterActivityController", CharacterActivityController);

}
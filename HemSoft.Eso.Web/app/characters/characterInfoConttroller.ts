module App.CharacterInfoController {

    interface ICharacterInfoViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;
    }

    class CharacterInfoController implements ICharacterInfoViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;

        static $inject = ["dataAccessService", "$location"];
        constructor(private dataService: App.Common.DataAccessService, private $location: ng.ILocationService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getCharacters();
            this.selectedCharacter = null;
        }

        getCharacters() {
            var res = this.dataAccessService.getCharacters();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }

        characterSelected(item) {
            this.selectedCharacter = item;
        }
    }

    angular.module("app").controller("characterInfoController", CharacterInfoController);

}
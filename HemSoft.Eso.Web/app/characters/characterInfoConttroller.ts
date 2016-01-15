module App.CharacterInfoController {

    interface ICharacterInfoViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;
        selectedCharacterLastActivity: App.Domain.ICharacterActivity;
    }

    class CharacterInfoController implements ICharacterInfoViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;
        selectedCharacterLastActivity: App.Domain.ICharacterActivity;

        static $inject = ["dataAccessService", "$location"];
        constructor(private dataService: App.Common.DataAccessService, private $location: ng.ILocationService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getCharacters();
            this.selectedCharacter = null;
            this.selectedCharacterLastActivity = null;
        }

        getCharacters() {
            var res = this.dataAccessService.getCharacters();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }

        getLastCharacterActivity(id: number) {
            var res = this.dataAccessService.getLastCharacterActivity(id);
            res.get((data: App.Domain.ICharacterActivity) => {
                this.selectedCharacterLastActivity = data;
            });
        }

        characterSelected(item) {
            this.selectedCharacter = item;
            this.getLastCharacterActivity(item.Id);
        }
    }

    angular.module("app").controller("characterInfoController", CharacterInfoController);

}
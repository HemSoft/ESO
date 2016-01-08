module App.CharacterQuestsController {

    interface ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        questSortType: string;
        questSortReverse: boolean;
    }

    class CharacterQuestsController implements ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        questSortType: string;
        questSortReverse: boolean;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.selectCharactersResearching();
            this.questSortType = "Completed";
            this.questSortReverse = true;
        }

        selectCharactersResearching() {
            var res = this.dataAccessService.getCharacterQuests();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }
    }

    angular.module("app").controller("characterQuestsController", CharacterQuestsController);

}
module App.CharacterQuestsController {

    interface ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;
        characterQuests: any[];
        questSortType: string;
        questSortReverse: boolean;
    }

    class CharacterQuestsController implements ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        selectedCharacter: App.Domain.ICharacter;
        characterQuests: any[];
        questSortType: string;
        questSortReverse: boolean;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getCharacters();
            this.selectedCharacter = null;
            this.characterQuests = null;
            this.questSortType = "Completed";
            this.questSortReverse = true;
        }

        getCharacters() {
            var res = this.dataAccessService.getCharacters();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }

        characterSelected(item) {
            this.selectedCharacter = item;
            if (this.selectedCharacter !== undefined && this.selectedCharacter !== null) {
                var res = this.dataAccessService.getCharacterQuests(this.selectedCharacter.Id);
                res.query((data: App.Domain.ICharacter[]) => {
                    this.characterQuests = data;
                });
            }
        }
    }

    angular.module("app").controller("characterQuestsController", CharacterQuestsController);

}
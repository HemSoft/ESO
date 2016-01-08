module App.CharacterSkillsController {

    interface ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        questSortType: string;
        questSortReverse: boolean;
    }

    class CharacterSkillsController implements ICharacterQuestsViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
        questSortType: string;
        questSortReverse: boolean;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.selectCharactersSkills();
            this.questSortType = "Completed";
            this.questSortReverse = true;
        }

        selectCharactersSkills() {
            var res = this.dataAccessService.getCharacterSkills();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }
    }

    angular.module("app").controller("characterSkillsController", CharacterSkillsController);

}
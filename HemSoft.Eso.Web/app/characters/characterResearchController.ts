module App.CharacterResearchController {

    interface ICharacterResearchViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
    }

    class CharacterResearchController implements ICharacterResearchViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.selectCharactersResearching();
        }

        selectCharactersResearching() {
            var res = this.dataAccessService.getCharactersResearching();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }
    }

    angular.module("app").controller("characterResearchController", CharacterResearchController);

}
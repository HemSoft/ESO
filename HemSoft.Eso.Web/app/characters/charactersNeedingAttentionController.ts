module App.CharactersNeedingAttentionController {

    interface ICharactersNeedAttentionViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;
    }

    class CharactersNeedingAttentionController implements ICharactersNeedAttentionViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        dataAccessService: App.Common.DataAccessService;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Characters Needing Attention";
            this.dataAccessService = dataService;
            this.selectCharactersNeedingAttention();
        }

        selectCharactersNeedingAttention() {
            var res = this.dataAccessService.getCharactersNeedingAttention();
            res.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });
        }
    }

    angular.module("app").controller("charactersNeedingAttentionController", CharactersNeedingAttentionController);

}
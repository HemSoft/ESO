module App.CharacterController {

    interface ICharacterViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        selectedCharacter: App.Domain.ICharacter;
        selectCharacter: Function;
    }

    class CharacterController implements ICharacterViewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        selectedCharacter: App.Domain.ICharacter;

        static $inject = ["dataAccessService"];
        constructor(private dataAccessService: App.Common.DataAccessService) {
            this.title = "Characters";

            var characterResource = dataAccessService.getCharacterResource()
            characterResource.query((data: App.Domain.ICharacter[]) => {
                this.characters = data;
            });

        }

        selectCharacter(character) {
            this.selectedCharacter = character;
        }
    }

    angular.module("app").controller("characterController", CharacterController);

}
module App.CharacterInventoryController {

    interface ICharacterInventoryiewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        // TODO:
        inventory: any[];
        dataAccessService: App.Common.DataAccessService;
        inventorySortType: string;
        inventorySortReverse: boolean;
    }

    class CharacterInventoryController implements ICharacterInventoryiewModel {
        title: string;
        characters: App.Domain.ICharacter[];
        inventory: any[];
        dataAccessService: App.Common.DataAccessService;
        inventorySortType: string;
        inventorySortReverse: boolean;

        static $inject = ["dataAccessService"];
        constructor(private dataService: App.Common.DataAccessService) {
            this.title = "Upcoming";
            this.dataAccessService = dataService;
            this.getAllInventory();
            this.inventorySortType = "Completed";
            this.inventorySortReverse = true;
        }

        getAllInventory() {
            var res = this.dataAccessService.getAllInventory();
            res.query((data: App.Domain.ICharacter[]) => {
                this.inventory = data;
            });
        }
    }

    angular.module("app").controller("characterInventoryController", CharacterInventoryController);

}
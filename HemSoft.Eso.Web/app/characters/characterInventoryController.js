var App;
(function (App) {
    var CharacterInventoryController;
    (function (CharacterInventoryController_1) {
        var CharacterInventoryController = (function () {
            function CharacterInventoryController(dataService) {
                this.dataService = dataService;
                this.title = "Upcoming";
                this.dataAccessService = dataService;
                this.getAllInventory();
                this.inventorySortType = "Completed";
                this.inventorySortReverse = true;
            }
            CharacterInventoryController.prototype.getAllInventory = function () {
                var _this = this;
                var res = this.dataAccessService.getAllInventory();
                res.query(function (data) {
                    _this.inventory = data;
                });
            };
            CharacterInventoryController.$inject = ["dataAccessService"];
            return CharacterInventoryController;
        })();
        angular.module("app").controller("characterInventoryController", CharacterInventoryController);
    })(CharacterInventoryController = App.CharacterInventoryController || (App.CharacterInventoryController = {}));
})(App || (App = {}));
//# sourceMappingURL=characterInventoryController.js.map
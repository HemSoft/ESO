var App;
(function (App) {
    var CharactersNeedingAttentionController;
    (function (CharactersNeedingAttentionController_1) {
        var CharactersNeedingAttentionController = (function () {
            function CharactersNeedingAttentionController(dataService) {
                this.dataService = dataService;
                this.title = "Characters Needing Attention";
                this.dataAccessService = dataService;
                this.selectCharactersNeedingAttention();
            }
            CharactersNeedingAttentionController.prototype.selectCharactersNeedingAttention = function () {
                var _this = this;
                var res = this.dataAccessService.getCharactersNeedingAttention();
                res.query(function (data) {
                    _this.characters = data;
                });
            };
            CharactersNeedingAttentionController.$inject = ["dataAccessService"];
            return CharactersNeedingAttentionController;
        })();
        angular.module("app").controller("charactersNeedingAttentionController", CharactersNeedingAttentionController);
    })(CharactersNeedingAttentionController = App.CharactersNeedingAttentionController || (App.CharactersNeedingAttentionController = {}));
})(App || (App = {}));
//# sourceMappingURL=charactersNeedingAttentionController.js.map
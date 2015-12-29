var App;
(function (App) {
    var app = angular
        .module("app", [
        "ngResource",
        "ngRoute",
        "common.services"
    ]);
    app.config(routeConfig);
    routeConfig.$inject = ["$routeProvider"];
    function routeConfig($routeProvider) {
        $routeProvider
            .when("/Home/Index", {
            templateUrl: "/app/accounts/accountListView.html",
            controller: "accountController as vmac"
        })
            .when("/Home/FamilyList", {
            templateUrl: "/app/family/familyListView.html",
            controller: "FamilyListController as vmflc"
        })
            .when("/Home/FamilyDetail/:familyId", {
            templateUrl: "/app/family/familyDetailView.html",
            controller: "FamilyDetailController as vmfdc"
        })
            .otherwise("/Home/Index");
    }
})(App || (App = {}));
//# sourceMappingURL=app.js.map